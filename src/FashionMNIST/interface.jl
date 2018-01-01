"""
    traintensor([T = N0f8], [indices]; [dir]) -> Array{T}

Returns the Fashion-MNIST **training** images corresponding to
the given `indices` as a multi-dimensional array of eltype `T`.

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 3D array (i.e. a `Array{T,3}`), in which
the first dimension corresponds to the pixel *rows* (x) of the
image, the second dimension to the pixel *columns* (y) of the
image, and the third dimension denotes the index of the image.

```julia
julia> FashionMNIST.traintensor() # load all training images
28×28×60000 Array{N0f8,3}:
[...]

julia> FashionMNIST.traintensor(Float32, 1:3) # first three images as Float32
28×28×3 Array{Float32,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{T}` in horizontal-major layout, which means that the
first dimension denotes the pixel *rows* (x), and the second
dimension denotes the pixel *columns* (y) of the image.

```julia
julia> FashionMNIST.traintensor(1) # load first training image
28×28 Array{N0f8,2}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an FashionMNIST array into a
vertical-major Julia image with the corrected color values.

```
julia> FashionMNIST.convert2image(FashionMNIST.traintensor(1)) # convert to column-major colorant array
28×28 Array{Gray{N0f8},2}:
[...]
```

The corresponding resource file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted the
directories in `DataDeps.default_loadpath` will be searched for
an existing `$DEPNAME` subfolder. In case no such subfolder is
found, `dir` will default to `~/datadeps/$DEPNAME`. In the case
that `dir` does not yet exist, a download prompt will be
triggered. You can also use `FashionMNIST.download([dir])`
explicitly for pre-downloading (or re-downloading) the dataset.
Please take a look at the documentation of the package
DataDeps.jl for more detail and configuration options.
"""
function traintensor(::Type{T}, args...; dir = nothing) where T
    path = datafile(DEPNAME, TRAINIMAGES, dir)
    images = Reader.readimages(path, args...)
    bytes_to_type(T, images)
end

function traintensor(args...; dir = nothing)
    traintensor(N0f8, args...; dir = dir)
end

"""
    testtensor([T = N0f8], [indices]; [dir]) -> Array{T}

Returns the Fashion-MNIST **test** images corresponding to the
given `indices` as a multi-dimensional array of eltype `T`.

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 3D array (i.e. a `Array{T,3}`), in which
the first dimension corresponds to the pixel *rows* (x) of the
image, the second dimension to the pixel *columns* (y) of the
image, and the third dimension denotes the index of the image.

```julia
julia> FashionMNIST.testtensor() # load all test images
28×28×10000 Array{N0f8,3}:
[...]

julia> FashionMNIST.testtensor(Float32, 1:3) # first three images as Float32
28×28×3 Array{Float32,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{T}` in horizontal-major layout, which means that the
first dimension denotes the pixel *rows* (x), and the second
dimension denotes the pixel *columns* (y) of the image.

```julia
julia> FashionMNIST.testtensor(1) # load first test image
28×28 Array{N0f8,2}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an FashionMNIST array into a
vertical-major Julia image with the corrected color values.

```
julia> FashionMNIST.convert2image(FashionMNIST.testtensor(1)) # convert to column-major colorant array
28×28 Array{Gray{N0f8},2}:
[...]
```

The corresponding resource file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted the
directories in `DataDeps.default_loadpath` will be searched for
an existing `$DEPNAME` subfolder. In case no such subfolder is
found, `dir` will default to `~/datadeps/$DEPNAME`. In the case
that `dir` does not yet exist, a download prompt will be
triggered. You can also use `FashionMNIST.download([dir])`
explicitly for pre-downloading (or re-downloading) the dataset.
Please take a look at the documentation of the package
DataDeps.jl for more detail and configuration options.
"""
function testtensor(::Type{T}, args...; dir = nothing) where T
    path = datafile(DEPNAME, TESTIMAGES, dir)
    images = Reader.readimages(path, args...)
    bytes_to_type(T, images)
end

function testtensor(args...; dir = nothing)
    testtensor(N0f8, args...; dir = dir)
end

"""
    trainlabels([indices]; [dir])

Returns the Fashion-MNIST **trainset** labels corresponding to
the given `indices` as an `Int` or `Vector{Int}`. The values of
the labels denote the digit that they represent. If `indices` is
omitted, all labels are returned.

```julia
julia> FashionMNIST.trainlabels() # full training set
60000-element Array{Int64,1}:
 5
 0
 ⋮
 6
 8

julia> FashionMNIST.trainlabels(1:3) # first three labels
3-element Array{Int64,1}:
 5
 0
 4

julia> FashionMNIST.trainlabels(1) # first label
5
```

The corresponding resource file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted the
directories in `DataDeps.default_loadpath` will be searched for
an existing `$DEPNAME` subfolder. In case no such subfolder is
found, `dir` will default to `~/datadeps/$DEPNAME`. In the case
that `dir` does not yet exist, a download prompt will be
triggered. You can also use `FashionMNIST.download([dir])`
explicitly for pre-downloading (or re-downloading) the dataset.
Please take a look at the documentation of the package
DataDeps.jl for more detail and configuration options.
"""
function trainlabels(args...; dir = nothing)
    path = datafile(DEPNAME, TRAINLABELS, dir)
    Vector{Int}(Reader.readlabels(path, args...))
