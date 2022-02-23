_check_jld2_nobs(nobs) = all(==(first(nobs)), nobs[2:end])

"""
    JLD2Dataset(file::AbstractString, paths)
    JLD2Dataset(fid::JLD2.JLDFile, paths::Union{String, Vector{String}})

Wrap several JLD2 datasets (`paths`) as a single dataset container.
Each dataset `p` in `paths` should be accessible as `fid[p]`.
Calling `getobs` on a `JLD2Dataset` is equivalent to mapping `getobs` on
each dataset in `paths`.
See [`close(::JLD2Dataset)`](@ref) for closing the underlying JLD2 file pointer.
"""
struct JLD2Dataset{T<:JLD2.JLDFile, S<:Tuple} <: AbstractDataContainer
    fid::T
    paths::S

    function JLD2Dataset(fid::JLD2.JLDFile, paths)
        _paths = Tuple(map(p -> fid[p], paths))
        nobs = map(numobs, _paths)
        _check_jld2_nobs(nobs) ||
            throw(ArgumentError("Cannot create JLD2Dataset for datasets with mismatched number of observations (got $nobs)."))

        new{typeof(fid), typeof(_paths)}(fid, _paths)
    end
end

JLD2Dataset(file::JLD2.JLDFile, path::String) = JLD2Dataset(file, (path,))
JLD2Dataset(file::AbstractString, paths) = JLD2Dataset(jldopen(file, "r"), paths)

Base.getindex(dataset::JLD2Dataset{<:JLD2.JLDFile, <:NTuple{1}}, i) = getobs(only(dataset.paths), i)
Base.getindex(dataset::JLD2Dataset, i) = map(Base.Fix2(getobs, i), dataset.paths)
Base.length(dataset::JLD2Dataset) = numobs(dataset.paths[1])

"""
    close(dataset::JLD2Dataset)

Close the underlying JLD2 file pointer for `dataset`.
"""
Base.close(dataset::JLD2Dataset) = close(dataset.fid)
