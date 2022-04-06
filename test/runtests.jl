using Test
using MLDatasets
using MLDatasets: SupervisedDataset, AbstractDataset
using FileIO
using ImageCore
using DataDeps
using DataFrames, CSV, Tables
using HDF5
using JLD2


ENV["DATADEPS_ALWAYS_ACCEPT"] = true

include("test_utils.jl")

dataset_tests = [
    ## misc
    "datasets_misc.jl",
    ## vision
    "tst_cifar10.jl",
    "tst_cifar100.jl",
    "tst_mnist.jl",
    "tst_fashion_mnist.jl",
    "tst_svhn2.jl",
    "tst_emnist.jl",
    ## graphs    
    "tst_citeseer.jl",
    "tst_cora.jl",
    "tst_pubmed.jl",
    "tst_tudataset.jl",
    "tst_polblogs.jl",
    ## text
    "tst_smsspamcollection.jl",
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
end

@testset "Containers" begin
    for t in container_tests
        include(t)
    end
end

#temporary to not stress CI
if !parse(Bool, get(ENV, "CI", "false"))
    @testset "other tests" begin
        # PTBLM
        x, y = PTBLM.traindata()
        x, y = PTBLM.testdata()

        # UD_English
        x = UD_English.traindata()
        x = UD_English.devdata()
        x = UD_English.testdata()
    end
end
nothing
