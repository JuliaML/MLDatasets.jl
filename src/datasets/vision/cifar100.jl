function __init__cifar100()
    DEPNAME = "CIFAR100"

    register(DataDep(
        DEPNAME,
        """
        Dataset: The CIFAR-100 dataset
        Authors: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton
        Website: https://www.cs.toronto.edu/~kriz/cifar.html
        Reference: https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf

        [Krizhevsky, 2009]
            Alex Krizhevsky.
            "Learning Multiple Layers of Features from Tiny Images",
            Tech Report, 2009.

        The CIFAR-100 dataset is a labeled subsets of the 80
        million tiny images dataset. It consists of 60000
        32x32 colour images in 100 classes. Specifically, it
        has 100 classes containing 600 images each. There are
        500 training images and 100 testing images per class.
        The 100 classes in the CIFAR-100 are grouped into 20
        superclasses. Each image comes with a "fine" label
        (the class to which it belongs) and a "coarse" label
        (the superclass to which it belongs).

        The compressed archive file that contains the
        complete dataset is available for download at the
        offical website linked above; specifically the binary
        version for C programs. Note that using the data
        responsibly and respecting copyright remains your
        responsibility. The authors of CIFAR-10 aren't really
        explicit about any terms of use, so please read the
        website to make sure you want to download the
        dataset.
        """,
        "https://www.cs.toronto.edu/~kriz/cifar-100-binary.tar.gz",
        "58a81ae192c23a4be8b1804d68e518ed807d710a4eb253b1f2a199162a40d8ec",
        post_fetch_method = file -> (run(BinDeps.unpack_cmd(file, dirname(file), ".gz", ".tar")); rm(file))
    ))
end


"""
    CIFAR100(; Tx=Float32, split=:train, dir=nothing)
    CIFAR100([Tx, split])

The CIFAR100 dataset is a labeled subsets of the 80
million tiny images dataset. It consists of 60000
32x32 colour images in 10 classes, with 6000 images
per class.

Return the CIFAR-100 **trainset** labels (coarse and fine)
corresponding to the given `indices` as a tuple of two `Int` or
two `Vector{Int}`. The variables returned are the coarse label(s)
(`Yc`) and the fine label(s) (`Yf`) respectively.

# Arguments

$ARGUMENTS_SUPERVISED_ARRAY
- `split`: selects the data partition. Can take the values `:train:` or `:test`. 

# Fields

$FIELDS_SUPERVISED_ARRAY
- `split`.

# Methods

$METHODS_SUPERVISED_ARRAY
- [`convert2image`](@ref) converts features to `RGB` images.

# Examples

```julia-repl
julia> dataset = CIFAR100()
CIFAR100:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :train
  features    =>    32×32×3×50000 Array{Float32, 4}
  targets     =>    (coarse = "50000-element Vector{Int64}", fine = "50000-element Vector{Int64}")

julia> dataset[1:5].targets
(coarse = [11, 15, 4, 14, 1], fine = [19, 29, 0, 11, 1])

julia> X, y = dataset[];

julia> dataset.metadata
Dict{String, Any} with 3 entries:
  "n_observations"     => 50000
  "class_names_coarse" => ["aquatic_mammals", "fish", "flowers", "food_containers", "fruit_and_vegetables", "household_electrical_devices", "household_furniture", "insects", "large_carnivores", "large_man-made_…
  "class_names_fine"   => ["apple", "aquarium_fish", "baby", "bear", "beaver", "bed", "bee", "beetle", "bicycle", "bottle"  …  "train", "trout", "tulip", "turtle", "wardrobe", "whale", "willow_tree", "wolf", "w…
```
"""
struct CIFAR100 <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Array{<:Any, 4}
    targets::NamedTuple{(:coarse, :fine), Tuple{Vector{Int}, Vector{Int}}}
end

CIFAR100(; split=:train, Tx=Float32, dir=nothing) = CIFAR100(Tx, split; dir)

