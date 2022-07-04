function __init__omniglot()
    DEPNAME = "Omniglot"
    TRAIN   = "data_background.mat"
    TEST    = "data_evaluation.mat"
    SMALL1  = "data_background_small1.mat"
    SMALL2  = "data_background_small2.mat"

    register(DataDep(
            DEPNAME,
            """
            Dataset: Omniglot data set for one-shot learning
            Authors: Brenden M. Lake, Ruslan Salakhutdinov, Joshua B. Tenenbaum
            Website: https://github.com/brendenlake/omniglot

            [Lake et al., 2015]
                Lake, B. M., Salakhutdinov, R., and Tenenbaum, J. B. (2015).
                Human-level concept learning through probabilistic program induction.
                Science, 350(6266), 1332-1338.

            The files are available for download at the official
            github repository linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility. The authors of Omniglot aren't really
            explicit about any terms of use, so please read the
            website to make sure you want to download the dataset.
            """,
            "https://github.com/brendenlake/omniglot/raw/master/matlab/" .* [TRAIN, TEST, SMALL1, SMALL2],
            "1cfb52d931d794a3dd2717da6c80ddb8f48b0a6f559916c60fcdcd908b65d3d8", #matlab links
        ))
end


"""
    Omniglot(; Tx=Float32, split=:train, dir=nothing)
    Omniglot([Tx, split])

Omniglot data set for one-shot learning

- Authors: Brenden M. Lake, Ruslan Salakhutdinov, Joshua B. Tenenbaum
- Website: https://github.com/brendenlake/omniglot

The Omniglot data set is designed for developing more human-like learning
algorithms. It contains 1623 different handwritten characters from 50 different
alphabets. Each of the 1623 characters was drawn online via Amazon's
Mechanical Turk by 20 different people. Each image is paired with stroke data, a
sequences of [x,y,t] coordinates with time (t) in milliseconds.

# Arguments

$ARGUMENTS_SUPERVISED_ARRAY
- `split`: selects the data partition. Can take the values `:train`, `:test`, `:small1`, or `:small2`. 

# Fields

$FIELDS_SUPERVISED_ARRAY
- `split`.

# Methods

$METHODS_SUPERVISED_ARRAY
- [`convert2image`](@ref) converts features to `Gray` images.

# Examples

The images are loaded as a multi-dimensional array of eltype `Tx`.
All values will be `0` or `1`. `Omniglot().features` is a 3D array
(i.e. a `Array{Tx,3}`), in WHN format (width, height, num_images).
Labels are stored as a vector of strings in `Omniglot().targets`. 

```julia-repl
julia> using MLDatasets: Omniglot

julia> dataset = Omniglot(:train)
Omniglot:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :train
  features    =>    105×105×19280 Array{Float32, 3}
  targets     =>    19280-element Vector{Int64}

julia> dataset[1:5].targets
5-element Vector{String}:
 "Arcadian"
 "Arcadian"
 "Arcadian"
 "Arcadian"
 "Arcadian"

julia> X, y = dataset[:];

julia> dataset = Omniglot(UInt8, :test)
Omniglot:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :test
  features    =>    105×105×13180 Array{UInt8, 3}
  targets     =>    13180-element Vector{Int64}
```
"""
struct Omniglot <: SupervisedDataset
    metadata::Dict{String, Any}
    split::Symbol
    features::Array{<:Any,3}
    targets::Vector{String}
end

Omniglot(; split=:train, Tx=Float32, dir=nothing) = Omniglot(Tx, split; dir)
Omniglot(split::Symbol; kws...) = Omniglot(; split, kws...)
Omniglot(Tx::Type; kws...) = Omniglot(; Tx, kws...)

function Omniglot(Tx::Type, split::Symbol; dir=nothing)
    @assert split ∈ [:train, :test, :small1, :small2]
    if split === :train 
        IMAGESPATH = "data_background.mat"
    elseif split === :test
        IMAGESPATH = "data_evaluation.mat"
    elseif split === :small1
        IMAGESPATH = "data_background_small1.mat"
    elseif split === :small2
        IMAGESPATH = "data_background_small2.mat"
    end

    filename = datafile("Omniglot", IMAGESPATH, dir)

    file = MAT.matopen(filename)
    images = MAT.read(file, "images")
    names  = MAT.read(file, "names")
    MAT.close(file)

    image_count = 0
    for alphabet in images
        for character in alphabet
            image_count += length(character)
        end
    end

    features = Array{Tx}(undef, 105, 105, image_count)
    targets  = Vector{String}(undef, image_count)    

    curr_idx = 1
    for i in range(1, length(images))
        alphabet = images[i]
        for character in alphabet
            for variation in character
                targets[curr_idx] = names[i]
                features[:,:,curr_idx] = variation
                curr_idx += 1
            end
        end
    end
    
    metadata = Dict{String,Any}()
    metadata["n_observations"] = size(features)[end]
    metadata["features_path"] = IMAGESPATH
    metadata["targets_path"] = IMAGESPATH

    return Omniglot(metadata, split, features, targets)
end



convert2image(::Type{<:Omniglot}, x::AbstractArray{<:Integer}) =
    convert2image(Omniglot, reinterpret(N0f8, convert(Array{UInt8}, x)))

function convert2image(::Type{<:Omniglot}, x::AbstractArray{T,N}) where {T,N}
    @assert N == 2 || N == 3
    x = permutedims(x, (2, 1, 3:N...))
    ImageCore = ImageShow.ImageCore
    return ImageCore.colorview(ImageCore.Gray, x)
end
