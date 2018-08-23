"""
    convert2features(array)

Convert the given CIFAR-10 tensor to a feature matrix (or feature
vector in the case of a single image). The purpose of this
function is to drop the spatial dimensions such that traditional
ML algorithms can process the dataset.

```julia
julia> CIFAR10.convert2features(CIFAR10.traintensor(Float32)) # full training data
3072×50000 Array{Float32,2}:
[...]

julia> CIFAR10.convert2features(CIFAR10.traintensor(Float32,1)) # first observation
3072-element Array{Float32,1}:
[...]
```
"""
function convert2features(array::AbstractArray{<:Number,3})
    nrows, ncols, nchan = size(array)
    @assert nchan == 3 "the given array should have the RGB channel in the third dimension"
    vec(array)
end

function convert2features(array::AbstractArray{<:Number,4})
    nrows, ncols, nchan, nimages = size(array)
    @assert nchan == 3 "the given array should have the RGB channel in the third dimension"
    reshape(array, (nrows * ncols * nchan, nimages))
end

convert2features(array::AbstractArray{<:RGB,2}) =
    convert2features(permutedims(_channelview(array), (3,2,1)))

convert2features(array::AbstractArray{<:RGB,3}) =
    convert2features(permutedims(_channelview(array), (3,2,1,4)))

"""
    convert2image(array) -> Array{RGB}

Convert the given CIFAR-10 horizontal-major tensor (or feature
vector/matrix) to a vertical-major `RGB` array.

```julia
julia> CIFAR10.convert2image(CIFAR10.traintensor()) # full training dataset
32×32×50000 Array{RGB{N0f8},3}:
[...]

julia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # first training image
32×32 Array{RGB{N0f8},2}:
[...]
```
"""
function convert2image(array::AbstractVector{<:Number})
    @assert length(array) % 3072 == 0
    if length(array) == 3072
        convert2image(reshape(array, 32, 32, 3))
    else
        n = Int(length(array) / 3072)
        convert2image(reshape(array, 32, 32, 3, n))
    end
end

function convert2image(array::AbstractMatrix{<:Number})
    @assert size(array, 1) == 3072
    convert2image(reshape(array, 32, 32, 3, size(array, 2)))
end

function convert2image(array::AbstractArray{<:Number,3})
    nrows, ncols, nchan = size(array)
    @assert nchan == 3 "the given array should have the RGB channel in the third dimension"
    _colorview(RGB, permutedims(_norm_array(array), (3,2,1)))
end

function convert2image(array::AbstractArray{<:Number,4})
    nrows, ncols, nchan, nimages = size(array)
    @assert nchan == 3 "the given array should have the RGB channel in the third dimension"
    _colorview(RGB, permutedims(_norm_array(array), (3,2,1,4)))
end

_norm_array(array::AbstractArray) = array
_norm_array(array::AbstractArray{<:Integer}) = reinterpret(N0f8, convert(Array{UInt8}, array))
