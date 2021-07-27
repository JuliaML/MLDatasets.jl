data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"CiteSeer"
end

@testset "CiteSeer" begin
    data  = CiteSeer.dataset()
    
    @test data.num_nodes == 3327
    @test data.num_edges == 9104
    @test data.directed == false
    @test size(data.node_features) == (3703, data.num_nodes)
    @test size(data.node_labels) == (data.num_nodes,)
    @test size(data.train_indices) == (120,)
    @test size(data.val_indices) == (500,)
    @test size(data.test_indices) == (1015,)
    @test size(data.adjacency_list) == (data.num_nodes, )
    @test sum(length.(data.adjacency_list)) == (data.num_edges)
    if VERSION >= v"1.6.0"
        @test minimum(minimum.(data.adjacency_list; init=1000)) == 1
        @test maximum(maximum.(data.adjacency_list; init=1000)) == data.num_nodes
    end
end