end

function trainlabels(index::Integer; dir = nothing)
    path = datafile(DEPNAME, TRAINLABELS, dir)
    Int(Reader.readlabels(path, index))
end

"""
    testlabels([indices]; [dir])

Returns the Fashion-MNIST **testset** labels corresponding to the
given `indices` as an `Int` or `Vector{Int}`. The values of the
labels denote the digit that they represent. If `indices` is
omitted, all labels are returned.

```julia
julia> FashionMNIST.testlabels() # full test set
10000-element Array{Int64,1}:
 7
 2
 ⋮
 5
 6

julia> FashionMNIST.testlabels(1:3) # first three labels
3-element Array{Int64,1}:
 7
 2
 1

julia> FashionMNIST.testlabels(1) # first label
7
```

The corresponding resource file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted the
directories in `DataDeps.default_loadpath` will be searched for
an existing `$DEPNAME` subfolder. In case no such subfolder is
found, `dir` will default to `~/datadeps/$DEPNAME`. In the case
that `dir` does not yet exist, a download prompt will be
triggered. You can also use `FashionMNIST.download([dir])`
explicitly for pre-downloading (or re-downloading) the dataset.
Please take a look at the documentation of the package
DataDeps.jl for more detail and configuration options.
"""
function testlabels(args...; dir = nothing)
    path = datafile(DEPNAME, TESTLABELS, dir)
    Vector{Int}(Reader.readlabels(path, args...))
end

function testlabels(index::Integer; dir = nothing)
    path = datafile(DEPNAME, TESTLABELS, dir)
    Int(Reader.readlabels(path, index))
end

"""
    traindata([T = N0f8], [indices]; [dir]) -> Tuple

Returns the Fashion-MNIST **trainingset** corresponding to the
given `indices` as a two-element tuple. If `indices` is omitted
the full trainingset is returned. The first element of thre
return value will be the images as a multi-dimensional array, and
the second element the corresponding labels as integers.

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
train_x, train_y = FashionMNIST.traindata() # full datatset
train_x, train_y = FashionMNIST.traindata(2) # only second observation
train_x, train_y = FashionMNIST.traindata(dir="./FashionMNIST") # custom folder
```

The corresponding resource files of the dataset are expected to
be located in the specified directory `dir`. If `dir` is omitted
the directories in `DataDeps.default_loadpath` will be searched
for an existing `$DEPNAME` subfolder. In case no such subfolder
is found, `dir` will default to `~/datadeps/$DEPNAME`. In the
case that `dir` does not yet exist, a download prompt will be
triggered. You can also use `FashionMNIST.download([dir])`
explicitly for pre-downloading (or re-downloading) the dataset.
Please take a look at the documentation of the package
DataDeps.jl for more detail and configuration options.

Take a look at [`traintensor`](@ref) and [`trainlabels`](@ref)
for more information.
"""
function traindata(::Type{T}, args...; dir = nothing) where T
    (traintensor(T, args...; dir = dir),
     trainlabels(args...; dir = dir))
end

traindata(args...; dir = nothing) = traindata(N0f8, args...; dir = dir)

"""
    testdata([T = N0f8], [indices]; [dir]) -> Tuple

Returns the Fashion-MNIST **testset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full testset is returned. The first element of thre return value
will be the images as a multi-dimensional array, and the second
element the corresponding labels as integers.

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
test_x, test_y = FashionMNIST.testdata() # full datatset
test_x, test_y = FashionMNIST.testdata(2) # only second observation
test_x, test_y = FashionMNIST.testdata(dir="./FashionMNIST") # custom folder
```

The corresponding resource files of the dataset are expected to
be located in the specified directory `dir`. If `dir` is omitted
the directories in `DataDeps.default_loadpath` will be searched
for an existing `$DEPNAME` subfolder. In case no such subfolder
is found, `dir` will default to `~/datadeps/$DEPNAME`. In the
case that `dir` does not yet exist, a download prompt will be
triggered. You can also use `FashionMNIST.download([dir])`
explicitly for pre-downloading (or re-downloading) the dataset.
Please take a look at the documentation of the package
DataDeps.jl for more detail and configuration options.

Take a look at [`testtensor`](@ref) and [`testlabels`](@ref)
for more information.
"""
function testdata(::Type{T}, args...; dir = nothing) where T
    (testtensor(T, args...; dir = dir),
     testlabels(args...; dir = dir))
end

testdata(args...; dir = nothing) = testdata(N0f8, args...; dir = dir)
