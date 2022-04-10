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
    # "datasets_vision/cifar10.jl", #ok
    # "datasets_vision/cifar100.jl", #ok
    # "datasets_vision/emnist.jl", #ok
    # "datasets_vision/fashion_mnist.jl", #ok
    # "datasets_vision/mnist.jl", #ok
    # "datasets_vision/svhn2.jl",
    # "datasets_vision/deprecated_cifar10.jl", #ok
    # "datasets_vision/deprecated_cifar100.jl", #ok
    # "datasets_vision/deprecated_fashion_mnist.jl", #ok
    # "datasets_vision/deprecated_mnist.jl", #ok
    # "datasets_vision/deprecated_svhn2.jl",
    # ## graphs    
    # "datasets_vision/citeseer.jl",
    # "datasets_vision/cora.jl",
    # "datasets_vision/pubmed.jl",
    # "datasets_vision/tudataset.jl",
    # "datasets_vision/polblogs.jl",
    # "datasets_vision/deprecated_citeseer.jl",
    # "datasets_vision/deprecated_cora.jl",
    # "datasets_vision/deprecated_pubmed.jl",
    # "datasets_vision/deprecated_tudataset.jl",
    # "datasets_vision/deprecated_polblogs.jl",
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
