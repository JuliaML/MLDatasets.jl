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

