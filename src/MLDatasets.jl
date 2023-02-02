module MLDatasets

using FixedPointNumbers
using SparseArrays
using Tables
using DataDeps
import MLUtils
using MLUtils: getobs, numobs, AbstractDataContainer
using Printf
using Glob
using DelimitedFiles: readdlm
using FileIO
using StackViews: StackView
import CSV
using LazyModules: @lazy

include("require.jl") # export @require

# Use `@lazy import SomePkg` whenever the returned types are not its own types,
# since for methods applied on the returned types we would encounter in world-age issues
# (see discussion in  https://github.com/JuliaML/MLDatasets.jl/pull/128).
# In the other case instead, use `require import SomePkg` to force
# the use to manually import.

@require import JSON3="0f8b85d8-7281-11e9-16c2-39a750bddbf1"
@require import DataFrames="a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
@require import ImageShow="4e3cecfd-b093-5904-9786-8bbb286a6a31"
@require import Chemfiles="46823bd8-5fb3-5f92-9aa0-96921f3dd015"

# @lazy import NPZ # lazy imported by FileIO
@lazy import Pickle="fbb45041-c46e-462f-888f-7c521cafbc2c"
@lazy import MAT="23992714-dd62-5051-b70f-ba57cb901cac"
@lazy import HDF5="f67ccb44-e63f-5c2f-98bd-6dc0ccc4ba2f"
# @lazy import JLD2

@lazy import JpegTurbo="b835a17e-a41a-41e7-81f0-2f016b05efe0" # Required for ImageNet

export getobs, numobs # From MLUtils.jl

include("abstract_datasets.jl")
# export AbstractDataset,
#        SupervisedDataset

include("utils.jl")
export convert2image

include("io.jl")
# export read_csv, read_npy, ...

include("download.jl")

include("containers/filedataset.jl")
export FileDataset
include("containers/cacheddataset.jl")
export CachedDataset
# include("containers/tabledataset.jl")
# export TableDataset

## TODO add back when compatible with `@lazy` or `@require`
## which means that they cannot dispatch on types from JLD2 and HDF5
# include("containers/hdf5dataset.jl")
# export HDF5Dataset
# include("containers/jld2dataset.jl")
# export JLD2Dataset

## Misc.

include("datasets/misc/boston_housing.jl")
export BostonHousing
include("datasets/misc/iris.jl")
export Iris
include("datasets/misc/mutagenesis.jl")
export Mutagenesis
include("datasets/misc/titanic.jl")
export Titanic


## Vision

include("datasets/vision/cifar10_reader/CIFAR10Reader.jl")
include("datasets/vision/cifar10.jl")
export CIFAR10
include("datasets/vision/cifar100_reader/CIFAR100Reader.jl")
include("datasets/vision/cifar100.jl")
export CIFAR100
include("datasets/vision/emnist.jl")
export EMNIST
include("datasets/vision/fashion_mnist.jl")
export FashionMNIST
include("datasets/vision/mnist_reader/MNISTReader.jl")
include("datasets/vision/mnist.jl")
export MNIST
include("datasets/vision/omniglot.jl")
export Omniglot
include("datasets/vision/svhn2.jl")
export SVHN2
include("datasets/vision/imagenet_reader/ImageNetReader.jl")
include("datasets/vision/imagenet.jl")
export ImageNet


## Text

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
# export read_planetoid_data
include("datasets/graphs/cora.jl")
export Cora
include("datasets/graphs/citeseer.jl")
export CiteSeer
include("datasets/graphs/karateclub.jl")
export KarateClub
include("datasets/graphs/movielens.jl")
export MovieLens
include("datasets/graphs/ogbdataset.jl")
export OGBDataset
include("datasets/graphs/organicmaterialsdb.jl")
export OrganicMaterialsDB
include("datasets/graphs/polblogs.jl")
export PolBlogs
include("datasets/graphs/pubmed.jl")
export PubMed
include("datasets/graphs/reddit.jl")
export Reddit
include("datasets/graphs/tudataset.jl")
export TUDataset

# Meshes

include("datasets/meshes/faust.jl")
export FAUST

function __init__()
    # TODO automatically find and execute __init__xxx functions

    # graph
    __init__citeseer()
    __init__cora()
    __init__movielens()
    __init__ogbdataset()
    __init__omdb()
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
    __init__imagenet()
    __init__mnist()
    __init__omniglot()
    __init__svhn2()

    # mesh
    __init__faust()
end

end #module
