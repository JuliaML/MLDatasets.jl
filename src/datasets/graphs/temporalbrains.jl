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

function create_tbdataset(dir)
    name_filelabels = joinpath(dir, "LabelledTBN", "labels.txt")
    filelabels = open(name_filelabels, "r")
    temporalgraphs = Vector{MLDatasets.TemporalSnapshotsGrapgs}(undef, 1000)

    for (i,line) in enumerate(eachline(filelabels))
        id, gender, age = split(line)
        
        name_network_file = joinpath(dir, "LabelledTBN", "networks", id * "_ws60_wo30_tuk0_pearson_schaefer_100.txt")
        
        data = readdlm(name_network_file,','; skipstart = 1) 
        edata = [data[data[:,3].==t,4] for t in 1:27]

        temporalgraphs[i] = TemporalSnapshotsGraph(num_nodes=ones(27).*102, edge_index = (data[:,1],data[:,2],data[:,3]), edge_data = edata, graph_data= (g = gender, a = age))
    end
    return temporalgraphs
end

struct TemporalBrains <: AbstractDataset
    graphs::Vector{TemporalSnapshotsGraph}
end

function TemporalBrains(; dir=nothing)
    create_default_dir("TemporalBrains")
    dir = tb_datadir(dir)
    graphs = create_tbdataset(dir)
    return TemporalBrains(graphs)
end

Base.length(d::TemporalBrains) = length(d.graphs)
Base.getindex(d::TemporalBrains, ::Colon) = d.graphs[1]
Base.getindex(d::TemporalBrains, i) = getindex(d.graphs, i)
