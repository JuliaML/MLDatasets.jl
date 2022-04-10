using Test
using MLDatasets
using MLDatasets: SupervisedDataset, AbstractDataset
using FileIO
using DataDeps
using DataFrames, CSV, Tables
using HDF5
using JLD2
using ColorTypes
using FixedPointNumbers
using MLDatasets
using DataDeps


ENV["DATADEPS_ALWAYS_ACCEPT"] = true

include("test_utils.jl")

dataset_tests = [
    ## misc
    # "datasets_misc/datasets_misc.jl",
    # "datasets_misc/deprecated_misc.jl",
    ## vision
    # "datasets_vision/cifar10.jl",
    # "datasets_vision/fashion_mnist.jl",
    # "datasets_vision/mnist.jl",
    # "datasets_vision/deprecated_mnist.jl",
    "datasets_vision/deprecated_fashion_mnist.jl",
    # "datasets_vision/deprecated_cifar10.jl",
    # "tst_cifar100.jl",
    # "tst_svhn2.jl",
    # "tst_emnist.jl",
    # ## graphs    
    # "tst_citeseer.jl",
    # "tst_cora.jl",
    # "tst_pubmed.jl",
    # "tst_tudataset.jl",
    # "tst_polblogs.jl",
    # ## text
    # "datasets_text/datasets_text.jl",
    # "datasets_text/smsspamcollection.jl",
]

# container_tests = [
#     "containers/filedataset.jl",
#     "containers/tabledataset.jl",
#     "containers/hdf5dataset.jl",
#     "containers/jld2dataset.jl",
#     "containers/cacheddataset.jl",
# ]

@testset "Datasets" begin
    @testset "$(split(t,"/")[end])" for t in dataset_tests
        include(t)
    end
end

# @testset "Containers" begin
#     for t in container_tests
#         include(t)
#     end
# end

nothing
