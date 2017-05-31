"""
    traintensor([indices]; [dir], [decimal=true]) -> Array{Float64}

Returns the MNIST **training** images corresponding to the given
`indices` as a multi-dimensional array.

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/mnist`. In the case the
source files have not been downloaded yet, you can use
`MNIST.download_helper(dir)` to assist in the process.

```julia
julia> MNIST.traintensor(dir="/home/user/MNIST")
WARNING: The MNIST file "train-images-idx3-ubyte.gz" was not found in "/home/user/MNIST". You can download [...]
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
julia> MNIST.traintensor() # load all training images
28×28×60000 Array{Float64,3}:
[...]

julia> MNIST.traintensor(1:3) # load first three training images
28×28×3 Array{Float64,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{Float64}` in horizontal-major layout, which means that
the first dimension denotes the pixel *rows* (x), and the second
dimension denotes the pixel *columns* (y) of the image.

```julia
julia> MNIST.traintensor(1) # load first training image
28×28 Array{Float64,2}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an MNIST array into a
vertical-major Julia image with the corrected color values.

```
julia> MNIST.convert2image(MNIST.traintensor(1)) # convert to column-major colorant array
28×28 Array{Gray{Float64},2}:
[...]
```
"""
function traintensor(args...; dir=DEFAULT_DIR, decimal=true)
    if decimal
        Reader.readtrainimages(dir, args...) ./ 255
    else
        convert(Array{Float64}, Reader.readtrainimages(dir, args...))
    end
end

"""
    testtensor([indices]; [dir], [decimal=true]) -> Array{Float64}

Returns the MNIST **test** images corresponding to the given
`indices` as a multi-dimensional array.

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/mnist`. In the case the
source files have not been downloaded yet, you can use
`MNIST.download_helper(dir)` to assist in the process.

```julia
julia> MNIST.testtensor(dir="/home/user/MNIST")
WARNING: The MNIST file "t10k-images-idx3-ubyte.gz" was not found in "/home/user/MNIST". You can download [...]
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
julia> MNIST.testtensor() # load all test images
28×28×10000 Array{Float64,3}:
[...]

julia> MNIST.testtensor(1:3) # load first three test images
28×28×3 Array{Float64,3}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Matrix{Float64}` in horizontal-major layout, which means that
the first dimension denotes the pixel *rows* (x), and the second
dimension denotes the pixel *columns* (y) of the image.

```julia
julia> MNIST.testtensor(1) # load first test image
28×28 Array{Float64,2}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an MNIST array into a
vertical-major Julia image with the corrected color values.

```
julia> MNIST.convert2image(MNIST.testtensor(1)) # convert to column-major colorant array
28×28 Array{Gray{Float64},2}:
[...]
```
"""
function testtensor(args...; dir=DEFAULT_DIR, decimal=true)
    if decimal
        Reader.readtestimages(dir, args...) ./ 255
    else
        convert(Array{Float64}, Reader.readtestimages(dir, args...))
    end
end

"""
    trainlabels([indices]; [dir])

Returns the MNIST **trainset** labels corresponding to the given
`indices` as an `Int` or `Vector{Int}`. The values of the labels
denote the digit that they represent. If `indices` is omitted,
all labels are returned.

```julia
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

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/mnist`. In the case the
source files have not been downloaded yet, you can use
`MNIST.download_helper(dir)` to assist in the process.

```julia
julia> MNIST.trainlabels(dir="/home/user/MNIST")
WARNING: The MNIST file "train-labels-idx1-ubyte.gz" was not found in "/home/user/MNIST". You can download [...]
```
"""
trainlabels(args...; dir=DEFAULT_DIR) = Vector{Int}(Reader.readtrainlabels(dir, args...))
trainlabels(index::Integer; dir=DEFAULT_DIR) = Int(Reader.readtrainlabels(dir, index))

"""
    testlabels([indices]; [dir])

Returns the MNIST **testset** labels corresponding to the given
`indices` as an `Int` or `Vector{Int}`. The values of the labels
denote the digit that they represent. If `indices` is omitted,
all labels are returned.

```julia
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

The corresponding source file of the dataset is expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/mnist`. In the case the
source files have not been downloaded yet, you can use
`MNIST.download_helper(dir)` to assist in the process.

```julia
julia> MNIST.testlabels(dir="/home/user/MNIST")
WARNING: The MNIST file "t10k-labels-idx1-ubyte.gz" was not found in "/home/user/MNIST". You can download [...]
```
"""
testlabels(args...; dir=DEFAULT_DIR) = Vector{Int}(Reader.readtestlabels(dir, args...))
testlabels(index::Integer; dir=DEFAULT_DIR) = Int(Reader.readtestlabels(dir, index))

"""
    traindata([indices]; [dir], [decimal=true]) -> Tuple

Returns the MNIST **trainingset** corresponding to the given
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
train_x, train_y = MNIST.traindata() # full datatset
train_x, train_y = MNIST.traindata(2) # only second observation
train_x, train_y = MNIST.traindata(dir="./MNIST") # custom folder
```

The corresponding source files of the dataset are expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/mnist`. In the case the
source files have not been downloaded yet, you can use
`MNIST.download_helper(dir)` to assist in the process.

Take a look at [`traintensor`](@ref) and [`trainlabels`](@ref)
for more information.
"""
function traindata(args...; dir=DEFAULT_DIR, decimal=true)
    (traintensor(args...; dir=dir, decimal=decimal),
     trainlabels(args...; dir=dir))
end

"""
    testdata([indices]; [dir], [decimal=true]) -> Tuple

Returns the MNIST **testset** corresponding to the given
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
test_x, test_y = MNIST.testdata() # full datatset
test_x, test_y = MNIST.testdata(2) # only second observation
test_x, test_y = MNIST.testdata(dir="./MNIST") # custom folder
```

The corresponding source files of the dataset are expected to be
located in the specified directory `dir`. If `dir` is omitted it
will default to `MLDatasets/datasets/mnist`. In the case the
source files have not been downloaded yet, you can use
`MNIST.download_helper(dir)` to assist in the process.

Take a look at [`testtensor`](@ref) and [`testlabels`](@ref)
for more information.
"""
function testdata(args...; dir=DEFAULT_DIR, decimal=true)
    (testtensor(args...; dir=dir, decimal=decimal),
     testlabels(args...; dir=dir))
end
