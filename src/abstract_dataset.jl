abstract type AbstractDataset <: AbstractDataContainer end

function Base.show(io::IO, d::D) where D <: AbstractDataset
    recur_io = IOContext(io, :compact => false)
    
    println(io, "$D:")
    
    for f in fieldnames(D)
        if !startswith(string(f), "_")
            print(recur_io, "  $f => ")
            # show(recur_io, MIME"text/plain"(), getfield(d, f))
            # println(recur_io)
            println(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end

_summary(x) = x
_summary(x::Union{Dict, AbstractArray, DataFrame}) = summary(x)
