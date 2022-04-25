
function __init__svhn2()
    DEPNAME = "SVHN2"
    TRAINDATA = "train_32x32.mat"
    TESTDATA  = "test_32x32.mat"
    EXTRADATA = "extra_32x32.mat"

    register(DataDep(
        DEPNAME,
        """
        Dataset: The Street View House Numbers (SVHN) Dataset
        Authors: Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng
        Website: http://ufldl.stanford.edu/housenumbers
        Format: Cropped Digits (Format 2 on the website)
        Note: for non-commercial use only

        [Netzer et al., 2011]
            Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng
            "Reading Digits in Natural Images with Unsupervised Feature Learning"
            NIPS Workshop on Deep Learning and Unsupervised Feature Learning 2011

        The dataset is split up into three subsets: 73257
        digits for training, 26032 digits for testing, and
        531131 additional to use as extra training data.

        The files are available for download at the official
        website linked above. Note that using the data
        responsibly and respecting copyright remains your
        responsibility. For example the website mentions that
        the data is for non-commercial use only. Please read
        the website to make sure you want to download the
        dataset.
        """,
        "http://ufldl.stanford.edu/housenumbers/" .* [TRAINDATA, TESTDATA, EXTRADATA],
        "2fa3b0b79baf39de36ed7579e6947760e6241f4c52b6b406cabc44d654c13a50"
    ))
end


"""
    SVHN2(; Tx=Float32, split=:train, dir=nothing)
    SVHN2([Tx, split])

The Street View House Numbers (SVHN) Dataset.

- Authors: Yuval Netzer, Tao Wang, Adam Coates, Alessandro Bissacco, Bo Wu, Andrew Y. Ng
- Website: http://ufldl.stanford.edu/housenumbers

SVHN was obtained from house numbers in Google Street View
images. As such they are quite diverse in terms of orientation
and image background. Similar to MNIST, SVHN has 10 classes (the
digits 0-9), but unlike MNIST there is more data and the images
are a little bigger (32x32 instead of 28x28) with an additional
RGB color channel. The dataset is split up into three subsets:
73257 digits for training, 26032 digits for testing, and 531131
additional to use as extra training data.

# Arguments

$ARGUMENTS_SUPERVISED_ARRAY
- `split`: selects the data partition. Can take the values `:train:`, `:test` or `:extra`. 

# Fields

$FIELDS_SUPERVISED_ARRAY
- `split`.

# Methods

$METHODS_SUPERVISED_ARRAY
- [`convert2image`](@ref) converts features to `RGB` images.

# Examples

```julia-repl
julia> using MLDatasets: SVHN2

julia> using MLDatasets: SVHN2

julia> dataset = SVHN2()
SVHN2:
  metadata    =>    Dict{String, Any} with 2 entries
  split       =>    :train
  features    =>    32×32×3×73257 Array{Float32, 4}
  targets     =>    73257-element Vector{Int64}

julia> dataset[1:5].targets
5-element Vector{Int64}:
 1
 9
 2
 3
 2

julia> dataset.metadata
Dict{String, Any} with 2 entries:
  "n_observations" => 73257
  "class_names"    => ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
```
"""
struct SVHN2 <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Array{<:Any, 4}
    targets::Vector{Int}
end

SVHN2(; split=:train, Tx=Float32, dir=nothing) = SVHN2(Tx, split; dir)

function SVHN2(Tx::Type, split::Symbol=:train; dir=nothing)
    DEPNAME = "SVHN2"
    TRAINDATA = "train_32x32.mat"
    TESTDATA  = "test_32x32.mat"
    EXTRADATA = "extra_32x32.mat"
    CLASSES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    @assert split ∈ [:train, :test, :extra]
    if split == :train
        PATH = TRAINDATA
    elseif split == :test
        PATH = TESTDATA
    else
        PATH = EXTRADATA
    end

    path = datafile(DEPNAME, PATH, dir)
    vars = matread(path)
    images = vars["X"]::Array{UInt8,4}
    labels = vars["y"]
    images = permutedims(images, (2, 1, 3, 4))
    features = bytes_to_type(Tx, images)
    targets = Vector{Int}(vec(labels))

    metadata = Dict{String, Any}()
    metadata["n_observations"] = size(features)[end]
    metadata["class_names"] = string.(CLASSES)

    return SVHN2(metadata, split, features, targets)
end

convert2image(::Type{<:SVHN2}, x) = convert2image(CIFAR10, x)

      

# DEPRECATED INTERFACE, REMOVE IN v0.7 (or 0.6.x)
function Base.getproperty(::Type{SVHN2}, s::Symbol)
    if s == :traintensor
        @warn "SVHN2.traintensor() is deprecated, use `SVHN2(split=:train).features` instead." maxlog=2
        traintensor(T::Type=N0f8; kws...) = traintensor(T, :; kws...)
        traintensor(i; kws...) = traintensor(N0f8, i; kws...)
        function traintensor(T::Type, i; dir=nothing)
            SVHN2(; split=:train, Tx=T, dir)[i][1]
        end
        return traintensor
    elseif s == :testtensor
        @warn "SVHN2.testtensor() is deprecated, use `SVHN2(split=:test).features` instead."  maxlog=2
        testtensor(T::Type=N0f8; kws...) = testtensor(T, :; kws...)
        testtensor(i; kws...) = testtensor(N0f8, i; kws...)
        function testtensor(T::Type, i; dir=nothing)
            SVHN2(; split=:test, Tx=T, dir)[i][1]
        end
        return testtensor        
    elseif s == :trainlabels
        @warn "SVHN2.trainlabels() is deprecated, use `SVHN2(split=:train).targets` instead."  maxlog=2
        trainlabels(; kws...) = trainlabels(:; kws...)
        function trainlabels(i; dir=nothing)
            SVHN2(; split=:train, dir)[i][2]
        end
        return trainlabels
    elseif s == :testlabels
        @warn "SVHN2.testlabels() is deprecated, use `SVHN2(split=:test).targets` instead." maxlog=2
        testlabels(; kws...) = testlabels(:; kws...)
        function testlabels(i; dir=nothing)
            SVHN2(; split=:test, dir)[i][2]
        end
        return testlabels
    elseif s == :traindata
        @warn "SVHN2.traindata() is deprecated, use `SVHN2(split=:train)[]` instead." maxlog=2
        traindata(T::Type=N0f8; kws...) = traindata(T, :; kws...)
        traindata(i; kws...) = traindata(N0f8, i; kws...)
        function traindata(T::Type, i; dir=nothing)
            SVHN2(; split=:train, Tx=T, dir)[i]
        end
        return traindata
    elseif s == :testdata
        @warn "SVHN2.testdata() is deprecated, use `SVHN2(split=:test)[]` instead."  maxlog=2
        testdata(T::Type=N0f8; kws...) = testdata(T, :; kws...)
        testdata(i; kws...) = testdata(N0f8, i; kws...)
        function testdata(T::Type, i; dir=nothing)
            SVHN2(; split=:test, Tx=T, dir)[i]
        end
        return testdata
    elseif s == :convert2image
        @warn "SVHN2.convert2image(x) is deprecated, use `convert2image(SVHN2, x)` instead"
        return x -> convert2image(SVHN2, x)
    else
        return getfield(SVHN2, s)
    end
end
