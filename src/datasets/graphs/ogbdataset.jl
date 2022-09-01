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

`name` is the name  of one of the datasets (listed [here](https://ogb.stanford.edu/docs/dataset_overview/))
available for node prediction, edge prediction, or graph prediction tasks.

# Examples

## Node prediction tasks

```julia-repl
julia> data = OGBDataset("ogbn-arxiv")
OGBDataset ogbn-arxiv:
  metadata    =>    Dict{String, Any} with 17 entries
  graphs      =>    1-element Vector{MLDatasets.Graph}
  graph_data  =>    nothing

julia> data[:]
Graph:
  num_nodes   =>    169343
  num_edges   =>    1166243
  edge_index  =>    ("1166243-element Vector{Int64}", "1166243-element Vector{Int64}")
  node_data   =>    (val_mask = "29799-trues BitVector", test_mask = "48603-trues BitVector", year = "169343-element Vector{Int64}", features = "128×169343 Matrix{Float32}", label = "169343-element Vector{Int64}", train_mask = "90941-trues BitVector")
  edge_data   =>    nothing

julia> data.metadata
Dict{String, Any} with 17 entries:
  "download_name"         => "arxiv"
  "num classes"           => 40
  "num tasks"             => 1
  "binary"                => false
  "url"                   => "http://snap.stanford.edu/ogb/data/nodeproppred/arxiv.zip"
  "additional node files" => ["node_year"]
  "is hetero"             => false
  "task level"            => "node"
  ⋮                       => ⋮

julia> data = OGBDataset("ogbn-mag")
OGBDataset ogbn-mag:
  metadata    =>    Dict{String, Any} with 17 entries
  graphs      =>    1-element Vector{MLDatasets.HeteroGraph}
  graph_data  =>    nothing

julia> data[:]
Heterogeneous Graph:
  num_nodes     =>    Dict{String, Int64} with 4 entries
  num_edges     =>    Dict{Tuple{String, String, String}, Int64} with 4 entries
  edge_indices  =>    Dict{Tuple{String, String, String}, Tuple{Vector{Int64}, Vector{Int64}}} with 4 entries
  node_data     =>    (year = "Dict{String, Vector{Float32}} with 1 entry", features = "Dict{String, Matrix{Float32}} with 1 entry", label = "Dict{String, Vector{Int64}} with 1 entry")
  edge_data     =>    (reltype = "Dict{Tuple{String, String, String}, Vector{Float32}} with 4 entries",)
```

## Edge prediction task

```julia-repl
julia> data = OGBDataset("ogbl-collab")
OGBDataset ogbl-collab:
  metadata    =>    Dict{String, Any} with 15 entries
  graphs      =>    1-element Vector{MLDatasets.Graph}
  graph_data  =>    nothing

julia> data[:]
Graph:
  num_nodes   =>    235868
  num_edges   =>    2358104
  edge_index  =>    ("2358104-element Vector{Int64}", "2358104-element Vector{Int64}")
  node_data   =>    (features = "128×235868 Matrix{Float32}",)
  edge_data   =>    (year = "2×1179052 Matrix{Int64}", weight = "2×1179052 Matrix{Int64}")
```

## Graph prediction task

```julia-repl
julia> data = OGBDataset("ogbg-molhiv")
OGBDataset ogbg-molhiv:
  metadata    =>    Dict{String, Any} with 17 entries
  graphs      =>    41127-element Vector{MLDatasets.Graph}
  graph_data  =>    (labels = "41127-element Vector{Int64}", train_mask = "32901-trues BitVector", val_mask = "4113-trues BitVector", test_mask = "4113-trues BitVector")

julia> data[1]
(graphs = Graph(19, 40), labels = 0)
```

# References

[1] [Open Graph Benchmark: Datasets for Machine Learning on Graphs](https://arxiv.org/pdf/2005.00687.pdf)
"""
struct OGBDataset{GD} <: GraphDataset
    name::String
    metadata::Dict{String, Any}
    graphs::Vector{<:AbstractGraph}
    graph_data::GD
end

function OGBDataset(fullname; dir = nothing)
    metadata = read_ogb_metadata(fullname, dir)
    path = makedir_ogb(fullname, metadata["url"], dir)
    metadata["path"] = path
    if get(metadata, "is hetero", false)
        graph_dicts, graph_data = read_ogb_hetero_graph(path, metadata)
        graphs = ogbdict2heterograph.(graph_dicts)
    else
        graph_dicts, graph_data = read_ogb_graph(path, metadata)
        graphs = ogbdict2graph.(graph_dicts)
    end
    split = read_ogb_split(path, graphs, metadata)
    for key in keys(split)
        if get(metadata, key, nothing) != nothing
            metadata[key] = merge(split[key], metadata[key])
        else
            metadata[key] = split[key]
        end
    end
    return OGBDataset(fullname, metadata, graphs, graph_data)
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
    # edge cases for additional node and edge files
    for additional_keys in ["additional edge files", "additional node files"]
        if !isnothing(metadata[additional_keys])
            metadata[additional_keys] = Vector{String}(split(metadata[additional_keys], ","))
        end
    end
    if prefix == "ogbn"
        metadata["task level"] = "node"
    elseif prefix == "ogbl"
        metadata["task level"] = "link"
    elseif prefix == "ogbg"
        metadata["task level"] = "graph"
    end
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
        # conditions when unzipped folder is our required data dir
        (unzipped == data_dir) || mv(unzipped, data_dir) # none of them are relative path
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

    dict["edge_index"] = read_ogb_file(joinpath(path, "raw", "edge.csv"), Int, transp=false)
    dict["edge_index"] = dict["edge_index"] .+ 1 # from 0-indexing to 1-indexing

    dict["node_features"] = read_ogb_file(joinpath(path, "raw", "node-feat.csv"), Float32)
    dict["edge_features"] = read_ogb_file(joinpath(path, "raw", "edge-feat.csv"), Float32)

    dict["num_nodes"] = read_ogb_file(joinpath(path, "raw", "num-node-list.csv"), Int; tovec=true)
    dict["num_edges"] = read_ogb_file(joinpath(path, "raw", "num-edge-list.csv"), Int; tovec=true)

    # replace later with data from metadata?
    for file in readdir(joinpath(path, "raw"))
    if file ∉ ["edge.csv", "num-node-list.csv", "num-edge-list.csv", "node-feat.csv", "edge-feat.csv"] && file[end-3:end] == ".csv"
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
        end
        num_edge_accum += m

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
            if k ∉ [node_keys; edge_keys]
                dlabels[k] = dict[k]
            end
        end
    end
    labels = isempty(dlabels) ? nothing :
                length(dlabels) == 1 ? first(dlabels)[2] : dlabels

    graph_data = nothing

    return graphs, graph_data
end

function read_ogb_split(path::String, graphs, metadata::Dict)
    splits = readdir(joinpath(path, "split"))
    @assert length(splits) == 1 # TODO check if datasets with multiple splits existin in OGB

    # TODO sometimes splits are given in .pt format
    # Use read_pytorch in src/io.jl to load them.
    if metadata["task level"] in ["node", "graph"]
        split_idx = (train = read_ogb_file(joinpath(path, "split", splits[1], "train.csv"), Int; tovec=true),
                    val = read_ogb_file(joinpath(path, "split", splits[1], "valid.csv"), Int; tovec=true),
                    test = read_ogb_file(joinpath(path, "split", splits[1], "test.csv"), Int; tovec=true))
    else
        split_idx = (train = read_pytorch(joinpath(path, "split", splits[1], "train.pt")),
                    val = read_pytorch(joinpath(path, "split", splits[1], "train.pt")),
                    test = read_pytorch(joinpath(path, "split", splits[1], "train.pt")))
    end

    split_dict = Dict()

    if metadata["task level"] == "node"
        @assert length(graphs) == 1
        num_nodes = graphs[1].num_nodes

        train_mask = split_idx.train == nothing ? nothing : indexes2mask(split_idx.train .+ 1, num_nodes)
        val_mask = split_idx.val == nothing ? nothing : indexes2mask(split_idx.val .+ 1, num_nodes)
        test_mask = split_idx.test == nothing ? nothing : indexes2mask(split_idx.test .+ 1, num_nodes)

        split_dict["node"] = (; split = Dict(splits[1] => [(; train=train_mask, val=val_mask, test=test_mask)]))

    elseif metadata["task level"] == "link"
        @assert length(graphs) == 1

        for key in keys(split_idx)
            split_idx[key]["edge"] .+= 1
        end

        split_dict["edge"] = (; split = Dict(splits[1] => [(; train=split_idx.train, val=split_idx.val, test=split_idx.test)]))

    elseif metadata["task level"] == "graph"
        num_graphs = length(graphs)
        train_mask = split_idx.train == nothing ? nothing : indexes2mask(split_idx.train .+ 1, num_graphs)
        val_mask = split_idx.val == nothing ? nothing : indexes2mask(split_idx.val .+ 1, num_graphs)
        test_mask = split_idx.test == nothing ? nothing : indexes2mask(split_idx.test .+ 1, num_graphs)

        split_dict["graph"] = (; split = Dict(splits[1] => (; train=train_mask, val=val_mask, test=test_mask)))
    end
    return split_dict
end

function read_ogb_hetero_graph(path, metadata)

    dict = Dict{String, Any}()
    num_node_df = read_csv_asdf(joinpath(path, "raw", "num-node-dict.csv"))
    dict["num_nodes"] = Dict(String(node) => Vector{Int}(num) for (node, num) in pairs(eachcol(num_node_df)))
    node_types = sort(collect(keys(dict["num_nodes"])))
    num_graphs = length(dict["num_nodes"][node_types[1]])

    triplet_mat = read_ogb_file(joinpath(path, "raw", "triplet-type-list.csv"), String, transp=false)
    @assert size(triplet_mat)[2] == 3
    triplets = sort([Tuple(triplet[:]) for triplet in eachrow(triplet_mat)])

    dict["edge_indices"] = Dict{Tuple{String, String, String}, Matrix{Int}}()
    dict["num_edges"] = Dict{Tuple{String, String, String}, Any}()
    dict["edge_features"] = Dict{Tuple{String, String, String}, Any}()

    for triplet in triplets
        subdir = joinpath(path, "raw", "relations", join(triplet, "___"))
        dict["edge_indices"][triplet] = read_ogb_file(joinpath(subdir, "edge.csv"), Int, transp=false) .+ 1
        dict["num_edges"][triplet] = read_ogb_file(joinpath(subdir, "num-edge-list.csv"), Int)
        dict["edge_features"][triplet] = read_ogb_file(joinpath(subdir, "edge-feat.csv"), AbstractFloat)
    end

    # Check if the number of graphs are consistent accross node and edge data
    @assert length(dict["num_nodes"][node_types[1]]) == length(dict["num_edges"][triplets[1]])

    dict["node_features"] = Dict{String, Any}()
    for node_type in node_types
        subdir = joinpath(path, "raw", "node-feat", node_type)
        dict["node_features"][node_type] = read_ogb_file(joinpath(subdir, "node-feat.csv"), AbstractFloat)
    end

    for additional_file in metadata["additional node files"]
        node_add_feat = Dict()
        @assert additional_file[1:5] == "node_"

        for node_type in node_types
            subdir = joinpath(path, "raw", "node-feat", node_type)
            node_feat = read_ogb_file(joinpath(subdir, additional_file * ".csv"), Float32)
            isnothing(node_feat) || @assert length(node_feat) == sum(dict["num_nodes"][node_type])
            node_add_feat[node_type] = node_feat
        end
        dict[additional_file] = node_add_feat
    end

    for additional_file in metadata["additional edge files"]
        edge_add_feats = Dict()
        @assert additional_file[1:5] == "edge_"

        for triplet in triplets
            subdir = joinpath(path, "raw", "relations", join(triplet, "___"))

            edge_feat = read_ogb_file(joinpath(subdir, additional_file * ".csv"), AbstractFloat)
            @assert length(edge_feat) == sum(dict["num_edges"][triplet])
            edge_add_feats[triplet] = edge_feat
        end
    dict[additional_file] = edge_add_feats
    end

    if metadata["task level"] == "node"
        dict["node_label"] = Dict()
        nodetype_has_label_df = read_csv_asdf(joinpath(path, "raw", "nodetype-has-label.csv"))
        nodetype_has_label = Dict(String(node) => num[1] for (node, num) in pairs(eachcol(nodetype_has_label_df)))
        for (node_type, has_label) in nodetype_has_label
            @assert node_type ∈ node_types
            if has_label
                dict["node_label"][node_type] = read_ogb_file(joinpath(path, "raw", "node-label", node_type, "node-label.csv"), Int)
            else
                dict["node_label"][node_type] = nothing
            end
        end
    end

    node_keys = [k for k in keys(dict) if startswith(k, "node_")]
    edge_keys = [k for k in keys(dict) if startswith(k, "edge_") && k != "edge_indices"]

    graphs = Dict[]
    num_node_accums = Dict(node_type=> 0 for node_type in node_types)
    num_edge_accums = Dict(triplet=> 0 for triplet in triplets)
    graph_data = nothing

    for i in 1:num_graphs
        graph = Dict{String, Any}()
        graph["num_nodes"] = Dict(k => v[i] for (k, v) in dict["num_nodes"])
        graph["edge_indices"] = Dict()
        for key in vcat(node_keys, edge_keys)
            graph[key] = Dict()
        end

        for triplet in triplets
            edge_indices = dict["edge_indices"][triplet]
            num_edge = dict["num_edges"][triplet][i]
            num_edge_accum = num_edge_accums[triplet]

            if metadata["add_inverse_edge"]
                edge_index = edge_indices[num_edge_accum+1:num_edge_accum+num_edge, :]
                # Compensate for the duplicate/inverse the edges
                s, t = edge_index[:, 1], edge_index[:, 2]
                graph["edge_indices"][triplet] = [s t; t s]

                for k in edge_keys
                    v = dict[k][triplet]
                    if v === nothing
                        graph[k][triplet] = nothing
                    else
                        x = v[:, num_edge_accum+1:num_edge_accum+num_edge]
                        graph[k][triplet] = [x; x]
                    end
                end
            else
                graph["edge_indices"][triplet] = edge_indices[num_edge_accum+1:num_edge_accum+num_edge, :]
                for k in edge_keys
                    v = dict[k][triplet]
                    if v === nothing
                        graph[k][triplet] = nothing
                    else
                        graph[k][triplet] = v[:, num_edge_accum+1:num_edge_accum+num_edge]
                    end
                end
            end
            num_edge_accums[triplet] += num_edge
        end

        for node_type in node_types
            num_node = dict["num_nodes"][node_type][i]
            num_node_accum = num_node_accums[node_type]
            for k in node_keys
                v = dict[k][node_type]
                if v === nothing
                    graph[k][node_type] = nothing
                else
                    graph[k][node_type] = v[:, num_node_accum+1:num_node_accum+num_node]
                end
            end
            num_node_accums[node_type] += num_node
        end

        push!(graphs, graph)
    end
    graph_data = nothing
    return graphs, graph_data
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
    if res !== nothing && T === Any
        res = restrict_array_type(res)
    end
    return res
end


function ogbdict2graph(d::Dict)
    edge_index = d["edge_index"][:,1], d["edge_index"][:,2]
    num_nodes = d["num_nodes"]
    node_data = Dict(Symbol(k[6:end]) => maybesqueeze(v) for (k,v) in d if startswith(k, "node_") && v !== nothing)
    edge_data = Dict(Symbol(k[6:end]) => maybesqueeze(v) for (k,v) in d if startswith(k, "edge_") && k!="edge_index" && v !== nothing)
    node_data = isempty(node_data) ? nothing : (; node_data...)
    edge_data = isempty(edge_data) ? nothing : (; edge_data...)
    return Graph(; num_nodes, edge_index, node_data, edge_data)
end

function ogbdict2heterograph(d::Dict)
    num_nodes = d["num_nodes"]
    edge_indices = Dict(triplet => (ei[:, 1], ei[:, 2])
                        for (triplet, ei) in d["edge_indices"])

    edge_data = Dict(k => Dict{Symbol, Any}() for k in keys(edge_indices))
    for (feature_name, v) in d
        # v is a dict
        # the number of nothing values should not be equal to total number of values
        if startswith(feature_name, "edge_") && feature_name != "edge_indices" && sum(isnothing.(values(v))) < length(v)
            for (edge_key, edge_value) in v
                if !isnothing(edge_value)
                    edge_data[edge_key][Symbol(feature_name[6:end])] = maybesqueeze(edge_value)
                end
            end
        end
    end

    node_data = Dict(k => Dict{Symbol, Any}() for k in keys(num_nodes))
    for (feature_name, v) in d
        if startswith(feature_name, "node_") && sum(isnothing.(values(v))) < length(v)
            for (node_key, node_value) in v
                if !isnothing(node_value)
                    node_data[node_key][Symbol(feature_name[6:end])] = maybesqueeze(node_value)
                end
            end
        end
    end
    node_data = Dict(k => v for (k,v) in node_data if !isempty(v))
    edge_data = Dict(k => v for (k,v) in edge_data if !isempty(v))
    # node_data = isempty(node_data) ? nothing : (; node_data...)
    # edge_data = map(x -> isempty(x) ? nothing : (; x...), edge_data)

    return HeteroGraph(;num_nodes, edge_indices, edge_data, node_data)
end

Base.getindex(data::OGBDataset{Nothing}, ::Colon) = length(data.graphs) == 1 ? data.graphs[1] : data.graphs
Base.getindex(data::OGBDataset, ::Colon) = (; data.graphs, data.graph_data.labels)
Base.getindex(data::OGBDataset{Nothing}, i) = getobs(data.graphs, i)
Base.getindex(data::OGBDataset, i) = getobs((; data.graphs, data.graph_data.labels), i)

# dataset OGBDaataset looks odd
function Base.show(io::IO, ::MIME"text/plain", d::OGBDataset)
    recur_io = IOContext(io, :compact => false)

    print(io, "OGBDataset $(d.name):")  # if the type is parameterized don't print the parameters

    for f in fieldnames(OGBDataset)
        if !startswith(string(f), "_") && f != :name
            fstring = leftalign(string(f), 10)
            print(recur_io, "\n  $fstring  =>    ")
            # show(recur_io, MIME"text/plain"(), getfield(d, f))
            # println(recur_io)
            print(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end
