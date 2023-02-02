const IMAGENET_WEBSITE = "https://image-net.org/"

function __init__imagenet()
    DEPNAME = "ImageNet"
    return register(
        ManualDataDep(
            DEPNAME,
            """The ImageNet 2012 Classification Dataset (ILSVRC 2012-2017) can be downloaded at
            $(IMAGENET_WEBSITE) after signing up and accepting the terms of access.
            It is therefore required that you download this dataset manually.

            Please follow the instructions at
            https://github.com/JuliaML/MLDatasets.jl/blob/master/docs/src/datasets/imagenet_installation.md.
            """,
        ),
    )
end

"""
    ImageNet(; Tx=Float32, split=:train, dir=nothing)
    ImageNet([Tx, split])

The ImageNet 2012 Classification Dataset (ILSVRC 2012-2017).
This is the most highly-used subset of ImageNet. It spans 1000 object classes and contains
1,281,167 training images, 50,000 validation images and 100,000 test images.
Each image is in 224x224x3 format using RGB color space.

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
julia> using MLDatasets: ImageNet

julia> dataset = ImageNet(:val);

julia> dataset[1:5].targets
5-element Vector{Int64}:
 1
 1
 1
 1
 1

julia> X, y = dataset[1:5];

julia> size(X)
(224, 224, 3, 5)

julia> X, y = dataset[2000];

julia> convert2image(dataset, X)

julia> dataset.metadata
Dict{String, Any} with 4 entries:
  "class_WNIDs"       => ["n01440764", "n01443537", "n01484850", "n01491361", "n01494475", …
  "class_description" => ["freshwater dace-like game fish of Europe and western Asia noted …
  "class_names"       => Vector{SubString{String}}[["tench", "Tinca tinca"], ["goldfish", "…
  "wnid_to_label"     => Dict("n07693725"=>932, "n03775546"=>660, "n01689811"=>45, "n021008…

julia> dataset.metadata["class_names"][y]
  3-element Vector{SubString{String}}:
   "common iguana"
   "iguana"
   "Iguana iguana"
```

# References

[1]: [Russakovsky et al., ImageNet Large Scale Visual Recognition Challenge](https://arxiv.org/abs/1409.0575)
"""
struct ImageNet <: SupervisedDataset
    metadata::Dict{String,Any}
    split::Symbol
    dataset::FileDataset
    targets::Vector{Int}
    inverse_preprocess::Function
end

ImageNet(; split=:train, Tx=Float32, kws...) = ImageNet(Tx, split; kws...)
ImageNet(split::Symbol; kws...) = ImageNet(; split, kws...)
ImageNet(Tx::Type; kws...) = ImageNet(; Tx, kws...)

function ImageNet(
    Tx::Type,
    split::Symbol;
    preprocess=ImageNetReader.default_preprocess,
    inverse_preprocess=ImageNetReader.default_inverse_preprocess,
    dir=nothing,
    train_dir="train",
    val_dir="val",
    test_dir="test",
    devkit_dir="devkit",
)
    @assert split ∈ (:train, :val, :test)

    DEPNAME = "ImageNet"
    METADATA_FILENAME = joinpath(devkit_dir, "data", "meta.mat")

    TRAINSET_SIZE = 1_281_167
    VALSET_SIZE = 50_000
    TESTSET_SIZE = 100_000

    # Load metadata
    file_path = datafile(DEPNAME, METADATA_FILENAME, dir)
    metadata = ImageNetReader.read_metadata(file_path)

    root_dir = @datadep_str DEPNAME
    if split == :train
        dataset = ImageNetReader.get_file_dataset(
            Tx, preprocess, joinpath(root_dir, train_dir)
        )
        @assert length(dataset) == TRAINSET_SIZE
    elseif split == :val
        dataset = ImageNetReader.get_file_dataset(
            Tx, preprocess, joinpath(root_dir, val_dir)
        )
        @assert length(dataset) == VALSET_SIZE
    else
        dataset = ImageNetReader.get_file_dataset(
            Tx, preprocess, joinpath(root_dir, test_dir)
        )
        @assert length(dataset) == TESTSET_SIZE
    end
    targets = [
        metadata["wnid_to_label"][wnid] for wnid in ImageNetReader.get_wnids(dataset)
    ]
    return ImageNet(metadata, split, dataset, targets, inverse_preprocess)
end

convert2image(d::ImageNet, x::AbstractArray) = d.inverse_preprocess(x)

Base.length(d::ImageNet) = length(d.dataset)

const IMAGENET_MEM_WARNING = """Loading the entire ImageNet dataset into memory might not be possible.
    If you are sure you want to load all of ImageNet, use `dataset[1:end]` instead of `dataset[:]`.
    """
Base.getindex(::ImageNet, ::Colon) = throw(ArgumentError(IMAGENET_MEM_WARNING))
Base.getindex(d::ImageNet, i::Integer) = (features=d.dataset[i], targets=d.targets[i])
function Base.getindex(d::ImageNet, is::AbstractVector)
    return (features=StackView(d.dataset[is]), targets=d.targets[is])
end
