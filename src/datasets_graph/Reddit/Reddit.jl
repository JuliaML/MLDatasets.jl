export Reddit

"""
    Reddit

# References

[1]: [Inductive Representation Learning on Large Graphs](https://arxiv.org/abs/1706.02216)
"""
module Reddit
using DataDeps
using JSON3
using ..MLDatasets: datafile
using NPZ: npzread

DATA = [
        "reddit-G.json", "reddit-G_full.json", "reddit-adjlist.txt",
        "reddit-class_map.json", "reddit-feats.npy", "reddit-id_map.json", "reddit-walks.txt"
        ]
DEPNAME = "Reddit"

function __init__()
    DEPNAME = "Reddit"
    LINK = ""
    DOCS = ""

    register(DataDep(
        DEPNAME,
        """
        Dataset: The $DEPNAME Dataset
        Website: $DOCS
        Download Link: $LINK
        """,
        "http://snap.stanford.edu/graphsage/reddit.zip",
        fetch_method=unpack
    ))
end

"""
    edge_index(self_loops=true)

"""
function edge_index(self_loops=true)

    if self_loops
        data_path = datafile(DEPNAME, DATA[1])
    else
        data_path = datafile(DEPNAME, DATA[0])
    end
    graph = open(JSON3.read, data_path)
    links = graph["links"]

    s = map(link->link["source"], links)
    t = map(link->link["target"], links)

    edge_index = [s t; t s]

    return edge_index
end

"""
    labels()

"""
function labels()
    data_path = datafile(DEPNAME, DATA[1])
    graph = open(JSON3.read, data_path)
    nodes = graph[:nodes]

    class_map_file = datafile(DEPNAME, DATA[4])
    id_map_file = datafile(DEPNAME, DATA[6])
    class_map = open(JSON3.read, class_map_file)
    id_map = open(JSON3.read, id_map_file)

    node_keys = get.(nodes, "id", nothing)
    node_idx = [id_map[key] for key in node_keys]
    class_idx = [class_map[key] for key in  node_keys]
    # Sort according to the node_idx
    @assert length(node_idx) == length(class_idx)

    return class_idx
end

"""
    node_features()

"""
function node_features()
    feat_path = datafile(DEPNAME, DATA[5])
    features = npzread(feat_path)
    return features
end

"""
    split()

"""
function split()
    data_path = datafile(DEPNAME, DATA[1])
    graph = open(JSON3.read, data_path)
    nodes = graph["nodes"]

    id_map_file = datafile(DEPNAME, DATA[6])
    id_map = open(JSON3.read, id_map_file)

    test_mask =  get.(nodes, "test", nothing)
    val_mask = get.(nodes, "val", nothing)
    @assert sum(val_mask .& test_mask) == 0
    train_mask = nor.(test_mask, val_mask)

    train_nodes = nodes[train_mask]
    val_nodes = nodes[val_mask]
    test_nodes = nodes[test_mask]

    train_keys = get.(train_nodes, "id", nothing)
    test_keys = get.(test_nodes, "id", nothing)
    val_keys = get.(val_nodes, "id", nothing)

    train_idx = [id_map[key] for key in train_keys]
    test_idx = [id_map[key] for key in test_keys]
    val_idx = [id_map[key] for key in val_keys]

    split_dict = Dict(
        "train" => train_idx,
        "test" => test_idx,
        "val"  => val_idx
    )
end

end #module