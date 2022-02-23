matches(re::Regex) = f -> matches(re, f)
matches(re::Regex, f) = !isnothing(match(re, f))
const RE_IMAGEFILE = r".*\.(gif|jpe?g|tiff?|png|webp|bmp)$"i
isimagefile(f) = matches(RE_IMAGEFILE, f)

"""
    rglob(filepattern, dir = pwd(), depth = 4)

Recursive glob up to `depth` layers deep within `dir`.
"""
function rglob(filepattern = "*", dir = pwd(), depth = 4)
    patterns = [repeat("*/", i) * filepattern for i in 0:(depth - 1)]

    return vcat([glob(pattern, dir) for pattern in patterns]...)
end

"""
    loadfile(file)

Load a file from disk into the appropriate format.
"""
function loadfile(file::String)
    if isimagefile(file)
        # faster image loading
        return FileIO.load(file, view = true)
    elseif endswith(file, ".csv")
        return DataFrame(CSV.File(file))
    else
        return FileIO.load(file)
    end
end
loadfile(file::AbstractPath) = loadfile(string(file))

"""
    FileDataset([loadfn = loadfile,] paths)
    FileDataset([loadfn = loadfile,] dir, pattern = "*", depth = 4)

Wrap a set of file `paths` as a dataset (traversed in the same order as `paths`).
Alternatively, specify a `dir` and collect all paths that match a glob `pattern`
(recursively globbing by `depth`). The glob order determines the traversal order.
"""
struct FileDataset{F, T<:Union{AbstractPath, AbstractString}} <: AbstractDataContainer
    loadfn::F
    paths::Vector{T}
end

FileDataset(paths) = FileDataset(loadfile, paths)
FileDataset(loadfn,
            dir::Union{AbstractPath, AbstractString},
            pattern::AbstractString = "*",
            depth = 4) = FileDataset(loadfn, rglob(pattern, string(dir), depth))
FileDataset(dir::Union{AbstractPath, AbstractString}, pattern::AbstractString = "*", depth = 4) =
    FileDataset(loadfile, dir, pattern, depth)

Base.getindex(dataset::FileDataset, i::Integer) = loadfile(dataset.paths[i])
Base.getindex(dataset::FileDataset, is::AbstractVector) = map(Base.Fix1(getobs, dataset), is)
Base.length(dataset::FileDataset) = length(dataset.paths)
