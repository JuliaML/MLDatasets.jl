# FileDataset

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

struct FileDataset{T} <: AbstractDataContainer
    paths::T
end

FileDataset(dir, pattern = "*", depth = 4) = rglob(pattern, string(dir), depth)

MLUtils.getobs(dataset::FileDataset, i) = loadfile(dataset.paths[i])
MLUtils.numobs(dataset::FileDataset) = length(dataset.paths)
