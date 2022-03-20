"""
    make_cache(source, cacheidx)

Return a in-memory copy of `source` at observation indices `cacheidx`.
Defaults to `getobs(source, cacheidx)`.
"""
make_cache(source, cacheidx) = getobs(source, cacheidx)

"""
    CachedDataset(source, cachesize = numbobs(source))
    CachedDataset(source, cacheidx = 1:numbobs(source))
    CachedDataset(source, cacheidx, cache)

Wrap a `source` data container and cache `cachesize` samples in memory.
This can be useful for improving read speeds when `source` is a lazy data container,
but your system memory is large enough to store a sizeable chunk of it.

By default the observation indices `1:cachesize` are cached.
You can manually pass in a set of `cacheidx` as well.

See also [`make_cache`](@ref) for customizing the default cache creation for `source`.
"""
struct CachedDataset{T, S} <: AbstractDataContainer
    source::T
    cacheidx::Vector{Int}
    cache::S
end

CachedDataset(source, cachesize::Int) = CachedDataset(source, 1:cachesize)

CachedDataset(source, cacheidx::AbstractVector{<:Integer} = 1:numobs(source)) =
    CachedDataset(source, collect(cacheidx), make_cache(source, cacheidx))

function Base.getindex(dataset::CachedDataset, i::Integer)
    _i = findfirst(==(i), dataset.cacheidx)

    return isnothing(_i) ? getobs(dataset.source, i) : getobs(dataset.cache, _i)
end
Base.length(dataset::CachedDataset) = numobs(dataset.source)
