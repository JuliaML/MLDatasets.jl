module MLDatasets

using DelimitedFiles: readdlm
using FixedPointNumbers
using Pickle
using SparseArrays
using FileIO
using DataFrames, CSV, Tables
using Glob
using HDF5
using JLD2
import JSON3
import ImageCore
using ColorTypes
using MAT: matopen, matread
import MLUtils
using MLUtils: getobs, numobs, AbstractDataContainer

export getobs, numobs
export convert2image


include("abstract_datasets.jl")
# export AbstractDataset, 
#        SupervisedDataset

include("utils.jl")
export convert2image

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
include("datasets_misc/boston_housing.jl")
export BostonHousing
include("datasets_misc/iris.jl")
export Iris
include("datasets_misc/mutagenesis.jl")
export Mutagenesis
include("datasets_misc/titanic.jl")
export Titanic


# Vision

include("datasets_vision/emnist.jl")
export EMNIST
include("datasets_vision/mnist_reader/MNISTReader.jl")
include("datasets_vision/mnist.jl")
export MNIST
include("datasets_vision/fashion_mnist.jl")
export FashionMNIST
include("datasets_vision/cifar10_reader/CIFAR10Reader.jl")
include("datasets_vision/cifar10.jl")
export CIFAR10
include("datasets_vision/cifar100_reader/CIFAR100Reader.jl")
include("datasets_vision/cifar100.jl")
export CIFAR100

include("datasets_vision/svhn2.jl")
export SVHN2

# Text
include("datasets_text/PTBLM/PTBLM.jl")
include("datasets_text/UD_English/UD_English.jl")
include("datasets_text/SMSSpamCollection/SMSSpamCollection.jl")

# Graphs
include("datasets_graph/planetoid.jl")
    include("datasets_graph/Cora/Cora.jl")
    include("datasets_graph/PubMed/PubMed.jl")
    include("datasets_graph/CiteSeer/CiteSeer.jl")
include("datasets_graph/TUDataset/TUDataset.jl")
include("datasets_graph/OGBDataset/OGBDataset.jl")
include("datasets_graph/PolBlogs/PolBlogs.jl")
include("datasets_graph/KarateClub/KarateClub.jl")
export KarateClub

function __init__()

    # misc
    __init__iris()
    __init__mutagenesis()
    __init__ogbdataset()
    __init__tudataset()

    # vision
    __init__cifar10()
    __init__cifar100()
    __init__emnist()
    __init__fashionmnist()
    __init__mnist()
    __init__svhn2()
end

end
