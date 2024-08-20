function __init__aqsol()
    DEPNAME = "AQSOL"
    LINK = "https://www.dropbox.com/s/lzu9lmukwov12kt/aqsol_graph_raw.zip?dl=1"
    register(DataDep(DEPNAME,
                     """
                     Dataset: The AQSOL dataset.
                     Website: http://arxiv.org/abs/2003.00982
                     """,
                     LINK,
                     post_fetch_method = unpack))
end

struct AQSOL <: AbstractDataset
    split::Symbol
    metadata::Dict{String,Any}
    graphs::Vector{Graph}
end

"""
    AQSOL(; split=:train, dir=nothing)

The AQSOL (Aqueous Solubility) dataset from the paper 
[Graph Neural Network for Predicting Aqueous Solubility of Organic Molecules](http://arxiv.org/abs/2003.00982).

The dataset contains 9,882 graphs representing small organic molecules. Each graph represents a molecule, where nodes correspond to atoms and edges to bonds. The node features represent the atomic number, and the edge features represent the bond type. The target is the aqueous solubility of the molecule, measured in mol/L.

# Arguments

- `split`: Which split of the dataset to load. Can be one of `:train`, `:val`, or `:test`. Defaults to `:train`.
- `dir`: Directory in which the dataset is in.

# Examples

```julia-repl
julia> using MLDatasets

julia> dataset = AQSOL()
dataset AQSOL:
  split     =>    :train
  metadata  =>    Dict{String, Any} with 1 entry
  graphs    =>    7985-element Vector{Graph}
```
"""
function AQSOL(;split=:train, dir=nothing)
    @assert split ∈ [:train, :val, :test]
    DEPNAME = "AQSOL"
    path = datafile(DEPNAME, "asqol_graph_raw/$(split).pickle", dir)
    graphs = Pickle.npyload(path)
    g = [create_aqsol_graph(g...) for g in graphs]
    metadata = Dict{String, Any}("n_observations" => length(g))
    return AQSOL(split, metadata, g)
end

function create_aqsol_graph(x, edge_attr, edge_index, y)
    x = Int.(x)
    edge_attr = Int.(edge_attr)
    edge_index = Int.(edge_index .+ 1)
    
    if size(edge_index, 2) == 0
        s, t = Int[], Int[] 
    else
        s, t = edge_index[:,1], edge_index[:,2]
    end

    return Graph(; num_nodes = length(x),
                  edge_index = (s, t),
                  node_data = (features = x,),
                  edge_data = (features = edge_attr,))
end

Base.length(d::AQSOL) = length(d.graphs)
Base.getindex(d::AQSOL, ::Colon) = d.graphs
Base.getindex(d::AQSOL, i) = getindex(d.graphs, i)
