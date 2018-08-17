module Reader

using ...MLDatasets.CIFAR10.Reader: _readdata

export readdata

const NROW = 32
const NCOL = 32
const NCHAN = 3

function readdata(source, nobs::Integer, indices::AbstractVector{<:Integer})
    images, labels = _readdata(source, NROW, NCOL, NCHAN, nobs, indices, UInt16)
    return images,
           Int[(lbl % UInt8) for lbl in labels]::Vector{Int},
           Int[((lbl >> 8) % UInt8) for lbl in labels]::Vector{Int}
end

readdata(source, nobs::Integer, indices::Nothing=nothing) =
    readdata(source, nobs, 1:nobs)

function readdata(source, nobs::Integer, index::Integer)
    images, labels = _readdata(source, NROW, NCOL, NCHAN, nobs, [index], UInt16)
    return dropdims(images, dims=4),
           convert(Int, labels[1] % UInt8)::Int,
           convert(Int, (labels[1] >> 8) % UInt8)::Int
end

end
