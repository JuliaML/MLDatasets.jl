function __init__chickenpox()
    DEPNAME = "ChickenPox"
    LINK = "https://graphmining.ai/temporal_datasets/"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """))
end

function chickenpox_datadir(dir = nothing)
    dir = isnothing(dir) ? datadep"ChickenPox" : dir
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/data/chickenpox.json"
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

function create_chickenpox_dataset( normalize::Bool, num_timesteps_in::Int, num_timesteps_out::Int, dir)
    name_file = joinpath(dir, "chickenpox.json")
    data = read_json(name_file)
    src = zeros(Int, length(data["edges"]))
    dst = zeros(Int, length(data["edges"]))
    for (i, edge) in enumerate(data["edges"])
        src[i] = edge[1] + 1
        dst[i] = edge[2] + 1
    end
    f = Float32.(stack(data["FX"]))
    f = reshape(f, 1, size(f, 1), size(f, 2))

    metadata = Dict(key => value + 1 for (key, value) in data["node_ids"])

    if normalize
        f = (f .- Statistics.mean(f, dims=(2))) ./ Statistics.std(f, dims=(2)) #Z-score normalization
    end

    x, y = generate_task(f, num_timesteps_in, num_timesteps_out)

    g = Graph(; edge_index = (src, dst),
                node_data = (features = x, targets = y))
    return g, metadata
end

"""
    ChickenPox(; normalize= true, num_timesteps_in = 8 , num_timesteps_out = 8, dir = nothing)

The ChickenPox dataset contains county-level chickenpox cases in Hungary between 2004 and 2014.

`ChickenPox` is composed of a graph with nodes representing counties and edges representing the neighborhoods, and a metadata dictionary containing the correspondence between the node indices and the county names. 

The node features are the number of weekly chickenpox cases in each county.

The dataset was taken from the [Pytorch Geometric Temporal repository](https://pytorch-geometric-temporal.readthedocs.io/en/latest/modules/dataset.html#torch_geometric_temporal.dataset.chickenpox.ChickenpoxDatasetLoader) and more information about the dataset can be found in the paper ["Chickenpox Cases in Hungary: a Benchmark Dataset for
Spatiotemporal Signal Processing with Graph Neural Networks"](https://arxiv.org/pdf/2102.08100).


# Keyword Arguments
- `normalize::Bool`: Whether to normalize the data using Z-score normalization. Default is `true`.
- `num_timesteps_in::Int`: The number of time steps for the input features. Default is `8`.
- `num_timesteps_out::Int`: The number of time steps for the target values. Default is `8`.
- `dir::String`: The directory to save the dataset. Default is `nothing`.
"""
struct ChickenPox <: AbstractDataset
    metadata::Dict{Symbol, Any}
    graphs::Vector{Graph}
end

function ChickenPox(; normalize::Bool = true, num_timesteps_in::Int = 8 , num_timesteps_out::Int = 8, dir = nothing)
    create_default_dir("ChickenPox")
    dir = chickenpox_datadir(dir)
    g, metadata = create_chickenpox_dataset(normalize, num_timesteps_in, num_timesteps_out, dir)
    return ChickenPox(metadata, [g])
end

Base.length(d::ChickenPox) = length(d.graphs)
Base.getindex(d::ChickenPox, ::Colon) = d.graphs[1]
Base.getindex(d::ChickenPox, i) = getindex(d.graphs, i)