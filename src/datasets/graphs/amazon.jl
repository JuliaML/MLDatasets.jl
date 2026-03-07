using DataDeps
using NPZ
using SparseArrays

function __init__amazon()

    ENV["DATADEPS_ALWAYS_ACCEPT"] = "true"
    DEPNAME = "Amazon"
    LINK = "https://github.com/shchur/gnn-benchmark/raw/master/data/npz"
    DOCS = "https://github.com/shchur/gnn-benchmark"

    DATA = [
        "amazon_electronics_computers.npz",
        "amazon_electronics_photo.npz"
    ]

    register(DataDep(
        DEPNAME,
        """
        Dataset: Amazon Co-purchase Network
        Website: $DOCS
        """,
        map(x -> "$LINK/$x", DATA),
        "98b9c971b900ac86d8b4bd64a969c42db4519e1b8697316e95b30b1bdccd72e3"
    ))
end


function read_amazon_data(file; dir=nothing)

    path = isnothing(dir) ? datadep"Amazon" : dir
    full_path = joinpath(path, file)

    vars = ["attr_data","attr_indices","attr_indptr","attr_shape",
            "labels","adj_indices","adj_indptr","adj_shape"]

    data = NPZ.npzread(full_path, vars)

    attr_shape = data["attr_shape"]

    x_sparse = SparseMatrixCSC(
        attr_shape[2],
        attr_shape[1],
        data["attr_indptr"] .+ 1,
        data["attr_indices"] .+ 1,
        data["attr_data"]
    )

    x = Float32.(Matrix(x_sparse))

    y = vec(Int.(data["labels"])) .+ 1

    indices = data["adj_indices"]
    indptr = data["adj_indptr"]

    src = Int[]
    dst = Int[]

    for i in 1:(length(indptr)-1)
        for j in (indptr[i]+1):indptr[i+1]

            u = i
            v = Int(indices[j]) + 1

            push!(src, u)
            push!(dst, v)

            push!(src, v)
            push!(dst, u)

        end
    end

    edge_tuples = unique(zip(src, dst))
    edge_tuples = filter(e -> e[1] != e[2], edge_tuples)

    src = [e[1] for e in edge_tuples]
    dst = [e[2] for e in edge_tuples]

    num_nodes = attr_shape[1]

    node_data = (
        features = x,
        targets = y
    )

    metadata = Dict(
        "name" => file,
        "num_classes" => length(unique(y))
    )

    g = Graph(
        num_nodes=num_nodes,
        edge_index=(src, dst),
        node_data=node_data
    )

    return metadata, g

end


"""
    AmazonComputers(; dir=nothing)

The Amazon Computers co-purchase network dataset from the
"Pitfalls of Graph Neural Network Evaluation" paper.

Nodes represent products and edges represent products frequently
bought together. Features are bag-of-words product reviews.

Statistics
- Nodes: 13752
- Edges: 491722
- Features: 767
"""
struct AmazonComputers <: AbstractDataset
    metadata::Dict{String,Any}
    graphs::Vector{Graph}
end


function AmazonComputers(; dir=nothing)

    metadata, g = read_amazon_data(
        "amazon_electronics_computers.npz",
        dir=dir
    )

    AmazonComputers(metadata, [g])

end


Base.length(d::AmazonComputers) = length(d.graphs)
Base.getindex(d::AmazonComputers, ::Colon) = d.graphs[1]
Base.getindex(d::AmazonComputers, i) = d.graphs[i]


"""
    AmazonPhoto(; dir=nothing)

The Amazon Photo co-purchase network dataset from the
"Pitfalls of Graph Neural Network Evaluation" paper.

Nodes represent photo-related products and edges represent
products frequently bought together.

Statistics
- Nodes: 7650
- Edges: 238162
- Features: 745
"""
struct AmazonPhoto <: AbstractDataset
    metadata::Dict{String,Any}
    graphs::Vector{Graph}
end


function AmazonPhoto(; dir=nothing)

    metadata, g = read_amazon_data(
        "amazon_electronics_photo.npz",
        dir=dir
    )

    AmazonPhoto(metadata, [g])

end


Base.length(d::AmazonPhoto) = length(d.graphs)
Base.getindex(d::AmazonPhoto, ::Colon) = d.graphs[1]
Base.getindex(d::AmazonPhoto, i) = d.graphs[i]
