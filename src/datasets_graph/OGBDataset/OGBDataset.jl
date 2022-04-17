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

The collection of datasets from the [Open Graph Benchmark: Datasets for Machine Learning on Graphs](https://arxiv.org/abs/2005.00687)
paper. 

`name` is the name  of one of the dasets (listed [here](https://ogb.stanford.edu/docs/dataset_overview/))
available for node prediction, edge prediction, or graph prediction tasks.

The `OGBDataset` type stores the graphs internally as dictionary objects. 
The key "edge_index" contains `2 x num_edges`, where the first and second
column contain the source and target nodes of each edge respectively.

# Examples

## Node prediction tasks

```julia-repl
julia> data = OGBDataset("ogbn-arxiv")
OGBDataset{Vector{Any}}:
  name => ogbn-arxiv
  path => /home/carlo/.julia/datadeps/OGBDataset/arxiv
  metadata => Dict{String, Any} with 15 entries
  graphs => 1-element Vector{Dict}
  labels => 1-element Vector{Any}
  split => Dict{String, Any} with 3 entries


julia> data.metadata
Dict{String, Any} with 15 entries:
  "num classes"           => 40
  "binary"                => false
  "is hetero"             => false
  "eval metric"           => "acc"
  "task type"             => "multiclass classification"
  "version"               => 1
  "split"                 => "time"
  "download_name"         => "arxiv"
  "num tasks"             => 1
  "url"                   => "http://snap.stanford.edu/ogb/data/nodeproppred/arxiv.zip"
  "additional node files" => "node_year"
  "add_inverse_edge"      => false
  "has_node_attr"         => true
  "additional edge files" => nothing
  "has_edge_attr"         => false

julia> data.split
Dict{String, Any} with 3 entries:
  "test_idx"  => [347, 399, 452, 481, 489, 491, 527, 538, 541, 603  …  169334, 169335, 169336, 169337, 169338, 169339, 169340, 169341, 169342, 169343]
  "train_idx" => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10  …  169110, 169112, 169113, 169114, 169115, 169116, 169118, 169146, 169149, 169252]
  "val_idx"   => [350, 358, 367, 383, 394, 422, 430, 436, 468, 470  …  169089, 169096, 169108, 169111, 169128, 169156, 169177, 169186, 169262, 169297]

julia> length(data)
1

julia> graph, labels = data[1];

julia> graph
Dict{String, Any} with 6 entries:
  "edge_index" => [104448 13092; 15859 47284; … ; 45119 162538; 45119 72718]
  "edge_feat"  => nothing
  "node_feat"  => Float32[-0.057943 -0.1245 … -0.138236 -0.029875; -0.05253 -0.070665 … 0.040885 0.268417; … ; -0.172796 -0.372111 … -0.041253 0.077647; -0.140059 -0.301036 … -0.376132 -0.091018]
  "num_nodes"  => 169343
  "node_year"  => [2013 2015 … 2020 2020]
  "num_edges"  => 1166243

julia> source, target = graph["edge_index][:,1], graph["edge_index][:,2];
```

## Edge prediction task

```julia-repl
julia> data = OGBDataset("ogbl-collab")
OGBDataset{Nothing}:
  name => ogbl-collab
  path => /home/carlo/.julia/datadeps/OGBDataset/collab
  metadata => Dict{String, Any} with 13 entries
  graphs => 1-element Vector{Dict}
  labels => nothing
  split => Dict{String, Any} with 3 entries

julia> graph = data[1]  # no labels for this dataset
Dict{String, Any} with 7 entries:
  "edge_index"  => [150990 224882; 150990 224882; … ; 221742 135759; 207233 140615]
  "edge_feat"   => nothing
  "node_feat"   => Float32[-0.177486 -0.237488 … 0.004236 -0.035025; -0.10298 0.022193 … 0.031942 -0.118059; … ; 0.003879 0.062124 … 0.05208 -0.176961; -0.276317 -0.081464 … -0.201557 -0.258715]
  "num_nodes"   => 235868
  "edge_year"   => [2004 2002 … 2006 1984; 2004 2002 … 2006 1984]
  "edge_weight" => [2 1 … 1 1; 2 1 … 1 1]
  "num_edges"   => 2358104
```

## Graph prediction task

```julia-repl
julia> data = OGBDataset("ogbg-molhiv")
OGBDataset{Matrix{Int64}}:
  name => ogbg-molhiv
  path => /home/carlo/.julia/datadeps/OGBDataset/molhiv
  metadata => Dict{String, Any} with 15 entries
  graphs => 41127-element Vector{Dict}
  labels => 1×41127 Matrix{Int64}
  split => Dict{String, Any} with 3 entries

julia> length(data)
41127

julia> graph, labels = data[10]
(Dict{String, Any}("edge_index" => [-202 -201; -201 -200; … ; -198 -184; -201 -202], "node_feat" => Float32[7.0 6.0 … 7.0 7.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], "edge_feat" => Float32[0.0 0.0 … 0.0 1.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 1.0], "num_nodes" => 20, "num_edges" => 42), [0])

julia> graph, labels = data[10];

julia> graph
Dict{String, Any} with 5 entries:
  "edge_index" => [1 2; 2 3; … ; 5 19; 2 1]
  "edge_feat"  => Float32[0.0 0.0 … 0.0 1.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 1.0]
  "node_feat"  => Float32[7.0 6.0 … 7.0 7.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0]
  "num_nodes"  => 20
  "num_edges"  => 42

julia> labels
1-element Vector{Int64}:
 0
```
"""
struct OGBDataset{L} <: AbstractDataset
    name::String
    split::Symbol
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
    labels::L
end

function OGBDataset(fullname; split=:train, dir = nothing)
    metadata = read_ogb_metadata(fullname, dir)
    path = makedir_ogb(fullname, metadata["url"], dir)
    metadata["path"] = path
    
    graphs, labels, split_idx = read_ogb_graph(path, metadata)
    return OGBDataset(fullname, split, metadata, graphs, labels)
end

function read_ogb_metadata(fullname, dir = nothing)
    dir = isnothing(dir) ? datadep"OGBDataset" : dir
    @assert contains(fullname, "-") "The full name should be provided, e.g. ogbn-arxiv"
    prefix, name = split(fullname, "-")
    if prefix == "ogbn"
        path_metadata = joinpath(dir, "nodeproppred_metadata.csv")
    elseif prefix == "ogbl"
        path_metadata = joinpath(dir, "linkproppred_metadata.csv")
    elseif prefix == "ogbg"
        path_metadata = joinpath(dir, "graphproppred_metadata.csv")
    else 
        @assert "The dataset name should start with ogbn, ogbl, or ogbg."
    end
    df = read_csv(path_metadata)
    @assert fullname ∈ names(df)
    metadata = Dict{String, Any}(String(r[1]) => parse_pystring(r[2]) for r in eachrow(df[!,[names(df)[1], fullname]]))
    return metadata
end

function makedir_ogb(fullname, url, dir = nothing)
    root_dir = isnothing(dir) ? datadep"OGBDataset" : dir
    @assert contains(fullname, "-") "The full name should be provided, e.g. ogbn-arxiv"
    prefix, name = split(fullname, "-")
    data_dir = joinpath(root_dir, name)
    if !isdir(data_dir)
        local_filepath = DataDeps.fetch_default(url, root_dir)
        currdir = pwd()
        cd(root_dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(local_filepath)
        unzipped = local_filepath[1:findlast('.', local_filepath)-1]
        mv(unzipped, data_dir) 
        for (root, dirs, files) in walkdir(data_dir)
            for file in files
                if endswith(file, r"zip|gz")
                    cd(root)
                    DataDeps.unpack(joinpath(root, file))
                end
            end
        end
        cd(currdir)
    end
    @assert isdir(data_dir)

    return data_dir
end

## See https://github.com/snap-stanford/ogb/blob/master/ogb/io/read_graph_raw.py
function read_ogb_graph(path, metadata)
    dict = Dict{String, Any}()
    
    edge_index = read_ogb_file(joinpath(path, "raw", "edge.csv"), Int, transp=false)
    edge_index = dict["edge_index"] .+ 1 # from 0-indexing to 1-indexing
        
    dict["node_feat"] = read_ogb_file(joinpath(path, "raw", "node-feat.csv"), Float32)
    dict["edge_feat"] = read_ogb_file(joinpath(path, "raw", "edge-feat.csv"), Float32)
    
    dict["num_nodes"] = read_ogb_file(joinpath(path, "raw", "num-node-list.csv"), Int; tovec=true)
    dict["num_edges"] = read_ogb_file(joinpath(path, "raw", "num-edge-list.csv"), Int; tovec=true)
    
    for file in readdir(joinpath(path, "raw"))
        if file ∉ ["edge.csv", "num-node-list.csv", "num-edge-list.csv", "node-feat.csv", "edge-feat.csv"]
            propname = replace(split(file,".")[1], "-" => "_")
            dict[propname] = read_ogb_file(joinpath(path, "raw", file), Any)

            # from https://github.com/snap-stanford/ogb/blob/5e9d78e80ffd88787d9a1fdfdf4079f42d171565/ogb/io/read_graph_raw.py
            # # hack for ogbn-proteins
            # if additional_file == 'node_species' and osp.exists(osp.join(raw_dir, 'species.csv.gz')):
            #     os.rename(osp.join(raw_dir, 'species.csv.gz'), osp.join(raw_dir, 'node_species.csv.gz'))
        end
    end

    node_keys = [k for k in keys(dict) if startswith(k, "node_")]
    edge_keys = [k for k in keys(dict) if startswith(k, "edge_") && k != "edge_index"]
    # graph_keys = [k for k in keys(dict) if startswith(k, "graph_")] # no graph-level features in official implementation
    
    num_graphs = length(dict["num_nodes"])
    @assert num_graphs == length(dict["num_edges"])

    graphs = Dict[]
    num_node_accum = 0
    num_edge_accum = 0
    for i in 1:num_graphs
        graph = Dict{String, Any}()
        n, m = dict["num_nodes"][i], dict["num_edges"][i]
        graph["num_nodes"] = n
        graph["num_edges"] = metadata["add_inverse_edge"] ? 2*m : m

        # EDGE FEATURES
        if metadata["add_inverse_edge"]
            ei = dict["edge_index"][num_edge_accum+1:num_edge_accum+m, :]
            s, t = ei[:,1], ei[:,2]
            graph["edge_index"] = [s t; t s]
            
            for k in edge_keys
                v = dict[k]
                if v === nothing
                    graph[k] = nothing
                else 
                    x = v[:, num_edge_accum+1:num_edge_accum+m]
                    graph[k] = [x; x]
                end
            end
        else
            graph["edge_index"] = dict["edge_index"][num_edge_accum+1:num_edge_accum+m, :]
            
            for k in edge_keys
                v = dict[k]
                if v === nothing
                    graph[k] = nothing
                else 
                    graph[k] = v[:, num_edge_accum+1:num_edge_accum+m]
                end
            end
            num_edge_accum += m
        end

        # NODE FEATURES
        for k in node_keys
            v = dict[k]
            if v === nothing
                graph[k] = nothing
            else 
                graph[k] = v[:, num_node_accum+1:num_node_accum+n]
            end
        end
        num_node_accum += n

        push!(graphs, graph)
    end

    # PROCESS LABELS
    dlabels = Dict{String, Any}()
    for k in keys(dict)
        if contains(k, "label")
            if k in [node_keys; edge_keys]
                labels = []
                for g in graphs
                    push!(labels, g[k])
                    delete!(g, k)
                end
                dlabels[k] = labels
            else
                dlabels[k] = dict[k]
            end
        end
    end
    labels = isempty(dlabels) ? nothing : 
             length(dlabels) == 1 ? first(dlabels)[2] : dlabels

    dsplit = Dict{String, Any}()
    splits = readdir(joinpath(path, "split"))
    @assert length(splits) == 1 # TODO check if datasets with multiple splits existin in OGB
    # TODO sometimes splits are given in .pt format
    dsplit["train_idx"] = read_ogb_file(joinpath(path, "split", splits[1], "train.csv"), Int; tovec=true)
    dsplit["val_idx"] = read_ogb_file(joinpath(path, "split", splits[1], "valid.csv"), Int; tovec=true)
    dsplit["test_idx"] = read_ogb_file(joinpath(path, "split", splits[1], "test.csv"), Int; tovec=true)
    if dsplit["train_idx"] !== nothing 
        dsplit["train_idx"] = dsplit["train_idx"] .+ 1
    end
    if dsplit["val_idx"] !== nothing 
        dsplit["val_idx"] = dsplit["val_idx"] .+ 1
    end
    if dsplit["test_idx"] !== nothing 
        dsplit["test_idx"] = dsplit["test_idx"] .+ 1
    end
    return graphs, labels, dsplit
end

function read_ogb_file(p, T; tovec = false, transp = true)
    res = isfile(p) ? read_csv(p, Matrix{T}, header=false) : nothing
    if tovec && res !== nothing
        @assert size(res, 1) == 1 || size(res, 2) == 1
        res = vec(res)
    end
    if transp && res !== nothing && !tovec
        res = collect(res')
    end
    if res !== nothing T === Any
        res = restrict_array_type(res)
    end
    return res
end

Base.length(data::OGBDataset) = length(data.graphs)

function Base.getindex(data::OGBDataset, i)
    if data.labels === nothing
        getindex(data.graphs, i)
    else
        getobs((data.graphs, data.labels), i) 
    end
end
