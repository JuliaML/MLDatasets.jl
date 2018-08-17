"""
    classnames_coarse(; [dir]) -> Vector{String}

Return the 20 names for the CIFAR100 superclasses as a vector of
strings. Note that these strings are read from the actual
resource file.

$(download_docstring("CIFAR100", DEPNAME))
"""
function classnames_coarse(; dir = nothing)
    file_path = datafile(DEPNAME, COARSE_FILENAME, dir)
    readlines(file_path)
end

"""
    classnames_fine(; [dir]) -> Vector{String}

Return the 100 names for the CIFAR100 classes as a vector of
strings. Note that these strings are read from the actual
resource file.

$(download_docstring("CIFAR100", DEPNAME))
"""
function classnames_fine(; dir = nothing)
    file_path = datafile(DEPNAME, FINE_FILENAME, dir)
    readlines(file_path)
end

"""
    traintensor([T = N0f8], [indices]; [dir]) -> Array{T}

Return the CIFAR-100 **training** images corresponding to the
given `indices` as a multi-dimensional array of eltype `T`. If
the corresponding labels are required as well, it is recommended
to use [`CIFAR100.traindata`](@ref) instead.

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
julia> CIFAR100.traintensor() # load all training images
32×32×3×50000 Array{N0f8,4}:
[...]

julia> CIFAR100.traintensor(Float32, 1:3) # first three images as Float32
32×32×3×3 Array{Float32,4}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Array{T,3}` in horizontal-major layout, which means that the
first dimension denotes the pixel *rows* (x), the second
dimension denotes the pixel *columns* (y), and the third
dimension the RGB color channels of the image.

```julia-repl
julia> CIFAR100.traintensor(1) # load first training image
32×32×3 Array{N0f8,3}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an CIFAR-100 array into a
vertical-major Julia image with the appropriate `RGB` eltype.

```julia-repl
julia> CIFAR100.convert2image(CIFAR100.traintensor(1)) # convert to column-major colorant array
32×32 Array{RGB{N0f8},2}:
[...]
```

$(download_docstring("CIFAR100", DEPNAME))
"""
traintensor(args...; dir = nothing) = traindata(args...; dir = dir)[1]

"""
    testtensor([T = N0f8], [indices]; [dir]) -> Array{T}

Return the CIFAR-100 **test** images corresponding to the given
`indices` as a multi-dimensional array of eltype `T`. If the
corresponding labels are required as well, it is recommended to
use [`CIFAR100.testdata`](@ref) instead.

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
julia> CIFAR100.testtensor() # load all training images
32×32×3×10000 Array{N0f8,4}:
[...]

julia> CIFAR100.testtensor(Float32, 1:3) # first three images as Float32
32×32×3×3 Array{Float32,4}:
[...]
```

If `indices` is an `Integer`, the single image is returned as
`Array{T,3}` in horizontal-major layout, which means that the
first dimension denotes the pixel *rows* (x), the second
dimension denotes the pixel *columns* (y), and the third
dimension the RGB color channels of the image.

```julia-repl
julia> CIFAR100.testtensor(1) # load first training image
32×32×3 Array{N0f8,3}:
[...]
```

As mentioned above, the images are returned in the native
horizontal-major layout to preserve the original feature
ordering. You can use the utility function
[`convert2image`](@ref) to convert an CIFAR-100 array into a
vertical-major Julia image with the appropriate `RGB` eltype.

```julia-repl
julia> CIFAR100.convert2image(CIFAR100.testtensor(1)) # convert to column-major colorant array
32×32 Array{RGB{N0f8},2}:
[...]
```

$(download_docstring("CIFAR100", DEPNAME))
"""
testtensor(args...; dir = nothing) = testdata(args...; dir = dir)[1]

"""
    trainlabels([indices]; [dir]) -> Yc, Yf

Return the CIFAR-100 **trainset** labels (coarse and fine)
corresponding to the given `indices` as a tuple of two `Int` or
two `Vector{Int}`. The variables returned are the coarse label(s)
(`Yc`) and the fine label(s) (`Yf`) respectively.

```julia
Yc, Yf = CIFAR100.trainlabels(); # full training set
```

The values of the labels denote the zero-based class-index that
they represent (see [`CIFAR100.classnames_coarse`](@ref) and
[`CIFAR100.classnames_fine`](@ref) for the corresponding names).
If `indices` is omitted, all labels are returned.

```julia-repl
julia> Yc, Yf = CIFAR100.trainlabels(1:3) # first three labels
([11, 15, 4], [19, 29, 0])

julia> yc, yf = CIFAR100.trainlabels(1) # first label
(11, 19)

julia> CIFAR100.classnames_coarse()[yc + 1] # corresponding superclass name
"large_omnivores_and_herbivores"

julia> CIFAR100.classnames_fine()[yf + 1] # corresponding class name
"cattle"
```

$(download_docstring("CIFAR100", DEPNAME))
"""
function trainlabels(args...; dir = nothing)
    _, Yc, Yf = traindata(args...; dir = dir)
    Yc, Yf
