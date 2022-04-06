module MLDatasets

using FixedPointNumbers: length
using ColorTypes: length
using Requires
using DelimitedFiles: readdlm
using FixedPointNumbers, ColorTypes
using Pickle
using SparseArrays
using FileIO
using DataFrames, CSV, Tables
using Glob
using HDF5
using JLD2
import JSON3

import MLUtils
using MLUtils: getobs, numobs, AbstractDataContainer
export getobs, numobs

include("utils.jl")
include("download.jl")

include("abstract_datasets.jl")
# export AbstractDataset, 
#        SupervisedDataset

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
include("SMSSpamCollection/SMSSpamCollection.jl")

# Graphs
include("planetoid.jl")
    include("Cora/Cora.jl")
    include("PubMed/PubMed.jl")
    include("CiteSeer/CiteSeer.jl")
include("TUDataset/TUDataset.jl")
include("OGBDataset/OGBDataset.jl")
include("PolBlogs/PolBlogs.jl")

function __init__()
    # initialize optional dependencies
    @require ImageCore="a09fc81d-aa75-5fe9-8630-4744c3626534" begin
        global __images_supported__ = true
    end

    __init__iris()
    __init__mutagenesis()
    __init__tudataset()
    __init__ogbdataset()
end

end
