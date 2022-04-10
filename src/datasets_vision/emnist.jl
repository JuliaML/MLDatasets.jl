
function __init__emnist()
    DEPNAME = "EMNIST"

    register(DataDep(
        DEPNAME,
        """
        Dataset: The EMNIST Dataset
        Authors: Gregory Cohen, Saeed Afshar, Jonathan Tapson, and Andre van Schaik
        Website: https://www.nist.gov/itl/products-and-services/emnist-dataset

        [Cohen et al., 2017]
            Cohen, G., Afshar, S., Tapson, J., & van Schaik, A. (2017).
            EMNIST: an extension of MNIST to handwritten letters.
            Retrieved from http://arxiv.org/abs/1702.05373

        The EMNIST dataset is a set of handwritten character digits derived from the
        NIST Special Database 19 (https://www.nist.gov/srd/nist-special-database-19)
        and converted to a 28x28 pixel image format and dataset structure that directly
        matches the MNIST dataset (http://yann.lecun.com/exdb/mnist/). Further information
        on the dataset contents and conversion process can be found in the paper available
        at https://arxiv.org/abs/1702.05373v1.

        The files are available for download at the official
        website linked above. Note that using the data
        responsibly and respecting copyright remains your
        responsibility. For example the website mentions that
        the data is for non-commercial use only. Please read
        the website to make sure you want to download the
        dataset.
        """,
        "http://www.itl.nist.gov/iaui/vip/cs_links/EMNIST/matlab.zip",
        "e1fa805cdeae699a52da0b77c2db17f6feb77eed125f9b45c022e7990444df95",
        post_fetch_method = file -> (run(BinDeps.unpack_cmd(file, dirname(file), ".zip", "")); rm(file))
    ))
end


"""
    EMNIST(name; Tx=Float32, split=:train, dir=nothing)
    EMNIST(name, [Tx, split])

The EMNIST dataset is a set of handwritten character digits derived from the
NIST Special Database 19 (https://www.nist.gov/srd/nist-special-database-19)
and converted to a 28x28 pixel image format and dataset structure that directly
matches the MNIST dataset (http://yann.lecun.com/exdb/mnist/). Further information
on the dataset contents and conversion process can be found in the paper available
at https://arxiv.org/abs/1702.05373v1.

# Arguments

- `name`: name of the EMNIST dataset. Possible values are: `:balanced, :byclass, :bymerge, :digits, :letters, :mnist`.
- `split`: selects the data partition. Can take the values `:train:` or `:test`. 
$ARGUMENTS_SUPERVISED_ARRAY

# Fields

- `name`.
- `split`.
$FIELDS_SUPERVISED_ARRAY

# Methods

$METHODS_SUPERVISED_ARRAY
- [`convert2image`](@ref) converts features to `Gray` images.

# Examples

The images are loaded as a multi-dimensional array of eltype `Tx`.
If `Tx <: Integer`, then all values will be within `0` and `255`, 
otherwise the values are scaled to be between `0` and `1`.
`EMNIST().features` is a 3D array (i.e. a `Array{Tx,3}`), in
WHN format (width, height, num_images). Labels are stored as
a vector of integers in `EMNIST().targets`. 

```julia-repl
julia> using MLDatasets: EMNIST

julia> dataset = EMNIST(:letters, split=:train)
EMNIST:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :train
  features    =>    28×28×60000 Array{Float32, 3}
  targets     =>    60000-element Vector{Int64}

julia> dataset[1:5].targets
5-element Vector{Int64}:
7
2
1
0
4

julia> X, y = dataset[];

julia> dataset = EMNIST(:balanced, Tx=UInt8, split=:test)
EMNIST:
  metadata    =>    Dict{String, Any} with 3 entries
  split       =>    :test
  features    =>    28×28×10000 Array{UInt8, 3}
  targets     =>    10000-element Vector{Int64}
```
"""
struct EMNIST <: SupervisedDataset
    metadata::Dict{String, Any}
    name::Symbol
    split::Symbol
    features::Array{<:Any,3}
    targets::Vector{Int}
end

EMNIST(name; split=:train, Tx=Float32, dir=nothing) = EMNIST(name, Tx, split; dir)

function EMNIST(name, Tx::Type, split::Symbol=:train; dir=nothing)
    @assert split ∈ [:train, :test]
    @assert name ∈ [:balanced, :byclass, :bymerge, :digits, :letters, :mnist]
    path = "matlab/emnist-$name.mat"
    
    path = datafile("EMNIST", path, dir)
    vars = matread(path)
    features = reshape(vars["dataset"]["$split"]["images"], :, 28, 28)
    features = permutedims(features, (3, 2, 1))
    targets = Int.(vars["dataset"]["$split"]["labels"] |> vec)
    features = bytes_to_type(Tx, features)
    
    metadata = Dict{String,Any}()
    metadata["n_observations"] = size(features)[end]
    
    return EMNIST(metadata, name, split, features, targets)
end

convert2image(::Type{<:EMNIST}, x::AbstractArray) = convert2image(MNIST, x)
