# Image preprocessing for ImageNet models.
# Code adapted from Metalhead 0.5.3's utils.jl

# Resize an image such that its smallest dimension is the given length
function resize_smallest_dimension(im, len)
    old_size = size(im)[1:2]
    reduction_factor = len / minimum(old_size)
    new_size = (
        round(Int, old_size[1] * reduction_factor),
        round(Int, old_size[2] * reduction_factor),
    )
    return Images.imresize(im, new_size)
end

# Take the len-by-len square of pixels at the center of image `im`
function center_crop(im, len)
    l2 = div(len, 2)
    adjust = ifelse(len % 2 == 0, 1, 0)
    return @view im[
        (div(end, 2) - l2):(div(end, 2) + l2 - adjust),
        (div(end, 2) - l2):(div(end, 2) + l2 - adjust),
    ]
end

# Coefficients taken from PyTorch's ImageNet normalization code
const PYTORCH_MEAN = [0.485f0, 0.456f0, 0.406f0]
const PYTORCH_STD = [0.229f0, 0.224f0, 0.225f0]

function preprocess(Tx::Type, im::AbstractMatrix{<:Images.AbstractRGB})
    # @assert im isa AbstractMatrix{<:Images.AbstractRGB}
    im = resize_smallest_dimension(im, 256)
    im = center_crop(im, 224)
    im = (Images.channelview(im) .- PYTORCH_MEAN) ./ PYTORCH_STD
    # Convert from CHW (Image.jl's channel ordering) to WHC:
    return Tx.(PermutedDimsArray(im, (3, 2, 1)))
end

function inverse_preprocess(x::AbstractArray{T,N}) where {T,N}
    @assert N == 3 || N == 4
    return Images.colorview(
        Images.RGB, PermutedDimsArray(x, (3, 2, 1, 4:N...)) .* PYTORCH_STD .+ PYTORCH_MEAN
    )
end
