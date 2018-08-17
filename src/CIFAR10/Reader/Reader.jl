module Reader

export readdata

const NROW = 32
const NCOL = 32
const NCHAN = 3
const CHUNK_SIZE = 10_000

# Reads images and their labels at (`src_indices`-`src_offset`) positions from `io`
# and puts them to dst_indices positions into the `images` and `labels` arrays, resp.
# 1st, 2nd and 3rd dimensions of `images` array define width, height and N of image channels, resp.
# `nsrc` is the total number of images available at `io`.
# `src_indices` should be sorted in ascending order,
# otherwise `io` will fail to go to the already read position.
function _readdata!(io::IO,
                    images::Array{UInt8, 4}, labels::Vector,
                    nsrc::Integer, src_indices::AbstractVector{<:Integer},
                    src_offset::Integer = 0, dst_indices::AbstractVector{<:Integer} = 1:size(images, 4))
    all(ix -> 1 <= ix-src_offset <= nsrc, src_indices) ||
        throw(ArgumentError("not all elements in parameter \"indices\" are in 1:$nsrc"))
    img_size = map(i -> size(images, i), (1, 2, 3))
    imagesize = prod(img_size)*sizeof(eltype(images)) + sizeof(eltype(labels))
    if size(images, 4) == 1
        # avoid buffer allocation for single image
        skip(io, imagesize * (src_indices[1] - src_offset - 1))
        labels[dst_indices[1]] = read(io, eltype(labels))
        read!(io, images)
    else
        buffer = Array{UInt8}(undef, img_size)
        pos = 0
        last_src_ix = 0
        last_label = first(labels)
        @inbounds for (dst_ix, src_ix) in zip(dst_indices, src_indices)
            if src_ix != last_src_ix
                nextpos = imagesize * (src_ix - src_offset - 1)
                skip(io, nextpos - pos)
                last_label = read(io, eltype(labels))
                read!(io, buffer)
                pos = nextpos + imagesize
                last_src_ix = src_ix
            end
            copyto!(view(images, :,:,:, dst_ix), buffer)
            labels[dst_ix] = last_label
        end
    end
    return images, labels
end

function _readdata!(file::AbstractString, images, labels, nsrc, src_indices,
                    src_offset = 0, dst_indices::AbstractVector{<:Integer} = axes(images, 4))
    open(file, "r") do io
        _readdata!(io, images, labels, nsrc, src_indices, src_offset, dst_indices)
    end
end

# Returns a tuple of `nrows`×`ncols`×`nchannels`×`length(indices)` images array
# and `length(indices)` vector of their labels filled by `_readdata!()`
_readdata(io::IO,
          nrows::Integer, ncols::Integer, nchannels::Integer, nsrc::Integer,
          indices::AbstractVector{<:Integer}, labeltype::Type{T}) where T<:Integer =
    _readdata!(io, Array{UInt8, 4}(undef, nrows, ncols, nchannels, length(indices)),
               fill(zero(labeltype), length(indices)), nsrc, indices, 0)

function _readdata(file::AbstractString,
        nrows::Integer, ncols::Integer, nchannels::Integer, nsrc::Integer,
        indices::AbstractVector{<:Integer}, labeltype::Type)
    open(file, "r") do io
        _readdata(io, nrows, ncols, nchannels, nsrc, indices, labeltype)
    end
end

function readdata(source, indices::AbstractVector{<:Integer})
    images, labels = _readdata(source, NROW, NCOL, NCHAN, CHUNK_SIZE, indices, UInt8)
    return images, Vector{Int}(labels)
end

readdata(source, indices::Nothing = nothing) = readdata(source, 1:CHUNK_SIZE)

function readdata(source, index::Integer)
    images, labels = _readdata(source, NROW, NCOL, NCHAN, CHUNK_SIZE, [index], UInt8)
    return dropdims(images, dims=4), convert(Int, @inbounds(labels[1]))::Int
end

end
