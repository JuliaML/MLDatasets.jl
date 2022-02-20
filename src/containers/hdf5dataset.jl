function _check_hdf5_shapes(shapes)
    nobs = map(last, filter(!isempty, shapes))

    return all(==(first(nobs)), nobs[2:end])
end

"""
    HDF5Dataset(file::Union{AbstractString, AbstractPath}, paths)
    HDF5Dataset(fid::HDF5.File, paths::Vector{HDF5.Dataset})
    HDF5Dataset(fid::HDF5.File, paths::Vector{<:AbstractString})
    HDF5Dataset(fid::HDF5.File, paths::Vector{HDF5.Dataset}, shapes)

Wrap several HDF5 datasets (`paths`) as a single dataset container.
Each dataset `p` in `paths` should be accessible as `fid[p]`.
Calling `getobs` on a `HDF5Dataset` returns a tuple with each element corresponding
to the observation from each dataset in `paths`.
See [`close(::HDF5Dataset)`](@ref) for closing the underlying HDF5 file pointer.

For array datasets, the last dimension is assumed to be the observation dimension.
For scalar datasets, the stored value is returned by `getobs` for any index.
"""
struct HDF5Dataset
    fid::HDF5.File
    paths::Vector{HDF5.Dataset}
    shapes::Vector{Tuple}

    function HDF5Dataset(fid::HDF5.File, paths::Vector{HDF5.Dataset}, shapes::Vector)
        _check_hdf5_shapes(shapes) ||
            throw(ArgumentError("Cannot create HDF5Dataset for datasets with mismatch number of observations."))

        new(fid, paths, shapes)
    end
end

HDF5Dataset(fid::HDF5.File, paths::Vector{HDF5.Dataset}) =
    HDF5Dataset(fid, paths, map(size, paths))
HDF5Dataset(fid::HDF5.File, paths::Vector{<:AbstractString}) =
    HDF5Dataset(fid, map(p -> fid[p], paths))
HDF5Dataset(file::Union{AbstractString, AbstractPath}, paths) =
    HDF5Dataset(h5open(file, "r"), paths)

MLUtils.getobs(dataset::HDF5Dataset, i) = Tuple(map(dataset.paths, dataset.shapes) do path, shape
    if isempty(shape)
        return read(path)
    else
        I = map(s -> 1:s, shape[1:(end - 1)])
        return path[I..., i]
    end
end)
MLUtils.numobs(dataset::HDF5Dataset) = last(first(filter(!isempty, dataset.shapes)))

"""
    close(dataset::HDF5Dataset)

Close the underlying HDF5 file pointer for `dataset`.
"""
Base.close(dataset::HDF5Dataset) = close(dataset.fid)
