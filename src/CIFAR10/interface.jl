traintensor(args...; dir = nothing) = traindata(args...; dir = dir)[1]
trainlabels(args...; dir = nothing) = traindata(args...; dir = dir)[2]
traindata(args...; dir = nothing) = traindata(N0f8, args...; dir = dir)

filename_for_chunk(file_index::Int) = joinpath("cifar-10-batches-bin", "data_batch_$(file_index).bin")

function traindata(::Type{T}; dir = nothing) where T
    Xs = Vector{Array{UInt8,4}}(NCHUNKS)
    Ys = Vector{Vector{Int}}(NCHUNKS)
    for file_index in 1:NCHUNKS
        file_name = filename_for_chunk(file_index)
        file_path = datafile(DEPNAME, file_name, dir)
        X, Y = Reader.readdata(file_path)
        Xs[file_index] = X
        Ys[file_index] = Y
    end
    images = cat(4, Xs...)::Array{UInt8,4}
    labels = vcat(Ys...)::Vector{Int}
    bytes_to_type(T, images), labels
end

function traindata(::Type{T}, index::Integer; dir = nothing) where T
    @assert 1 <= index <= NCHUNKS * Reader.CHUNK_SIZE "parameter \"index\" ($index) not in 1:$(NCHUNKS*Reader.CHUNK_SIZE)"
    file_index = ceil(Int, index / Reader.CHUNK_SIZE)
    file_name = filename_for_chunk(file_index)
    file_path = datafile(DEPNAME, file_name, dir)
    sub_index = ((index - 1) % Reader.CHUNK_SIZE) + 1
    image, label = Reader.readdata(file_path, sub_index)
    bytes_to_type(T, image), label
end

function traindata(::Type{T}, indices::AbstractVector; dir = nothing) where T
    mi, ma = extrema(indices)
    @assert mi >= 1 && ma <= NCHUNKS * Reader.CHUNK_SIZE "not all elements in parameter \"indices\" are in 1:$(NCHUNKS*Reader.CHUNK_SIZE)"
    buffer = Array{UInt8,3}(Reader.NROW, Reader.NCOL, Reader.NCHAN)
    images = Array{UInt8,4}(Reader.NROW, Reader.NCOL, Reader.NCHAN, length(indices))
    labels = Array{Int,1}(length(indices))
    for file_index in 1:NCHUNKS
        file_name = filename_for_chunk(file_index)
        file_path = datafile(DEPNAME, file_name, dir)
        open(file_path, "r") do io
            @inbounds for (i, index) in enumerate(indices)
                cur_file_index = ceil(Int, index / Reader.CHUNK_SIZE)
                cur_file_index == file_index || continue
                sub_index = ((index - 1) % Reader.CHUNK_SIZE) + 1
                _, y = Reader.readdata!(buffer, io, sub_index)
                copy!(view(images,:,:,:,i), buffer)
                labels[i] = y
            end
        end
    end
    bytes_to_type(T, images), labels
end

testtensor(args...; dir = nothing) = testdata(args...; dir = dir)[1]
testlabels(args...; dir = nothing) = testdata(args...; dir = dir)[2]
testdata(args...; dir = nothing) = testdata(N0f8, args...; dir = dir)

const FILENAME_TEST = joinpath("cifar-10-batches-bin","test_batch.bin")

function testdata(::Type{T}; dir = nothing) where T
    file_path = datafile(DEPNAME, FILENAME_TEST, dir)
    images, labels = Reader.readdata(file_path)
    bytes_to_type(T, images), labels
end

function testdata(::Type{T}, index::Integer; dir = nothing) where T
    @assert 1 <= index <= Reader.CHUNK_SIZE "parameter \"index\" ($index) not in 1:$(Reader.CHUNK_SIZE)"
    file_path = datafile(DEPNAME, FILENAME_TEST, dir)
    image, label = Reader.readdata(file_path, index)
    bytes_to_type(T, image), label
end

function testdata(::Type{T}, indices::AbstractVector; dir = nothing) where T
    mi, ma = extrema(indices)
    @assert mi >= 1 && ma <= Reader.CHUNK_SIZE "not all elements in parameter \"indices\" are in 1:$(Reader.CHUNK_SIZE)"
    buffer = Array{UInt8,3}(Reader.NROW, Reader.NCOL, Reader.NCHAN)
    images = Array{UInt8,4}(Reader.NROW, Reader.NCOL, Reader.NCHAN, length(indices))
    labels = Array{Int,1}(length(indices))
    file_path = datafile(DEPNAME, FILENAME_TEST, dir)
    open(file_path, "r") do io
        @inbounds for (i, index) in enumerate(indices)
            _, y = Reader.readdata!(buffer, io, index)
            copy!(view(images,:,:,:,i), buffer)
            labels[i] = y
        end
    end
    bytes_to_type(T, images), labels
end
