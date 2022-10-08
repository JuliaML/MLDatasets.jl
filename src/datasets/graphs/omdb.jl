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


The OMDB-GAP1 v1.1 fataset from the Organic Materials Database (OMDB) of bulk organic crystals.

The dataset has to be manually downloaded from https://omdb.mathub.io/dataset, 
then unzipped, and  its content placed in the `OrganicMaterialsDB` folder.

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
    DEPNAME = "OrganicMaterialsDB"
    structures = read_chemfile(datafile(DEPNAME, "structures.xyz", dir))
    bandgaps = read_csv(datafile(DEPNAME, "bandgaps.csv", dir), Matrix) |> vec
    graphs = Graph[]
    for frame in structures
        pos = Float32.(Chemfiles.positions(frame))
        z = Int.(Chemfiles.atomic_number.(frame))
        g = Graph(num_nodes=length(z), node_data=(; pos, z))
        push!(graphs, g)
    end
    if split == :train
        graphs = graphs[1:10000]
        bandgaps = bandgaps[1:10000]
    else
        graphs = graphs[10001:end]
        bandgaps = bandgaps[10001:end]
    end

    metadata = Dict{String, Any}(
        "split" => train,
        "size" => length(graphs),
    )

    return OMDB(metadata, graphs, graph_data=(; bandgaps))
end
