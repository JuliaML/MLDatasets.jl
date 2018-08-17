# Reads nrows×ncols images at src_indices positions from io
# and puts them to dst_indices positions into the resulting 3D-array
# with (x, y, #image) dimensions.
# src_indices should be sorted in ascending order,
# otherwise io would fail to go to the already read position.
function _readimages(io::IO, nrows::Integer, ncols::Integer,
                     src_indices::AbstractVector{<:Integer},
                     dst_indices::AbstractVector{<:Integer})
    @assert length(src_indices) == length(dst_indices)
    images = Array{UInt8, 3}(undef, nrows, ncols, length(src_indices))
    imagesize = nrows * ncols
    if length(src_indices) == 1
        # avoid allocating buffer for single image
        src_ix = src_indices[1]
        @assert dst_indices[1] == 1
        skip(io, imagesize * (src_ix-1))
        read!(io, images)
    else
        buffer = Matrix{UInt8}(undef, nrows, ncols)
        pos = IMAGEOFFSET
        for (dst_ix, src_ix) in zip(dst_indices, src_indices)
            nextpos = IMAGEOFFSET + imagesize * (src_ix - 1)
            skip(io, nextpos - pos)
            read!(io, buffer)
            copyto!(view(images, :, :, dst_ix), buffer)
            pos = nextpos + imagesize
        end
    end
    return images
end

"""
    readimages(file::AbstractString, [indices])
    readimages(io::IO, [indices])

Reads the label denoted by `indices` from `file` or `io`. The given file
is assumed to be in the MNIST label-file format, as it is described
on the official homepage at http://yann.lecun.com/exdb/mnist/

Reads the images denoted by `indices` from `file`. The given
`file` can either be specified using an IO-stream or a string
that denotes the fully qualified path. The conent of `file` is
assumed to be in the MNIST image-file format, as it is described
on the official homepage at http://yann.lecun.com/exdb/mnist/

If specified, `indices` could be either a single 1-based image index or a vector of indices.
If `indices` is not specified, all images are read.

Returns a 3D array (`Array{UInt8,3}`), in which the first
dimension corresponds to the pixel *rows* (x) of the image, the
second dimension to the pixel *columns* (y) of the image, and
the third dimension denotes the index of the image.
"""
function readimages(io::IO, indices::Union{AbstractVector{<:Integer}, Nothing} = nothing)
    _, nimages, nrows, ncols = readimageheader(io)
    _indices = indices !== nothing ? indices : (1:nimages)
    @assert isa(_indices, AbstractVector)
    all(i -> 1 <= i <= nimages, _indices) ||
        throw(ArgumentError("not all elements in parameter \"indices\" are in 1:$nimages"))

    issorted(_indices) && return _readimages(io, nrows, ncols, _indices, 1:length(_indices))
    # sort indices, because IO might not support seek()
    perm = sortperm(_indices)
    return _readimages(io, nrows, ncols, _indices[perm], (1:length(_indices))[perm])
end

readimages(io::IO, index::Integer) = dropdims(readimages(io, [index]), dims=3)

function readimages(file::AbstractString, indices = nothing)
    open(GzipDecompressorStream, file) do io
        readimages(io, indices)
    end
end
