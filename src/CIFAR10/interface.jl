"""
    classnames() -> Vector{String}

Return the 10 names for the CIFAR10 classes as a vector of strings.
"""
classnames() = CLASSES

"""
    traintensor([T = N0f8], [indices]; [dir]) -> Array{T}

Return the CIFAR-10 **training** images corresponding to the
given `indices` as a multi-dimensional array of eltype `T`. If
the corresponding labels are required as well, it is recommended
to use [`CIFAR10.traindata`](@ref) instead.

The image(s) is/are returned in the horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 4D array (i.e. a `Array{T,4}`) in
WHCN format (width, height, #channels, #images). 
For integer `indices` instead, a 3D array in WHC format is returned.


```julia-repl
julia> CIFAR10.traintensor() # load all training images
32×32×3×50000 Array{N0f8,4}:
[...]

julia> CIFAR10.traintensor(Float32, 1:3) # first three images as Float32
32×32×3×3 Array{Float32,4}:
[...]
```

If `indices` is an `Integer`, a single image is returned as
`Array{T,3}` array. 

```julia-repl
julia> CIFAR10.traintensor(1) # load first training image
32×32×3 Array{N0f8,3}:
[...]
```

You can use the utility function
[`convert2image`](@ref) to convert an CIFAR-10 array into a
horizontal-major Julia image with the appropriate `RGB` eltype.

```julia-repl
julia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # convert to column-major colorant array
32×32 Array{RGB{N0f8},2}:
[...]
```

$(download_docstring("CIFAR10", DEPNAME))
"""
function traintensor(args...; dir = nothing)
    traindata(args...; dir = dir)[1]
end

# needed for type inference for some reason
function traintensor(::Type{T}, args...; dir = nothing) where T
    traindata(T, args...; dir = dir)[1]
end

"""
    testtensor([T = N0f8], [indices]; [dir]) -> Array{T}

Return the CIFAR-10 **test** images corresponding to the given
`indices` as a multi-dimensional array of eltype `T`. If the
corresponding labels are required as well, it is recommended to
use [`CIFAR10.testdata`](@ref) instead.

Images are returned in horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 4D array (i.e. a `Array{T,4}`) in
WHCN format (width, height, #channels, #images). 
For integer `indices` instead, a 3D array in WHC format is returned.

```julia-repl
julia> CIFAR10.testtensor() # load all training images
32×32×3×10000 Array{N0f8,4}:
[...]

julia> CIFAR10.testtensor(Float32, 1:3) # first three images as Float32
32×32×3×3 Array{Float32,4}:
[...]
```

If `indices` is an `Integer`, a single image is returned as
`Array{T,3}`.

```julia-repl
julia> CIFAR10.testtensor(1) # load first training image
32×32×3 Array{N0f8,3}:
[...]
```

You can use the utility function
[`convert2image`](@ref) to convert an CIFAR-10 array into a
horizontal-major HW Julia image with the appropriate `RGB` eltype.

```julia-repl
julia> CIFAR10.convert2image(CIFAR10.testtensor(1)) # convert to column-major colorant array
32×32 Array{RGB{N0f8},2}:
[...]
```

$(download_docstring("CIFAR10", DEPNAME))
"""
function testtensor(args...; dir = nothing)
    testdata(args...; dir = dir)[1]
end

function testtensor(::Type{T}, args...; dir = nothing) where T
    testdata(T, args...; dir = dir)[1]
end

"""
    trainlabels([indices]; [dir])

Returns the CIFAR-10 **trainset** labels corresponding to the
given `indices` as an `Int` or `Vector{Int}`. The values of the
labels denote the zero-based class-index that they represent (see
[`CIFAR10.classnames`](@ref) for the corresponding names). If
`indices` is omitted, all labels are returned.

```julia-repl
julia> CIFAR10.trainlabels() # full training set
50000-element Array{Int64,1}:
 6
 9
 ⋮
 1
 1

julia> CIFAR10.trainlabels(1:3) # first three labels
3-element Array{Int64,1}:
 6
 9
 9

julia> CIFAR10.trainlabels(1) # first label
6

julia> CIFAR10.classnames()[CIFAR10.trainlabels(1) + 1] # corresponding name
"frog"
```

$(download_docstring("CIFAR10", DEPNAME))
"""
function trainlabels(args...; dir = nothing)
    traindata(args...; dir = dir)[2]
