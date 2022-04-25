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
    MNIST(; Tx=Float32, split=:train, dir=nothing)
    MNIST([Tx, split])

The MNIST database of handwritten digits.

- Authors: Yann LeCun, Corinna Cortes, Christopher J.C. Burges
- Website: http://yann.lecun.com/exdb/mnist/

MNIST is a classic image-classification dataset that is often
used in small-scale machine learning experiments. It contains
70,000 images of handwritten digits. Each observation is a 28x28
pixel gray-scale image that depicts a handwritten version of 1 of
the 10 possible digits (0-9).

# Arguments

$ARGUMENTS_SUPERVISED_ARRAY
- `split`: selects the data partition. Can take the values `:train:` or `:test`. 

# Fields

$FIELDS_SUPERVISED_ARRAY
- `split`.

# Methods

$METHODS_SUPERVISED_ARRAY
- [`convert2image`](@ref) converts features to `Gray` images.

# Examples

The images are loaded as a multi-dimensional array of eltype `Tx`.
If `Tx <: Integer`, then all values will be within `0` and `255`, 
otherwise the values are scaled to be between `0` and `1`.
`MNIST().features` is a 3D array (i.e. a `Array{Tx,3}`), in
WHN format (width, height, num_images). Labels are stored as
a vector of integers in `MNIST().targets`. 

```julia-repl
julia> using MLDatasets: MNIST

julia> dataset = MNIST()
MNIST:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :train
  features    =>    28×28×60000 Array{Float32, 3}
  targets     =>    60000-element Vector{Int64}

julia> dataset[1:5].targets
5-element Vector{Int64}:
7
2
1
0
4

julia> X, y = dataset[];

julia> dataset = MNIST(UInt8, :test)
MNIST:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :test
  features    =>    28×28×10000 Array{UInt8, 3}
  targets     =>    10000-element Vector{Int64}
```
"""
struct MNIST <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Array{<:Any,3}
    targets::Vector{Int}
end

MNIST(; split=:train, Tx=Float32, dir=nothing) = MNIST(Tx, split; dir)

function MNIST(Tx::Type, split::Symbol=:train; dir=nothing)
    @assert split in [:train, :test]
    if split === :train 
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
    metadata["n_observations"] = size(features)[end]
    metadata["features_path"] = features_path
    metadata["targets_path"] = targets_path

    return MNIST(metadata, split, features, targets)
end

convert2image(::Type{<:MNIST}, x::AbstractArray{<:Integer}) =
    convert2image(MNIST, reinterpret(N0f8, convert(Array{UInt8}, x)))

function convert2image(::Type{<:MNIST}, x::AbstractArray{T,N}) where {T,N}
    @assert N == 2 || N == 3
    x = permutedims(x, (2, 1, 3:N...))
    return ImageCore.colorview(Gray, x)
end

# DEPRECATED INTERFACE, REMOVE IN v0.7 (or 0.6.x)
# This is has an hack to deprecate the old datasets-are-modules interface
# in favor of a datasets-are-types interface.
# Unfortunately overloading getproperty for a a type doesn't play well for
# parameterized types (e.g. typeof(dataset) hangs). 
# After we remove this deprecation path, we can parameterize the type like this:
# MNIST{Tx, A <: AbstractArray{Tx, 3}}
function Base.getproperty(::Type{MNIST}, s::Symbol)
    if s === :traintensor
        @warn "MNIST.traintensor() is deprecated, use `MNIST(split=:train).features` instead." maxlog=2
        traintensor(T::Type=N0f8; kws...) = traintensor(T, :; kws...)
        traintensor(i; kws...) = traintensor(N0f8, i; kws...)
        function traintensor(T::Type, i; dir=nothing)
            MNIST(; split=:train, Tx=T, dir)[i][1]
        end
        return traintensor
    elseif s === :testtensor
        @warn "MNIST.testtensor() is deprecated, use `MNIST(split=:test).features` instead."  maxlog=2
        testtensor(T::Type=N0f8; kws...) = testtensor(T, :; kws...)
        testtensor(i; kws...) = testtensor(N0f8, i; kws...)
        function testtensor(T::Type, i; dir=nothing)
            MNIST(; split=:test, Tx=T, dir)[i][1]
        end
        return testtensor        
    elseif s === :trainlabels
        @warn "MNIST.trainlabels() is deprecated, use `MNIST(split=:train).targets` instead."  maxlog=2
        trainlabels(; kws...) = trainlabels(:; kws...)
        function trainlabels(i; dir=nothing)
            MNIST(; split=:train, dir)[i][2]
        end
        return trainlabels
    elseif s === :testlabels
        @warn "MNIST.testlabels() is deprecated, use `MNIST(split=:test).targets` instead." maxlog=2
        testlabels(; kws...) = testlabels(:; kws...)
        function testlabels(i; dir=nothing)
            MNIST(; split=:test, dir)[i][2]
        end
        return testlabels
    elseif s === :traindata
        @warn "MNIST.traindata() is deprecated, use `MNIST(split=:train)[]` instead." maxlog=2
        traindata(T::Type=N0f8; kws...) = traindata(T, :; kws...)
        traindata(i; kws...) = traindata(N0f8, i; kws...)
        function traindata(T::Type, i; dir=nothing)
            MNIST(; split=:train, Tx=T, dir)[i]
        end
        return traindata
    elseif s === :testdata
        @warn "MNIST.testdata() is deprecated, use `MNIST(split=:test)[]` instead."  maxlog=2
        testdata(T::Type=N0f8; kws...) = testdata(T, :; kws...)
        testdata(i; kws...) = testdata(N0f8, i; kws...)
        function testdata(T::Type, i; dir=nothing)
            MNIST(; split=:test, Tx=T, dir)[i]
        end
        return testdata
    elseif s === :convert2image
        @warn "MNIST.convert2image(x) is deprecated, use `convert2image(MNIST, x)` instead"
        return x -> convert2image(MNIST, x)
    else
        return getfield(MNIST, s)
    end
end
