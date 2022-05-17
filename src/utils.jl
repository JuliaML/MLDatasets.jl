
function parse_pystring(s::AbstractString)
    s == "False" && return false
    s == "True" && return true
    s == "None" && return nothing
    try return parse(Int, s); catch; end
    try return parse(Float64, s); catch; end 
    return s
end

function restrict_array_type(res::AbstractArray)
    # attempt conversion
    if all(x -> x isa Integer, res)
        return Int.(res)
    elseif all(x -> x isa AbstractFloat, res)
        return Float32.(res)
    elseif all(x -> x isa String, res)
        return String.(res)
    else 
        return res
    end
end

function df_to_matrix(df)
    x = Matrix(df)
    if size(x, 2) == 1
        return reshape(x, 1, size(x, 1))
    else
        return permutedims(x, (2, 1))
    end
end

bytes_to_type(::Type{UInt8}, A::Array{UInt8}) = A
bytes_to_type(::Type{N0f8}, A::Array{UInt8}) = reinterpret(N0f8, A)
bytes_to_type(::Type{T}, A::Array{UInt8}) where T<:Integer = convert(Array{T}, A)
bytes_to_type(::Type{T}, A::Array{UInt8}) where T<:AbstractFloat = A ./ T(255)
bytes_to_type(::Type{T}, A::Array{UInt8}) where T<:Number  = convert(Array{T}, reinterpret(N0f8, A))


function clean_nt(nt::NamedTuple)
    res = (; (p for p in  pairs(nt) if p[2] !== nothing)...)
    if isempty(res)
        return nothing
    else
        return res
    end
end

function indexes2mask(idxs::AbstractVector{Int}, n)
    mask = falses(n)
    mask[idxs] .= true
    return mask
end

function mask2indexes(mask::BitVector)
    n = length(mask)
    return (1:n)[mask]
end

maybesqueeze(x) = x
maybesqueeze(x::AbstractMatrix) = size(x, 1) == 1 ? vec(x) : x

"""
    convert2image(d, i)
    convert2image(d, x)
    convert2image(DType, x)

Convert the observation(s) `i` from dataset `d` to image(s).
It can also convert a numerical array `x`.

In order to support a new dataset, e.g. `MyDataset`, 
implement `convert2image(::Type{MyDataset}, x::AbstractArray)`.

# Examples

```julia-repl
julia> using MLDatasets, ImageInTerminal

julia> d = MNIST()

julia> convert2image(d, 1:2) 
# You should see 2 images in the terminal

julia> x = d[1].features;

julia> convert2image(MNIST, x) # or convert2image(d, x)
```
"""
function convert2image end


convert2image(d::SupervisedDataset, i::Integer) =
    convert2image(typeof(d), d[i].features)
convert2image(d::SupervisedDataset, i::AbstractVector) =
    convert2image(typeof(d), d[i].features)
convert2image(d::SupervisedDataset, x::AbstractArray) =
    convert2image(typeof(d), x)
