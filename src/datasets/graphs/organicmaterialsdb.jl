function __init__omdb()
    DEPNAME = "OrganicMaterialsDB"
    LINK = "https://omdb.mathub.io/dataset"
    FILE = "https://omdb.mathub.io/dataset/download/gap1_v1.1"

    register(DataDep(DEPNAME,
    """
    Dataset : The Organic Materials Database (OMDB)
    Website : $LINK
    """,
    [],
    # post_fetch_method = unpack
    ))
end

"""
    OrganicMaterialsDB(; split=:train, dir=nothing)

The OMDB-GAP1 v1.1 dataset from the Organic Materials Database (OMDB) of bulk organic crystals.

The dataset has to be manually downloaded from https://omdb.mathub.io/dataset, 
then unzipped and  its file content placed in the `OrganicMaterialsDB` folder.

The dataset contains the following files:

| Filename       | Description                                                                                              |
|----------------|----------------------------------------------------------------------------------------------------------|
| structures.xyz | 12500 crystal structures. Use the first 10000 as training examples and the remaining 2500 as test set.   |
| bandgaps.csv   | 12500 DFT band gaps corresponding to structures.xyz                                                      |
| CODids.csv     | 12500 COD ids cross referencing the Crystallographic Open Database (in the same order as structures.xyz) |

Please cite the paper introducing this dataset: https://arxiv.org/abs/1810.12814
"""
struct OrganicMaterialsDB <: AbstractDataset
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
    graph_data::NamedTuple
end

function OrganicMaterialsDB(; split=:train, dir=nothing)
    @assert split in [:train, :test]
    procfiles = process_data_if_needed(OrganicMaterialsDB; dir)
    if split == :train
        return FileIO.load(procfiles[1], "dataset")
    else
        return FileIO.load(procfiles[2], "dataset")
    end
end

processed_files(::Type{<:OrganicMaterialsDB}) = ["train.jld2", "test.jld2"]
raw_files(::Type{<:OrganicMaterialsDB}) = ["structures.xyz", "bandgaps.csv"]

function process_data_if_needed(::Type{<:OrganicMaterialsDB}; dir=nothing)
    DEPNAME = "OrganicMaterialsDB"
    ddir = datadir(DEPNAME, dir)

    if !(isdir(joinpath(ddir, "processed")))
        mkpath(joinpath(ddir, "processed"))
    end

    procfiles = [joinpath(ddir, "processed", f) for f in processed_files(OrganicMaterialsDB)]
    rawfiles = [joinpath(ddir, f) for f in raw_files(OrganicMaterialsDB)]

    for f in rawfiles
        if !isfile(f)
            error("Please download the OMDB dataset from https://omdb.mathub.io/dataset, 
            then unzip it and place its content in the $ddir folder.")
        end
    end

    for f in procfiles
        if !isfile(f)
            process_data(OrganicMaterialsDB, rawfiles, procfiles)
        end
    end
    return procfiles
end

function process_data(::Type{<:OrganicMaterialsDB}, rawfiles, procfiles)
    structures = read_chemfile(rawfiles[1])
    bandgaps = read_csv(rawfiles[2], Matrix) |> vec
    graphs = Graph[]
    for frame in structures
        pos = Float32.(Chemfiles.positions(frame))
        z = Int.(Chemfiles.atomic_number.(frame))
        g = Graph(num_nodes=length(z), node_data=(; pos, z))
        push!(graphs, g)
    end


    train_graphs = graphs[1:10000]
    train_bandgaps = bandgaps[1:10000]
    train_metadata = Dict{String, Any}(
        "split" => :train,
        "size" => length(graphs),
    )
    train_dataset = OrganicMaterialsDB(train_metadata, train_graphs, (; bandgaps=train_bandgaps))
    FileIO.save(procfiles[1], Dict("dataset" => train_dataset))

    test_graphs = graphs[10001:end]
    test_bandgaps = bandgaps[10001:end]
    test_metadata = Dict{String, Any}(
        "split" => :test,
        "size" => length(graphs),
    )
    test_dataset = OrganicMaterialsDB(test_metadata, test_graphs, (; bandgaps=test_bandgaps))
    FileIO.save(procfiles[2], Dict("dataset" => test_dataset))
end

Base.length(data::OrganicMaterialsDB) = length(data.graphs)

function Base.getindex(data::OrganicMaterialsDB, ::Colon) 
    return (; data.graphs, data.graph_data.bandgaps)
end

function Base.getindex(data::OrganicMaterialsDB, i) 
    return getobs((; data.graphs, data.graph_data...), i)    
end
