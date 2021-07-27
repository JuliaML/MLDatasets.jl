module MLDatasets

using Requires
using DelimitedFiles: readdlm
using FixedPointNumbers, ColorTypes
using PyCall

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


include("download.jl")


# Misc.
include("BostonHousing/BostonHousing.jl")
include("Iris/Iris.jl")

# Vision
include("CIFAR10/CIFAR10.jl")
include("CIFAR100/CIFAR100.jl")
include("MNIST/MNIST.jl")
include("FashionMNIST/FashionMNIST.jl")
include("SVHN2/SVHN2.jl")
include("EMNIST/EMNIST.jl")

# Text
include("CoNLL.jl")
include("PTBLM/PTBLM.jl")
include("UD_English/UD_English.jl")

# Graphs
include("planetoid.jl")
    include("Cora/Cora.jl")
    include("PubMed/PubMed.jl")
    include("CiteSeer/CiteSeer.jl")

function __init__()
    # initialize optional dependencies
    @require ImageCore="a09fc81d-aa75-5fe9-8630-4744c3626534" begin
        global __images_supported__ = true
    end

    # install scipy if not already there
    pyimport_conda("scipy", "scipy")

    py"""
    import pickle

    def pyread_planetoid_file(path, name):
        out = pickle.load(open(path, "rb"), encoding="latin1")
        if name == 'graph':
            return out
        out = out.todense() if hasattr(out, 'todense') else out
        return out
    """
end

end
