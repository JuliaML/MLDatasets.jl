function readimages!(buffer::Matrix{UInt8}, io::IO, index::Integer, nrows::Integer, ncols::Integer)
    seek(io, IMAGEOFFSET + nrows * ncols * (index - 1))
    read!(io, buffer)
end

# """
#     readimages(io::IO, index::Integer, nrows::Integer, ncols::Integer)

# Jumps to the position of `io` where the bytes for the `index`'th
# image are located and reads the next `nrows` * `ncols` bytes. The
# read bytes are returned as a `Matrix{UInt8}` of size `(nrows, ncols)`.
# """
function readimages(io::IO, index::Integer, nrows::Integer, ncols::Integer)
    buffer = Array{UInt8}(undef, nrows, ncols)
    readimages!(buffer, io, index, nrows, ncols)
end

# """
#     readimages(io::IO, indices::AbstractVector, nrows::Integer, ncols::Integer)

# Reads the first `nrows` * `ncols` bytes for each image index in
# `indices` and stores them in a `Array{UInt8,3}` of size `(nrows,
# ncols, length(indices))` in the same order as denoted by
# `indices`.
# """
function readimages(io::IO, indices::AbstractVector, nrows::Integer, ncols::Integer)
    images = Array{UInt8}(undef, nrows, ncols, length(indices))
    buffer = Array{UInt8}(undef, nrows, ncols)
    dst_index = 1
    for src_index in indices
        readimages!(buffer, io, src_index, nrows, ncols)
        copyto!(images, 1 + nrows * ncols * (dst_index - 1), buffer, 1, nrows * ncols)
        dst_index += 1
    end
    images
end

# """
#     readimages(file, [indices])

# Reads the images denoted by `indices` from `file`. The given
# `file` can either be specified using an IO-stream or a string
# that denotes the fully qualified path. The conent of `file` is
# assumed to be in the MNIST image-file format, as it is described
# on the official homepage at http://yann.lecun.com/exdb/mnist/

# - if `indices` is an `Integer`, the single image is returned as
#   `Matrix{UInt8}` in horizontal major layout, which means that
#   the first dimension denotes the pixel *rows* (x), and the
#   second dimension denotes the pixel *columns* (y) of the image.

# - if `indices` is a `AbstractVector`, the images are returned as
#   a 3D array (i.e. a `Array{UInt8,3}`), in which the first
#   dimension corresponds to the pixel *rows* (x) of the image, the
#   second dimension to the pixel *columns* (y) of the image, and
#   the third dimension denotes the index of the image.

# - if `indices` is ommited all images are returned
#   (as 3D array described above)
# """
function readimages(io::IO, indices)
    _, nimages, nrows, ncols = readimageheader(io)
    @assert minimum(indices) >= 1 && maximum(indices) <= nimages
    readimages(io, indices, nrows, ncols)
end

function readimages(file::AbstractString, index::Integer)
    gzopen(file, "r") do io
        readimages(io, index)
    end::Matrix{UInt8}
end

function readimages(file::AbstractString, indices::AbstractVector)
    gzopen(file, "r") do io
        readimages(io, indices)
    end::Array{UInt8,3}
end

function readimages(file::AbstractString)
    gzopen(file, "r") do io
        _, nimages, nrows, ncols = readimageheader(io)
        readimages(io, 1:nimages, nrows, ncols)
    end::Array{UInt8,3}
end
