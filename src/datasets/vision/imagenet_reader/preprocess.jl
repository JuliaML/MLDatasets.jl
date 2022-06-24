# Image preprocessing for ImageNet models.
# Code adapted from Metalhead 0.5.3's utils.jl

# Take rectangle of pixels of shape `outsize` at the center of image `im`
adjust(i::Integer) = ifelse(iszero(i % 2), 1, 0)
function center_crop_view(im::AbstractMatrix, outsize=IMGSIZE)
    h2, w2 = div.(outsize, 2) # half height, half width of view
    h_adjust, w_adjust = adjust.(outsize)
    return @view im[
        (div(end, 2) - h2):(div(end, 2) + h2 - h_adjust),
        (div(end, 2) - w2):(div(end, 2) + w2 - w_adjust),
    ]
end

# Coefficients taken from PyTorch's ImageNet normalization code
const PYTORCH_MEAN = [0.485f0, 0.456f0, 0.406f0]
const PYTORCH_STD = [0.229f0, 0.224f0, 0.225f0]

function preprocess(Tx::Type, im::AbstractMatrix{<:AbstractRGB})
    im = center_crop_view(im)
    im = (channelview(im) .- PYTORCH_MEAN) ./ PYTORCH_STD
    # Convert from CHW (Image.jl's channel ordering) to WHC:
    return Tx.(PermutedDimsArray(im, (3, 2, 1)))
end

function inverse_preprocess(x::AbstractArray{T,N}) where {T,N}
    @assert N == 3 || N == 4
    return colorview(
        RGB, PermutedDimsArray(x, (3, 2, 1, 4:N...)) .* PYTORCH_STD .+ PYTORCH_MEAN
    )
end
