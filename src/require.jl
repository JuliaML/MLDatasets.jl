
using Base: invokelatest
using Base: PkgId, UUID

# export @require

const _LOAD_LOCKER = Threads.ReentrantLock()

mutable struct RequireModule
    _require_pkgid::PkgId
    _require_loaded::Bool
end
RequireModule(uuid::UUID, name::String) = RequireModule(PkgId(uuid, name), false)
function Base.Docs.Binding(m::RequireModule, v::Symbol)
    Base.Docs.Binding(checked_import(m._require_pkgid), v)
end
function Base.show(io::IO, m::RequireModule)
    print(io, "RequireModule(", m._require_pkgid.name, ")")
end

function Base.getproperty(m::RequireModule, s::Symbol)
    if s in (:_require_pkgid, :_require_loaded)
        return getfield(m, s)
    end
    lm = require_import(m)
    return getproperty(lm, s)
end

function assert_imported(pkgid::PkgId)
    if !Base.root_module_exists(pkgid)
        name = pkgid.name
        error("Add `import $name` or `using $name` to your code to unlock this functionality.")
    end
end

function require_import(m::RequireModule)
    pkgid = getfield(m, :_require_pkgid)
    if !getfield(m, :_require_loaded)
        assert_imported(pkgid)
        setfield!(m, :_require_loaded, true)
    end
    return Base.root_module(pkgid)
end

"""
    @require import PkgName=UUID

Force the user to add to their code `import package PkgName`.
only if they want the functionality provided by PkgName, 
otherwise PkgName won't be imported and won't affect loading time.

```julia
module MyRequirePkg
    @require import Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80"
    
    draw_figure(data) = Plots.plot(data, title="MyPkg Plot")
end
```
"""
macro require(ex)
    if ex.head in (:import, :using)
        error("require `@require $(ex)=UUID` format.")
    end
    if ex.head != :(=)
        error("unrecognized expression: $(ex)")
    end
    uuid = UUID(ex.args[2])
    ex = ex.args[1]

    if ex.head != :import
        @warn "only `import` command is supported, fallback to eager mode"
        return ex
    end
    args = ex.args
    if length(args) != 1
        @warn "only single package import is supported, fallback to eager mode"
        return ex
    end
    x = args[1]
    if x.head == :.
        # usage: @require import Foo
        m = _require_load(__module__, x.args[1], uuid, x.args[1])
        # TODO(johnnychen94): the background eager loading seems to work only for Main scope
        isa(m, Module) && return m
        isnothing(m) && return ex
        return m
    elseif x.head == :(:)
        # usage: @require import Foo: foo, bar
        @warn "lazily importing symbols are not supported, fallback to eager mode"
        return ex
    elseif x.head == :as # compat: Julia at least v1.6
        # usage: @require import Foo as RequireFoo
        m = _require_load(__module__, x.args[2], uuid, x.args[1].args[1])
        isa(m, Module) && return m
        isnothing(m) && return ex
        return m
    else
        @warn "unrecognized syntax $ex"
        return ex
    end
end

function _require_load(mod, name::Symbol, uuid::UUID, sym::Symbol)
    if isdefined(mod, name)
        # otherwise, Revise will constantly trigger the constant redefinition warning
        m = getfield(mod, name)
        if m isa RequireModule || m isa Module
            return m
        else
            @warn "Failed to import module, the name `$name` already exists, do nothing"
            return nothing
        end
    end
    try
        m = RequireModule(uuid, String(sym))
        Core.eval(mod, :(const $(name) = $m))
        return m
    catch err
        @warn err
        return nothing
    end
end
