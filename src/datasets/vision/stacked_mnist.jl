using Images
using DataDeps
using Flux
using Random

# Define the StackedMNIST type
struct StackedMNIST
    features::Array{<:Any, 3}
    targets::Vector{Int}
    index::Vector{Tuple{Int, Int, Int}}
end

function StackedMNIST(
        Tx::Type,
        split::Symbol = :train; dir = nothing)
    mnist = MNIST(Tx, split; dir = dir)
    features = mnist.features
    targets = vec(mnist.targets)

    num_images = 2 * size(features, 3)
    index1 = vcat(1:size(features, 3), 1:size(features, 3))
    index2 = vcat(1:size(features, 3), 1:size(features, 3))
    index3 = vcat(1:size(features, 3), 1:size(features, 3))

    Random.shuffle!(index1)
    Random.shuffle!(index2)
    Random.shuffle!(index3)

    index = [(index1[i], index2[i], index3[i]) for i in 1:num_images]

    StackedMNIST(features, targets, index)
end

# Define the length function
Base.length(sm::StackedMNIST) = sm.num_images

# Define the getindex function
function Base.getindex(sm::StackedMNIST, idx::Int)
    img = zeros(N0f8, 28, 28, 3)
    target = 0

    for i in 1:3
        img_ = sm.features[:, :, sm.index[idx][i]]
        target_ = sm.targets[sm.index[idx][i]]
        img[:, :, i] .= N0f8.(img_)
        target += target_ * 10^(2 - (i - 1))
    end

    # Manually construct the RGB image
    red_channel = img[:, :, 1]
    green_channel = img[:, :, 2]
    blue_channel = img[:, :, 3]
    rgb_img = RGB.(red_channel, green_channel, blue_channel)

    return rgb_img, target
end
