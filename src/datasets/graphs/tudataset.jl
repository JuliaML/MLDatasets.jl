function __init__tudataset()
    DEPNAME = "TUDataset"
    DOCS = "https://chrsmrrs.github.io/datasets/docs/home/"

    register(ManualDataDep(DEPNAME,
                           """
                           Datahub: $DEPNAME.
                           Website: $DOCS
                           """))
end

"""
    TUDataset(name; dir=nothing)

A variety of graph benchmark datasets, *.e.g.* "QM9", "IMDB-BINARY",
"REDDIT-BINARY" or "PROTEINS", collected from the [TU Dortmund University](https://chrsmrrs.github.io/datasets/).
Retrieve from the TUDataset collection the dataset `name`, where `name`
is any of the datasets available [here](https://chrsmrrs.github.io/datasets/docs/datasets/). 

A `TUDataset` object can be indexed to retrieve a specific graph or a subset of graphs.

See [here](https://chrsmrrs.github.io/datasets/docs/format/) for an in-depth 
description of the format. 

# Usage Example

```julia-repl
julia> data = TUDataset("PROTEINS")
dataset TUDataset:
  name        =>    PROTEINS
  metadata    =>    Dict{String, Any} with 1 entry
  graphs      =>    1113-element Vector{MLDatasets.Graph}
  graph_data  =>    (targets = "1113-element Vector{Int64}",)
  num_nodes   =>    43471
  num_edges   =>    162088
  num_graphs  =>    1113

julia> data[1]
(graphs = Graph(42, 162), targets = 1)
```
"""
struct TUDataset <: AbstractDataset
    name::String
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
    graph_data::Union{Nothing, NamedTuple}
    num_nodes::Int
    num_edges::Int
    num_graphs::Int
end

function TUDataset(name; dir = nothing)
    create_default_dir("TUDataset")
    d = tudataset_datadir(name, dir)
    # See here for the file format: https://chrsmrrs.github.io/datasets/docs/format/

    st = readdlm(joinpath(d, "$(name)_A.txt"), ',', Int)
    # Check that the first node is labeled 1.
    # TODO this will fail if the first node is isolated
    @assert minimum(st) == 1
    source, target = st[:, 1], st[:, 2]

    graph_indicator = readdlm(joinpath(d, "$(name)_graph_indicator.txt"), Int) |> vec
    if !all(sort(unique(graph_indicator)) .== 1:length(unique(graph_indicator)))
        @warn "Some graph indicators are not present in graph_indicator.txt. Ordering of graph and graph labels may not be consistent. Base.getindex might produce unexpected behavior for unaltered data."
    end

    num_nodes = length(graph_indicator)
    num_edges = length(source)
    num_graphs = length(unique(graph_indicator))

    # LOAD OPTIONAL FILES IF EXIST

    node_labels = isfile(joinpath(d, "$(name)_node_labels.txt")) ?
                  readdlm(joinpath(d, "$(name)_node_labels.txt"), ',', Int)' |> collect |>
                  maybesqueeze :
                  nothing
    edge_labels = isfile(joinpath(d, "$(name)_edge_labels.txt")) ?
                  readdlm(joinpath(d, "$(name)_edge_labels.txt"), ',', Int)' |> collect |>
                  maybesqueeze :
                  nothing
    graph_labels = isfile(joinpath(d, "$(name)_graph_labels.txt")) ?
                   readdlm(joinpath(d, "$(name)_graph_labels.txt"), ',', Int)' |> collect |>
                   maybesqueeze :
                   nothing

    node_attributes = isfile(joinpath(d, "$(name)_node_attributes.txt")) ?
                      readdlm(joinpath(d, "$(name)_node_attributes.txt"), ',', Float32)' |>
                      collect :
                      nothing
    edge_attributes = isfile(joinpath(d, "$(name)_edge_attributes.txt")) ?
                      readdlm(joinpath(d, "$(name)_edge_attributes.txt"), ',', Float32)' |>
                      collect :
                      nothing
    graph_attributes = isfile(joinpath(d, "$(name)_graph_attributes.txt")) ?
                       readdlm(joinpath(d, "$(name)_graph_attributes.txt"), ',',
                               Float32)' |> collect :
                       nothing

    # TODO: maybe introduce consistency in graph labels and attributes if possible

    # We need this two vectors sorted for efficiency in tudataset_getgraph(full_dataset, i)
    @assert issorted(graph_indicator)
    if !issorted(source)
        p = sortperm(source)
        source, target = source[p], target[p]
        if edge_labels !== nothing
            edge_labels = edge_labels[p]
        end
        if edge_attributes !== nothing
            edge_attributes = edge_attributes[:, p]
        end
    end

    full_dataset = (; num_nodes, num_edges, num_graphs,
                    source, target,
                    graph_indicator,
                    node_labels,
                    edge_labels,
                    graph_labels,
                    node_attributes,
                    edge_attributes,
                    graph_attributes)

    graphs = [tudataset_getgraph(full_dataset, i) for i in sort(unique(graph_indicator))]
    graph_data = (; features = graph_attributes, targets = graph_labels) |> clean_nt
    metadata = Dict{String, Any}("name" => name)
    return TUDataset(name, metadata, graphs, graph_data, num_nodes, num_edges, num_graphs)
end

function tudataset_datadir(name, dir = nothing)
    dir = isnothing(dir) ? datadep"TUDataset" : dir
    LINK = "https://www.chrsmrrs.com/graphkerneldatasets/$name.zip"
    d = joinpath(dir, name)
    if !isdir(d)
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "$name.zip"))
        cd(currdir)
    end
    @assert isdir(d)
    return d
end

function tudataset_getgraph(data::NamedTuple, i::Int)
    vmin = searchsortedfirst(data.graph_indicator, i)
    vmax = searchsortedlast(data.graph_indicator, i)
    nodes = vmin:vmax
    node_labels = isnothing(data.node_labels) ? nothing : getobs(data.node_labels, nodes)
    node_attributes = isnothing(data.node_attributes) ? nothing :
                      getobs(data.node_attributes, nodes)

    emin = searchsortedfirst(data.source, vmin)
    emax = searchsortedlast(data.source, vmax)
    edges = emin:emax
    source = data.source[edges] .- vmin .+ 1
    target = data.target[edges] .- vmin .+ 1
    edge_labels = isnothing(data.edge_labels) ? nothing : getobs(data.edge_labels, edges)
    edge_attributes = isnothing(data.edge_attributes) ? nothing :
                      getobs(data.edge_attributes, edges)

    num_nodes = length(nodes)
    num_edges = length(source)
    node_data = (features = node_attributes, targets = node_labels)
    edge_data = (features = edge_attributes, targets = edge_labels)

    return Graph(; num_nodes,
                 edge_index = (source, target),
                 node_data = node_data |> clean_nt,
                 edge_data = edge_data |> clean_nt)
end

Base.length(data::TUDataset) = length(data.graphs)

function Base.getindex(data::TUDataset, ::Colon)
    if data.graph_data === nothing
        return data.graphs
    else
        return (; data.graphs, data.graph_data...)
    end
end

function Base.getindex(data::TUDataset, i)
    if data.graph_data === nothing
        return getobs(data.graphs, i)
    else
        return getobs((; data.graphs, data.graph_data...), i)
    end
end
