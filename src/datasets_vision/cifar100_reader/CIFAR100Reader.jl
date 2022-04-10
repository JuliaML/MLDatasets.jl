module CIFAR100Reader

export

    readdata!,
    readdata

const NROW = 32
const NCOL = 32
const NCHAN = 3
const NBYTE = NROW * NCOL * NCHAN + 2 # "+ 2" for label

function readnext!(buffer::Array{UInt8}, io::IO)
    c = Int(read(io, UInt8))
    f = Int(read(io, UInt8))
    read!(io, buffer)
    buffer, c, f
end

function readdata!(buffer::Array{UInt8}, io::IO, index::Integer)
    seek(io, (index - 1) * NBYTE)
    readnext!(buffer, io)
end

function readdata(io::IO, nobs::Int, index::Integer)
    buffer = Array{UInt8}(undef, NROW, NCOL, NCHAN)
    readdata!(buffer, io, index)
end

function readdata(io::IO, nobs::Int)
    X = Array{UInt8}(undef, NROW, NCOL, NCHAN, nobs)
    C = Array{Int}(undef, nobs)
    F = Array{Int}(undef, nobs)
    buffer = Array{UInt8}(undef, NROW, NCOL, NCHAN)
    @inbounds for index in 1:nobs
        _, tc, tf = readnext!(buffer, io)
        copyto!(view(X,:,:,:,index), buffer)
        C[index] = tc
        F[index] = tf
    end
    X, C, F
end

function readdata(file::AbstractString, nobs::Int, index::Integer)
    open(file, "r") do io
        readdata(io, nobs, index)
    end::Tuple{Array{UInt8,3},Int,Int}
end

function readdata(file::AbstractString, nobs::Int)
    open(file, "r") do io
        readdata(io, nobs)
    end::Tuple{Array{UInt8,4},Vector{Int},Vector{Int}}
end

end
