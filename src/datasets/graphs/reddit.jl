function __init__reddit()
    DEPNAME = "Reddit"
    LINK = "http://snap.stanford.edu/graphsage/reddit.zip"
    DOCS = "http://snap.stanford.edu/graphsage/"

    register(DataDep(
        DEPNAME,
        """
        Dataset: The $DEPNAME Dataset
        Website: $DOCS
        Download Link: $LINK
        """,
        LINK,
        "25337a21540cd373e4cee3751e6600324ab6a7377ef3966bb49f57412a17ed02",
        post_fetch_method=unpack
    ))
end

"""
    Reddit(; full=true, dir=nothing)

The Reddit dataset was introduced in Ref [1].
It is a graph dataset of Reddit posts made in the month of September, 2014.
The dataset contains a single post-to-post graph, connecting posts if the same user comments on both. 
The node label in this case is one of the 41 communities, or “subreddit”s, that a post belongs to.  
This dataset contains 232,965 posts.
The first 20 days are used for training and the remaining days for testing (with 30% used for validation).
Each node is represented by a 602 word vector.

Use `full=false` to lod only a subsample of the dataset.


# References
[1]: [Inductive Representation Learning on Large Graphs](https://arxiv.org/abs/1706.02216)
[2]: [Benchmarks on the Reddit Dataset](https://paperswithcode.com/dataset/reddit)
"""
struct Reddit <: AbstractDataset
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
end


function Reddit(; full=true, dir=nothing)
    DATAFILES =  [
        "reddit-G.json", "reddit-G_full.json", "reddit-adjlist.txt",
        "reddit-class_map.json", "reddit-feats.npy", "reddit-id_map.json"
        ]
    DATA = joinpath.("reddit", DATAFILES)
    DEPNAME = "Reddit"


    if full
        graph_json = datafile(DEPNAME, DATA[2], dir)
    else
        graph_json = datafile(DEPNAME, DATA[1], dir)
    end

    class_map_json = datafile(DEPNAME, DATA[4], dir)
    id_map_json = datafile(DEPNAME, DATA[6], dir)
    feat_path = datafile(DEPNAME, DATA[5], dir)

    # Read the json files
    graph = open(JSON3.read, graph_json)
    class_map = open(JSON3.read, class_map_json)
    id_map = open(JSON3.read, id_map_json)

    # Metadata
    directed = graph["directed"]
    multigraph = graph["multigraph"]
    links = graph["links"]
    nodes = graph["nodes"]
    num_edges = directed ? length(links) : length(links) * 2
    num_nodes = length(nodes)
    num_graphs = length(graph["graph"]) # should be zero

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
    labels = [class_map[key] for key in  node_keys][sort_order]
    @assert length(node_idx) == length(labels)

    # features
    features = npzread(feat_path)[node_idx, :]
    features = permutedims(features, (2, 1))

    # split
    test_mask =  get.(nodes, "test", nothing)[sort_order]
    val_mask = get.(nodes, "val", nothing)[sort_order]
    # A node should not be both test and validation
    @assert sum(val_mask .& test_mask) == 0
    train_mask = nor.(test_mask, val_mask)

    train_idx = node_idx[train_mask]
    test_idx = node_idx[test_mask]
    val_idx = node_idx[val_mask]

    split = Dict(
        "train" => train_idx,
        "test" => test_idx,
        "val"  => val_idx
    )

    metadata = Dict{String, Any}("directed" => directed, "multigraph" => multigraph, 
                "num_graphs" => num_graphs, "num_edges" => num_edges, "num_nodes" => num_nodes, 
                "split" => split)
    g = Graph(
        num_edges=num_edges, num_nodes=num_nodes, 
        edge_index=(s, t), 
        node_data= (; labels, features)
    )
    return Reddit(metadata, [g])
end

Base.length(d::Reddit) = length(d.graphs) 
Base.getindex(d::Reddit) = d.graphs
Base.getindex(d::Reddit, i) = getindex(d.graphs, i)
