data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"TUDataset"
end

@testset "TUDataset - PROTEINS" begin
    data  = TUDataset("PROTEINS")
    
    @test data.num_nodes == 43471
    @test data.num_edges == 162088
    @test data.num_graphs == 1113

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

    @testset "indexing" begin
        d1, d2 = data[5], data[6]
        d12 = data[5:6]
    
        @test d12.num_nodes == d1.num_nodes + d2.num_nodes
        @test d12.num_edges == d1.num_edges + d2.num_edges
        @test d12.num_graphs == d1.num_graphs + d2.num_graphs == 2
    
        @test length(d12.source) == d12.num_edges 
        @test length(d12.target) == d12.num_edges 
        @test length(d1.source) == d1.num_edges 
        @test length(d1.target) == d1.num_edges 
        @test length(d2.source) == d2.num_edges 
        @test length(d2.target) == d2.num_edges 
        
        @test length(d12.graph_indicator) == d12.num_nodes
        @test length(d1.graph_indicator) == d1.num_nodes
        @test length(d2.graph_indicator) == d2.num_nodes
    
        @test all(d1.graph_indicator .== 1)
        @test all(d2.graph_indicator .== 1)
        @test sort(unique(d12.graph_indicator)) == [1,2]
    end
end

@testset "TUDataset - QM9" begin
    data  = TUDataset("QM9")
    
    @test data.num_nodes == 2333625
    @test data.num_edges == 4823498
    @test data.num_graphs == 129433

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


    @testset "indexing" begin
        d1, d2 = data[5], data[6]
        d12 = data[5:6]
    
        @test d12.num_nodes == d1.num_nodes + d2.num_nodes
        @test d12.num_edges == d1.num_edges + d2.num_edges
        @test d12.num_graphs == d1.num_graphs + d2.num_graphs == 2
    
        @test length(d12.source) == d12.num_edges 
        @test length(d12.target) == d12.num_edges 
        @test length(d1.source) == d1.num_edges 
        @test length(d1.target) == d1.num_edges 
        @test length(d2.source) == d2.num_edges 
        @test length(d2.target) == d2.num_edges 
        
        @test length(d12.graph_indicator) == d12.num_nodes
        @test length(d1.graph_indicator) == d1.num_nodes
        @test length(d2.graph_indicator) == d2.num_nodes
    
        @test all(d1.graph_indicator .== 1)
        @test all(d2.graph_indicator .== 1)
        @test sort(unique(d12.graph_indicator)) == [1,2]

        @test size(d12.node_attributes) == (16, d12.num_nodes)
        @test size(d12.edge_attributes) == (4, d12.num_edges)
        @test size(d12.graph_attributes) == (19, d12.num_graphs)
        @test size(d1.node_attributes) == (16, d1.num_nodes)
        @test size(d1.edge_attributes) == (4, d1.num_edges)
        @test size(d1.graph_attributes) == (19, d1.num_graphs)
        @test size(d2.node_attributes) == (16, d2.num_nodes)
        @test size(d2.edge_attributes) == (4, d2.num_edges)
        @test size(d2.graph_attributes) == (19, d2.num_graphs)
    end
end
