
@testset "Cora" begin
    data  = Cora()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 2708
    @test g.num_edges == 10556
    @test size(g.node_data.features) == (1433, g.num_nodes)
    @test size(g.node_data.targets) == (g.num_nodes,)
    @test sum(g.node_data.train_mask) == 140
    @test sum(g.node_data.val_mask) == 500
    @test sum(g.node_data.test_mask) == 1000
    @test g.edge_index isa Tuple{Vector{Int}, Vector{Int}}
    s, t = g.edge_index
    for a in (s, t)
        @test a isa Vector{Int}
        @test length(a) == g.num_edges
        @test minimum(a) == 1
        @test maximum(a) == g.num_nodes 
    end
end

@testset "CiteSeer" begin
    data  = CiteSeer()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 3327
    @test g.num_edges == 9104
    @test size(g.node_data.features) == (3703, g.num_nodes)
    @test size(g.node_data.targets) == (g.num_nodes,)
    @test sum(g.node_data.train_mask) == 120
    @test sum(g.node_data.val_mask) == 500
    @test sum(g.node_data.test_mask) == 1015
    @test g.edge_index isa Tuple{Vector{Int}, Vector{Int}}
    s, t = g.edge_index
    for a in (s, t)
        @test a isa Vector{Int}
        @test length(a) == g.num_edges
        @test minimum(a) == 1
        @test maximum(a) == g.num_nodes 
    end
end

@testset "PubMed" begin
    data  = PubMed()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 19717
    @test g.num_edges == 88648
    @test size(g.node_data.features) == (500, g.num_nodes)
    @test size(g.node_data.targets) == (g.num_nodes,)
    @test sum(g.node_data.train_mask) == 60
    @test sum(g.node_data.val_mask) == 500
    @test sum(g.node_data.test_mask) == 1000
    @test g.edge_index isa Tuple{Vector{Int}, Vector{Int}}
    s, t = g.edge_index
    for a in (s, t)
        @test a isa Vector{Int}
        @test length(a) == g.num_edges
        @test minimum(a) == 1
        @test maximum(a) == g.num_nodes 
    end
end

@testset "KarateClub" begin
    data  = KarateClub()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 34
    @test g.num_edges == 156
    @test size(g.node_data.labels_clubs) == (g.num_nodes,)
    @test sort(unique(g.node_data.labels_clubs)) == [0, 1]
    @test size(g.node_data.labels_comm) == (g.num_nodes,)
    @test sort(unique(g.node_data.labels_comm)) == [0, 1, 2, 3]

    @test g.edge_index isa Tuple{Vector{Int}, Vector{Int}}
    s, t = g.edge_index
    for a in (s, t)
        @test a isa Vector{Int}
        @test length(a) == g.num_edges
        @test minimum(a) == 1
        @test maximum(a) == g.num_nodes 
    end
end


@testset "PolBlogs" begin
    data  = PolBlogs()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 1490
    @test g.num_edges == 19025
    @test size(g.node_data.labels) == (g.num_nodes,)
    @test sort(unique(g.node_data.labels)) == [0, 1]
    
    @test g.edge_index isa Tuple{Vector{Int}, Vector{Int}}
    s, t = g.edge_index
    for a in (s, t)
        @test a isa Vector{Int}
        @test length(a) == g.num_edges
        @test minimum(a) >= 1
        @test maximum(a) <= g.num_nodes 
    end
end

# maybe, maybe, maybe??
@testset "OGBn-mag" begin
    # data = OGBDataset("ogbn-mag")
    # @test data isa AbstractDataset
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph
    # check if the number of ndoes are consistent
    for node_data in g.node_data
        for (node_type, features) in node_data
            @test g.num_nodes[node_type] == size(features)[end]
        end
    end
    # check if the number of edges are consistent
    for edge_data in g.edge_data
        for (edge_type, features) in edge_data
            @test g.num_edges[edge_type] == size(features)[end]
        end
    end
end