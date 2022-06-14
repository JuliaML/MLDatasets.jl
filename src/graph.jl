
abstract type AbstractGraph end

"""
    Graph(; kws...)

A type that represents a graph and that can also store node and edge data.
It doesn't distinguish between directed or undirected graph, therefore for
undirected graphs will store edges in both directions. 
Nodes are indexed in `1:num_nodes`.

Graph datasets in MLDatasets.jl contain one or more `Graph` objects.

# Keyword Arguments 

- `num_nodes`: the number of nodes. If omitted, is inferred from `edge_index`.
- `edge_index`: a tuple containing two vectors with length equal to the number of edges. 
    The first vector contains the list of the source nodes of each edge, the second the target nodes.
    Defaults to `(Int[], Int[])`.  
- `node_data`: node-related data. Can be `nothing`, a named tuple of arrays or a dictionary of arrays.
            The arrays last dimension size should be equal to the number of nodes. 
            Default `nothing`.
- `edge_data`: edge-related data. Can be `nothing`, a named tuple of arrays or a dictionary of arrays.
             The arrays' last dimension size should be equal to the number of edges. 
             Default `nothing`.

# Examples

All graph datasets in MLDatasets.jl contain `Graph` objects:
```julia-repl
julia> using MLDatasets: Cora

julia> d = Cora() # the Cora dataset
dataset Cora:
  metadata    =>    Dict{String, Any} with 3 entries
  graphs      =>    1-element Vector{Graph}

julia> d[1]
Graph:
  num_nodes   =>    2708
  num_edges   =>    10556
  edge_index  =>    ("10556-element Vector{Int64}", "10556-element Vector{Int64}")
  node_data   =>    (features = "1433×2708 Matrix{Float32}", targets = "2708-element Vector{Int64}", train_mask = "2708-element BitVector with 140 trues", val_mask = "2708-element BitVector with 500 trues", test_mask = "2708-element BitVector with 1000 trues")
  edge_data   =>    nothing
```

Let's se how to convert a Graphs.jl's graph to a `MLDatasets.Graph` and viceversa:

```julia
import Graphs, MLDatasets

## From Graphs.jl to MLDatasets.Graphs

# From a directed graph
g = Graphs.erdos_renyi(10, 20, is_directed=true)
s = [e.src for e in Graphs.edges(g)]
t = [e.dst for e in Graphs.edges(g)]
mlg = MLDatasets.Graph(num_nodes=10, edge_index=(s, t))

# From an undirected graph
g = Graphs.erdos_renyi(10, 20, is_directed=false)
s = [e.src for e in Graphs.edges(g)]
t = [e.dst for e in Graphs.edges(g)]
s, t = [s; t], [t; s] # adding reverse edges
mlg = MLDatasets.Graph(num_nodes=10, edge_index=(s, t))

# From MLDatasets.Graphs to Graphs.jl
s, t = mlg.edge_index
g = Graphs.DiGraph(mlg.num_nodes)
for (i, j) in zip(s, t)
    Graphs.add_edge!(g, i, j)
end
```
"""
struct Graph <: AbstractGraph
    num_nodes::Int
    num_edges::Int
    edge_index::Tuple{Vector{Int}, Vector{Int}}
    node_data
    edge_data
end

function Graph(;
    num_nodes::Union{Int, Nothing} = nothing,
    edge_index::Tuple{Vector{Int}, Vector{Int}} = (Int[], Int[]),
    node_data = nothing,
    edge_data = nothing)

    s, t = edge_index
    @assert length(s) == length(t)
    num_edges = length(s)
    if num_nodes === nothing
        if num_edges == 0
            num_nodes = 0
        else
            num_nodes = max(maximum(s), maximum(t)) 
        end
    end
    return Graph(num_nodes, num_edges, edge_index, node_data, edge_data)
end


function Base.show(io::IO, d::Graph)    
    print(io, "Graph($(d.num_nodes), $(d.num_edges))")
end

function Base.show(io::IO, ::MIME"text/plain", d::Graph)    
    recur_io = IOContext(io, :compact => false)
    print(io, "Graph:")
    for f in fieldnames(Graph)
        if !startswith(string(f), "_")
            fstring = leftalign(string(f), 10)
            print(recur_io, "\n  $fstring  =>    ")
            print(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end

"""
    HeteroGraph(; kws...)

Type that represents heterogeneous Graph.
"""
struct HeteroGraph <: AbstractGraph
    num_nodes::Dict{String, Int}
    num_edges::Dict{Tuple{String, String, String}, Int}
    edge_indices::Dict{Tuple{String, String, String}, Tuple{Vector{Int}, Vector{Int}}}
    node_data
    edge_data
end

function HeteroGraph(;
    num_nodes::Dict{String, Int},
    num_edges,
    edge_indices,
    node_data,
    edge_data
    )
    num_edges = Dict()
    for (relation, edge_index) in edge_indices
        s, t = edge_index
        @assert length(s) == length(t)
        num_edges[relation] = length(s)
    end
    return HeteroGraph(num_nodes, num_edges, edge_indices, node_data, edge_data)
end

function Base.show(io::IO, d::HeteroGraph)
    print(io, "HeteroGraph($(length(d.num_nodes)) node types, $(length(d.num_edges)) relations)")
end

function Base.show(io::IO, ::MIME"text/plain", d::HeteroGraph)
    recur_io = IOContext(io, :compact => false)
    print(io, "HeteroGraph:")
    for f in fieldnames(HeteroGraph)
        if !startswith(string(f), "_")
            fstring = leftalign(string(f), 12)
            print(recur_io, "\n  $fstring  =>    ")
            print(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end

# Transform an adjacency list to edge index.
# If inneigs = true, assume neighbors from incoming edges.
function adjlist2edgeindex(adj; inneigs=false)
    s, t = Int[], Int[]
    for i in 1:length(adj)
        for j in adj[i]
            push!(s, i)
            push!(t, j)
        end
    end

    if inneigs
        s, t = t, s
    end

    return s, t
end

function edgeindex2adjlist(s, t, num_nodes; inneigs=false)
    adj = [Int[] for _ in 1:num_nodes]
    if inneigs
        s, t = t, s
    end
    for (i, j) in zip(s, t)
        push!(adj[i], j)
    end
    return adj
end


