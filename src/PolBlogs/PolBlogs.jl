export PolBlogs


"""
The Political Blogs dataset from the `"The Political Blogosphere and
the 2004 US Election: Divided they Blog" <https://dl.acm.org/doi/10.1145/1134271.1134277>`_ paper.

`Polblogs` is a graph with 1,490 vertices (representing political blogs) and 19,025 edges (links between blogs).

The links are automatically extracted from a crawl of the front page of the blog. 

Each vertex receives a label indicating the political leaning of the blog: liberal or conservative.
# Interface
- [`PolBlogs.adjacency`](@ref)
 - [`PolBlogs.labels`](@ref)
# Utilities
- [`PolBlogs.download`](@ref)
"""
module PolBlogs

using DataDeps
using DelimitedFiles
using ..MLDatasets: bytes_to_type, datafile, download_dep, download_docstring

export download,adjacency,lables

const LINK = "https://netset.telecom-paris.fr/datasets/polblogs.tar.gz"
const DEPNAME = "PolBlogs"
const DATA = ["adjacency.csv","labels.csv"]

"""
download([dir]; [i_accept_the_terms_of_use])
Trigger the (interactive) download of the full dataset into
"`dir`". If no `dir` is provided the dataset will be
downloaded into "~/.julia/datadeps/$DEPNAME".
This function will display an interactive dialog unless
either the keyword parameter `i_accept_the_terms_of_use` or
the environment variable `DATADEPS_ALWAY_ACCEPT` is set to
`true`. Note that using the data responsibly and respecting
copyright/terms-of-use remains your responsibility.
"""
download(args...;kw...) = download_dep(DEPNAME,args...;kw...)

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
    adjacency(; dir = nothing)

Returns a 19025x2 matrix containing edge indices

```juliarepl
using MLDatasets : PolBlogs
adj = PolBlogs.adjacency()
```
"""
function adjacency(;dir=nothing)
    path = datafile(DEPNAME,DATA[1],dir)
    adj = readdlm(path,',')
    Matrix{Int64}(adj)
end
"""
    lables(; dir = nothing)

Returns a vector of lables of size 1490
```juliarepl
using MLDatasets : PolBlogs
lables = Polblogs.lables()
```
"""
function lables(;dir=nothing)
    path = datafile(DEPNAME,DATA[2],dir)
    lables = readdlm(path,',')
    Matrix{Int64}(lables)
end
end #module