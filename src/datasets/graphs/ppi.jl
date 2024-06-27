function __init__ppi()
    DEPNAME = "PPI"
    LINK = "http://snap.stanford.edu/graphsage/ppi.zip"
    DOCS = "http://snap.stanford.edu/graphsage/"

    register(DataDep(DEPNAME,
                     """
                     Dataset: The $DEPNAME Dataset
                     Website: $DOCS
                     Download Link: $LINK
                     """,
                     LINK,
                     "53aeb76e54fd41b645e7edb48b62929240b89839495396b048086fd212503fbd",
                     post_fetch_method = unpack))
end

"""
    PPI(; full=true, dir=nothing)

The PPI dataset was introduced in Ref [1].
Protein roles—in terms of their cellular functions from gene
ontology—in various protein-protein interaction (PPI) graphs,
with each graph corresponding to a different human tissue.
Positional gene sets are used, motif gene sets and immunological
signatures as features and gene ontology sets as labels (121 in total),
collected from the Molecular Signatures Database.
The average graph contains 2373 nodes, with an average degree of 28.8.


# References
[1]: [Inductive Representation Learning on Large Graphs](https://arxiv.org/abs/1706.02216)
"""
struct PPI <: AbstractDataset
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
end

function PPI(; dir = nothing)
    DATAFILES = [
        "ppi-G.json", "ppi-walks.txt",
        "ppi-class_map.json", "ppi-feats.npy", "ppi-id_map.json",
    ]
    DATA = joinpath.("ppi", DATAFILES)
    DEPNAME = "PPI"


    graph_json = datafile(DEPNAME, DATA[1], dir)

    class_map_json = datafile(DEPNAME, DATA[3], dir)
    id_map_json = datafile(DEPNAME, DATA[5], dir)
    feat_path = datafile(DEPNAME, DATA[4], dir)

    metadata, g = read_graphsage_data(graph_json, class_map_json, id_map_json, feat_path)

    return PPI(metadata, [g])
end

Base.length(d::PPI) = length(d.graphs)
Base.getindex(d::PPI, ::Colon) = d.graphs
Base.getindex(d::PPI, i) = getindex(d.graphs, i)
