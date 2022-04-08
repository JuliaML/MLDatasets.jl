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

global __images_supported__ = false

function _channelview(image::AbstractArray{<:Colorant})
    __images_supported__ ||
        error("Converting to/from image requires `using ImageCore`")
    ImageCore.channelview(image)
end

function _colorview(::Type{T}, array::AbstractArray{<:Number}) where T <: Color
    __images_supported__ ||
        error("Converting to image requires `using ImageCore`")
    ImageCore.colorview(T, array)
end

# PIRACY
MLUtils.numobs(x::AbstractDataFrame) = size(x, 1)
MLUtils.getobs(x::AbstractDataFrame, i) = x[i, :]
