# Image preprocessing defaults for ImageNet models.

function default_preprocess(im::AbstractMatrix{<:AbstractRGB}, outsize)
    im = channelview(center_crop(im, outsize))
    return PermutedDimsArray(im, (3, 2, 1)) # Convert from Image.jl's CHW to Flux's WHC
end

function default_inverse_preprocess(x::AbstractArray{T, N}) where {T, N}
    @assert N == 3 || N == 4
    x = PermutedDimsArray(x, (3, 2, 1, 4:N...)) # Convert from WHC[N] to CHW[N]
    return colorview(RGB, x)
end

# Take rectangle of pixels of shape `outsize` at the center of image `im`
function center_crop(im::AbstractMatrix, outsize)
    h2, w2 = div.(outsize, 2) # half height, half width of view
    h_adjust, w_adjust = _adjust.(outsize)
    return @view im[((div(end, 2) - h2):(div(end, 2) + h2 - h_adjust)) .+ 1,
                    ((div(end, 2) - w2):(div(end, 2) + w2 - w_adjust)) .+ 1]
end
_adjust(i::Integer) = ifelse(iszero(i % 2), 1, 0)
