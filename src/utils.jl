read_csv(path; kws...) = read_csv(path, DataFrame; kws...)

# function read_csv(path, sink::Type{<:AbstractMatrix{T}}; delim=nothing, kws...) where T
#     x = delim === nothing ? readdlm(path, T; kws...) : readdlm(path, delim, T; kws...)
#     return x
# end

function read_csv(path, sink::Type{A}; kws...) where A <: AbstractMatrix
    A(read_csv(path; kws...))
end

function read_csv(path, sink::Type{<:DataFrame}; kws...)
    return CSV.read(path, sink; kws...)
end

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

function df_to_matrix(df::AbstractDataFrame)
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

# PIRACY # see https://github.com/JuliaML/MLUtils.jl/issues/67
MLUtils.numobs(x::AbstractDataFrame) = size(x, 1)
MLUtils.getobs(x::AbstractDataFrame, i) = x[i, :]


"""
    convert2image(d, i)
    convert2image(d, x)
    convert2image(DType, x)

Convert the observation(s) `i` from dataset `d` to image(s).
It can also convert a numerical array `x`.

# Examples

```julia-repl
julia> using MLDatasets: MNIST
        
julia> using ImageInTerminal

julia> d = MNIST()

julia> i = 1:2;

julia> convert2image(d, i)

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
