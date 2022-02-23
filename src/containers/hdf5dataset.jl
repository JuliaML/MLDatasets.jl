function _check_hdf5_shapes(shapes)
    nobs = map(last, filter(!isempty, shapes))

    return all(==(first(nobs)), nobs[2:end])
end

"""
    HDF5Dataset(file::Union{AbstractString, AbstractPath}, paths)
    HDF5Dataset(fid::HDF5.File, paths::Union{HDF5.Dataset, Vector{HDF5.Dataset}})
    HDF5Dataset(fid::HDF5.File, paths::Union{AbstractString, Vector{<:AbstractString}})
    HDF5Dataset(fid::HDF5.File, paths::Union{HDF5.Dataset, Vector{HDF5.Dataset}}, shapes)

Wrap several HDF5 datasets (`paths`) as a single dataset container.
Each dataset `p` in `paths` should be accessible as `fid[p]`.
Calling `getobs` on a `HDF5Dataset` returns a tuple with each element corresponding
to the observation from each dataset in `paths`.
See [`close(::HDF5Dataset)`](@ref) for closing the underlying HDF5 file pointer.

For array datasets, the last dimension is assumed to be the observation dimension.
For scalar datasets, the stored value is returned by `getobs` for any index.
"""
struct HDF5Dataset{T<:Union{HDF5.Dataset, Vector{HDF5.Dataset}}} <: AbstractDataContainer
    fid::HDF5.File
    paths::T
    shapes::Vector{Tuple}

    function HDF5Dataset(fid::HDF5.File, paths::T, shapes::Vector) where T<:Union{HDF5.Dataset, Vector{HDF5.Dataset}}
        _check_hdf5_shapes(shapes) ||
            throw(ArgumentError("Cannot create HDF5Dataset for datasets with mismatched number of observations."))

        new{T}(fid, paths, shapes)
    end
end

HDF5Dataset(fid::HDF5.File, path::HDF5.Dataset) = HDF5Dataset(fid, path, [size(path)])
HDF5Dataset(fid::HDF5.File, paths::Vector{HDF5.Dataset}) =
    HDF5Dataset(fid, paths, map(size, paths))
HDF5Dataset(fid::HDF5.File, path::AbstractString) = HDF5Dataset(fid, fid[path])
HDF5Dataset(fid::HDF5.File, paths::Vector{<:AbstractString}) =
    HDF5Dataset(fid, map(p -> fid[p], paths))
HDF5Dataset(file::Union{AbstractString, AbstractPath}, paths) =
    HDF5Dataset(h5open(file, "r"), paths)

_getobs_hdf5(dataset::HDF5.Dataset, ::Tuple{}, i) = read(dataset)
function _getobs_hdf5(dataset::HDF5.Dataset, shape, i)
    I = map(s -> 1:s, shape[1:(end - 1)])

    return dataset[I..., i]
end
Base.getindex(dataset::HDF5Dataset{HDF5.Dataset}, i) =
    _getobs_hdf5(dataset.paths, only(dataset.shapes), i)
Base.getindex(dataset::HDF5Dataset{<:Vector}, i) =
    Tuple(map((p, s) -> _getobs_hdf5(p, s, i), dataset.paths, dataset.shapes))
Base.length(dataset::HDF5Dataset) = last(first(filter(!isempty, dataset.shapes)))

"""
    close(dataset::HDF5Dataset)

Close the underlying HDF5 file pointer for `dataset`.
"""
Base.close(dataset::HDF5Dataset) = close(dataset.fid)
