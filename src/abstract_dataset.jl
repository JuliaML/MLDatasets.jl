abstract type AbstractDataset <: AbstractDataContainer end

function Base.show(io::IO, d::D) where D <: AbstractDataset
<<<<<<< HEAD
    recur_io = IOContext(io, :compact => false)
    
    println(io, "$D:")
    
    for f in fieldnames(D)
        if !startswith(string(f), "_")
            print(recur_io, "  $f => ")
            # show(recur_io, MIME"text/plain"(), getfield(d, f))
            # println(recur_io)
            println(recur_io, "$(_summary(getfield(d, f)))")
=======
    println(io, "$D dataset:")
    for f in fieldnames(D)
        if !startswith(string(f), "_")
            println(io, "  $f : $(_summary(getfield(d, f)))")
>>>>>>> 66e6378 (add ArrayDataset)
        end
    end
end

_summary(x) = x
<<<<<<< HEAD
_summary(x::Union{Dict, AbstractArray}) = summary(x)
=======
_summary(x::AbstractArray) = summary(x)


# TODO check if hasfield(D, :targets) to handle both supervised and unsupervised
Base.getindex(d::AbstractDataset) = getobs((; d.features, d.targets))
Base.getindex(d::AbstractDataset, i) = getobs((; d.features, d.targets), i)
Base.length(d::AbstractDataset) = numobs(d.features)
>>>>>>> 66e6378 (add ArrayDataset)
