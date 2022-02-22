module MLDatasets

using FixedPointNumbers: length
using ColorTypes: length
using Requires
using DelimitedFiles: readdlm
using FixedPointNumbers, ColorTypes
using Pickle
using SparseArrays
using DataFrames, CSV, Tables
using FilePathsBase
using FilePathsBase: AbstractPath
using Glob
using HDF5
using JLD2

import MLUtils
using MLUtils: getobs, numobs, AbstractDataContainer
export getobs, numobs

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


include("download.jl")

include("containers/filedataset.jl")
export FileDataset
include("containers/tabledataset.jl")
export TableDataset
include("containers/hdf5dataset.jl")
export HDF5Dataset
include("containers/jld2dataset.jl")
export JLD2Dataset
include("containers/cacheddataset.jl")
export CachedDataset

# Misc.
include("BostonHousing/BostonHousing.jl")
include("Iris/Iris.jl")
include("Mutagenesis/Mutagenesis.jl")
include("Titanic/Titanic.jl")

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
include("TUDataset/TUDataset.jl")

function __init__()
    # initialize optional dependencies
    @require ImageCore="a09fc81d-aa75-5fe9-8630-4744c3626534" begin
        global __images_supported__ = true
    end

    __init__tudataset()
end

end
