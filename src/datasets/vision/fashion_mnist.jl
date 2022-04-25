function __init__fashionmnist()
    DEPNAME = "FashionMNIST"
    TRAINIMAGES = "train-images-idx3-ubyte.gz"
    TRAINLABELS = "train-labels-idx1-ubyte.gz"
    TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    register(DataDep(
        DEPNAME,
        """
        Dataset: FashionMNIST
        Authors: Han Xiao, Kashif Rasul, Roland Vollgraf
        Website: https://github.com/zalandoresearch/fashion-mnist
        License: MIT

        [Han Xiao et al. 2017]
            Han Xiao, Kashif Rasul, and Roland Vollgraf.
            "Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms."
            arXiv:1708.07747

        The files are available for download at the offical
        website linked above. Note that using the data
        responsibly and respecting copyright remains your
        responsibility.
        """,
        "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/" .* [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS],
        "c916b6e00d3083643332b70f3c5c3543d3941334b802e252976893969ee6af67",
    ))
end


"""
    FashionMNIST(; Tx=Float32, split=:train, dir=nothing)
    FashionMNIST([Tx, split])

FashionMNIST is a dataset of Zalando's article images consisting
of a training set of 60_000 examples and a test set of 10_000
examples. Each example is a 28x28 grayscale image, associated
with a label from 10 classes. It can serve as a drop-in
replacement for MNIST.

- Authors: Han Xiao, Kashif Rasul, Roland Vollgraf
- Website: https://github.com/zalandoresearch/fashion-mnist

See [`MNIST`](@ref) for details of the interface.
"""
struct FashionMNIST <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Array{<:Any,3}
    targets::Vector{Int}
end

FashionMNIST(; split=:train, Tx=Float32, dir=nothing) = FashionMNIST(Tx, split; dir)

function FashionMNIST(Tx, split::Symbol; dir=nothing)
    @assert split in [:train, :test]
    if split == :train 
        IMAGESPATH = "train-images-idx3-ubyte.gz"
        LABELSPATH = "train-labels-idx1-ubyte.gz"
    else
        IMAGESPATH  = "t10k-images-idx3-ubyte.gz"
        LABELSPATH  = "t10k-labels-idx1-ubyte.gz"
    end

    features_path = datafile("FashionMNIST", IMAGESPATH, dir)
    features = bytes_to_type(Tx, MNISTReader.readimages(features_path))

    targets_path = datafile("FashionMNIST", LABELSPATH, dir)
    targets = Vector{Int}(MNISTReader.readlabels(targets_path))
    # targets = reshape(targets, 1, :) 

    metadata = Dict{String,Any}()
    metadata["n_observations"] = size(features)[end]
    metadata["features_path"] = features_path
    metadata["targets_path"] = targets_path
    metadata["class_names"] = ["T-Shirt", "Trouser", "Pullover", "Dress", "Coat", "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot"]

    return FashionMNIST(metadata, split, features, targets)
end

convert2image(::Type{<:FashionMNIST}, x::AbstractArray) = convert2image(MNIST, x)

# DEPRECATED INTERFACE, REMOVE IN v0.7 (or 0.6.x)
function Base.getproperty(::Type{FashionMNIST}, s::Symbol)
    if s == :traintensor
        @warn "FashionMNIST.traintensor() is deprecated, use `FashionMNIST(split=:train).features` instead." maxlog=2
        traintensor(T::Type=N0f8; kws...) = traintensor(T, :; kws...)
        traintensor(i; kws...) = traintensor(N0f8, i; kws...)
        function traintensor(T::Type, i; dir=nothing)
            FashionMNIST(; split=:train, Tx=T, dir)[i][1]
        end
        return traintensor
    elseif s == :testtensor
        @warn "FashionMNIST.testtensor() is deprecated, use `FashionMNIST(split=:test).features` instead."  maxlog=2
        testtensor(T::Type=N0f8; kws...) = testtensor(T, :; kws...)
        testtensor(i; kws...) = testtensor(N0f8, i; kws...)
        function testtensor(T::Type, i; dir=nothing)
            FashionMNIST(; split=:test, Tx=T, dir)[i][1]
        end
        return testtensor        
    elseif s == :trainlabels
        @warn "FashionMNIST.trainlabels() is deprecated, use `FashionMNIST(split=:train).targets` instead."  maxlog=2
        trainlabels(; kws...) = trainlabels(:; kws...)
        function trainlabels(i; dir=nothing)
            FashionMNIST(; split=:train, dir)[i][2]
        end
        return trainlabels
    elseif s == :testlabels
        @warn "FashionMNIST.testlabels() is deprecated, use `FashionMNIST(split=:test).targets` instead." maxlog=2
        testlabels(; kws...) = testlabels(:; kws...)
        function testlabels(i; dir=nothing)
            FashionMNIST(; split=:test, dir)[i][2]
        end
        return testlabels
    elseif s == :traindata
        @warn "FashionMNIST.traindata() is deprecated, use `FashionMNIST(split=:train)[]` instead." maxlog=2
        traindata(T::Type=N0f8; kws...) = traindata(T, :; kws...)
        traindata(i; kws...) = traindata(N0f8, i; kws...)
        function traindata(T::Type, i; dir=nothing)
            FashionMNIST(; split=:train, Tx=T, dir)[i]
        end
        return traindata
    elseif s == :testdata
        @warn "FashionMNIST.testdata() is deprecated, use `FashionMNIST(split=:test)[]` instead."  maxlog=2
        testdata(T::Type=N0f8; kws...) = testdata(T, :; kws...)
        testdata(i; kws...) = testdata(N0f8, i; kws...)
        function testdata(T::Type, i; dir=nothing)
            FashionMNIST(; split=:test, Tx=T, dir)[i]
        end
        return testdata
    elseif s == :convert2image
        @warn "FashionMNIST.convert2image(x) is deprecated, use `convert2image(FashionMNIST, x)` instead." maxlog=2
        return x -> convert2image(FashionMNIST, x)
    elseif s == :classnames
        @warn "FashionMNIST.classnames() is deprecated, use `FashionMNIST().metadata[\"class_names\"]` instead." maxlog=2
        return () -> ["T-Shirt", "Trouser", "Pullover", "Dress", "Coat", "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot"]
    else
        return getfield(FashionMNIST, s)
    end
end
