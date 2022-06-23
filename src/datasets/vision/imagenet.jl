const IMAGENET_WEBSITE = "https://image-net.org/"

function __init__imagenet()
    DEPNAME = "ImageNet"
    return register(
        ManualDataDep(
            DEPNAME,
            # TODO: currently markdown formatting is not applied
            """
            The ImageNet 2012 Classification Dataset (ILSVRC 2012-2017) can be downloaded at
            $IMAGENET_WEBSITE after signing up and accepting the terms of access.
            It is therefore required that you download this dataset manually.

            ## Existing installation
            The dataset structure is assumed to look as follows:
            ```
            ImageNet
            ├── train
            ├── val
            │   ├── n01440764
            │   │   ├── ILSVRC2012_val_00000293.JPEG
            │   │   ├── ILSVRC2012_val_00002138.JPEG
            │   │   └── ...
            │   ├── n01443537
            │   └── ...
            ├── test
            └── devkit
                ├── data
                │   ├── meta.mat
                │   └── ...
                └── ...
            ```
            If your existing copy of the ImageNet dataset uses another file structure,
            we recommend to create symbolic links, e.g. using `ln` on Unix-like operating
            systems:
            ```bash
            cd ~/.julia/datadeps
            mkdir -p ImageNet/val
            ln -s my/path/to/imagenet/val ImageNet/val
            mkdir -p ImageNet/devkit/data
            ln -s my/path/to/imagenet/devkit/data ImageNet/devkit/data
            ```

            ## New installation
            Download the following files from the ImageNet website ($IMAGENET_WEBSITE):
            * `ILSVRC2012_devkit_t12`
            * `ILSVRC2012_img_train.tar`, only required for `:train` split
            * `ILSVRC2012_img_val.tar`, only required for `:val` split

            After downloading the data, move and extract the training and validation images to
            labeled subfolders running the following shell script:
            ```bash
            # Extract the training data:
            mkdir -p ImageNet/train && tar -xvf ILSVRC2012_img_train.tar -C ImageNet/train
            # Unpack all 1000 compressed tar-files, one for each category:
            cd ImageNet/train
            find . -name "*.tar" | while read NAME ; do mkdir -p "\${NAME%.tar}"; tar -xvf "\${NAME}" -C "\${NAME%.tar}"; rm -f "\${NAME}"; done

            # Extract the validation data:
            cd ../..
            mkdir -p ImageNet/val && tar -xvf ILSVRC2012_img_val.tar -C ImageNet/val

            # Run script from soumith to create all class directories and moves images into corresponding directories:
            cd ImageNet/val
            wget -qO- https://raw.githubusercontent.com/soumith/imagenetloader.torch/master/valprep.sh | bash

            # Extract metadata from the devkit:
            cd ../..
            mkdir -p ImageNet/devkit && tar -xvf ILSVRC2012_img_val.tar -C ImageNet/devkit
            ```
            """,
            # shell script based on PyTorch example "ImageNet training in PyTorch":
            # https://github.com/pytorch/examples/blob/d5478765d38210addf474dd73faf0d103052027a/imagenet/extract_ILSVRC.sh
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

- Authors: Olga Russakovsky, Jia Deng, Hao Su, Jonathan Krause, Sanjeev Satheesh,
    Sean Ma, Zhiheng Huang, Andrej Karpathy, Aditya Khosla, Michael Bernstein,
    Alexander C. Berg, Li Fei-Fei
- Website: $IMAGENET_WEBSITE
- Reference: Russakovsky et al., ImageNet Large Scale Visual Recognition Challenge
    (https://arxiv.org/abs/1409.0575)

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

julia> dataset = ImageNet(:val)
dataset ImageNet:
  metadata    =>    Dict{String, Any} with 4 entries
  split       =>    :val
  files       =>    50000-element Vector{String}
  targets     =>    50000-element Vector{Int64}
  Tx          =>    Float32

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

julia> dataset.metadata
Dict{String, Any} with 4 entries:
  "class_WNIDs"       => ["n02119789", "n02100735", "n02110185", "n02096294", "n02102040", "n02066245", "n02509815", "n02124075", "n02417914", "n02123394"  …  "n02815834", "n09229709", "n07697313", "n03888605", "n03355925", "n03…
  "class_description" => ["small grey fox of southwestern United States; may be a subspecies of Vulpes velox", "an English breed having a plumed tail and a soft silky coat that is chiefly white", "breed of sled dog developed in …
  "class_names"       => Vector{SubString{String}}[["kit fox", "Vulpes macrotis"], ["English setter"], ["Siberian husky"], ["Australian terrier"], ["English springer", "English springer spaniel"], ["grey whale", "gray whale", "d…
  "wnid_to_label"     => Dict("n07693725"=>768, "n03775546"=>829, "n01689811"=>469, "n02100877"=>192, "n02441942"=>48, "n04371774"=>569, "n07717410"=>741, "n03347037"=>919, "n04355338"=>526, "n02097474"=>158…)
```
"""
struct ImageNet <: SupervisedDataset
    metadata::Dict{String,Any}
    split::Symbol
    files::Vector{String}
    targets::Vector{Int}
    Tx::Type
end

ImageNet(; split=:train, Tx=Float32, dir=nothing) = ImageNet(Tx, split; dir)
ImageNet(split::Symbol; kws...) = ImageNet(; split, kws...)
ImageNet(Tx::Type; kws...) = ImageNet(; Tx, kws...)

function ImageNet(
    Tx::Type,
    split::Symbol;
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
        files = ImageNetReader.readdata(joinpath(root_dir, train_dir))
        @assert length(files) == TRAINSET_SIZE
    elseif split == :val
        files = ImageNetReader.readdata(joinpath(root_dir, val_dir))
        @assert length(files) == VALSET_SIZE
    else
        files = ImageNetReader.readdata(joinpath(root_dir, test_dir))
        @assert length(files) == TESTSET_SIZE
    end
    targets = [metadata["wnid_to_label"][wnid] for wnid in ImageNetReader.load_wnids(files)]
    return ImageNet(metadata, split, files, targets, Tx)
end

function convert2image(::Type{<:ImageNet}, x::AbstractArray{<:Integer})
    return convert2image(ImageNet, reinterpret(N0f8, convert(Array{UInt8}, x)))
end
convert2image(::Type{<:ImageNet}, x) = ImageNetReader.inverse_preprocess(x)

Base.length(d::ImageNet) = length(d.image_files)
function Base.getindex(d::ImageNet, ::Colon)
    # Throw warning here that ImageNet probably will not fit in memory?
    return (features=ImageNetReader.readimage(d.Tx, d.files), targets=d.targets)
end
function Base.getindex(d::ImageNet, i)
    return (features=ImageNetReader.readimage(d.Tx, d.files[i]), targets=d.targets[i])
end
