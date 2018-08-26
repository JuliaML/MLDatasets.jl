module MLDatasets

using Requires
using FixedPointNumbers, ColorTypes

bytes_to_type(::Type{UInt8}, A::Array{UInt8}) = A
bytes_to_type(::Type{N0f8}, A::Array{UInt8}) = reinterpret(N0f8, A)
bytes_to_type(::Type{T}, A::Array{UInt8}) where T<:Integer = convert(Array{T}, A)
bytes_to_type(::Type{T}, A::Array{UInt8}) where T<:AbstractFloat = A ./ T(255)
bytes_to_type(::Type{T}, A::Array{UInt8}) where T<:Number  = convert(Array{T}, reinterpret(N0f8, A))

global __images_supported__ = false
global __matfiles_supported__ = false

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

function _matopen(f::Function, path::AbstractString)
    __matfiles_supported__ ||
        error("Reading .mat files requires `using MAT`")
    MAT.matopen(f, path)
end

function _matread(path::AbstractString)
    __matfiles_supported__ ||
        error("Reading .mat files requires `using MAT`")
    MAT.matread(path)
end


include("download.jl")
include("CoNLL.jl")

include("CIFAR10/CIFAR10.jl")
include("CIFAR100/CIFAR100.jl")
include("MNIST/MNIST.jl")
include("FashionMNIST/FashionMNIST.jl")
include("SVHN2/SVHN2.jl")
include("PTBLM/PTBLM.jl")
include("UD_English/UD_English.jl")

function __init__()
    # initialize optional dependencies
    @require ImageCore="a09fc81d-aa75-5fe9-8630-4744c3626534" begin
        global __images_supported__ = true
    end
    @require MAT="23992714-dd62-5051-b70f-ba57cb901cac" begin
        global __matfiles_supported__ = true
    end
end

end
