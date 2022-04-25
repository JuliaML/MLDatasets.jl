

"""
    Graph(; kws...)

A type representing a graph (a set of nodes and edges) that can also store additional node- edge- and graph- related data.

Graph datasets in MLDatasets.jl contain one or more `Graph` objects.

# Fields 

- num_nodes
- num_edges
- directed
- edge_index
- node_data
- edge_data
- graph_data
"""
Base.@kwdef struct Graph
    num_nodes::Int
    num_edges::Int
    directed::Bool
    edge_index::Tuple{Vector{Int}, Vector{Int}}
    node_data = nothing
    edge_data = nothing
    graph_data = nothing
end


function Base.show(io::IO, d::Graph)    
    recur_io = IOContext(io, :compact => false)
    print(io, "Graph:")
    for f in fieldnames(Graph)
        if !startswith(string(f), "_")
            fstring = leftalign(string(f), 10)
            print(recur_io, "\n  $fstring  =>    ")
            print(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end


function adjlist2edgeindex(adj; inneigs=true)
    s, t = Int[], Int[]     
    for i in 1:length(adj)
        for j in adj[i]
            push!(s, i)
            push!(t, j)
        end
    end

    if inneigs
        return t, s
    else
        return s, t
    end
end
