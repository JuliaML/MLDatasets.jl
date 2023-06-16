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

function METRLA(;num_timesteps_in::Int = 12, num_timesteps_out::Int = 12, dir = nothing)
    d = metrla_datadir(dir)
    adj_matrix, node_values = read_metrla(d)

    permutedims!(node_values,(3,2,1))
    node_values = (node_values .- mean(node_values, dims=(2,3))) ./ std(node_values, dims=(2,3)) #Z-score normalization

    s, t, w = adjmatrix2edgeindex(adj_matrix; weighted = true)

    x, y = generate_task(node_values, num_timesteps_in, num_timesteps_out)
    
    g = Graph(; num_nodes = 207,
              edge_index = (s, t),
              edge_data = w,
            node_data = (features = x, targets = y)


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

function read_metrla(d::String)
    adj_matrix = npzread(joinpath(d, "adj_mat.npy"))
    node_features = npzread(joinpath(d, "node_values.npy"))
    return adj_matrix, node_features
end
    
function generate_task(node_values::AbstractArray, num_timesteps_in::Int, num_timesteps_out::Int)
    indices = [(i, i + num_timesteps_in + num_timesteps_out) for i in 1:(size(node_values,1) - num_timesteps_in - num_timesteps_out)]
    features=[]
    targets=[]
    for (i,j) in indices
        push!(features,node_values[i:i+num_timesteps_in-1,:,:])
        push!(targets,reshape(node_values[i+num_timesteps_in:j-1,1,:], (num_timesteps_out, 1, size(node_values, 3))))
    end
    return features, targets
end