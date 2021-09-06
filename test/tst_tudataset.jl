data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"TUDataset"
end

@testset "TUDataset - PROTEINS" begin
    data  = TUDataset("PROTEINS")
    
    @test data.num_nodes == 43471
    @test data.num_edges == 162088
    @test data.num_graphs === 1113

    @test length(data.source) == data.num_edges 
    @test length(data.target) == data.num_edges 
    
    @test size(data.node_attributes) == (1, data.num_nodes)
    @test data.edge_attributes === nothing
    @test data.graph_attributes === nothing
    
    @test size(data.node_labels) == (data.num_nodes,)
    @test data.edge_labels === nothing
    @test size(data.graph_labels) == (data.num_graphs,)

    @test length(data.graph_indicator) == data.num_nodes
    @test all(sort(unique(data.graph_indicator)) .== 1:data.num_graphs)  
end

@testset "TUDataset - QM9" begin
    data  = TUDataset("QM9")
    
    @test data.num_nodes == 2333625
    @test data.num_edges == 4823498
    @test data.num_graphs === 129433

    @test length(data.source) == data.num_edges 
    @test length(data.target) == data.num_edges 
    
    @test size(data.node_attributes) == (16, data.num_nodes)
    @test size(data.edge_attributes) == (4, data.num_edges)
    @test size(data.graph_attributes) == (19, data.num_graphs)
    
    @test data.node_labels === nothing
    @test data.edge_labels === nothing
    @test data.graph_labels === nothing

    @test length(data.graph_indicator) == data.num_nodes
    @test all(sort(unique(data.graph_indicator)) .== 1:data.num_graphs)  
end
