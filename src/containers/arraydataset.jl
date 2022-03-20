"""
    ArrayDataset(x::AbstractArray)
    
Wrap an array as a dataset container.

# Examples

```julia-repl
julia> x = [1 2 3
            4 5 6];

julia> dataset = ArrayDataset(x)
ArrayDataset{Matrix{Int64}}([1 2 3; 4 5 6])

julia> dataset[1]
2-element Vector{Int64}:
 1
 4

julia> dataset[2:3]
2×2 Matrix{Int64}:
 2  3
 5  6

julia> MLDatasets.unwrap(dataset)  # return original array
2×3 Matrix{Int64}:
 1  2  3
 4  5  6
```
"""
struct ArrayDataset{T<:AbstractArray} <: AbstractDataContainer
    x::T
end

Base.length(dataset::ArrayDataset) = numobs(dataset.x)
Base.getindex(dataset::ArrayDataset, i) = getobs(dataset.x, i)

"""
    unwrap(dataset::ArrayDataset)

Return the array contained in `dataset` 
"""
unwrap(dataset::ArrayDataset) = dataset.x
