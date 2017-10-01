"""
    traintensor([indices]; [dir], [decimal=true]) -> Array{Float64}

Returns the FashionMNIST **training** images corresponding to the given
`indices` as a multi-dimensional array.

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/fashion_mnist`. In the case the
source files have not been downloaded yet, you can use
`FashionMNIST.download_helper(dir)` to assist in the process.

```julia
julia> FashionMNIST.traintensor(dir="/home/user/fashion_mnist")
WARNING: The FashionMNIST file "train-images-idx3-ubyte.gz" was not found in "/home/user/FashionMNIST". You can download [...]
```

The image(s) is/are returned in the native horizontal-major
memory layout as a single floating point array. If `decimal=true`
all values are scaled to be between `0.0` and `1.0`, otherwise
the values will be between `0.0` and `255.0`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 3D array (i.e. a `Array{Float64,3}`), in
which the first dimension corresponds to the pixel *rows* (x) of
the image, the second dimension to the pixel *columns* (y) of the
image, and the third dimension denotes the index of the image.

```julia
julia> FashionMNIST.traintensor() # load all training images
28×28×60000 Array{Float64,3}:
[...]

julia> FashionMNIST.traintensor(1:3) # load first three training images
28×28×3 Array{Float64,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{Float64}` in horizontal-major layout, which means that
the first dimension denotes the pixel *rows* (x), and the second
dimension denotes the pixel *columns* (y) of the image.

```julia
julia> FashionMNIST.traintensor(1) # load first training image
28×28 Array{Float64,2}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an FashionMNIST array into a
vertical-major Julia image with the corrected color values.

```
julia> FashionMNIST.convert2image(FashionMNIST.traintensor(1)) # convert to column-major colorant array
28×28 Array{Gray{Float64},2}:
[...]
```
"""
function traintensor(args...; dir=DEFAULT_DIR, decimal=true)
    rawimages = Reader.readimages(downloaded_file(SETTINGS, dir, TRAINIMAGES), args...)
    decimal ? rawimages ./ 255 : convert(Array{Float64}, rawimages)
end

"""
    testtensor([indices]; [dir], [decimal=true]) -> Array{Float64}

Returns the FashionMNIST **test** images corresponding to the given
`indices` as a multi-dimensional array.

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/fashion_mnist`. In the case the
source files have not been downloaded yet, you can use
`FashionMNIST.download_helper(dir)` to assist in the process.

```julia
julia> FashionMNIST.testtensor(dir="/home/user/FashionMNIST")
WARNING: The FashionMNIST file "t10k-images-idx3-ubyte.gz" was not found in "/home/user/FashionMNIST". You can download [...]
```

The image(s) is/are returned in the native horizontal-major
memory layout as a single floating point array. If `decimal=true`
all values are scaled to be between `0.0` and `1.0`, otherwise
the values will be between `0.0` and `255.0`.

If the parameter `indices` is omitted or an `AbstractVector`, the
images are returned as a 3D array (i.e. a `Array{Float64,3}`), in
which the first dimension corresponds to the pixel *rows* (x) of
the image, the second dimension to the pixel *columns* (y) of the
image, and the third dimension denotes the index of the image.

```julia
julia> FashionMNIST.testtensor() # load all test images
28×28×10000 Array{Float64,3}:
[...]

julia> FashionMNIST.testtensor(1:3) # load first three test images
28×28×3 Array{Float64,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{Float64}` in horizontal-major layout, which means that
the first dimension denotes the pixel *rows* (x), and the second
dimension denotes the pixel *columns* (y) of the image.

```julia
julia> FashionMNIST.testtensor(1) # load first test image
28×28 Array{Float64,2}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an FashionMNIST array into a
vertical-major Julia image with the corrected color values.

```
julia> FashionMNIST.convert2image(FashionMNIST.testtensor(1)) # convert to column-major colorant array
28×28 Array{Gray{Float64},2}:
[...]
```
"""
function testtensor(args...; dir=DEFAULT_DIR, decimal=true)
    rawimages = Reader.readimages(downloaded_file(SETTINGS, dir, TESTIMAGES), args...)
    decimal ? rawimages ./ 255 : convert(Array{Float64}, rawimages)
end