end

"""
    testlabels([indices]; [dir]) -> Yc, Yf

Return the CIFAR-100 **testset** labels (coarse and fine)
corresponding to the given `indices` as a tuple of two `Int` or
two `Vector{Int}`. The variables returned are the coarse label(s)
(`Yc`) and the fine label(s) (`Yf`) respectively.

```julia
Yc, Yf = CIFAR100.testlabels(); # full training set
```

The values of the labels denote the zero-based class-index that
they represent (see [`CIFAR100.classnames_coarse`](@ref) and
[`CIFAR100.classnames_fine`](@ref) for the corresponding names).
If `indices` is omitted, all labels are returned.

```julia-repl
julia> Yc, Yf = CIFAR100.testlabels(1:3) # first three labels
([10, 10, 0], [49, 33, 72])

julia> yc, yf = CIFAR100.testlabels(1) # first label
(10, 49)

julia> CIFAR100.classnames_coarse()[yc + 1] # corresponding superclass name
"large_natural_outdoor_scenes"

julia> CIFAR100.classnames_fine()[yf + 1] # corresponding class name
"mountain"
```

$(download_docstring("CIFAR100", DEPNAME))
"""
function testlabels(args...; dir = nothing)
    _, Yc, Yf = testdata(args...; dir = dir)
    Yc, Yf
end

"""
    traindata([T = N0f8], [indices]; [dir]) -> X, Yc, Yf

Returns the CIFAR-100 **trainset** corresponding to the given
`indices` as a three-element tuple. If `indices` is omitted the
full trainingset is returned. The first element of the three
return values (`X`) will be the images as a multi-dimensional
array, the second element (`Yc`) the corresponding coarse labels
as integers, and the third element (`Yf`) the fine labels
respectively.

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
X, Yc, Yf = CIFAR100.traindata() # full datatset
X, Yc, Yf = CIFAR100.traindata(dir="./CIFAR100") # custom folder
x, yc, yf = CIFAR100.traindata(2) # only second observation
```

$(download_docstring("CIFAR100", DEPNAME))

Take a look at [`CIFAR100.traintensor`](@ref) and
[`CIFAR100.trainlabels`](@ref) for more information.
"""
function traindata(::Type{T}, indices = nothing; dir = nothing) where T
    # read the single image+label corresponding to "index"
    images, labels_c, labels_f =
        Reader.readdata(datafile(DEPNAME, TRAINSET_FILENAME, dir), TRAINSET_SIZE, indices)
    # optionally transform the image array before returning
    bytes_to_type(T, images), labels_c, labels_f
end

traindata(indices::Union{Integer, AbstractVector, Nothing} = nothing; dir = nothing) =
    traindata(N0f8, indices, dir=dir)

"""
    testdata([T = N0f8], [indices]; [dir]) -> X, Yc, Yf

Returns the CIFAR-100 **testset** corresponding to the given
`indices` as a three-element tuple. If `indices` is omitted the
full testset is returned. The first element of the three return
values (`X`) will be the images as a multi-dimensional array, the
second element (`Yc`) the corresponding coarse labels as
integers, and the third element (`Yf`) the fine labels
respectively.

The image(s) is/are returned in the native horizontal-major
memory layout as a single numeric array of eltype `T`. If `T <:
Integer`, then all values will be within `0` and `255`, otherwise
the values are scaled to be between `0` and `1`. The integer
values of the labels correspond 1-to-1 the digit that they
represent.

```julia
X, Yc, Yf = CIFAR100.testdata() # full datatset
X, Yc, Yf = CIFAR100.testdata(dir="./CIFAR100") # custom folder
x, yc, yf = CIFAR100.testdata(2) # only second observation
```

$(download_docstring("CIFAR100", DEPNAME))

Take a look at [`CIFAR100.testtensor`](@ref) and
[`CIFAR100.testlabels`](@ref) for more information.
"""
function testdata(::Type{T}, indices = nothing; dir = nothing) where T
    # read the single image+label corresponding to "index"
    images, labels_c, labels_f =
        Reader.readdata(datafile(DEPNAME, TESTSET_FILENAME, dir), TESTSET_SIZE, indices)
    # optionally transform the image array before returning
    bytes_to_type(T, images), labels_c, labels_f
end

testdata(indices::Union{Integer, AbstractVector, Nothing} = nothing; dir = nothing) =
    testdata(N0f8, indices, dir=dir)
