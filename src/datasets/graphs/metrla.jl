function __init__metrla()
    DEPNAME = "METR-LA"
    LINK = "https://graphmining.ai/temporal_datasets/"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """,
                           LINK))
end

struct METRLA 
    graph::Graph
end

function METRLA(;dir = nothing)
    d = metrla_datadir(dir)
    adj_matrix, node_features = read_metrla(d)

    g = Graph(

    )
    return METRLA(g)
end

function metrla_datadir(;dir = nothing)
    dir = isnothing(dir) ? datadep"METR-LA" : dir
    dname = "METR-LA"
    LINK = "https://graphmining.ai/temporal_datasets/$dname.zip"
    d = joinpath(dir, dname)
    if !isdir(d)
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "$dname.zip"))
        # conditions when unzipped folder is our required data dir
        cd(currdir)
    end
    @assert isdir(d)
    return d
end

function read_metrla(d)
    adj_matrix = npzread(joinpath(d, "adj_mat.npy"))
    node_features = npzread(joinpath(d, "node_values.npy"))
    return adj_matrix, node_features
end
    