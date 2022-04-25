module CIFAR10Reader

export

    readdata!,
    readdata

const NROW = 32
const NCOL = 32
const NCHAN = 3
const NBYTE = NROW * NCOL * NCHAN + 1 # "+ 1" for label
const CHUNK_SIZE = 10_000

function readnext!(buffer::Array{UInt8}, io::IO)
    y = Int(read(io, UInt8))
    read!(io, buffer)
    buffer, y
end

function readdata!(buffer::Array{UInt8}, io::IO, index::Integer)
    seek(io, (index - 1) * NBYTE)
    readnext!(buffer, io)
end

function readdata(io::IO, index::Integer)
    buffer = Array{UInt8}(undef, NROW, NCOL, NCHAN)
    readdata!(buffer, io, index)
end

function readdata(io::IO)
    X = Array{UInt8}(undef, NROW, NCOL, NCHAN, CHUNK_SIZE)
    Y = Array{Int}(undef, CHUNK_SIZE)
    buffer = Array{UInt8}(undef, NROW, NCOL, NCHAN)
    @inbounds for index in 1:CHUNK_SIZE
        _, ty = readnext!(buffer, io)
        copyto!(view(X,:,:,:,index), buffer)
        Y[index] = ty
    end
    X, Y
end

function readdata(file::AbstractString, index::Integer)
    open(file, "r") do io
        readdata(io, index)
    end::Tuple{Array{UInt8,3},Int}
end

function readdata(file::AbstractString)
    open(file, "r") do io
        readdata(io)
    end::Tuple{Array{UInt8,4},Vector{Int}}
end

end
