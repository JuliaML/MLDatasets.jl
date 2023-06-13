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
    graphs::Vector{Graph}
end

function metrla_datadir(dir = nothing)
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

function read_metrla()
    d = metrla_datadir()
    adj_matrix = npzread(joinpath(d, "adj_mat.npy"))
    node_features = npzread(joinpath(d, "node_values.npy"))
    return adj_matrix, node_features
end
    