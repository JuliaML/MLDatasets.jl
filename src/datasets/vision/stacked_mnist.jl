function __init__stackedmist()
    DEPNAME = "StackedMNIST"
    TRAINIMAGES = "train-images-idx3-ubyte.gz"
    TRAINLABELS = "train-labels-idx1-ubyte.gz"
    TESTIMAGES = "t10k-images-idx3-ubyte.gz"
    TESTLABELS = "t10k-labels-idx1-ubyte.gz"
    register(DataDep(DEPNAME,
        """Dataset: The Stacked MNIST dataset is derived from the standard MNIST dataset with an increased number of discrete modes. 240,000 RGB images in the size of 28×28 are synthesized by stacking three random digit images from MNIST along the color channel, resulting in 1,000 explicit modes in a uniform distribution corresponding to the number of possible triples of digits.
         Authors: Metz et al.
         Website: https://paperswithcode.com/dataset/stacked-mnist

         [Metz L et al., 2016]
             Metz L, Poole B, Pfau D, Sohl-Dickstein J. Unrolled generative adversarial networks. arXiv preprint arXiv:1611.02163. 2016 Nov 7.
        """,
        "",
        [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS]
    ))
end

"""
    StackedMNIST(; Tx=Float32, split=:train, dir=nothing)
    StackedMNIST([Tx, split])

The StackedMNIST dataset is a variant of the classic MNIST dataset where each observation is a combination of three randomly shuffled MNIST digits, stacked as RGB channels.

# Arguments

- `Tx`: The data type for the features. Defaults to `Float32`. If `Tx <: Integer`, the features will range between 0 and 255; otherwise, they will be scaled between 0 and 1.
- `split`: The data partition to load, either `:train` or `:test`. Defaults to `:train`.
- `dir`: The directory where the dataset is stored. If `nothing`, the default location is used.

# Fields

- `features`: A 3D array of MNIST images with dimensions `(28, 28, num_images)`, where `num_images` is twice the number of images in the selected split due to the shuffling and stacking process.
- `targets`: A vector of integers, where each integer represents the combined label for the stacked RGB image.
- `index`: A vector of tuples, each containing three integers. These tuples indicate which original MNIST images were combined to create each RGB image.

# Methods

- [`convert2image`](@ref) converts features to RGB images.
- `Base.length(sm::StackedMNIST)`: Returns the number of images in the dataset.
- `Base.getindex(sm::StackedMNIST, idx::Int)`: Returns the RGB image and its corresponding target label at the specified index.

# Examples

The images in the StackedMNIST dataset are loaded as a multi-dimensional array of type `Tx`. The dataset's `features` field is a 3D array in WHN format (width, height, num_images). Labels are stored as a vector of integers in `StackedMNIST().targets`. The images are constructed by stacking three randomly chosen MNIST digits as RGB channels. Resulting in 1,000 explicit modes in a uniform distribution corresponding to the number of possible triples of digits.

```julia-repl
julia> using MLDatasets: StackedMNIST

julia> dataset = StackedMNIST(:train)
StackedMNIST:
features    =>    28×28×60000 Array{Float32, 3}
targets     =>    60000-element Vector{Int64}
index       =>    60000-element Vector{Tuple{Int, Int, Int}}

julia> dataset[1:5].targets
5-element Vector{Int64}:
721
238
153
409
745

julia> img, label = dataset[1]
RGB Image with dimensions 28×28, label: 721

julia> dataset = StackedMNIST(UInt8, :test)
StackedMNIST:
    features    =>    28×28×10000 Array{UInt8, 3}
    split       =>    :test
    targets     =>    10000-element Vector{Int64}
    index       =>    10000-element Vector{Tuple{Int, Int, Int}}
```
"""
struct StackedMNIST <: SupervisedDataset
    features::Array{<:Any, 3}
    split::Symbol
    index::Vector{Tuple{Int, Int, Int}}
end

# Convenience constructors for StackedMNIST
StackedMNIST(; split = :train, Tx = Float32, dir = nothing) = StackedMNIST(Tx, split; dir)
StackedMNIST(split::Symbol; kws...) = StackedMNIST(; split, kws...)
StackedMNIST(Tx::Type; kws...) = StackedMNIST(; Tx, kws...)

function StackedMNIST(
        Tx::Type,
        split::Symbol = :train,
        ; dir = nothing)
    mnist = MNIST(Tx, split; dir = dir)
    features = mnist.features
    split = mnist.split
    #targets = vec(mnist.targets)

    num_images = 2 * size(features, 3)
    index1 = vcat(1:size(features, 3), 1:size(features, 3))
    index2 = vcat(1:size(features, 3), 1:size(features, 3))
    index3 = vcat(1:size(features, 3), 1:size(features, 3))

    shuffle!(index1)
    shuffle!(index2)
    shuffle!(index3)

    index = [(index1[i], index2[i], index3[i]) for i in 1:num_images]

    StackedMNIST(features, split, index)
end

# Define the length function
Base.length(sm::StackedMNIST) = sm.num_images

# Define the getindex function
function Base.getindex(sm::StackedMNIST, idx::Int)
    img = zeros(N0f8, 28, 28, 3)
    target = 0

    for i in 1:3
        img_ = sm.features[:, :, sm.index[idx][i]]
        #target_ = sm.targets[sm.index[idx][i]]
        img[:, :, i] .= N0f8.(img_)
        #target += target_ * 10^(2 - (i - 1))
    end

    # Manually construct the RGB image
    red_channel = img[:, :, 1]
    green_channel = img[:, :, 2]
    blue_channel = img[:, :, 3]
    rgb_img = Colors.RGB.(red_channel, green_channel, blue_channel)

    return rgb_img, target
end
