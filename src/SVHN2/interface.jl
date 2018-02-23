"""
    classnames() -> Vector{Int}

Return the 10 digits for the SVHN classes as a vector of integers.
"""
classnames() = CLASSES

"""
    traindata([T = N0f8], [indices]; [dir]) -> images, labels

Returns the SVHN **trainset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full trainset is returned. The first element of the return values
will be the images as a multi-dimensional array, and the second
element the corresponding labels as integers.

The image(s) is/are returned in the native vertical-major memory
layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. You can use the
utility function [`convert2image`](@ref) to convert an SVHN array
into a Julia image with the appropriate `RGB` eltype. The integer
values of the labels correspond 1-to-1 the digit that they
represent with the exception of 0 which is encoded as `10`.

Note that because of the nature of how the dataset is stored on
disk, `SVHN2.traindata` will always load the full trainset,
regardless of which observations are requested. In the case
`indices` are provided by the user, it will simply result in a
sub-setting. This option is just provided for convenience.

```julia
train_x, train_y = SVHN2.traindata() # full dataset
train_x, train_y = SVHN2.traindata(2) # only second observation
train_x, train_y = SVHN2.traindata(dir="./SVHN") # custom folder
```

$(download_docstring("SVHN", DEPNAME))
"""
function traindata(args...; dir = nothing)
    traindata(N0f8, args...; dir = dir)
end

function traindata(::Type{T}; dir = nothing) where T
    path = datafile(DEPNAME, TRAINDATA, dir)
    vars = matread(path)
    images, labels = vars["X"], vars["y"]
    bytes_to_type(T, images), Vector{Int}(vec(labels))
end

function traindata(::Type{T}, indices; dir = nothing) where T
    images, labels = traindata(T, dir = dir)
    images[:,:,:,indices], labels[indices]
end

"""
    testdata([T = N0f8], [indices]; [dir]) -> images, labels

Returns the SVHN **testset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full testset is returned. The first element of the return
values will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The image(s) is/are returned in the native vertical-major memory
layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. You can use the
utility function [`convert2image`](@ref) to convert an SVHN array
into a Julia image with the appropriate `RGB` eltype. The integer
values of the labels correspond 1-to-1 the digit that they
represent with the exception of 0 which is encoded as `10`.

Note that because of the nature of how the dataset is stored on
disk, `SVHN2.testdata` will always load the full testset,
regardless of which observations are requested. In the case
`indices` are provided by the user, it will simply result in a
sub-setting. This option is just provided for convenience.

```julia
test_x, test_y = SVHN2.testdata() # full dataset
test_x, test_y = SVHN2.testdata(2) # only second observation
test_x, test_y = SVHN2.testdata(dir="./SVHN") # custom folder
```

$(download_docstring("SVHN", DEPNAME))
"""
function testdata(args...; dir = nothing)
    testdata(N0f8, args...; dir = dir)
end

function testdata(::Type{T}; dir = nothing) where T
    path = datafile(DEPNAME, TESTDATA, dir)
    vars = matread(path)
    images, labels = vars["X"], vars["y"]
    bytes_to_type(T, images), Vector{Int}(vec(labels))
end

function testdata(::Type{T}, indices; dir = nothing) where T
    images, labels = testdata(T, dir = dir)
    images[:,:,:,indices], labels[indices]
end

"""
    extradata([T = N0f8], [indices]; [dir]) -> images, labels

Returns the SVHN **extra trainset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full dataset is returned. The first element of the return values
will be the images as a multi-dimensional array, and the second
element the corresponding labels as integers.

The image(s) is/are returned in the native vertical-major memory
layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. You can use the
utility function [`convert2image`](@ref) to convert an SVHN array
into a Julia image with the appropriate `RGB` eltype. The integer
values of the labels correspond 1-to-1 the digit that they
represent with the exception of 0 which is encoded as `10`.

Note that because of the nature of how the dataset is stored on
disk, `SVHN2.extradata` will always load the full extra trainset,
regardless of which observations are requested. In the case
`indices` are provided by the user, it will simply result in a
sub-setting. This option is just provided for convenience.

```julia
extra_x, extra_y = SVHN2.extradata() # full dataset
extra_x, extra_y = SVHN2.extradata(2) # only second observation
extra_x, extra_y = SVHN2.extradata(dir="./SVHN") # custom folder
```

$(download_docstring("SVHN", DEPNAME))
"""
function extradata(args...; dir = nothing)
    extradata(N0f8, args...; dir = dir)
end

function extradata(::Type{T}; dir = nothing) where T
    path = datafile(DEPNAME, EXTRADATA, dir)
    vars = matread(path)
    images, labels = vars["X"], vars["y"]
    bytes_to_type(T, images), Vector{Int}(vec(labels))
end

function extradata(::Type{T}, indices; dir = nothing) where T
    images, labels = extradata(T, dir = dir)
    images[:,:,:,indices], labels[indices]
end
