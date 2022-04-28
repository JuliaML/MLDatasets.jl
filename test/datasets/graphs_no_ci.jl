
@testset "Reddit_full" begin
    data  = Reddit(full=true)
    @test length(data) == 1
    g = data[1]
    @test g.num_nodes == 232965
    @test g.num_edges == 114615892
    @test size(g.node_data.features) == (602, g.num_nodes)
    @test size(g.node_data.labels) == (g.num_nodes,)
    @test size(data.metadata["split"]["train"]) == (153431,)
    @test size(data.metadata["split"]["val"]) == (23831,)
    @test size(data.metadata["split"]["test"]) == (55703,)
    s, t = g.edge_index
    @test length(s) == length(t) == g.num_edges
    @test minimum(s) == minimum(t) == 1
    @test maximum(s) == maximum(t) == g.num_nodes
    @test sum(length.(values(data.metadata["split"]))) == g.num_nodes
end

@testset "Reddit_subset" begin
    data  = Reddit(full=false)
    @test length(data) == 1
    g = data[1]
    @test g.num_nodes == 231443
    @test g.num_edges == 23213838
    @test size(g.node_data.features) == (602, g.num_nodes)
    @test size(g.node_data.labels) == (g.num_nodes,)
    @test size(data.metadata["split"]["train"]) == (152410,)
    @test size(data.metadata["split"]["val"]) == (23699,)
    @test size(data.metadata["split"]["test"]) == (55334,)
    s, t = g.edge_index
    @test length(s) == length(t) == g.num_edges
    @test minimum(s) == minimum(t) == 1
    @test maximum(s) == maximum(t) == g.num_nodes
    @test sum(length.(values(data.metadata["split"]))) == g.num_nodes
end


@testset "TUDataset - PROTEINS" begin
    data  = TUDataset("PROTEINS")
    
    @test data.num_nodes == 43471
    @test data.num_edges == 162088
    @test data.num_graphs == 1113

    @test data.num_nodes == sum(g->g.num_nodes, data.graphs)
    @test data.num_edges == sum(g->g.num_edges, data.graphs)
    @test data.num_edges == sum(g->length(g.edge_index[1]), data.graphs)
    @test data.num_edges == sum(g->length(g.edge_index[2]), data.graphs)
    @test data.num_graphs == length(data) == length(data.graphs)
    
    i = rand(1:length(data))
    di = data[i]
    @test di isa NamedTuple
    g, targets = di.graphs, di.targets
    @test targets == 1
    @test g isa Graph
    @test all(1 .<= g.edge_index[1] .<= g.num_nodes)
    @test all(1 .<= g.edge_index[2] .<= g.num_nodes)
    
    # graph data 
    @test size(data.graph_data.targets) == (data.num_graphs,)

    # node data
    @test size(g.node_data.features) == (1, g.num_nodes)
    @test size(g.node_data.targets) == (g.num_nodes,)
    
    # edge data
    @test g.edge_data === nothing
end

@testset "TUDataset - QM9" begin
    data  = TUDataset("QM9")

    @test data.num_nodes == 2333625
    @test data.num_edges == 4823498
    @test data.num_graphs == 129433

    @test data.num_nodes == sum(g->g.num_nodes, data.graphs)
    @test data.num_edges == sum(g->g.num_edges, data.graphs)
    @test data.num_edges == sum(g->length(g.edge_index[1]), data.graphs)
    @test data.num_edges == sum(g->length(g.edge_index[2]), data.graphs)
    @test data.num_graphs == length(data) == length(data.graphs)
    
    i = rand(1:length(data))
    g, features = data[i]
    @test g isa Graph
    @test all(1 .<= g.edge_index[1] .<= g.num_nodes)
    @test all(1 .<= g.edge_index[2] .<= g.num_nodes)
    
    # graph data 
    @test size(data.graph_data.features) == (19, data.num_graphs)

    # node data
    @test size(g.node_data.features) == (16, g.num_nodes)
    
    # edge data
    @test size(g.edge_data.features) == (4, g.num_edges)
end

