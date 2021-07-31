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
function convert2image(array::AbstractArray{T}) where {T<:Number}
    nlast = size(array)[end] 
    array = reshape(array, 28, 28, :)
    array = permutedims(array, (2, 1, 3))
    if size(array)[end] == 1 && nlast != 1
        array = dropdims(array, dims=3)
    end    
    if any(x -> x > 1, array) # simple check if x in [0,1]
        img = _colorview(Gray, array ./ T(255))
    else
        img = _colorview(Gray, array)
    end
    img
end
