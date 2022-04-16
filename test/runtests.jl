using Test
using MLDatasets
using MLDatasets: SupervisedDataset, UnsupervisedDataset, AbstractDataset
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

# we comment out deprecated test
dataset_tests = [
    ### misc
    "datasets_misc/misc.jl",
    # "datasets_misc/deprecated_misc.jl",
    #### vision
    "datasets_vision/emnist.jl",
    "datasets_vision/fashion_mnist.jl",
    "datasets_vision/mnist.jl",
    # "datasets_vision/deprecated_fashion_mnist.jl",
    # "datasets_vision/deprecated_mnist.jl",
    #### graphs    
    "datasets_graph/deprecated_citeseer.jl",
    "datasets_graph/deprecated_cora.jl",
    "datasets_graph/deprecated_pubmed.jl",
    "datasets_graph/deprecated_tudataset.jl",
    "datasets_graph/deprecated_polblogs.jl",
    "datasets_graph/deprecated_karateclub.jl",
    #### text
    "datasets_text/text.jl",
    # "datasets_text/deprecated_text.jl",
]

no_ci_dataset_tests = [
    ## vision
    "datasets_vision/cifar10.jl",
    "datasets_vision/cifar100.jl",
    "datasets_vision/svhn2.jl",
    # "datasets_vision/deprecated_cifar10.jl",
    # "datasets_vision/deprecated_cifar100.jl",
    # "datasets_vision/deprecated_svhn2.jl", # NOT OK
    ]

@assert isempty(intersect(dataset_tests, no_ci_dataset_tests))

container_tests = [
    "containers/filedataset.jl",
    "containers/tabledataset.jl",
    "containers/hdf5dataset.jl",
    "containers/jld2dataset.jl",
    "containers/cacheddataset.jl",
]

@testset "Datasets" begin
    @testset "$(split(t,"/")[end])" for t in dataset_tests
        include(t)
    end

    if !parse(Bool, get(ENV, "CI", "false"))
        @info "Testing larger datasets"
        @testset "$(split(t,"/")[end])" for t in no_ci_dataset_tests
            include(t)
        end
    else 
        @info "CI detected: skipping tests on large datasets"
    end    
end

@testset "Containers" begin
    for t in container_tests
        include(t)
    end
end

nothing
