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
    ImageNet(; Tx=Float32, split=:train, dir=nothing, kwargs...)
    ImageNet([Tx, split])

The ImageNet 2012 Classification Dataset (ILSVRC 2012-2017).
This is the most highly-used subset of ImageNet. It spans 1000 object classes and contains
1,281,167 training images, 50,000 validation images and 100,000 test images.
Each image is in 224x224x3 format using RGB color space.

# Arguments

$ARGUMENTS_SUPERVISED_ARRAY
- `train_dir`, `val_dir`, `test_dir`, `devkit_dir`: optional subdirectory names of `dir`.
    Default to `"train"`, `"val"`, `"test"` and `"devkit"`.
- `split`: selects the data partition. Can take the values `:train:`, `:val` and `:test`.
    Defaults to `:train`.
- `Tx`: datatype used to load data. Defaults to `Float32`.
- `preprocess`: preprocessing steps applied to an image to convert it to an array.
    Assumes an RGB image in CHW format as input and an array in WHC format as output.
    Defaults to `ImageNetReader.default_preprocess`, which applies a center-crop
    and normalization using coefficients from PyTorch's vision models.
- `inverse_preprocess`: inverse function of `preprocess` used in `convert2image`.
    Defaults to `ImageNetReader.default_inverse_preprocess`.

**Note:** When providing custom preprocessing functions, make sure both match.

# Fields

- `metadata`: A dictionary containing additional information on the dataset.
- `split`: Symbol indicating the selected data partition
- `dataset`: A `FileDataset` containing paths to ImageNet images as well as a `loadfn`
    used to load images, which applies `preprocess`.
- `targets`: An array storing the targets for supervised learning.
- `inverse_preprocess`: inverse function of `preprocess` used in `convert2image`.

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
(5,)

julia> size(X[1])
(224, 224, 3)

julia> X, y = dataset[2000];

julia> convert2image(dataset, X)

julia> dataset.metadata
Dict{String, Any} with 8 entries:
  "features_dir"      => "/Users/funks/.julia/datadeps/ImageNet/val"
  "class_WNIDs"       => ["n01440764", "n01443537", "n01484850", "n01491361", "n01494475", "
  "class_description" => ["freshwater dace-like game fish of Europe and western Asia noted f
  "n_observations"    => 50000
  "class_names"       => Vector{SubString{String}}[["tench", "Tinca tinca"], ["goldfish", "C
  "metadata_path"     => "/Users/funks/.julia/datadeps/ImageNet/devkit/data/meta.mat"
  "n_classes"         => 1000
  "img_size"          => (224, 224)
  "wnid_to_label"     => Dict("n07693725"=>932, "n03775546"=>660, "n01689811"=>45, "n0210087

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
    img_size::Tuple{Int,Int}=(224, 224),
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

    root_dir = @datadep_str DEPNAME
    if split == :train
        split_dir = train_dir
        n_observations = TRAINSET_SIZE
    elseif split == :val
        split_dir = val_dir
        n_observations = VALSET_SIZE
    else # :test
        split_dir == test_dir
        n_observations = TESTSET_SIZE
    end
    features_dir = joinpath(root_dir, split_dir)

    # Load metadata
    metadata_path = datafile(DEPNAME, METADATA_FILENAME, dir)
    metadata = ImageNetReader.read_wordnet_metadata(metadata_path)
    metadata["metadata_path"] = metadata_path
    metadata["features_dir"] = features_dir
    metadata["n_observations"] = n_observations
    metadata["n_classes"] = ImageNetReader.NCLASSES
    metadata["img_size"] = img_size

    # Create FileDataset
    dataset = ImageNetReader.get_file_dataset(Tx, img_size, preprocess, features_dir)
    @assert length(dataset) == n_observations

    targets = [
        metadata["wnid_to_label"][wnid] for wnid in ImageNetReader.get_wnids(dataset)
    ]
    @assert length(targets) == n_observations
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
    return (features=d.dataset[is], targets=d.targets[is])
end
