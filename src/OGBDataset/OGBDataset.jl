export OGBDataset

using DataDeps
using DelimitedFiles: readdlm

function __init__ogbdataset()
    DEPNAME = "OGBDataset"
    LINK = "http://snap.stanford.edu/ogb/data"
    DOCS = "https://ogb.stanford.edu/docs/dataset_overview/"
    
    # NOT WORKING AS EXPECTED
    function fetch_method(remote_filepath, local_directory_path)
        if endswith(remote_filepath, "nodeproppred/master.csv")
            local_filepath = joinpath(local_directory_path, "nodeproppred_metadata.csv")
            download(remote_filepath, local_filepath)
        elseif endswith(remote_filepath, "linkproppred/master.csv")
            local_filepath = joinpath(local_directory_path, "linkproppred_metadata.csv")
            download(remote_filepath, local_filepath)
        elseif endswith(remote_filepath, "graphproppred/master.csv")
            local_filepath = joinpath(local_directory_path, "graphproppred_metadata.csv")
            download(remote_filepath, local_filepath)
        else 
            local_filepath = DataDeps.fetch_default(remote_filepath, local_directory_path)
        end
        return local_filepath
    end

    register(DataDep(
        DEPNAME,
        """
        Dataset: The $DEPNAME dataset.
        Website: $DOCS
        Download Link: $LINK
        """,
        ["https://raw.githubusercontent.com/snap-stanford/ogb/master/ogb/nodeproppred/master.csv",      
        "https://raw.githubusercontent.com/snap-stanford/ogb/master/ogb/linkproppred/master.csv",      
        "https://raw.githubusercontent.com/snap-stanford/ogb/master/ogb/graphproppred/master.csv",
        ],
        fetch_method=fetch_method
    ))
end


"""
    OGBDataset(name; dir=nothing)

# Examples

```julia
data = OGBDataset("ogbn-proteins") # a node-level task

graph = data[1]

data = OGBDataset("ogbl-collab") # an edge-level task

data = OGBDataset("ogbg-molhiv") # a graph-level task
"""
struct OGBDataset
    name::String
    path::String
    metadata::Dict
    graphs::Vector{Dict}
end

function OGBDataset(fullname; dir=nothing)
    path = datadir_ogbdataset(fullname, dir)
    
    
    g = read_ogb_graph(path)
    metadata = read_ogb_metadata(path, fullname)
    return OGBDataset(fullname, path, metadata, [g])
end

function read_ogb_metadata(path, fullname)
    prefix, name = split(fullname, "-")
    if prefix == "ogbn"
        path_metadata = joinpath(path, "..", "nodeproppred_metadata.csv")
    elseif prefix == "ogbl"
        path_metadata = joinpath(path, "..", "linkproppred_metadata.csv")
    elseif prefix == "ogbg"
        path_metadata = joinpath(path, "..", "graphproppred_metadata.csv")
    else 
        return nothing
    end
    df = read_csv(path_metadata)
    @assert fullname ∈ names(df)
    metadata = Dict(String(r[1]) => r[2] for r in eachrow(df[!,[names(df)[1], fullname]]))
    return metadata
end

function datadir_ogbdataset(fullname, dir = nothing)
    dir = isnothing(dir) ? datadep"OGBDataset" : dir
    @assert contains(fullname, "-") "The full name should be provided, e.g. ogbn-arxiv"
    prefix, name = split(fullname, "-")
    prefix = prefix == "ogbn" ? "nodeproppred" :
             prefix == "ogbl" ? "linkproppred" :
             prefix == "ogbg" ? "graphproppred" : error("wrong prefix")
    LINK = "http://snap.stanford.edu/ogb/data/$prefix/$name.zip"
    d  = joinpath(dir, name)
    if !isdir(d)
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "$name.zip"))
        for (root, dirs, files) in walkdir(dir)
            for file in files
                if endswith(file, r"zip|gz")
                    cd(root)
                    DataDeps.unpack(joinpath(root, file))
                end
            end
        end
        cd(currdir)
    end
    @assert isdir(d)

    return d
end

function read_ogb_graph(path)
    dict = Dict{String, Any}()
    
    dict["edge_index"] = read_ogb_file(joinpath(path, "raw", "edge.csv"), Int, transp=false)
    dict["edge_index"] = dict["edge_index"] .+ 1 # from 0-indexing to 1-indexing
        
    dict["node_feat"] = read_ogb_file(joinpath(path, "raw", "node-feat.csv"), Float32)
    dict["edge_feat"] = read_ogb_file(joinpath(path, "raw", "edge-feat.csv"), Float32)
    dict["node_label"] = read_ogb_file(joinpath(path, "raw", "node-label.csv"), Int)
    
    dict["num_nodes"] = read_ogb_file(joinpath(path, "raw", "num-node-list.csv"), Int; tovec=true)
    dict["num_edges"] = read_ogb_file(joinpath(path, "raw", "num-edge-list.csv"), Int; tovec=true)
    
    for file in readdir(joinpath(path, "raw"))
        if file ∉ ["edge.csv", "num-node-list.csv", "num-edge-list.csv", "node-feat.csv", "edge-feat.csv", "node-label.csv"]
            propname = replace(split(file,".")[1], "-" => "_")
            dict[propname] = read_ogb_file(joinpath(path, "raw", file), Any)
        end
    end
    
    splits = readdir(joinpath(path, "split"))
    @assert length(splits) == 1 # TODO check if datasets with multiple splits existin in OGB
    # TODO sometimes splits are given in .pt format
    dict["train_idx"] = read_ogb_file(joinpath(path, "split", splits[1], "train.csv"), Int; tovec=true)
    dict["val_idx"] = read_ogb_file(joinpath(path, "split", splits[1], "valid.csv"), Int; tovec=true)
    dict["test_idx"] = read_ogb_file(joinpath(path, "split", splits[1], "test.csv"), Int; tovec=true)
    if dict["train_idx"] !== nothing 
        dict["train_idx"] = dict["train_idx"] .+ 1
    end
    if dict["val_idx"] !== nothing 
        dict["val_idx"] = dict["val_idx"] .+ 1
    end
    if dict["test_idx"] !== nothing 
        dict["test_idx"] = dict["test_idx"] .+ 1
    end
    return dict
end

function read_ogb_file(p, T; tovec=false, transp=true)
    res = isfile(p) ? read_csv(p, Matrix{T}, header=false) : nothing
    if tovec && res !== nothing
        @assert size(res, 1) == 1 || size(res, 2) == 1
        res = vec(res)
    end
    if transp && res !== nothing && !tovec
        res = collect(res')
    end
    if res !== nothing T === Any
        # attempt conversion
        if all(x -> x isa Integer, res)
            res = Int.(res)
        elseif all(x -> x isa AbstractFloat, res)
            res = Float32.(res)
        elseif all(x -> x isa String, res)
            res = String.(res)
        end
    end
    return res
end

Base.length(data::OGBDataset, i) = getindex(data.graphs)
Base.getindex(data::OGBDataset, i) = getindex(data.graphs, i)
