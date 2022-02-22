"""
    make_cache(source, cacheidx)

Return a in-memory copy of `source` at observation indices `cacheidx`.
Defaults to `getobs(source, cacheidx)`.
"""
make_cache(source, cacheidx) = getobs(source, cacheidx)

"""
    CachedDataset(source, cachesize = numbobs(source))
    CachedDataset(source, cacheidx, cache)

Wrap a `source` data container and cache `cachesize` samples in memory.
This can be useful for improving read speeds when `source` is a lazy data container,
but your system memory is large enough to store a sizeable chunk of it.

By default the observation indices `1:cachesize` are cached.
You can manually pass in a `cache` and set of `cacheidx` as well.

See also [`make_cache`](@ref) for customizing the default cache creation for `source`.
"""
struct CachedDataset{T, S}
    source::T
    cacheidx::Vector{Int}
    cache::S
end

function CachedDataset(source, cachesize::Int = numobs(source))
    cacheidx = 1:cachesize

    CachedDataset(source, collect(cacheidx), make_cache(source, cacheidx))
end

function MLUtils.getobs(dataset::CachedDataset, i::Integer)
    _i = findfirst(==(i), dataset.cacheidx)

    return isnothing(_i) ? getobs(dataset.source, i) : getobs(dataset.cache, _i)
end
MLUtils.numobs(dataset::CachedDataset) = numobs(dataset.source)
