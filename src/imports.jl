# Check that packages like JSON3 are already imported by the user.

function require_import(m::Symbol)
    pkgid = Base.identify_package(string(m))
    if Base.root_module_exists(pkgid)
        return Base.root_module(pkgid)
    else
        error("Add `import $m` or `using $m` to your code to unlock this functionality.")
    end
end


const load_locker = Threads.ReentrantLock()

function lazy_import(m::Symbol)
    pkgid = Base.identify_package(string(m))
    mod = if Base.root_module_exists(pkgid)
              Base.root_module(pkgid)
          else
              lock(load_locker) do
                  Base.require(pkgid)
              end
          end

    return ImportedModule(mod)
end

struct ImportedModule
    mod::Module
end

function Base.getproperty(m::ImportedModule, s::Symbol)
    if s == :mod
        return getfield(m, s)
    else
        function f(args...; kws...)
            Base.invokelatest(getproperty(m.mod, s), args...; kws...) 
        end
        return f
    end
end