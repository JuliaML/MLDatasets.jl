"""
Read any of the datasets “Reddit” and “PPI”
from the “Inductive Representation Learning on Large Graphs” paper.

Data collected from
http://snap.stanford.edu/graphsage/
"""

function read_graphsage_data(graph_json, class_map_json, id_map_json, feat_path)
    # Read the json files
    graph = read_json(graph_json)
    class_map = read_json(class_map_json)
    id_map = read_json(id_map_json)

    # Metadata
    directed = graph["directed"]
    multigraph = graph["multigraph"]
    links = graph["links"]
    nodes = graph["nodes"]
    num_edges = directed ? length(links) : length(links) * 2
    num_nodes = length(nodes)
    @assert length(graph["graph"]) == 0 # should be zero

    # edges
    s = get.(links, "source", nothing) .+ 1
    t = get.(links, "target", nothing) .+ 1
    if !directed
        s, t = [s; t], [t; s]
    end

    # labels
    node_keys = get.(nodes, "id", nothing)
    node_idx = [id_map[key] for key in node_keys] .+ 1

    sort_order = sortperm(node_idx)
    node_idx = node_idx[sort_order]
    labels = [class_map[key] for key in node_keys][sort_order]
    @assert length(node_idx) == length(labels)
    # if `labels` is an array of array, this turns it into a matrix
    # if `labels` is an array of numbers, this dose nothing
    labels = stack(labels)

    # features
    features = read_npz(feat_path)[node_idx, :]
    features = permutedims(features, (2, 1))

    # split
    test_mask = get.(nodes, "test", nothing)[sort_order]
    val_mask = get.(nodes, "val", nothing)[sort_order]
    # A node should not be both test and validation
    @assert sum(val_mask .& test_mask) == 0
    train_mask = nor.(test_mask, val_mask)

    metadata = Dict{String, Any}("directed" => directed, "multigraph" => multigraph,
                                 "num_edges" => num_edges, "num_nodes" => num_nodes)
    g = Graph(; num_nodes,
              edge_index = (s, t),
              node_data = (; labels, features, train_mask, val_mask, test_mask))

    return metadata, g
end
