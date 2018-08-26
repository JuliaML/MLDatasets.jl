"""
    convert2features(array)

Convert the given MNIST tensor to a feature matrix (or feature
vector in the case of a single image). The purpose of this
function is to drop the spatial dimensions such that traditional
ML algorithms can process the dataset.

```julia
julia> MNIST.convert2features(MNIST.traintensor()) # full training data
784×60000 Array{N0f8,2}:
[...]

julia> MNIST.convert2features(MNIST.traintensor(1)) # first observation
784-element Array{N0f8,1}:
[...]
```
"""
convert2features(array::AbstractMatrix{<:Number}) = vec(array)

function convert2features(array::AbstractArray{<:Number,3})
    nrows, ncols, nimages = size(array)
    reshape(array, (nrows * ncols, nimages))
end

"""
    convert2image(array) -> Array{Gray}

Convert the given MNIST horizontal-major tensor (or feature matrix)
to a vertical-major `Colorant` array. The values are also color
corrected according to the website's description, which means that
the digits are black on a white background.

```julia
julia> MNIST.convert2image(MNIST.traintensor()) # full training dataset
28×28×60000 Array{Gray{N0f8},3}:
[...]

julia> MNIST.convert2image(MNIST.traintensor(1)) # first training image
28×28 Array{Gray{N0f8},2}:
[...]
```
"""
function convert2image(array::AbstractVector{<:Number})
    @assert length(array) % 784 == 0
    if length(array) == 784
        convert2image(reshape(array, 28, 28))
    else
        n = Int(length(array) / 784)
        convert2image(reshape(array, 28, 28, n))
    end
end

function convert2image(array::AbstractMatrix{T}) where {T<:Number}
    if size(array) == (28, 28)
        # simple check to see if values are normalized to [0,1]
        if any(x->x > 50, array)
            _colorview(Gray, T(1) .- transpose(array) ./ T(255))
        else
            _colorview(Gray, T(1) .- transpose(array))
        end
    else # feature matrix
        @assert size(array, 1) == 784
        n = size(array, 2)
        convert2image(reshape(array, 28, 28, n))
    end
end

function convert2image(array::AbstractArray{T,3}) where {T<:Number}
    h, w, n = size(array)
    @assert h == 28 && w == 28
    # simple check to see if values are normalized to [0,1]
    if any(x->x > 50, array)
        _colorview(Gray, permutedims(T(1) .- array ./ T(255), [2,1,3]))
    else
        _colorview(Gray, permutedims(T(1) .- array, [2,1,3]))
    end
end
