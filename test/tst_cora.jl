data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"Cora"
end

@testset "Cora" begin
    data  = Cora.dataset()
    
    @test data.num_nodes == 2708
    @test data.num_edges == 10556
    @test data.directed == false
    @test size(data.node_features) == (1433, data.num_nodes)
    @test size(data.node_labels) == (data.num_nodes,)
    @test size(data.train_indices) == (140,)
    @test size(data.val_indices) == (500,)
    @test size(data.test_indices) == (1000,)
    @test size(data.adjacency_list) == (data.num_nodes, )
    @test sum(length.(data.adjacency_list)) == (data.num_edges)
    @test minimum(minimum.(data.adjacency_list)) == 1
    @test maximum(maximum.(data.adjacency_list)) == data.num_nodes
end
