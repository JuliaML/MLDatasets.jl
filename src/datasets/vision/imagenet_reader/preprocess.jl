# Image preprocessing for ImageNet models.
# Code adapted from Metalhead 0.5.3's utils.jl

# Coefficients taken from PyTorch's ImageNet normalization code
const PYTORCH_MEAN = [0.485f0, 0.456f0, 0.406f0]
const PYTORCH_STD = [0.229f0, 0.224f0, 0.225f0]

normalize_pytorch(x) = (x .- PYTORCH_MEAN) ./ PYTORCH_STD
inv_normalize_pytorch(x) = x .* PYTORCH_STD .+ PYTORCH_MEAN

function default_preprocess(im::AbstractMatrix{<:AbstractRGB})
    # Similar to the validation dataset loader in PyTorch's ImageNet example
    # https://github.com/pytorch/examples/blob/91ccd7a21be6fa687000beef82fc1e5d7d64e4bd/imagenet/main.py#L223-L230
    im = center_crop(im)
    im = normalize_pytorch(channelview(im))
    return PermutedDimsArray(im, (3, 2, 1)) # Convert from Image.jl's CHW to Flux's WHC
end

function default_inverse_preprocess(x::AbstractArray{T,N}) where {T,N}
    @assert N == 3 || N == 4
    x = PermutedDimsArray(x, (3, 2, 1, 4:N...)) # Convert from WHC[N] to CHW[N]
    return colorview(RGB, inv_normalize_pytorch(x))
end

# Take rectangle of pixels of shape `outsize` at the center of image `im`
function center_crop(im::AbstractMatrix, outsize=IMGSIZE)
    h2, w2 = div.(outsize, 2) # half height, half width of view
    h_adjust, w_adjust = _adjust.(outsize)
    return @view im[
        ((div(end, 2) - h2):(div(end, 2) + h2 - h_adjust)) .+ 1,
        ((div(end, 2) - w2):(div(end, 2) + w2 - w_adjust)) .+ 1,
    ]
end
_adjust(i::Integer) = ifelse(iszero(i % 2), 1, 0)
