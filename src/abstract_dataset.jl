abstract type AbstractDataset <: AbstractDataContainer end

function Base.show(io::IO, d::D) where D <: AbstractDataset
    println(io, "$D dataset:")
    for f in fieldnames(D)
        if !startswith(string(f), "_")
            println(io, "  $f : $(_summary(getfield(d, f)))")
        end
    end
end

_summary(x) = x
_summary(x::AbstractArray) = summary(x)


# TODO check if hasfield(D, :targets) to handle both supervised and unsupervised
Base.getindex(d::AbstractDataset) = getobs((; d.features, d.targets))
Base.getindex(d::AbstractDataset, i) = getobs((; d.features, d.targets), i)
Base.length(d::AbstractDataset) = numobs(d.features)
