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
    features::Any
    split::Symbol
    targets::Vector{Tuple{Int, Int, Int}}
    size::Int
end

# Convenience constructors for StackedMNIST
StackedMNIST(; split = :train, Tx = Float32, dir = nothing) = StackedMNIST(Tx, split; dir)
StackedMNIST(split::Symbol; kws...) = StackedMNIST(; split, kws...)
StackedMNIST(Tx::Type; kws...) = StackedMNIST(; Tx, kws...)

function StackedMNIST(
        Tx::Type,
        split::Symbol = :train,
        ; size = 60000, dir = nothing)
    mnist = MNIST(Tx, split; dir = dir)
    split = mnist.split

    mnist_targets = vec(mnist.targets)
    targets = Vector{Tuple{Int, Int, Int}}(undef, size)
    features = Array{Tx, 4}(undef, 28, 28, 3, size)
    # Randomly select 3 numbers from the list 60,000 times and store them as tuples

    function random_three_unique(vec)
        indices = randperm(length(vec))[1:3]
        return (vec[indices[1]], vec[indices[2]], vec[indices[3]])
    end

    for i in 1:size
        label1, label2, label3 = random_three_unique(mnist_targets)
        index1 = findall(x -> x == label1, mnist_targets)
        random_index1 = rand(index1)
        red_channel = mnist.features[:, :, random_index1]

        index2 = findall(x -> x == label2, mnist_targets)
        random_index2 = rand(index2)
        green_channel = mnist.features[:, :, random_index2]

        index3 = findall(x -> x == label3, mnist_targets)
        random_index3 = rand(index3)
        blue_channel = mnist.features[:, :, random_index3]

        targets[i] = label1, label2, label3
        # Combine the channels into an RGB image and store in the features array
        features[:, :, 1, i] = red_channel
        features[:, :, 2, i] = green_channel
        features[:, :, 3, i] = blue_channel
    end

    StackedMNIST(features, split, targets, size)
end

# Define the length function
Base.length(sm::StackedMNIST) = sm.size

# Define the getindex function
function Base.getindex(sm::StackedMNIST, idx::Int)
    return sm.features[idx], d.targets[idx]
end

# Function to extract and show an RGB image
function show_rgb_image(features, index)
    red_channel = features[:, :, 1, index]  # Extract and convert red channel
    green_channel = features[:, :, 2, index]  # Extract and convert green channel
    blue_channel = features[:, :, 3, index]  # Extract and convert blue channel

    img_rgb = Colors.RGB.(red_channel, green_channel, blue_channel)  # Combine into RGB image
    return img_rgb # Plot as an RGB image
end
