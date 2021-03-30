export MNIST

"""
The MNIST database of handwritten digits

- Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges
- Website: http://yann.lecun.com/exdb/mnist/

MNIST is a classic image-classification dataset that is often
used in small-scale machine learning experiments. It contains
70,000 images of handwritten digits. Each observation is a 28x28
pixel gray-scale image that depicts a handwritten version of 1 of
the 10 possible digits (0-9).

## Interface

- [`MNIST.traintensor`](@ref), [`MNIST.trainlabels`](@ref), [`MNIST.traindata`](@ref)
- [`MNIST.testtensor`](@ref), [`MNIST.testlabels`](@ref), [`MNIST.testdata`](@ref)

## Utilities

- [`MNIST.download`](@ref)
- [`MNIST.convert2image`](@ref)
"""
module MNIST
    using Pkg.Artifacts
    using LazyArtifacts
    using ColorTypes
    using FixedPointNumbers
    using ..MLDatasets: bytes_to_type, _colorview

    export

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        convert2image,

        download

    @deprecate convert2features reshape

    const ARTIFACT_NAME = "MNIST"
    const TRAINIMAGES = "train-images-idx3-ubyte.gz"
    const TRAINLABELS = "train-labels-idx1-ubyte.gz"
    const TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    const TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

   
    include(joinpath("Reader","Reader.jl"))
    include("interface.jl")
    include("utils.jl")

          
    artifact_toml = joinpath(@__DIR__, "..", "..", "Artifacts.toml")
    _hash = artifact_hash(ARTIFACT_NAME, artifact_toml)

    if _hash === nothing || !artifact_exists(_hash)
        _hash = create_artifact() do artifact_dir
            url_base = "https://ossci-datasets.s3.amazonaws.com/mnist/"
            for file in [TRAINIMAGES, TRAINLABELS, 
                         TESTIMAGES, TESTLABELS]
                download("$url_base/$file", joinpath(artifact_dir, file))
            end         
        end
        bind_artifact!(artifact_toml, ARTIFACT_NAME, _hash, lazy=true)
    end

    
end
