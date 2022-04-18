data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"Reddit"
end

@testset "Reddit_full" begin
    data  = Reddit.dataset(data=:full)

    @test data.num_nodes == 232965
    @test data.num_edges == 114615892
    @test data.directed == false
    @test size(data.node_features) == (data.num_nodes, 602)
    @test size(data.node_labels) == (data.num_nodes,)
    @test size(data.split["train"]) == (153431,)
    @test size(data.split["val"]) == (23831,)
    @test size(data.split["test"]) == (55703,)
    @test size(data.edge_index) == (data.num_edges, 2)
    @test minimum(data.edge_index) == 1
    @test maximum(data.edge_index) == data.num_nodes
    @test sum(length.(values(data.split))) == data.num_nodes
end

@testset "Reddit_subset" begin
    data  = Reddit.dataset(data=nothing)

    @test data.num_nodes == 231443
    @test data.num_edges == 23213838
    @test data.directed == false
    @test size(data.node_features) == (data.num_nodes, 602)
    @test size(data.node_labels) == (data.num_nodes,)
    @test size(data.split["train"]) == (152410,)
    @test size(data.split["val"]) == (23699,)
    @test size(data.split["test"]) == (55334,)
    @test size(data.edge_index) == (data.num_edges, 2)
    @test minimum(data.edge_index) == 1
    @test maximum(data.edge_index) == data.num_nodes
    @test sum(length.(values(data.split))) == data.num_nodes
end