"""
    trainlabels([indices]; [dir])

Returns the FashionMNIST **trainset** labels corresponding to the given
`indices` as an `Int` or `Vector{Int}`. The values of the labels
denote the digit that they represent. If `indices` is omitted,
all labels are returned.

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

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/fashion_mnist`. In the case the
source files have not been downloaded yet, you can use
`FashionMNIST.download_helper(dir)` to assist in the process.

```julia
julia> FashionMNIST.trainlabels(dir="/home/user/fashion_mnist")
WARNING: The FashionMNIST file "train-labels-idx1-ubyte.gz" was not found in "/home/user/fashion_mnist". You can download [...]
```
"""
function trainlabels(args...; dir=DEFAULT_DIR)
    path = downloaded_file(SETTINGS, dir, TRAINLABELS)
    Vector{Int}(Reader.readlabels(path, args...))
end

function trainlabels(index::Integer; dir=DEFAULT_DIR)
    path = downloaded_file(SETTINGS, dir, TRAINLABELS)
    Int(Reader.readlabels(path, index))
end

"""
    testlabels([indices]; [dir])

Returns the FashionMNIST **testset** labels corresponding to the given
`indices` as an `Int` or `Vector{Int}`. The values of the labels
denote the digit that they represent. If `indices` is omitted,
all labels are returned.

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

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/fashion_mnist`. In the case the
source files have not been downloaded yet, you can use
`FashionMNIST.download_helper(dir)` to assist in the process.

```julia
julia> FashionMNIST.testlabels(dir="/home/user/fashion_mnist")
WARNING: The FashionMNIST file "t10k-labels-idx1-ubyte.gz" was not found in "/home/user/fashion_mnist". You can download [...]
```
"""
function testlabels(args...; dir=DEFAULT_DIR)
    path = downloaded_file(SETTINGS, dir, TESTLABELS)
    Vector{Int}(Reader.readlabels(path, args...))
end

function testlabels(index::Integer; dir=DEFAULT_DIR)
    path = downloaded_file(SETTINGS, dir, TESTLABELS)
    Int(Reader.readlabels(path, index))
end

"""
    traindata([indices]; [dir], [decimal=true]) -> Tuple

Returns the FashionMNIST **trainingset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full trainingset is returned. The first element of thre return
value will be the images as a multi-dimensional array, and the
second element the corresponding labels as integers.

The images are returned in the native horizontal-major memory
layout as a single floating point array. If `decimal=true` all
values are scaled to be between `0.0` and `1.0`, otherwise the
values will be between `0.0` and `255.0`. The integer values of
the labels correspond 1-to-1 the digit that they represent.

```julia
train_x, train_y = FashionMNIST.traindata() # full datatset
train_x, train_y = FashionMNIST.traindata(2) # only second observation
train_x, train_y = FashionMNIST.traindata(dir="./FashionMNIST") # custom folder
```

The corresponding source files of the dataset are expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/fashion_mnist`. In the case the
source files have not been downloaded yet, you can use
`FashionMNIST.download_helper(dir)` to assist in the process.

Take a look at [`traintensor`](@ref) and [`trainlabels`](@ref)
for more information.
"""
function traindata(args...; dir=DEFAULT_DIR, decimal=true)
    (traintensor(args...; dir=dir, decimal=decimal),
     trainlabels(args...; dir=dir))
end

"""
    testdata([indices]; [dir], [decimal=true]) -> Tuple

Returns the FashionMNIST **testset** corresponding to the given
`indices` as a two-element tuple. If `indices` is omitted the
full testset is returned. The first element of thre return value
will be the images as a multi-dimensional array, and the second
element the corresponding labels as integers.

The images are returned in the native horizontal-major memory
layout as a single floating point array. If `decimal=true` all
values are scaled to be between `0.0` and `1.0`, otherwise the
values will be between `0.0` and `255.0`. The integer values of
the labels correspond 1-to-1 the digit that they represent.

```julia
test_x, test_y = FashionMNIST.testdata() # full datatset
test_x, test_y = FashionMNIST.testdata(2) # only second observation
test_x, test_y = FashionMNIST.testdata(dir="./FashionMNIST") # custom folder
```

The corresponding source files of the dataset are expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/fashion_mnist`. In the case the
source files have not been downloaded yet, you can use
`FashionMNIST.download_helper(dir)` to assist in the process.

Take a look at [`testtensor`](@ref) and [`testlabels`](@ref)
for more information.
"""
function testdata(args...; dir=DEFAULT_DIR, decimal=true)
    (testtensor(args...; dir=dir, decimal=decimal),
     testlabels(args...; dir=dir))
end
