"""
    traintensor([T = N0f8], [indices]; [dir]) -> Array{T}

Returns the MNIST **training** images corresponding to the given
`indices` as a multi-dimensional array of eltype `T`.

The image(s) is/are returned in the horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 3D array (i.e. a `Array{T,3}`), in
WHN format (width, height, #images). 
For integer `indices` instead, a 2D array in WH format is returned.

```julia-repl
julia> MNIST.traintensor() # load all training images
28×28×60000 Array{N0f8,3}:
[...]

julia> MNIST.traintensor(Float32, 1:3) # first three images as Float32
28×28×3 Array{Float32,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{T}`.

```julia-repl
julia> MNIST.traintensor(1) # load first training image
28×28 Array{N0f8,2}:
[...]
```

You can use the utility function
[`convert2image`](@ref) to convert an MNIST array into a
vertical-major Julia image with the corrected color values.

```julia-repl
julia> MNIST.convert2image(MNIST.traintensor(1)) # convert to column-major colorant array
28×28 Array{Gray{N0f8},2}:
[...]
```

$(download_docstring("MNIST", DEPNAME))
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

Returns the MNIST **test** images corresponding to the given
`indices` as a multi-dimensional array of eltype `T`.

The image(s) is/are returned in the horizontal-major
memory layout as a single numeric array. If `T <: Integer`, then
all values will be within `0` and `255`, otherwise the values are
scaled to be between `0` and `1`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 3D array (i.e. a `Array{T,3}`), in
WHN format (width, height, #images). 
For integer `indices` instead, a 2D array in WH format is returned.

```julia-repl
julia> MNIST.testtensor() # load all test images
28×28×10000 Array{N0f8,3}:
[...]

julia> MNIST.testtensor(Float32, 1:3) # first three images as Float32
28×28×3 Array{Float32,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{T}`.

```julia-repl
julia> MNIST.testtensor(1) # load first test image
28×28 Array{N0f8,2}:
[...]
```

You can use the utility function
[`convert2image`](@ref) to convert an MNIST array into a
vertical-major Julia image with the corrected color values.

```julia-repl
julia> MNIST.convert2image(MNIST.testtensor(1)) # convert to column-major colorant array
28×28 Array{Gray{N0f8},2}:
[...]
```

$(download_docstring("MNIST", DEPNAME))
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

Returns the MNIST **trainset** labels corresponding to the given
`indices` as an `Int` or `Vector{Int}`. The values of the labels
denote the digit that they represent. If `indices` is omitted,
all labels are returned.

```julia-repl
julia> MNIST.trainlabels() # full training set
60000-element Array{Int64,1}:
 5
 0
 ⋮
 6
 8

julia> MNIST.trainlabels(1:3) # first three labels
3-element Array{Int64,1}:
 5
 0
 4

julia> MNIST.trainlabels(1) # first label
5
```

$(download_docstring("MNIST", DEPNAME))
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

Returns the MNIST **testset** labels corresponding to the given
`indices` as an `Int` or `Vector{Int}`. The values of the labels
denote the digit that they represent. If `indices` is omitted,
all labels are returned.

```julia-repl
julia> MNIST.testlabels() # full test set
10000-element Array{Int64,1}:
 7
 2
 ⋮
 5
 6

julia> MNIST.testlabels(1:3) # first three labels
3-element Array{Int64,1}:
 7
 2
 1

julia> MNIST.testlabels(1) # first label
7
```

$(download_docstring("MNIST", DEPNAME))
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

Returns the MNIST **trainingset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full trainingset is returned. The first element of three return
values will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The image(s) is/are returned in the horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
train_x, train_y = MNIST.traindata() # full datatset
train_x, train_y = MNIST.traindata(2) # only second observation
train_x, train_y = MNIST.traindata(dir="./MNIST") # custom folder
```

$(download_docstring("MNIST", DEPNAME))

Take a look at [`MNIST.traintensor`](@ref) and
[`MNIST.trainlabels`](@ref) for more information.
"""
function traindata(::Type{T}, args...; dir = nothing) where T
    (traintensor(T, args...; dir = dir),
     trainlabels(args...; dir = dir))
end

traindata(args...; dir = nothing) = traindata(N0f8, args...; dir = dir)

"""
    testdata([T = N0f8], [indices]; [dir]) -> Tuple

Returns the MNIST **testset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full testset is returned. The first element of three return
values will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The image(s) is/are returned in the horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
test_x, test_y = MNIST.testdata() # full datatset
test_x, test_y = MNIST.testdata(2) # only second observation
test_x, test_y = MNIST.testdata(dir="./MNIST") # custom folder
```

$(download_docstring("MNIST", DEPNAME))

Take a look at [`MNIST.testtensor`](@ref) and
[`MNIST.testlabels`](@ref) for more information.
"""
function testdata(::Type{T}, args...; dir = nothing) where T
    (testtensor(T, args...; dir = dir),
     testlabels(args...; dir = dir))
end

testdata(args...; dir = nothing) = testdata(N0f8, args...; dir = dir)
