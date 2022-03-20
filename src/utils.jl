# Julia 1.0 compatibility
if !isdefined(Base, :isnothing)
    isnothing(x) = x === nothing
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

