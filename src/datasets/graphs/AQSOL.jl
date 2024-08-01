export AQSOL

struct AQSOL <: AbstractDataset
    metadata::Dict{String, Any}
    graphs::Vector{Graph}
end

function __init__()
    register(DataDep(
        "AQSOL",
        """
        Dataset: AQSOL (Aqueous Solubility)
        Website: https://arxiv.org/abs/2003.00982
        """,
        "https://www.dropbox.com/s/lzu9lmukwov12kt/AQSOL_graph_raw.zip?dl=1",
        post_fetch_method = unpack
    ))
end

function AQSOL(split::String="train"; dir=nothing, transform=nothing, pre_transform=nothing, pre_filter=nothing)
    @assert split in ["train", "val", "test"]

    DATA = "asqol_graph_raw/" + split + ".pickle"
    DEPNAME = "ASQOL"
    
    pickle_path = datafile(DEPNAME, DATA, dir)
    
    graphs = read_pickle(pickle_path)
    
    processed_graphs = Vector{Graph}()
    for graph in graphs
        x, edge_attr, edge_index, y = map(convert_array, graph)
        
        x = Array{Float32}(x)
        edge_attr = Array{Float32}(edge_attr)
        edge_index = Array{Int}(edge_index) .+ 1 
        y = [Float32(y)]
        
        if size(edge_index, 2) == 0
            continue  
        end
        
        num_nodes = size(x, 1)
        edge_index_tuple = (edge_index[1, :], edge_index[2, :])
        g = Graph(num_nodes=num_nodes, edge_index=edge_index_tuple, node_data=x, edge_data=edge_attr)
        
        g = Graph(g.num_nodes, g.num_edges, g.edge_index, (g.node_data, y), g.edge_data)
        
        if !isnothing(pre_filter) && !pre_filter(g)
            continue
        end
        
        if !isnothing(pre_transform)
            g = pre_transform(g)
        end
        
        push!(processed_graphs, g)
    end
    
    if !isnothing(transform)
        processed_graphs = transform.(processed_graphs)
    end
    
    metadata = Dict{String, Any}(
        "name" => "AQSOL",
        "split" => split,
        "num_graphs" => length(processed_graphs)
    )
    
    return AQSOL2(metadata, processed_graphs)
end

function atoms()
    return [
        "Br", "C", "N", "O", "Cl", "Zn", "F", "P", "S", "Na", "Al", "Si",
        "Mo", "Ca", "W", "Pb", "B", "V", "Co", "Mg", "Bi", "Fe", "Ba", "K",
        "Ti", "Sn", "Cd", "I", "Re", "Sr", "H", "Cu", "Ni", "Lu", "Pr",
        "Te", "Ce", "Nd", "Gd", "Zr", "Mn", "As", "Hg", "Sb", "Cr", "Se",
        "La", "Dy", "Y", "Pd", "Ag", "In", "Li", "Rh", "Nb", "Hf", "Cs",
        "Ru", "Au", "Sm", "Ta", "Pt", "Ir", "Be", "Ge"
    ]
end

function bonds()
    return ["NONE", "SINGLE", "DOUBLE", "AROMATIC", "TRIPLE"]
end

Base.length(d::AQSOL) = length(d.graphs)
Base.getindex(d::AQSOL, ::Colon) = d.graphs
Base.getindex(d::AQSOL, i) = d.graphs[i]

