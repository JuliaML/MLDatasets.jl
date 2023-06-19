function __init__metrla()
    DEPNAME = "METR-LA"
    LINK = "https://graphmining.ai/temporal_datasets/"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """))
end

"""
    METRLA(; num_timesteps_in::Int = 12, num_timesteps_out::Int=12, dir=nothing)

The METR-LA dataset from the [Diffusion Convolutional Recurrent Neural Network: Data-Driven Traffic Forecasting](https://arxiv.org/abs/1707.01926) paper.

`METRLA` is a graph with 207 nodes representing traffic sensors in Los Angeles. 

The edge weights `w` are contained as a feature array in `edge_data` and represent the distance between the sensors. 

The node features are the traffic speed and the time of the measurements collected by the sensors, divided into `num_timesteps_in` time steps. 

The target values are the traffic speed and the time of the measurements collected by the sensors, divided into `num_timesteps_out` time steps.
"""
struct METRLA <: AbstractDataset
    graphs::Vector{Graph}
end

function METRLA(;num_timesteps_in::Int = 12, num_timesteps_out::Int=12, dir = nothing)
    create_default_dir("METR-LA")
    d = metrla_datadir(dir)
    adj_matrix, node_values = read_metrla(d)

    node_values = permutedims(node_values,(1,3,2))
    node_values = (node_values .- Statistics.mean(node_values, dims=(3,1))) ./ Statistics.std(node_values, dims=(3,1)) #Z-score normalization

    s, t, w = adjmatrix2edgeindex(adj_matrix; weighted = true)

    x, y = generate_task(node_values, num_timesteps_in, num_timesteps_out)

    g = Graph(; num_nodes = 207,
              edge_index = (s, t),
              edge_data = w,
            node_data = (features = x, targets = y)


    )
    return METRLA([g])
end

function metrla_datadir(dir = nothing)
    dir = isnothing(dir) ? datadep"METR-LA" : dir
    dname = "METR-LA"
    LINK = "https://graphmining.ai/temporal_datasets/$dname.zip"
    if length(readdir((dir))) == 0
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "$dname.zip"))
        # conditions when unzipped folder is our required data dir
        cd(currdir)
    end
    @assert isdir(dir)
    return dir
end

function read_metrla(d::String)
    adj_matrix = NPZ.npzread(joinpath(d, "adj_mat.npy"))
    node_features = NPZ.npzread(joinpath(d, "node_values.npy"))
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

Base.length(d::METRLA) = length(d.graphs)
Base.getindex(d::METRLA, ::Colon) = d.graphs[1]
Base.getindex(d::METRLA, i) = getindex(d.graphs, i)
