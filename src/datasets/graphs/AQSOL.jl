function __init__aqsol()
    DEPNAME = "AQSOL"
    LINK = "https://www.dropbox.com/s/lzu9lmukwov12kt/aqsol_graph_raw.zip?dl=1"
    register(DataDep(DEPNAME,
                     """
                     Dataset: The AQSOL dataset.
                     Website: http://arxiv.org/abs/2003.00982
                     """,
                     LINK,
                     post_fetch_method = unpack))
end

struct AQSOL <: AbstractDataset
    split::Symbol
    metadata::Dict{String,Any}
    graphs::Vector{Graph}
end

function AQSOL(;split=:train, dir=nothing)
    @assert split ∈ [:train, :val, :test]
    DEPNAME = "AQSOL"
    path = datafile(DEPNAME, "asqol_graph_raw/$(split).pickle", dir)
    graphs = Pickle.npyload(path)
    g = [create_aqsol_graph(g...) for g in graphs]
    metadata = Dict{String, Any}("n_observations" => length(g))
    return AQSOL(split, metadata, g)
end

function create_aqsol_graph(x, edge_attr, edge_index, y)
    x = Int.(x)
    edge_attr = Int.(edge_attr)
    edge_index = Int.(edge_index .+ 1)
    
    if size(edge_index, 2) == 0
        s, t = Int[], Int[] 
    else
        s, t = edge_index[:,1], edge_index[:,2]
    end

    return Graph(; num_nodes = length(x),
                  edge_index = (s, t),
                  node_data = (features = x,),
                  edge_data = (features = edge_attr,))
end

Base.length(d::AQSOL) = length(d.graphs)
Base.getindex(d::AQSOL, ::Colon) = d.graphs
Base.getindex(d::AQSOL, i) = getindex(d.graphs, i)