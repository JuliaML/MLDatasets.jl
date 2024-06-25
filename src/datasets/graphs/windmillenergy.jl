function __init__windmillenergy()
    DEPNAME = "WindMillEnergy"
    LINK = "https://graphmining.ai/temporal_datasets/"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """))
end

function windmillenergy_datadir(size::String, dir = nothing)
    dir = isnothing(dir) ? datadep"WindMillEnergy" : dir
    if size == "small" || size == "medium" || size == "large"
        LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/data/windmill_output_$(size).json"
    else
        print("Please choose a valid size: small, medium or large")
    end 
    if length(readdir((dir))) == 0
        DataDeps.fetch_default(LINK, dir)
    end
    @assert isdir(dir)
    return dir
end

function generate_task(data::AbstractArray, num_timesteps_in::Int, num_timesteps_out::Int)
    features = []
    targets = []
    for i in 1:(size(data,3)-num_timesteps_in-num_timesteps_out)
        push!(features, data[:,:,i:i+num_timesteps_in-1])
        push!(targets, data[:,:,i+num_timesteps_in:i+num_timesteps_in+num_timesteps_out-1])
    end
    return features, targets
end

function create_windmillenergy_dataset(size::String, normalize::Bool, num_timesteps_in::Int, num_timesteps_out::Int, dir)
    name_file = joinpath(dir, "windmill_output_$(size).json")
    data = read_json(name_file)
    src = zeros(Int, length(data["edges"]))
    dst = zeros(Int, length(data["edges"]))
    for (i, edge) in data["edges"]
        src[i] = edge[1] + 1
        dst[i] = edge[2] + 1
    end
    weights = Float32.(data["weights"])
    feat = stack(Float32.(data["block"]))
    feat = reshape(feat, (1, size(feat, 1), size(feat, 2)))

    if normalize
        feat = (feat .- Statistics.mean(feat, dims=(2))) ./ Statistics.std(feat, dims=(2)) #Z-score normalization
    end

    x, y = generate_task(feat, num_timesteps_in, num_timesteps_out)

    g = Graph(; edge_index = (src, dst),
                edge_data = weights,
                node_data = (features = x, targets = y))
    return g
end

"""
    WindMillEnergy(; size, normalize=true, num_timesteps_in=8, num_timesteps_out=8, dir=nothing)

The WindMillEnergy dataset contains a collection hourly energy output of windmills from a European country for more than 2 years. 

`WindMillEnergy` is a graph with nodes representing windmills. The edge weights represent the strength of the relationship between the windmills. The number of nodes is fixed and depends on the size of the dataset, 11 for `small`, 26 for `medium`, and 319 for `large`.

The node features and targets are the hourly energy output of the windmills.

# Keyword Arguments

- `size::String`: The size of the dataset, can be `small`, `medium`, or `large`.
- `normalize::Bool`: Whether to normalize the data using Z-score normalization. Default is `true`.
- `num_timesteps_in::Int`: The number of time steps for the input features. Default is `8`.
- `num_timesteps_out::Int`: The number of time steps for the target values. Default is `8`.
- `dir::String`: The directory to save the dataset. Default is `nothing`.
"""
function WindMillEnergy(;size::String, normalize::Bool = true, num_timesteps_in::Int = 8 , num_timesteps_out::Int = 8, dir = nothing)
    create_default_dir("WindMillEnergy")
    dir = windmillenergy_datadir(size, dir)
    g = create_windmillenergy_dataset(size, normalize, num_timesteps_in, num_timesteps_out, dir)
    return WindMillEnergy([g])
end

Base.length(d::WindMillEnergy) = length(d.graphs)
Base.getindex(d::WindMillEnergy, ::Colon) = d.graphs[1]
Base.getindex(d::WindMillEnergy, i) = getindex(d.graphs, i)