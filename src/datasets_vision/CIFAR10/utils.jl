"""
    convert2image(array) -> Array{RGB}

Convert the given CIFAR-10 horizontal-major tensor WHCN (or feature
vector/matrix) to a vertical-major HWN `RGB` array.

```julia
julia> CIFAR10.convert2image(CIFAR10.traintensor()) # full training dataset
32×32×50000 Array{RGB{N0f8},3}:
[...]

julia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # first training image
32×32 Array{RGB{N0f8},2}:
[...]
```
"""
function convert2image(array::AbstractArray{T}) where {T<:Number}
    nlast = size(array)[end] 
    array = reshape(array, 32, 32, 3, :)
    array = permutedims(array, (3, 2, 1, 4))
    if size(array)[end] == 1 && nlast != 1
        array = dropdims(array, dims=4)
    end
    img = _colorview(RGB, _norm_array(array))
 
    img
end

_norm_array(array::AbstractArray) = array
_norm_array(array::AbstractArray{<:Integer}) = reinterpret(N0f8, convert(Array{UInt8}, array))
