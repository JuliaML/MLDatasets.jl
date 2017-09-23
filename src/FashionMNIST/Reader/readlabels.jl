"""
    readlabels(io::IO, index::Integer)

Jumps to the position of `io` where the byte for the `index`'th
label is located and returns the byte at that position as `UInt8`
"""
function readlabels(io::IO, index::Integer)
    seek(io, LABELOFFSET + (index - 1))
    read(io, UInt8)::UInt8
end

"""
    readlabels(io::IO, indices::AbstractVector)

Reads the byte for each label-index in `indices` and stores them
in a `Vector{UInt8}` of length `length(indices)` in the same order
as denoted by `indices`.
"""
function readlabels(io::IO, indices::AbstractVector)
    labels = Array{UInt8}(length(indices))
    dst_index = 1
    for src_index in indices
        labels[dst_index] = readlabels(io, src_index)
        dst_index += 1
    end
    labels::Vector{UInt8}
end

"""
    readlabels(file::AbstractString, [indices])

Reads the label denoted by `indices` from `file`. The given `file`
is assumed to be in the FashionMNIST label-file format, as it is described
on the official homepage at http://yann.lecun.com/exdb/FashionMNIST/

- if `indices` is an `Integer`, the single label is returned as `UInt8`.

- if `indices` is a `AbstractVector`, the labels are returned as
  a `Vector{UInt8}`, length `length(indices)` in the same order as
  denoted by `indices`.

- if `indices` is ommited all all are returned
  (as `Vector{UInt8}` as described above)
"""
function readlabels(file::AbstractString, index::Integer)
    gzopen(file, "r") do io
        _, nlabels = readlabelheader(io)
        @assert minimum(index) >= 1 && maximum(index) <= nlabels
        readlabels(io, index)
    end::UInt8
end

function readlabels(file::AbstractString, indices::AbstractVector)
    gzopen(file, "r") do io
        _, nlabels = readlabelheader(io)
        @assert minimum(indices) >= 1 && maximum(indices) <= nlabels
        readlabels(io, indices)
    end::Vector{UInt8}
end

function readlabels(file::AbstractString)
    gzopen(file, "r") do io
        _, nlabels = readlabelheader(io)
        readlabels(io, 1:nlabels)
    end::Vector{UInt8}
end

"""
    readtrainlabels(dir::AbstractString, [indices])

Reads the labels of the given `indices` from the file
\"$TRAINLABELS\" using the function [`readlabels`](@ref), and
returns them as `UInt8` or an array of `UInt8`.

The file is expected to be located in the given directory `dir`.
In the case that the file does not yet exist the function will
provide you with download instructions.
"""
readtrainlabels(dir) = readlabels(downloaded_file(dir, TRAINLABELS))
readtrainlabels(dir, indices) = readlabels(downloaded_file(dir, TRAINLABELS), indices)

"""
    readtestlabels(dir::AbstractString, [indices])

Reads the labels of the given `indices` from the file
\"$TESTLABELS\" using the function [`readlabels`](@ref), and
returns them as `UInt8` or an array of `UInt8`.

The file is expected to be located in the given directory `dir`.
In the case that the file does not yet exist the function will
provide you with download instructions.
"""
readtestlabels(dir) = readlabels(downloaded_file(dir, TESTLABELS))
readtestlabels(dir, indices) = readlabels(downloaded_file(dir, TESTLABELS), indices)
