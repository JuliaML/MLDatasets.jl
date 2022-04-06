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
    MNIST(; split, dir=nothing)

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
struct MNIST #<: SupervisedDataset
    metadata::Dict
    split::Symbol
    features::Array{Float32, 3}
    targets::Matrix{Int}
end

MNIST(; split, dir=nothing) = MNIST(split; dir)

function MNIST(split::Symbol; dir=nothing)
    @assert split in [:train, :test]
    if split == :train 
        IMAGESPATH = "train-images-idx3-ubyte.gz"
        LABELSPATH = "train-labels-idx1-ubyte.gz"
    else
        IMAGESPATH  = "t10k-images-idx3-ubyte.gz"
        LABELSPATH  = "t10k-labels-idx1-ubyte.gz"
    end
    path = datafile("MNIST", IMAGESPATH, dir)
    images = MNISTReader.readimages(path)
    features = bytes_to_type(Float32, images)
   
    path = datafile("MNIST", LABELSPATH, dir)
    targets = Vector{Int}(MNISTReader.readlabels(path))
    targets = reshape(targets, 1, :) 

    metadata = Dict{String,Any}()
    metadata["n_observations"] = size(features, 2)

    return MNIST(metadata, split, features, targets)
end