end

"""
    testlabels([indices]; [dir])

Returns the CIFAR-10 **testset** labels corresponding to the
given `indices` as an `Int` or `Vector{Int}`. The values of the
labels denote the zero-based class-index that they represent (see
[`CIFAR10.classnames`](@ref) for the corresponding names). If
`indices` is omitted, all labels are returned.

```julia-repl
julia> CIFAR10.testlabels() # full training set
10000-element Array{Int64,1}:
 3
 8
 ⋮
 1
 7

julia> CIFAR10.testlabels(1:3) # first three labels
3-element Array{Int64,1}:
 3
 8
 8

julia> CIFAR10.testlabels(1) # first label
3

julia> CIFAR10.classnames()[CIFAR10.testlabels(1) + 1] # corresponding name
"cat"
```

$(download_docstring("CIFAR10", DEPNAME))
"""
function testlabels(args...; dir = nothing)
    testdata(args...; dir = dir)[2]
end

"""
    traindata([T = N0f8], [indices]; [dir]) -> images, labels

Returns the CIFAR-10 **trainingset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full trainingset is returned. The first element of the return
values will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The image(s) is/are returned in horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
train_x, train_y = CIFAR10.traindata() # full datatset
train_x, train_y = CIFAR10.traindata(2) # only second observation
train_x, train_y = CIFAR10.traindata(dir="./CIFAR10") # custom folder
```

$(download_docstring("CIFAR10", DEPNAME))

Take a look at [`CIFAR10.traintensor`](@ref) and
[`CIFAR10.trainlabels`](@ref) for more information.
"""
function traindata(args...; dir = nothing)
    traindata(N0f8, args...; dir = dir)
end

function traindata(::Type{T}; dir = nothing) where T
    # placeholders for the chunks
    Xs = Vector{Array{UInt8,4}}(undef, NCHUNKS)
    Ys = Vector{Vector{Int}}(undef, NCHUNKS)
    # loop over all 5 trainingset files (i.e. chunks)
    for file_index in 1:NCHUNKS
        file_name = filename_for_chunk(file_index)
        file_path = datafile(DEPNAME, file_name, dir)
        # load all the data from each file and append it to
        # the placeholders X and Y
        X, Y = Reader.readdata(file_path)
        Xs[file_index] = X
        Ys[file_index] = Y
    end
    # cat all the placeholders into one image array
    # and one label array. (good enough)
    images = cat(Xs..., dims=4)::Array{UInt8,4}
    labels = vcat(Ys...)::Vector{Int}
    # optionally transform the image array before returning
    bytes_to_type(T, images), labels
end

function traindata(::Type{T}, index::Integer; dir = nothing) where T
    @assert 1 <= index <= NCHUNKS * Reader.CHUNK_SIZE "parameter \"index\" ($index) not in 1:$(NCHUNKS*Reader.CHUNK_SIZE)"
    # we only need to return a single image, so the task breaks
    # down to computing which file that image is in.
    file_index = ceil(Int, index / Reader.CHUNK_SIZE)
    file_name = filename_for_chunk(file_index)
    file_path = datafile(DEPNAME, file_name, dir)
    # once we know the file we just need to compute the approriate
    # offset of the image realtive to that file.
    sub_index = ((index - 1) % Reader.CHUNK_SIZE) + 1
    image, label = Reader.readdata(file_path, sub_index)
    # optionally transform the image array before returning
    bytes_to_type(T, image), label
end

