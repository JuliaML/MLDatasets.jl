"""
Read any of the citation network datasets “Cora”, “CiteSeer” and “PubMed” 
from the “Revisiting Semi-Supervised Learning with Graph Embeddings” paper. 
Nodes represent documents and edges represent citation links. 

Data collected from 
https://github.com/kimiyoung/planetoid/raw/master/data
"""
function read_planetoid_data(DEPNAME; dir=nothing, reverse_edges=true)
    name = lowercase(DEPNAME)
    
    x  = read_planetoid_file(DEPNAME, "ind.$(name).x", dir)
    y  = read_planetoid_file(DEPNAME, "ind.$(name).y", dir)
    allx  = read_planetoid_file(DEPNAME, "ind.$(name).allx", dir)
    ally  = read_planetoid_file(DEPNAME, "ind.$(name).ally", dir)
    tx  = read_planetoid_file(DEPNAME, "ind.$(name).tx", dir)
    ty  = read_planetoid_file(DEPNAME, "ind.$(name).ty", dir) 
    graph = read_planetoid_file(DEPNAME, "ind.$(name).graph", dir)
    test_indices = read_planetoid_file(DEPNAME, "ind.$(name).test.index", dir)

    ntrain = size(x, 2)
    train_indices = 1:ntrain
    val_indices = ntrain+1:ntrain+500
    sorted_test_index = sort(test_indices)

    if name == "citeseer"
        # There are some isolated nodes in the Citeseer graph, resulting in
        # not consecutive test indices. We need to identify them and add them
        # as zero vectors to `tx` and `ty`.
        len_test_indices = (maximum(test_indices) - minimum(test_indices)) + 1

        tx_ext = zeros(size(tx,1), len_test_indices)
        tx_ext[:, sorted_test_index .- minimum(test_indices) .+ 1] .= tx
        ty_ext = zeros(len_test_indices)
        ty_ext[sorted_test_index .- minimum(test_indices) .+ 1] = ty

        tx, ty = tx_ext, ty_ext
    end
    x = hcat(allx, tx)
    y = vcat(ally, ty)
    x[:, test_indices] = x[:, sorted_test_index]
    y[test_indices] = y[sorted_test_index]
    test_indices = size(allx,2)+1:size(x,2)
    num_nodes = size(x, 2)

    adj_list = [Int[] for i=1:num_nodes]
    for (i, neigs) in pairs(graph) # graph is dictionay representing the adjacency list
        neigs = unique(neigs) # remove duplicated edges
        neigs = filter(x -> x!=i, neigs)# remove self-loops
        append!(adj_list[i+1], neigs .+ 1) # convert to 1-indexed
    end
    if reverse_edges
        for (i, neigs) in enumerate(adj_list)
            for j in neigs
                i ∉ adj_list[j] && push!(adj_list[j], i)
            end
        end
    end

    node_data = (features=x, targets=y, 
                train_indices, 
                val_indices, 
                test_indices)


    node_data = (features=x, targets=y, 
                train_mask = indexes2mask(train_indices, num_nodes),
                val_mask = indexes2mask(val_indices, num_nodes),
                test_mask = indexes2mask(test_indices, num_nodes))

    metadata = Dict{String,Any}(
        "name" => name,
        "num_classes" => length(unique(y)),
        "classes" => sort(unique(y))
    )

    edge_index = adjlist2edgeindex(adj_list)
    
    g = Graph(; num_nodes, 
                edge_index, 
                node_data)

    return metadata, g
end

function read_planetoid_file(DEPNAME, name, dir)
    filename = datafile(DEPNAME, name, dir)
    if endswith(name, "test.index")
        out = 1 .+ vec(readdlm(filename, Int))
    else
        out = read_pickle(filename)
        if out isa SparseMatrixCSC
            out = Matrix(out)
        end
        if out isa Matrix
            out = collect(out')
        end
    end
    if endswith(name, "y")
        out = map(y->y[1], argmax(out, dims=1)) |> vec
    end
    return out
end
