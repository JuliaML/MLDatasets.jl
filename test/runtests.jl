using Test
using MLDatasets
using MLDatasets: SupervisedDataset, UnsupervisedDataset, AbstractDataset
using MLDatasets: Graph
using DataFrames, Tables, CSV
using ImageShow
using ColorTypes
using FixedPointNumbers
using JSON3

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

include("test_utils.jl")

dataset_tests = [
    "datasets/graphs.jl",
    "datasets/misc.jl",
    "datasets/vision/fashion_mnist.jl",
    "datasets/vision/mnist.jl",
    "datasets/text.jl",
]

no_ci_dataset_tests = [
    "datasets/graphs_no_ci.jl",
    "datasets/vision/cifar10.jl",
    "datasets/vision/cifar100.jl",
    "datasets/vision/emnist.jl",
    "datasets/vision/svhn2.jl",
    ]

@assert isempty(intersect(dataset_tests, no_ci_dataset_tests))

container_tests = [
    "containers/filedataset.jl",
    # "containers/tabledataset.jl",
    # "containers/hdf5dataset.jl",
    # "containers/jld2dataset.jl",
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
