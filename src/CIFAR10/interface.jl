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

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 4D array (i.e. a `Array{T,4}`), in which
the first dimension corresponds to the pixel *rows* (x) of the
image, the second dimension to the pixel *columns* (y) of the
image, the third dimension the RGB color channels, and the fourth
dimension denotes the index of the image.

```julia-repl
julia> CIFAR10.traintensor() # load all training images
32×32×3×50000 Array{N0f8,4}:
[...]

julia> CIFAR10.traintensor(Float32, 1:3) # first three images as Float32
32×32×3×3 Array{Float32,4}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Array{T,3}` in horizontal-major layout, which means that the
first dimension denotes the pixel *rows* (x), the second
dimension denotes the pixel *columns* (y), and the third
dimension the RGB color channels of the image.

```julia-repl
julia> CIFAR10.traintensor(1) # load first training image
32×32×3 Array{N0f8,3}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an CIFAR-10 array into a
vertical-major Julia image with the appropriate `RGB` eltype.

```julia-repl
julia> CIFAR10.convert2image(CIFAR10.traintensor(1)) # convert to column-major colorant array
32×32 Array{RGB{N0f8},2}:
[...]
```

$(download_docstring("CIFAR10", DEPNAME))
"""
traintensor(args...; dir = nothing) = traindata(args...; dir = dir)[1]

"""
    testtensor([T = N0f8], [indices]; [dir]) -> Array{T}

Return the CIFAR-10 **test** images corresponding to the given
`indices` as a multi-dimensional array of eltype `T`. If the
corresponding labels are required as well, it is recommended to
use [`CIFAR10.testdata`](@ref) instead.

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 4D array (i.e. a `Array{T,4}`), in which
the first dimension corresponds to the pixel *rows* (x) of the
image, the second dimension to the pixel *columns* (y) of the
image, the third dimension the RGB color channels, and the fourth
dimension denotes the index of the image.

```julia-repl
julia> CIFAR10.testtensor() # load all training images
32×32×3×10000 Array{N0f8,4}:
[...]

julia> CIFAR10.testtensor(Float32, 1:3) # first three images as Float32
32×32×3×3 Array{Float32,4}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Array{T,3}` in horizontal-major layout, which means that the
first dimension denotes the pixel *rows* (x), the second
dimension denotes the pixel *columns* (y), and the third
dimension the RGB color channels of the image.

```julia-repl
julia> CIFAR10.testtensor(1) # load first training image
32×32×3 Array{N0f8,3}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an CIFAR-10 array into a
vertical-major Julia image with the appropriate `RGB` eltype.

```julia-repl
julia> CIFAR10.convert2image(CIFAR10.testtensor(1)) # convert to column-major colorant array
32×32 Array{RGB{N0f8},2}:
[...]
```

$(download_docstring("CIFAR10", DEPNAME))
"""
testtensor(args...; dir = nothing) = testdata(args...; dir = dir)[1]

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
trainlabels(args...; dir = nothing) = traindata(args...; dir = dir)[2]

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
testlabels(args...; dir = nothing) = testdata(args...; dir = dir)[2]

function _traindata(::Type{T}, indices::AbstractVector{<:Integer}; dir = nothing) where T
    all(in(1:(NCHUNKS*Reader.CHUNK_SIZE)), indices) ||
        throw(ArgumentError("not all elements in parameter \"indices\" are in 1:$(NCHUNKS*Reader.CHUNK_SIZE)"))
    # we know the types and dimensions of the return values,
    # so we can preallocate them
    images = Array{UInt8,4}(undef, Reader.NROW, Reader.NCOL, Reader.NCHAN, length(indices))
    labels = fill!(Vector{UInt8}(undef, length(indices)), 0)
    # split indices into chunks (1 chunk = 1 trainingset file)
    index_chunks = Dict{Int, Tuple{Vector{Int}, Vector{Int}}}()
    for (dst_ix, src_ix) in enumerate(indices)
        file_ix = fld1(src_ix, Reader.CHUNK_SIZE)
        @assert 1 <= file_ix <= NCHUNKS "file_ix=$file_ix for image #$src_ix, expected to be in 1:$NCHUNKS range"
        file_imgs = get!(() -> (Vector{Int}(), Vector{Int}()), index_chunks, file_ix)
        push!(file_imgs[1], dst_ix)
        push!(file_imgs[2], src_ix)
    end
    # read selected images from files
    for (file_index, (dst_indices, src_indices)) in index_chunks
        file_path = datafile(DEPNAME, filename_for_chunk(file_index), dir)
        if !issorted(src_indices)
            perm = sortperm(src_indices)
            permute!(src_indices, perm)
            permute!(dst_indices, perm)
        end
        Reader._readdata!(file_path, images, labels, Reader.CHUNK_SIZE, src_indices,
                          (file_index-1)*Reader.CHUNK_SIZE, dst_indices)
    end
    return images, labels
end

"""
    traindata([T = N0f8], [indices]; [dir]) -> images, labels

Returns the CIFAR-10 **trainingset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full trainingset is returned. The first element of the return
values will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The image(s) is/are returned in the native horizontal-major
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
function traindata(::Type{T}, indices::Nothing = nothing; dir = nothing) where T
    images, labels = _traindata(T, 1:(NCHUNKS*Reader.CHUNK_SIZE), dir=dir)
    # optionally transform the image array before returning
    return bytes_to_type(T, images), Vector{Int}(labels)
end

function traindata(::Type{T}, indices::AbstractVector{<:Integer}; dir = nothing) where T
    images, labels = _traindata(T, indices, dir=dir)
    # optionally transform the image array before returning
    return bytes_to_type(T, images), Vector{Int}(labels)
end

function traindata(::Type{T}, index::Integer; dir = nothing) where T
    images, labels = _traindata(T, [index], dir=dir)
    # optionally transform the image array before returning
    return bytes_to_type(T, dropdims(images, dims=4)), convert(Int, @inbounds(labels[1]))
end

traindata(indices = nothing; dir = nothing) =
    traindata(N0f8, indices, dir=dir)

"""
    testdata([T = N0f8], [indices]; [dir]) -> images, labels

Returns the CIFAR-10 **testset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full testset is returned. The first element of the return
values will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The image(s) is/are returned in the native horizontal-major
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
function testdata(::Type{T}, indices = nothing; dir = nothing) where T
    # read the single image+label corresponding to "index"
    images, labels = Reader.readdata(datafile(DEPNAME, TESTSET_FILENAME, dir), indices)
    # optionally transform the image array before returning
    bytes_to_type(T, images), labels
end

testdata(indices = nothing; dir = nothing) =
    testdata(N0f8, indices, dir=dir)
