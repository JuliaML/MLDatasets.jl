function __init__cifar10()
    DEPNAME = "CIFAR10"

    register(DataDep(
        DEPNAME,
        """
        Dataset: The CIFAR-10 dataset
        Authors: Alex Krizhevsky, Vinod Nair, Geoffrey Hinton
        Website: https://www.cs.toronto.edu/~kriz/cifar.html
        Reference: https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf

        [Krizhevsky, 2009]
            Alex Krizhevsky.
            "Learning Multiple Layers of Features from Tiny Images",
            Tech Report, 2009.

        The CIFAR-10 dataset is a labeled subsets of the 80
        million tiny images dataset. It consists of 60000
        32x32 colour images in 10 classes, with 6000 images
        per class.

        The compressed archive file that contains the
        complete dataset is available for download at the
        offical website linked above; specifically the binary
        version for C programs. Note that using the data
        responsibly and respecting copyright remains your
        responsibility. The authors of CIFAR-10 aren't really
        explicit about any terms of use, so please read the
        website to make sure you want to download the
        dataset.
        """,
        "https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz",
        "c4a38c50a1bc5f3a1c5537f2155ab9d68f9f25eb1ed8d9ddda3db29a59bca1dd",
        post_fetch_method = file -> (run(BinDeps.unpack_cmd(file, dirname(file), ".gz", ".tar")); rm(file))
    ))
end

struct CIFAR10{Tx, Ax<:AbstractArray{Tx, 4}} <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Ax
    targets::Vector{Int}
end


function CIFAR10(; split=:train, Tx=Float32, dir=nothing)
    DEPNAME = "CIFAR10"
    NCHUNKS = 5
    TESTSET_FILENAME = joinpath("cifar-10-batches-bin", "test_batch.bin")
    
    filename_for_chunk(file_index::Int) =
        joinpath("cifar-10-batches-bin", "data_batch_$(file_index).bin")

    @assert split ∈ (:train, :test)

    if split == :train
        # placeholders for the chunks
        Xs = Vector{Array{UInt8,4}}(undef, NCHUNKS)
        Ys = Vector{Vector{Int}}(undef, NCHUNKS)
        # loop over all 5 trainingset files (i.e. chunks)
        for file_index in 1:NCHUNKS
            file_name = filename_for_chunk(file_index)
            file_path = datafile(DEPNAME, file_name, dir)
            # load all the data from each file and append it to
            # the placeholders X and Y
            X, Y = CIFAR10Reader.readdata(file_path)
            Xs[file_index] = X
            Ys[file_index] = Y
            
            #TODO define a lazy version that reads a signle image only when asked
            # file_index = ceil(Int, index / Reader.CHUNK_SIZE)
            # file_name = filename_for_chunk(file_index)
            # file_path = datafile(DEPNAME, file_name, dir)
            ## once we know the file we just need to compute the approriate
            ## offset of the image realtive to that file.
            # sub_index = ((index - 1) % Reader.CHUNK_SIZE) + 1
            # image, label = CIFAR10Reader.readdata(file_path, sub_index)
        end
        # cat all the placeholders into one image array
        # and one label array. (good enough)
        images = cat(Xs..., dims=4)::Array{UInt8,4}
        labels = vcat(Ys...)::Vector{Int}
        # optionally transform the image array before returning
        features, targets = bytes_to_type(Tx, images), labels
    else
        file_path = datafile(DEPNAME, TESTSET_FILENAME, dir)
        # simply read the complete content of the testset file
        images, labels = CIFAR10Reader.readdata(file_path)
        # optionally transform the image array before returning
        features, targets = bytes_to_type(Tx, images), labels
    end

    metadata = Dict{String, Any}()
    metadata["class_names"] = ["airplane", "automobile", "bird", "cat", "deer", "dog", "frog", "horse", "ship", "truck"]
    return CIFAR10(metadata, split, features, targets)
end

function convert2image(d::CIFAR10, i)
    array = d[i].features
    d = ndims(array)  
    array = reshape(array, 32, 32, 3, :)
    array = permutedims(array, (3, 2, 1, 4))
    if d < ndims(array)
        array = dropdims(array, dims=4)
    end
    if eltype(array) <: Integer
        array = reinterpret(N0f8, convert(Array{UInt8}, array))
    end
    img = ImageCore.colorview(RGB, array)
    return img
end


# DEPRECATED INTERFACE, REMOVE IN v0.7 (or 0.6.x)
function Base.getproperty(::Type{CIFAR10}, s::Symbol)
    if s == :traintensor
        @warn "CIFAR10.traintensor() is deprecated, use `CIFAR10(split=:train).features` instead." maxlog=2
        traintensor(T::Type=N0f8; kws...) = traintensor(T, :; kws...)
        traintensor(i; kws...) = traintensor(N0f8, i; kws...)
        function traintensor(T::Type, i; dir=nothing)
            CIFAR10(; split=:train, Tx=T, dir)[i][1]
        end
        return traintensor
    elseif s == :testtensor
        @warn "CIFAR10.testtensor() is deprecated, use `CIFAR10(split=:test).features` instead."  maxlog=2
        testtensor(T::Type=N0f8; kws...) = testtensor(T, :; kws...)
        testtensor(i; kws...) = testtensor(N0f8, i; kws...)
        function testtensor(T::Type, i; dir=nothing)
            CIFAR10(; split=:test, Tx=T, dir)[i][1]
        end
        return testtensor        
    elseif s == :trainlabels
        @warn "CIFAR10.trainlabels() is deprecated, use `CIFAR10(split=:train).targets` instead."  maxlog=2
        trainlabels(; kws...) = trainlabels(:; kws...)
        function trainlabels(i; dir=nothing)
            CIFAR10(; split=:train, dir)[i][2]
        end
        return trainlabels
    elseif s == :testlabels
        @warn "CIFAR10.testlabels() is deprecated, use `CIFAR10(split=:test).targets` instead." maxlog=2
        testlabels(; kws...) = testlabels(:; kws...)
        function testlabels(i; dir=nothing)
            CIFAR10(; split=:test, dir)[i][2]
        end
        return testlabels
    elseif s == :traindata
        @warn "CIFAR10.traindata() is deprecated, use `CIFAR10(split=:train)[]` instead." maxlog=2
        traindata(T::Type=N0f8; kws...) = traindata(T, :; kws...)
        traindata(i; kws...) = traindata(N0f8, i; kws...)
        function traindata(T::Type, i; dir=nothing)
            CIFAR10(; split=:train, Tx=T, dir)[i]
        end
        return traindata
    elseif s == :testdata
        @warn "CIFAR10.testdata() is deprecated, use `CIFAR10(split=:test)[]` instead."  maxlog=2
        testdata(T::Type=N0f8; kws...) = testdata(T, :; kws...)
        testdata(i; kws...) = testdata(N0f8, i; kws...)
        function testdata(T::Type, i; dir=nothing)
            CIFAR10(; split=:test, Tx=T, dir)[i]
        end
        return testdata
    elseif s == :convert2image
        @error "CIFAR10.convert2image(x) is deprecated, use `d=CIFAR10(); convert2image(d, i)` instead"
    else
        return getfield(CIFAR10, s)
    end
end
