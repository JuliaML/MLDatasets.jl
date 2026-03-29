function __init__md17()
    for name in ("benzene2017", "uracil", "naphthalene", "aspirin", 
                 "salicylic", "malonaldehyde", "ethanol", "toluene")
        DEPNAME = "MD17_$name"
        URL = "http://quantum-machine.org/gdml/data/npz/md17_$name.npz"
        
        register(DataDep(
            DEPNAME,
            """
            Dataset: MD17 ($name)
            Website: http://quantum-machine.org/gdml/#datasets
            """,
            URL
        ))
    end
end

"""
    MD17(; name="aspirin", dir = nothing)

The MD17 dataset is a collection of ab-initio molecular dynamics (MD) trajectories 
for small organic molecules. It provides Cartesian coordinates (`R`), atomic numbers (`z`), 
total energies (`E`), and atomic forces (`F`).

The `features` are the Cartesian coordinates `R`. 
The `targets` are the energies `E` and forces `F` as a `NamedTuple`. 
The atomic numbers `z` are invariant across the trajectory and are stored in `metadata["z"]`.

# Arguments

- `name`: the name of the molecule. Available options are `"benzene2017"`, `"uracil"`, `"naphthalene"`, `"aspirin"`, `"salicylic"`, `"malonaldehyde"`, `"ethanol"`, and `"toluene"`. Default is `"aspirin"`.
$ARGUMENTS_SUPERVISED_ARRAY

# Fields

- `metadata`: A dictionary containing the dataset name, path, and atomic numbers (`z`).
- `features`: An array of Cartesian coordinates (`R`).
- `targets`: A `NamedTuple` with `E` (energies) and `F` (forces).

# Methods

$METHODS_SUPERVISED_ARRAY

# Examples

```julia-repl
julia> using MLDatasets

julia> d = MD17(name="aspirin")
dataset MD17:
  metadata => Dict{String, Any} with 3 entries
  features => 3×21×211762 Array{Float64, 3}
  targets  => (E = 211762-element Vector{Float64}, F = 3×21×211762 Array{Float64, 3})
```
"""
struct MD17 <: SupervisedDataset
    metadata::Dict{String, Any}
    features::Any
    targets::Any
end

function MD17(; name::AbstractString="aspirin", dir = nothing)
    valid_names = ("benzene2017", "uracil", "naphthalene", "aspirin", 
                 "salicylic", "malonaldehyde", "ethanol", "toluene")
    if name ∉ valid_names
        throw(ArgumentError("Unknown molecule name: \$name. Available names are: \$valid_names"))
    end
    
    DEPNAME = "MD17_\$name"
    data_dir = datadir(DEPNAME, dir)
    filepath = joinpath(data_dir, "md17_\$name.npz")
    
    data = read_npz(filepath)
    
    features = data["R"]
    targets = (E = vec(data["E"]), F = data["F"])
    
    metadata = Dict{String, Any}("name" => name, "path" => filepath, "z" => data["z"])
    
    return MD17(metadata, features, targets)
end
