
@testset "Reddit_full" begin
    data  = Reddit(full=true)
    @test length(data) == 1
    g = data[1]
    @test g.num_nodes == 232965
    @test g.num_edges == 114615892
    @test g.directed == false
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
    @test g.directed == false
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
