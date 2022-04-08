function __init__mnist()
    DEPNAME = "MNIST"
    TRAINIMAGES = "train-images-idx3-ubyte.gz"
    TRAINLABELS = "train-labels-idx1-ubyte.gz"
    TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    register(DataDep(
            DEPNAME,
            """
            Dataset: THE MNIST DATABASE of handwritten digits
            Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges
            Website: http://yann.lecun.com/exdb/mnist/

            [LeCun et al., 1998a]
                Y. LeCun, L. Bottou, Y. Bengio, and P. Haffner.
                "Gradient-based learning applied to document recognition."
                Proceedings of the IEEE, 86(11):2278-2324, November 1998

            The files are available for download at the offical
            website linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility. The authors of MNIST aren't really
            explicit about any terms of use, so please read the
            website to make sure you want to download the
            dataset.
            """,
            "https://ossci-datasets.s3.amazonaws.com/mnist/" .* [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS],
            "0bb1d5775d852fc5bb32c76ca15a7eb4e9a3b1514a2493f7edfcf49b639d7975",
            # post_fetch_method = DataDeps.unpack  # TODO should we unzip instead of reading directly from the zip?
        ))
end


"""
    MNIST(; split=:train, Tx=Float32, dir=nothing)

The MNIST database of handwritten digits

- Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges
- Website: http://yann.lecun.com/exdb/mnist/

MNIST is a classic image-classification dataset that is often
used in small-scale machine learning experiments. It contains
70,000 images of handwritten digits. Each observation is a 28x28
pixel gray-scale image that depicts a handwritten version of 1 of
the 10 possible digits (0-9).

# Interface

- [`MNIST.traintensor`](@ref), [`MNIST.trainlabels`](@ref), [`MNIST.traindata`](@ref)
- [`MNIST.testtensor`](@ref), [`MNIST.testlabels`](@ref), [`MNIST.testdata`](@ref)

# Utilities

- [`MNIST.download`](@ref)
- [`MNIST.convert2image`](@ref)

# Examples


Returns the MNIST **training** images corresponding to the given
`indices` as a multi-dimensional array of eltype `T`.

The image(s) is/are returned in the horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 3D array (i.e. a `Array{T,3}`), in
WHN format (width, height, #images). 
For integer `indices` instead, a 2D array in WH format is returned.

```julia-repl
julia> MNIST.traintensor() # load all training images
28×28×60000 Array{N0f8,3}:
[...]

julia> MNIST.traintensor(Float32, 1:3) # first three images as Float32
28×28×3 Array{Float32,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{T}`.

```julia-repl
julia> MNIST.traintensor(1) # load first training image
28×28 Array{N0f8,2}:
[...]
```

Returns the MNIST **trainset** labels corresponding to the given
`indices` as an `Int` or `Vector{Int}`. The values of the labels
denote the digit that they represent. If `indices` is omitted,
all labels are returned.

```julia-repl
julia> MNIST.trainlabels() # full training set
60000-element Array{Int64,1}:
 5
 0
 ⋮
 6
 8

julia> MNIST.trainlabels(1:3) # first three labels
3-element Array{Int64,1}:
 5
 0
 4

julia> MNIST.trainlabels(1) # first label
5
```
"""
struct MNIST{Tx, Ax<:AbstractArray{Tx, 3}} <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Ax
    targets::Vector{Int}
end

MNIST(; split=:train, Tx=Float32, dir=nothing) = MNIST(Tx, split; dir)

function MNIST(Tx, split::Symbol; dir=nothing)
    @assert split in [:train, :test]
    if split == :train 
        IMAGESPATH = "train-images-idx3-ubyte.gz"
        LABELSPATH = "train-labels-idx1-ubyte.gz"
    else
        IMAGESPATH  = "t10k-images-idx3-ubyte.gz"
        LABELSPATH  = "t10k-labels-idx1-ubyte.gz"
    end
    
    features_path = datafile("MNIST", IMAGESPATH, dir)
    features = bytes_to_type(Tx, MNISTReader.readimages(features_path))

    targets_path = datafile("MNIST", LABELSPATH, dir)
    targets = Vector{Int}(MNISTReader.readlabels(targets_path))
    # targets = reshape(targets, 1, :) 

    metadata = Dict{String,Any}()
    metadata["n_observations"] = size(features, 2)
    metadata["features_path"] = features_path
    metadata["targets_path"] = targets_path

    return MNIST(metadata, split, features, targets)
end



# DEPRECATED INTERFACE, REMOVE IN v0.7 (or 0.6.x)
function Base.getproperty(::Type{MNIST}, s::Symbol)
    if s == :traintensor
        @warn "MNIST.traintensor() is deprecated, use `MNIST(split=:train).features` instead." maxlog=2
        traintensor(T::Type=N0f8; kws...) = traintensor(T, :; kws...)
        traintensor(i; kws...) = traintensor(N0f8, i; kws...)
        function traintensor(T::Type, i; dir=nothing)
            MNIST(; split=:train, Tx=T, dir)[i][1]
        end
        return traintensor
    elseif s == :testtensor
        @warn "MNIST.testtensor() is deprecated, use `MNIST(split=:test).features` instead."  maxlog=2
        testtensor(T::Type=N0f8; kws...) = testtensor(T, :; kws...)
        testtensor(i; kws...) = testtensor(N0f8, i; kws...)
        function testtensor(T::Type, i; dir=nothing)
            MNIST(; split=:test, Tx=T, dir)[i][1]
        end
        return testtensor        
    elseif s == :trainlabels
        @warn "MNIST.trainlabels() is deprecated, use `MNIST(split=:train).targets` instead."  maxlog=2
        trainlabels(; kws...) = trainlabels(:; kws...)
        function trainlabels(i; dir=nothing)
            MNIST(; split=:train, dir)[i][2]
        end
        return trainlabels
    elseif s == :testlabels
        @warn "MNIST.testlabels() is deprecated, use `MNIST(split=:test).targets` instead." maxlog=2
        testlabels(; kws...) = testlabels(:; kws...)
        function testlabels(i; dir=nothing)
            MNIST(; split=:test, dir)[i][2]
        end
        return testlabels
    elseif s == :traindata
        @warn "MNIST.traindata() is deprecated, use `MNIST(split=:train)[]` instead." maxlog=2
        traindata(T::Type=N0f8; kws...) = traindata(T, :; kws...)
        traindata(i; kws...) = traindata(N0f8, i; kws...)
        function traindata(T::Type, i; dir=nothing)
            MNIST(; split=:train, Tx=T, dir)[i]
        end
        return traindata
    elseif s == :testdata
        @warn "MNIST.testdata() is deprecated, use `MNIST(split=:test)[]` instead."  maxlog=2
        testdata(T::Type=N0f8; kws...) = testdata(T, :; kws...)
        testdata(i; kws...) = testdata(N0f8, i; kws...)
        function testdata(T::Type, i; dir=nothing)
            MNIST(; split=:test, Tx=T, dir)[i]
        end
        return testdata
    elseif s == :convert2image
        @error "MNIST.convert2image(x) is deprecated, use `ImageCore.colorview(Gray, x)` instead"
    else
        return getfield(MNIST, s)
    end
end
