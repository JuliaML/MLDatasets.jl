_check_jld2_nobs(nobs) = all(==(first(nobs)), nobs[2:end])

"""
    JLD2Dataset(file::Union{AbstractString, AbstractPath}, paths)
    JLD2Dataset(fid::JLD2.JLDFile, paths)

Wrap several JLD2 datasets (`paths`) as a single dataset container.
Each dataset `p` in `paths` should be accessible as `fid[p]`.
Calling `getobs` on a `JLD2Dataset` is equivalent to mapping `getobs` on
each dataset in `paths`.
See [`close(::JLD2Dataset)`](@ref) for closing the underlying JLD2 file pointer.
"""
struct JLD2Dataset{T<:JLD2.JLDFile} <: AbstractDataContainer
    fid::T
    paths::Vector{String}

    function JLD2Dataset(fid::JLD2.JLDFile, paths::Vector{String})
        nobs = map(p -> numobs(fid[p]), paths)
        _check_jld2_nobs(nobs) ||
            throw(ArgumentError("Cannot create JLD2Dataset for datasets with mismatched number of observations."))

        new{typeof(fid)}(fid, paths)
    end
end

JLD2Dataset(file::Union{AbstractString, AbstractPath}, paths) =
    JLD2Dataset(jldopen(file, "r"), paths)

MLUtils.getobs(dataset::JLD2Dataset, i) = Tuple(map(p -> getobs(dataset.fid[p], i), dataset.paths))
MLUtils.numobs(dataset::JLD2Dataset) = numobs(dataset.fid[dataset.paths[1]])

"""
    close(dataset::JLD2Dataset)

Close the underlying JLD2 file pointer for `dataset`.
"""
Base.close(dataset::JLD2Dataset) = close(dataset.fid)
