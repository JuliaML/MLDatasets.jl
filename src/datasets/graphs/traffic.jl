function traffic_datadir(dname ::String, dir = nothing)
    if dname == "PEMS-BAY"
        dir = isnothing(dir) ? datadep"PEMS-BAY" : dir
    elseif dname == "METR-LA"
        dir = isnothing(dir) ? datadep"METR-LA" : dir
    end
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

function read_traffic(d::String, dname::String)
    if dname == "PEMS-BAY"
        s="pems_"
    elseif dname == "METR-LA"
        s=""
    end

    adj_matrix = NPZ.npzread(joinpath(d, "$(s)adj_mat.npy"))
    node_features = NPZ.npzread(joinpath(d, "$(s)node_values.npy"))

    return adj_matrix, node_features
end
    
function traffic_generate_task(node_values::AbstractArray, num_timesteps_in::Int, num_timesteps_out::Int)
    indices = [(i, i + num_timesteps_in + num_timesteps_out) for i in 1:(size(node_values,1) - num_timesteps_in - num_timesteps_out)]
    features = []
    targets = []
    for (i,j) in indices
        push!(features, node_values[i:i+num_timesteps_in-1,:,:])
        push!(targets, reshape(node_values[i+num_timesteps_in:j-1,1,:], (num_timesteps_out, 1, size(node_values, 3))))
    end
    return features, targets
end

function processed_traffic(dname::String, num_timesteps_in::Int, num_timesteps_out::Int, dir = nothing)
    create_default_dir(dname)
    d = traffic_datadir(dname, dir)
    adj_matrix, node_values = read_traffic(d, dname)

    node_values = permutedims(node_values,(1,3,2))
    node_values = (node_values .- Statistics.mean(node_values, dims=(3,1))) ./ Statistics.std(node_values, dims=(3,1)) #Z-score normalization

    s, t, w = adjmatrix2edgeindex(adj_matrix; weighted = true)

    x, y = traffic_generate_task(node_values, num_timesteps_in, num_timesteps_out)
    return s, t, w, x, y
end