function traindata(::Type{T}, indices::AbstractVector; dir = nothing) where T
    mi, ma = extrema(indices)
    @assert mi >= 1 && ma <= NCHUNKS * Reader.CHUNK_SIZE "not all elements in parameter \"indices\" are in 1:$(NCHUNKS*Reader.CHUNK_SIZE)"
    # preallocate a buffer we will reuse for reading individual
    # images. "buffer" is written to length(indices) times
    buffer = Array{UInt8,3}(undef, Reader.NROW, Reader.NCOL, Reader.NCHAN)
    # we know the types and dimensions of the return values,
    # so we can preallocate them
    images = Array{UInt8,4}(undef, Reader.NROW, Reader.NCOL, Reader.NCHAN, length(indices))
    labels = Array{Int,1}(undef, length(indices))
    # loop over all 5 trainingset files (i.e. chunks)
    for file_index in 1:NCHUNKS
        file_name = filename_for_chunk(file_index)
        file_path = datafile(DEPNAME, file_name, dir)
        open(file_path, "r") do io
            # for each chunk we loop through indices once
            @inbounds for (i, index) in enumerate(indices)
                # check if "index" is part of the current chunk
                cur_file_index = ceil(Int, index / Reader.CHUNK_SIZE)
                cur_file_index == file_index || continue
                # if it is, then compute the relative offset
                sub_index = ((index - 1) % Reader.CHUNK_SIZE) + 1
                # read the corresponding image into "buffer"
                # and the corresponding label into "y"
                _, y = Reader.readdata!(buffer, io, sub_index)
                # write the image into the appropriate position
                # of our preallocated "images" array.
                copyto!(view(images,:,:,:,i), buffer)
                # same with labels
                labels[i] = y
            end
        end
    end
    # optionally transform the image array before returning
    bytes_to_type(T, images::Array{UInt8,4}), labels::Vector{Int}
end

"""
    testdata([T = N0f8], [indices]; [dir]) -> images, labels

Returns the CIFAR-10 **testset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full testset is returned. The first element of the return
values will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The image(s) is/are returned in the horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
test_x, test_y = CIFAR10.testdata() # full datatset
test_x, test_y = CIFAR10.testdata(2) # only second observation
test_x, test_y = CIFAR10.testdata(dir="./CIFAR10") # custom folder
```

$(download_docstring("CIFAR10", DEPNAME))

Take a look at [`CIFAR10.testtensor`](@ref) and
[`CIFAR10.testlabels`](@ref) for more information.
"""
function testdata(args...; dir = nothing)
    testdata(N0f8, args...; dir = dir)
end

function testdata(::Type{T}; dir = nothing) where T
    file_path = datafile(DEPNAME, TESTSET_FILENAME, dir)
    # simply read the complete content of the testset file
    images, labels = Reader.readdata(file_path)
    # optionally transform the image array before returning
    bytes_to_type(T, images), labels
end

function testdata(::Type{T}, index::Integer; dir = nothing) where T
    @assert 1 <= index <= Reader.CHUNK_SIZE "parameter \"index\" ($index) not in 1:$(Reader.CHUNK_SIZE)"
    file_path = datafile(DEPNAME, TESTSET_FILENAME, dir)
    # read the single image+label corresponding to "index"
    image, label = Reader.readdata(file_path, index)
    # optionally transform the image array before returning
    bytes_to_type(T, image), label
end

function testdata(::Type{T}, indices::AbstractVector; dir = nothing) where T
    mi, ma = extrema(indices)
    @assert mi >= 1 && ma <= Reader.CHUNK_SIZE "not all elements in parameter \"indices\" are in 1:$(Reader.CHUNK_SIZE)"
    # preallocate a buffer we will reuse for reading individual
    # images. "buffer" is written to length(indices) times
    buffer = Array{UInt8,3}(undef, Reader.NROW, Reader.NCOL, Reader.NCHAN)
    # we know the types and dimensions of the return values,
    # so we can preallocate them
    images = Array{UInt8,4}(undef, Reader.NROW, Reader.NCOL, Reader.NCHAN, length(indices))
    labels = Array{Int,1}(undef, length(indices))
    # in contrast to the trainset, the testset only has one file
    file_path = datafile(DEPNAME, TESTSET_FILENAME, dir)
    open(file_path, "r") do io
        # iterate over the given "indices"
        @inbounds for (i, index) in enumerate(indices)
            # read the corresponding image into "buffer" and
            # the corresponding label into "y"
            _, y = Reader.readdata!(buffer, io, index)
            # write the image into the appropriate position
            # of our preallocated "images" array.
            copyto!(view(images,:,:,:,i), buffer)
            # same with labels
            labels[i] = y
        end
    end
    # optionally transform the image array before returning
    bytes_to_type(T, images::Array{UInt8,4}), labels::Vector{Int}
end
