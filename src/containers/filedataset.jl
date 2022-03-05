"""
    rglob(filepattern, dir = pwd(), depth = 4)

Recursive glob up to `depth` layers deep within `dir`.
"""
function rglob(filepattern = "*", dir = pwd(), depth = 4)
    patterns = [repeat("*/", i) * filepattern for i in 0:(depth - 1)]

    return vcat([glob(pattern, dir) for pattern in patterns]...)
end

"""
    FileDataset([loadfn = FileIO.load,] paths)
    FileDataset([loadfn = FileIO.load,] dir, pattern = "*", depth = 4)

Wrap a set of file `paths` as a dataset (traversed in the same order as `paths`).
Alternatively, specify a `dir` and collect all paths that match a glob `pattern`
(recursively globbing by `depth`). The glob order determines the traversal order.
"""
struct FileDataset{F, T<:AbstractString} <: AbstractDataContainer
    loadfn::F
    paths::Vector{T}
end

FileDataset(paths) = FileDataset(FileIO.load, paths)
FileDataset(loadfn,
            dir::AbstractString,
            pattern::AbstractString = "*",
            depth = 4) = FileDataset(loadfn, rglob(pattern, string(dir), depth))
FileDataset(dir::AbstractString, pattern::AbstractString = "*", depth = 4) =
    FileDataset(FileIO.load, dir, pattern, depth)

Base.getindex(dataset::FileDataset, i::Integer) = dataset.loadfn(dataset.paths[i])
Base.getindex(dataset::FileDataset, is::AbstractVector) = map(Base.Fix1(getobs, dataset), is)
Base.length(dataset::FileDataset) = length(dataset.paths)
