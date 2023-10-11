function __init__temporalbrains()
    DEPNAME = "TemporalBrains"
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/index.html"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """))
end


function tb_datadir(dir = nothing)
    dir = isnothing(dir) ? datadep"TemporalBrains" : dir
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/data/LabelledTBN.zip"
    if length(readdir((dir))) == 0
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "LabelledTBN.zip"))
        # conditions when unzipped folder is our required data dir
        cd(currdir)
    end
    @assert isdir(dir)
    return dir
end


function create_tbdataset(dir, thre)
    name_filelabels = joinpath(dir, "LabelledTBN", "labels.txt")
    filelabels = open(name_filelabels, "r")
    temporalgraphs = Vector{MLDatasets.TemporalSnapshotsGraph}(undef, 1000)

    for (i,line) in enumerate(eachline(filelabels))
        id, gender, age = split(line)
        name_network_file = joinpath(dir, "LabelledTBN", "networks", id * "_ws60_wo30_tuk0_pearson_schaefer_100.txt")
        
        data = readdlm(name_network_file,',',Float32; skipstart = 1) 
    
        data_thre = view(data,view(data,:,4) .> thre,:)
        data_thre_int = Int.(view(data_thre,:,1:3))

        activation = [zeros(Float32, 102) for _ in 1:27]
        for t in 1:27
             for n in 1:102
                rows = (view(data_thre_int,:,1).==n .&& view(data_thre_int,:,3).==t)
                activation[t][n] = mean(view(data_thre,rows,4))
             end
        end

        temporalgraphs[i] = TemporalSnapshotsGraph(num_nodes=ones(Int,27)*102, edge_index = (data_thre_int[:,1], data_thre_int[:,2], data_thre_int[:,3]), node_data= activation, graph_data= (g = gender, a = age))
    end
    return temporalgraphs
end

"""
    TemporalBrains(; dir = nothing, threshold_value = 0.6)

The TemporalBrains dataset contains a collection of temporal brain networks of 1000 subjects obtained from resting-state fMRI data from the [Human Connectome Project (HCP)](https://www.humanconnectome.org/study/hcp-young-adult/document/extensively-processed-fmri-data-documentation).

The number of nodes is fixed for each of the 27 snapshots at 102, instead, the edges change over time.
    
The feature of a node represents the average activation of the node in that snapshot.

Each graph has a label representing their gender ("M" for male and "F" for female) and age range (22-25, 26-30,31-35 and 36+) contained as a named tuple in `graph_data`.

The `threshold_value` is used to binarize the edge weights and is set to 0.6 by default.
"""
struct TemporalBrains <: AbstractDataset
    graphs::Vector{MLDatasets.TemporalSnapshotsGraph}
end

function TemporalBrains(;threshold_value = 0.6, dir=nothing)
    create_default_dir("TemporalBrains")
    dir = tb_datadir(dir)
    graphs = create_tbdataset(dir, threshold_value)
    return TemporalBrains(graphs)
end

Base.length(d::TemporalBrains) = length(d.graphs)
Base.getindex(d::TemporalBrains, ::Colon) = d.graphs[1]
Base.getindex(d::TemporalBrains, i) = getindex(d.graphs, i)
