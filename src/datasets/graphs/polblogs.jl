function __init__polblogs()
    LINK = "https://netset.telecom-paris.fr/datasets/polblogs.tar.gz"
    DEPNAME = "PolBlogs"
    

    register(DataDep(DEPNAME,
    """
    Dataset : The $DEPNAME dataset
    Website : $LINK
    """,
    LINK,
    post_fetch_method = unpack
    ))
end


"""
    PolBlogs(; dir=nothing)
 
The Political Blogs dataset from the [The Political Blogosphere and
the 2004 US Election: Divided they Blog](https://dl.acm.org/doi/10.1145/1134271.1134277) paper.

`PolBlogs` is a graph with 1,490 vertices (representing political blogs) and 19,025 edges (links between blogs).

The links are automatically extracted from a crawl of the front page of the blog. 

Each vertex receives a label indicating the political leaning of the blog: liberal or conservative.
"""
struct PolBlogs <: AbstractDataset
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
end

function PolBlogs(; dir=nothing)
    DEPNAME = "PolBlogs"
    DATA = ["adjacency.csv", "labels.csv"]

    path = datafile(DEPNAME, DATA[1], dir)
    adj = 1 .+ Matrix{Int64}(readdlm(path, ','))
    s, t = adj[:,1], adj[:,2]

    path = datafile(DEPNAME, DATA[2], dir)
    labels = Matrix{Int64}(readdlm(path, ',')) |> vec

    metadata = Dict{String, Any}()
    g = Graph(; num_nodes=1490, num_edges=19025,
            edge_index = (s, t), 
            node_data = (; labels))

    return PolBlogs(metadata, [g])
end

Base.length(d::PolBlogs) = length(d.graphs) 
Base.getindex(d::PolBlogs) = d.graphs
Base.getindex(d::PolBlogs, i) = getindex(d.graphs, i)
