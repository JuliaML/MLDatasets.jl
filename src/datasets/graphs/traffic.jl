function traffic_datadir(dname ::String, dir = nothing)
    if dname == "PEMSBAY"
        dir = isnothing(dir) ? datadep"PEMSBAY" : dir
    elseif dname == "METRLA"
        dir = isnothing(dir) ? datadep"METRLA" : dir
    end
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/data/$dname.zip"
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
    adj_matrix = load(joinpath(d, "$(dname).jld2"), "adj_matrix")
    node_features = load(joinpath(d, "$(dname).jld2"), "node_features")
    node_features = permutedims(node_features,(2,3,1))
    return adj_matrix, node_features
end
    
function traffic_generate_task(node_values::AbstractArray, num_timesteps::Int)
    features = []
    targets = []
    for i in 1:size(node_values,3)-num_timesteps
        push!(features, node_values[:,:,i:i+num_timesteps-1])
        push!(targets, reshape(node_values[1,:,i+1:i+num_timesteps], (1, size(node_values, 2),num_timesteps)))
    end
    return features, targets
end

function processed_traffic(dname::String, num_timesteps::Int, dir = nothing, normalize = true)
    create_default_dir(dname)
    d = traffic_datadir(dname, dir)
    adj_matrix, node_values = read_traffic(d, dname)

    if normalize
        node_values = (node_values .- Statistics.mean(node_values, dims=(3,1))) ./ Statistics.std(node_values, dims=(3,1)) #Z-score normalization
    end
    
    s, t, w = adjmatrix2edgeindex(adj_matrix; weighted = true)
    x, y = traffic_generate_task(node_values, num_timesteps )
    
    return s, t, w, x, y
end