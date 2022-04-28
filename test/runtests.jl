using Test
using MLDatasets
using MLDatasets: SupervisedDataset, UnsupervisedDataset, AbstractDataset
using MLDatasets: Graph
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
    "datasets/graphs.jl",
    "datasets/misc.jl",
    "datasets/vision/emnist.jl",
    "datasets/vision/fashion_mnist.jl",
    "datasets/vision/mnist.jl",
    "datasets/text.jl",
]

no_ci_dataset_tests = [
    "datasets/graphs_no_ci.jl",
    "datasets/vision/cifar10.jl",
    "datasets/vision/cifar100.jl",
    "datasets/vision/svhn2.jl",
    ]

@assert isempty(intersect(dataset_tests, no_ci_dataset_tests))

deprecated_interface = [
    # "datasets/vision/deprecated_fashion_mnist.jl",
    # "datasets/vision/deprecated_mnist.jl",
    # "datasets/vision/deprecated_cifar10.jl",
    # "datasets/vision/deprecated_cifar100.jl",
    # "datasets/vision/deprecated_svhn2.jl", # NOT OK
    # "datasets/graphs/deprecated_citeseer.jl",
    # "datasets/graphs/deprecated_cora.jl",
    # "datasets/graphs/deprecated_pubmed.jl",
    # "datasets/graphs/deprecated_tudataset.jl",
    # "datasets/graphs/deprecated_polblogs.jl",
    # "datasets/graphs/deprecated_karateclub.jl",
    # "datasets/text_deprecated.jl",
    # "datasets/misc_deprecated.jl",
]

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

    if !isempty(deprecated_interface)
        @info "Testing deprecated dataset interface"
        @testset "$(split(t,"/")[end])" for t in deprecated_interface
            include(t)
        end
    end
end

@testset "Containers" begin
    for t in container_tests
        include(t)
    end
end

nothing
