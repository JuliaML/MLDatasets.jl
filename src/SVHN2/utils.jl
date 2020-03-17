"""
    convert2image(array) -> Array{RGB}

Convert the given SVHN tensor (or feature vector/matrix) to a
`RGB` array.

```julia
julia> SVHN2.convert2image(SVHN2.traindata()[1]) # full training dataset
32×32×50000 Array{RGB{N0f8},3}:
[...]

julia> SVHN2.convert2image(SVHN2.traindata(1)[1]) # first training image
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
    _colorview(RGB, permutedims(_norm_array(array), (3,1,2)))
end

function convert2image(array::AbstractArray{<:Number,4})
    nrows, ncols, nchan, nimages = size(array)
    @assert nchan == 3 "the given array should have the RGB channel in the third dimension"
    _colorview(RGB, permutedims(_norm_array(array), (3,1,2,4)))
end

_norm_array(array::AbstractArray) = array
_norm_array(array::AbstractArray{<:Integer}) = reinterpret(N0f8, convert(Array{UInt8}, array))
