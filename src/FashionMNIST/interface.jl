"""
    classnames() -> Vector{String}

Return the 10 names for the Fashion-MNIST classes as a vector of
strings.
"""
classnames() = CLASSES

"""
    traintensor([T = N0f8], [indices]; [dir]) -> Array{T}

Same as [`MNIST.traintensor`](@ref) but for the `FashionMNIST` dataset.


$(download_docstring("FashionMNIST", DEPNAME))
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

Same as [`MNIST.testtensor`](@ref) but for the `FashionMNIST` dataset.
```

$(download_docstring("FashionMNIST", DEPNAME))
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
the labels denote the zero-based class-index that they represent
(see [`FashionMNIST.classnames`](@ref) for the corresponding
names). If `indices` is omitted, all labels are returned.

```julia-repl
julia> FashionMNIST.trainlabels() # full training set
60000-element Array{Int64,1}:
 9
 0
 ⋮
 0
 5

julia> FashionMNIST.trainlabels(1:3) # first three labels
3-element Array{Int64,1}:
 9
 0
 0

julia> y = FashionMNIST.trainlabels(1) # first label
9

julia> FashionMNIST.classnames()[y + 1] # corresponding name
"Ankle boot"
```

$(download_docstring("FashionMNIST", DEPNAME))
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
labels denote the class-index that they represent (see
[`FashionMNIST.classnames`](@ref) for the corresponding names).
If `indices` is omitted, all labels are returned.

```julia-repl
julia> FashionMNIST.testlabels() # full test set
10000-element Array{Int64,1}:
 9
 2
 ⋮
 1
 5

julia> FashionMNIST.testlabels(1:3) # first three labels
3-element Array{Int64,1}:
 9
 2
 1

julia> y = FashionMNIST.testlabels(1) # first label
9

julia> FashionMNIST.classnames()[y + 1] # corresponding name
"Ankle boot"
```

$(download_docstring("FashionMNIST", DEPNAME))
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
    traindata([T = N0f8], [indices]; [dir]) -> images, labels

Same as [`MNIST.traindata`](@ref) but for the `FashionMNIST` dataset.


$(download_docstring("FashionMNIST", DEPNAME))

Take a look at [`FashionMNIST.traintensor`](@ref) and
[`FashionMNIST.trainlabels`](@ref) for more information.
"""
function traindata(::Type{T}, args...; dir = nothing) where T
    (traintensor(T, args...; dir = dir),
     trainlabels(args...; dir = dir))
end

traindata(args...; dir = nothing) = traindata(N0f8, args...; dir = dir)

"""
    testdata([T = N0f8], [indices]; [dir]) -> images, labels

Same as [`MNIST.testdata`](@ref) but for the `FashionMNIST` dataset.

$(download_docstring("FashionMNIST", DEPNAME))

Take a look at [`FashionMNIST.testtensor`](@ref) and
[`FashionMNIST.testlabels`](@ref) for more information.
"""
function testdata(::Type{T}, args...; dir = nothing) where T
    (testtensor(T, args...; dir = dir),
     testlabels(args...; dir = dir))
end

testdata(args...; dir = nothing) = testdata(N0f8, args...; dir = dir)
