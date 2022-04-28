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
using NPZ: npzread

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
include("datasets/misc/boston_housing.jl")
export BostonHousing
include("datasets/misc/iris.jl")
export Iris
include("datasets/misc/mutagenesis.jl")
export Mutagenesis
include("datasets/misc/titanic.jl")
export Titanic


# Vision

include("datasets/vision/emnist.jl")
export EMNIST
include("datasets/vision/mnist_reader/MNISTReader.jl")
include("datasets/vision/mnist.jl")
export MNIST
include("datasets/vision/fashion_mnist.jl")
export FashionMNIST
include("datasets/vision/cifar10_reader/CIFAR10Reader.jl")
include("datasets/vision/cifar10.jl")
export CIFAR10
include("datasets/vision/cifar100_reader/CIFAR100Reader.jl")
include("datasets/vision/cifar100.jl")
export CIFAR100

include("datasets/vision/svhn2.jl")
export SVHN2

# Text
include("datasets/text/ptblm.jl")
export PTBLM
include("datasets/text/udenglish.jl")
export UD_English
include("datasets/text/smsspamcollection.jl")
export SMSSpamCollection

# Graphs
include("graph.jl")
# export Graph

include("datasets/graphs/planetoid.jl")
include("datasets/graphs/cora.jl")
export Cora
include("datasets/graphs/pubmed.jl")
export PubMed
include("datasets/graphs/citeseer.jl")
export CiteSeer
include("datasets/graphs/tudataset.jl")
export TUDataset
include("datasets/graphs/ogbdataset.jl")
export OGBDataset
include("datasets/graphs/polblogs.jl")
export PolBlogs
include("datasets/graphs/karateclub.jl")
export KarateClub
include("datasets/graphs/reddit.jl")
export Reddit

function __init__()
    # TODO automatically find and execute __init__xxx functions

    # graph
    __init__citeseer()
    __init__cora()
    __init__ogbdataset()
    __init__polblogs()
    __init__pubmed()
    __init__reddit()
    __init__tudataset()

    # misc
    __init__iris()
    __init__mutagenesis()

    #text
    __init__ptblm()
    __init__smsspam()
    __init__udenglish()

    # vision
    __init__cifar10()
    __init__cifar100()
    __init__emnist()
    __init__fashionmnist()
    __init__mnist()
    __init__svhn2()
end

end #module
