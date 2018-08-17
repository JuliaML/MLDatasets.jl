# Reads labels at src_indices positions from io
# and puts them to dst_indices positions in the resulting vector.
# src_indices should be sorted in ascending order,
# otherwise io would fail to go to the already read position.
function _readlabels(io::IO,
                     src_indices::AbstractVector{<:Integer},
                     dst_indices::AbstractVector{<:Integer})
    @assert length(src_indices) == length(dst_indices)
    labels = Vector{UInt8}(undef, length(src_indices))
    pos = LABELOFFSET
    last_src_ix = 0
    last_label = UInt8(0)
    for (dst_ix, src_ix) in zip(dst_indices, src_indices)
        if src_ix != last_src_ix
            nextpos = LABELOFFSET + (src_ix - 1)
            skip(io, nextpos - pos)
            last_label = read(io, UInt8)
            pos = nextpos + 1
            last_src_ix = src_ix
        end
        labels[dst_ix] = last_label
    end
    return labels
end

"""
    readlabels(file::AbstractString, [indices])
    readlabels(io::IO, [indices])

Reads the label denoted by `indices` from `file` or `io`. The given file
is assumed to be in the MNIST label-file format, as it is described
on the official homepage at http://yann.lecun.com/exdb/mnist/

If specified, `indices` could be either a single 1-based image index or a vector of indices.
If `indices` is not specified, all images are read.

Returns a `Vector{UInt8}` with image labels in the same order as `indices`.
"""
function readlabels(io::IO, indices::Union{AbstractVector{<:Integer}, Nothing})
    _, nlabels = readlabelheader(io)
    _indices = indices !== nothing ? indices : (1:nlabels)
    @assert isa(_indices, AbstractVector)
    all(i -> 1 <= i <= nlabels, _indices) ||
        throw(ArgumentError("not all elements in parameter \"indices\" are in 1:$nlabels"))

    issorted(_indices) && return _readlabels(io, _indices, 1:length(_indices))
    # sort indices, because IO might not support seek()
    perm = sortperm(_indices)
    return _readlabels(io, _indices[perm], (1:length(_indices))[perm])
end

readlabels(io::IO, index::Integer) = readlabels(io, [index])[1]::UInt8

function readlabels(file::AbstractString, indices = nothing)
    open(GzipDecompressorStream, file) do io
        return readlabels(io, indices)
    end
end
