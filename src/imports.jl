
const idDataFrames = Base.PkgId(Base.UUID("a93c6f00-e57d-5684-b7b6-d8193f3e46c0"), "DataFrames")
const idCSV = Base.PkgId(Base.UUID("336ed68f-0bac-5ca0-87d4-7b16caf5d00b"), "CSV")
const idImageCore = Base.PkgId(Base.UUID("a09fc81d-aa75-5fe9-8630-4744c3626534"), "ImageCore")
const idPickle = Base.PkgId(Base.UUID("fbb45041-c46e-462f-888f-7c521cafbc2c"), "Pickle")
const idHDF5 = Base.PkgId(Base.UUID("f67ccb44-e63f-5c2f-98bd-6dc0ccc4ba2f"), "HDF5")
const idMAT = Base.PkgId(Base.UUID("23992714-dd62-5051-b70f-ba57cb901cac"), "MAT")
const idJSON3 = Base.PkgId(Base.UUID("0f8b85d8-7281-11e9-16c2-39a750bddbf1"), "JSON3")
# ColorTypes = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
# JLD2 = "033835bb-8acc-5ee8-8aae-3f567f8a3819"

const load_locker = Threads.ReentrantLock()

function checked_import(pkgid)
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