function CIFAR100(Tx::Type, split::Symbol=:train; dir=nothing)
    DEPNAME = "CIFAR100"
    TRAINSET_FILENAME = joinpath("cifar-100-binary", "train.bin")
    TESTSET_FILENAME  = joinpath("cifar-100-binary", "test.bin")
    COARSE_FILENAME = joinpath("cifar-100-binary", "coarse_label_names.txt")
    FINE_FILENAME = joinpath("cifar-100-binary", "fine_label_names.txt")    
    TRAINSET_SIZE = 50_000
    TESTSET_SIZE  = 10_000

    @assert split ∈ (:train, :test)

    if split == :train
        file_path = datafile(DEPNAME, TRAINSET_FILENAME, dir)
        images, labels_c, labels_f = CIFAR100Reader.readdata(file_path, TRAINSET_SIZE)
    else
        file_path = datafile(DEPNAME, TESTSET_FILENAME, dir)
        images, labels_c, labels_f = CIFAR100Reader.readdata(file_path, TESTSET_SIZE)
    end
    features = bytes_to_type(Tx, images)
    targets = (coarse = labels_c, fine = labels_f)

    metadata = Dict{String, Any}()
    metadata["class_names_coarse"] = readlines(datafile(DEPNAME, COARSE_FILENAME, dir))
    metadata["class_names_fine"] = readlines(datafile(DEPNAME, FINE_FILENAME, dir))
    metadata["n_observations"] = size(features)[end]
    
    return CIFAR100(metadata, split, features, targets)
end

convert2image(::Type{<:CIFAR100}, x) = convert2image(CIFAR10, x)

# DEPRECATED INTERFACE, REMOVE IN v0.7 (or 0.6.x)
function Base.getproperty(::Type{CIFAR100}, s::Symbol)
    if s == :traintensor
        @warn "CIFAR100.traintensor() is deprecated, use `CIFAR100(split=:train).features` instead." maxlog=2
        traintensor(T::Type=N0f8; kws...) = traintensor(T, :; kws...)
        traintensor(i; kws...) = traintensor(N0f8, i; kws...)
        function traintensor(T::Type, i; dir=nothing)
            CIFAR100(; split=:train, Tx=T, dir)[i][1]
        end
        return traintensor
    elseif s == :testtensor
        @warn "CIFAR100.testtensor() is deprecated, use `CIFAR100(split=:test).features` instead."  maxlog=2
        testtensor(T::Type=N0f8; kws...) = testtensor(T, :; kws...)
        testtensor(i; kws...) = testtensor(N0f8, i; kws...)
        function testtensor(T::Type, i; dir=nothing)
            CIFAR100(; split=:test, Tx=T, dir)[i][1]
        end
        return testtensor        
    elseif s == :trainlabels
        @warn "CIFAR100.trainlabels() is deprecated, use `CIFAR100(split=:train).targets` instead."  maxlog=2
        trainlabels(; kws...) = trainlabels(:; kws...)
        function trainlabels(i; dir=nothing)
            yc, yf = CIFAR100(; split=:train, dir)[i][2]
            yc, yf
        end
        return trainlabels
    elseif s == :testlabels
        @warn "CIFAR100.testlabels() is deprecated, use `CIFAR100(split=:test).targets` instead." maxlog=2
        testlabels(; kws...) = testlabels(:; kws...)
        function testlabels(i; dir=nothing)
            yc, yf = CIFAR100(; split=:test, dir)[i][2]
            yc, yf
        end
        return testlabels
    elseif s == :traindata
        @warn "CIFAR100.traindata() is deprecated, use `CIFAR100(split=:train)[]` instead." maxlog=2
        traindata(T::Type=N0f8; kws...) = traindata(T, :; kws...)
        traindata(i; kws...) = traindata(N0f8, i; kws...)
        function traindata(T::Type, i; dir=nothing)
            x, (yc, yf) = CIFAR100(; split=:train, Tx=T, dir)[i]
            x, yc, yf
        end
        return traindata
    elseif s == :testdata
        @warn "CIFAR100.testdata() is deprecated, use `CIFAR100(split=:test)[]` instead."  maxlog=2
        testdata(T::Type=N0f8; kws...) = testdata(T, :; kws...)
        testdata(i; kws...) = testdata(N0f8, i; kws...)
        function testdata(T::Type, i; dir=nothing)
            x, (yc, yf) = CIFAR100(; split=:test, Tx=T, dir)[i]
            x, yc, yf
        end
        return testdata
    elseif s == :convert2image
        @warn "CIFAR100.convert2image(x) is deprecated, use `convert2image(CIFAR100, x)` instead"
        return x -> convert2image(CIFAR100, x)
    elseif s == :classnames_fine
        @warn "CIFAR100.classnames_fine() is deprecated, use `CIFAR100().metadata[\"class_names_fine\"]` instead"
        return () -> CIFAR100().metadata["class_names_fine"]
    elseif s == :classnames_coarse
        @warn "CIFAR100.classnames_coarse() is deprecated, use `CIFAR100().metadata[\"class_names_coarse\"]` instead"
        return () -> CIFAR100().metadata["class_names_coarse"]
    else
        return getfield(CIFAR100, s)
    end
end
