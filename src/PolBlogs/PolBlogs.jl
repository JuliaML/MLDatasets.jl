export PolBlogs


"""
    PolBlogs
 
The Political Blogs dataset from the [The Political Blogosphere and
the 2004 US Election: Divided they Blog](https://dl.acm.org/doi/10.1145/1134271.1134277) paper.

`PolBlogs` is a graph with 1,490 vertices (representing political blogs) and 19,025 edges (links between blogs).

The links are automatically extracted from a crawl of the front page of the blog. 

Each vertex receives a label indicating the political leaning of the blog: liberal or conservative.

# Interface

- [`PolBlogs.edge_index`](@ref)
- [`PolBlogs.labels`](@ref)
"""
module PolBlogs

using DataDeps
using DelimitedFiles
using ..MLDatasets: datafile

export edge_index, labels

const LINK = "https://netset.telecom-paris.fr/datasets/polblogs.tar.gz"
const DEPNAME = "PolBlogs"
const DATA = ["adjacency.csv", "labels.csv"]

function __init__()
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
    edge_index(; dir = nothing)

Returns a 19025 x 2 matrix containing edge indices where first column as source node and second column as target node together they represent an edge

```julia-repl
using MLDatasets: PolBlogs
adj = PolBlogs.edge_index()
```
"""
function edge_index(; dir = nothing)
    path = datafile(DEPNAME, DATA[1], dir)
    adj = readdlm(path, ',')
    return Matrix{Int64}(adj)
end

"""
    labels(; dir = nothing)

Returns a vector containing the 1490 labels.

```julia-repl
using MLDatasets: PolBlogs
labels = PolBlogs.labels()
```
"""
function labels(; dir=nothing)
    path = datafile(DEPNAME, DATA[2], dir)
    labels = readdlm(path, ',')
    Matrix{Int64}(labels) |> vec
end

end #module
