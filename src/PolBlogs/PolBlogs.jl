export PolBlogs


"""
"""
module PolBlogs

using DataDeps
using DelimitedFiles
using ..MLDatasets: bytes_to_type, datafile, download_dep, download_docstring

export download,adjacency,lables

const LINK = "https://netset.telecom-paris.fr/datasets/polblogs.tar.gz"
const DEPNAME = "PolBlogs"
const DATA = ["adjaceny.csv","lables.csv"]

download(args...;kw...) = download_dep(DEPNAME,args...;kw...)
"""
"""
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
"""
function adjacency(;dir=nothing)
    path = datafile(DEPNAME,DATA[0],dir)
    adj = readdlm(path,',')
    Matrix{Int64}(adj)
end
"""
"""
function lables(;dir=nothing)
    path = datafile(DEPNAME,DATA[1],dir)
    lables = readdlm(path,',')
    Matrix{Int64}(lables)
end #module