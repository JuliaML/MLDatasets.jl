
@testset "CiteSeer" begin
    data = CiteSeer()
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

@testset "Cora" begin
    data = Cora()
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

@testset "KarateClub" begin
    data = KarateClub()
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
    data = PolBlogs()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 1490
    @test g.num_edges == 19025
    @test size(g.node_data.labels) == (g.num_nodes,)
    @test sort(unique(g.node_data.labels)) == [0, 1]
    @test g.node_data.names isa Vector{String}
    @test size(g.node_data.names) == (g.num_nodes,)

    @test g.edge_index isa Tuple{Vector{Int}, Vector{Int}}
    s, t = g.edge_index
    for a in (s, t)
        @test a isa Vector{Int}
        @test length(a) == g.num_edges
        @test minimum(a) >= 1
        @test maximum(a) <= g.num_nodes
    end
end

@testset "PubMed" begin
    data = PubMed()
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

# maybe, maybe, maybe??
Sys.iswindows() || @testset "OGBn-mag" begin
    data = OGBDataset("ogbn-mag")
    # @test data isa AbstractDataset
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph

    num_nodes = Dict("paper" => 736389,
                     "author" => 1134649,
                     "institution" => 8740,
                     "field_of_study" => 59965)
    num_edges = Dict(("author", "affiliated_with", "institution") => 1043998,
                     ("author", "writes", "paper") => 7145660,
                     ("paper", "cites", "paper") => 5416271,
                     ("paper", "has_topic", "field_of_study") => 7505078)

    for type in keys(num_nodes)
        @test type ∈ g.node_types
        @test g.num_nodes[type] == num_nodes[type]
        node_data = get(g.node_data, type, nothing)
        isnothing(node_data) || for (key, val) in node_data
            @test key ∈ [:year, :features, :label, :train_mask, :test_mask, :val_mask]
            if key == :features
                @test size(val)[1] == 128
            end
            @test size(val)[end] == num_nodes[type]
        end
    end

    for type in keys(num_edges)
        @test type ∈ g.edge_types
        @test g.num_edges[type] == num_edges[type]
        @test length(g.edge_indices[type][1]) == num_edges[type]
        @test length(g.edge_indices[type][2]) == num_edges[type]
        edge_data = g.edge_data[type]
        for (key, val) in edge_data
            @test key == :reltype
            @test ndims(val) == 1
            @test size(val)[end] == num_edges[type]
        end
    end
end

@testset "OGBl-ddi" begin
    data = OGBDataset("ogbl-ddi")
    # @test data isa AbstractDataset
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 4267
    @test g.num_edges == 2135822
    @test g.edge_index isa Tuple{Vector{Int}, Vector{Int}}
    s, t = g.edge_index
    for a in (s, t)
        @test a isa Vector{Int}
        @test length(a) == g.num_edges
        @test minimum(a) == 1
        @test maximum(a) == g.num_nodes
    end
    for key in keys(g.edge_data)
        @assert key ∈ [:train_dict, :val_dict, :test_dict]
        s, t = g.edge_data[key]["edge"]
        for a in (s, t)
            @test a isa Vector{Int}
            @test minimum(a) >= 1
            @test maximum(a) <= g.num_nodes
        end
        if haskey(g.edge_data[key], "edge_neg")
            s, t = g.edge_data[key]["edge_neg"]
            for a in (s, t)
                @test a isa Vector{Int}
                @test minimum(a) >= 1
                @test maximum(a) <= g.num_nodes
            end
        end
    end
end

@testset "ml-latest-small" begin
    data = MovieLens("latest-small")
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph

    num_nodes = Dict("tag" => 3683,
                     "movie" => 9742,
                     "user" => 610)
    num_edges = Dict(("user", "rating", "movie") => 100836,
                     ("user", "tag", "movie") => 3683)

    for type in keys(num_nodes)
        @test type ∈ g.node_types
        @test g.num_nodes[type] == num_nodes[type]
        node_data = get(g.node_data, type, nothing)
        isnothing(node_data) || for (key, val) in node_data
            @test size(val)[end] == num_nodes[type]
        end
    end

    for type in keys(num_edges)
        @test type ∈ g.edge_types
        @test g.num_edges[type] == num_edges[type]
        @test length(g.edge_indices[type][1]) == num_edges[type]
        @test length(g.edge_indices[type][2]) == num_edges[type]
        edge_data = g.edge_data[type]
        for (key, val) in edge_data
            @test key in [:timestamp, :tag_name, :rating]
            @test ndims(val) == 1
            @test size(val)[end] == num_edges[type]
        end
    end
end

@testset "TUDataset - Cuneiform" begin
    data = TUDataset("Cuneiform")

    @test data.num_nodes == 5680
    @test data.num_edges == 23922
    @test data.num_graphs == 267

    @test data.num_nodes == sum(g -> g.num_nodes, data.graphs)
    @test data.num_edges == sum(g -> g.num_edges, data.graphs)
    @test data.num_edges == sum(g -> length(g.edge_index[1]), data.graphs)
    @test data.num_edges == sum(g -> length(g.edge_index[2]), data.graphs)
    @test data.num_graphs == length(data) == length(data.graphs)

    i = rand(1:length(data))
    di = data[i]
    @test di isa NamedTuple
    g, targets = di.graphs, di.targets
    @test targets isa Int
    @test g isa Graph
    @test all(1 .<= g.edge_index[1] .<= g.num_nodes)
    @test all(1 .<= g.edge_index[2] .<= g.num_nodes)

    # graph data
    @test size(data.graph_data.targets) == (data.num_graphs,)

    # node data
    @test size(g.node_data.features) == (3, g.num_nodes)
    @test size(g.node_data.targets) == (2, g.num_nodes)

    # edge data
    @test size(g.edge_data.features) == (2, g.num_edges)
    @test size(g.edge_data.targets) == (g.num_edges,)
end

@testset "AQSOL" begin
    split_counts = Dict(:train => 7985, :val => 998, :test => 999)
    for split in [:train, :val, :test]
        data = AQSOL(split=split)
        @test data isa AbstractDataset
        @test data.split == split
        @test length(data) == data.metadata["n_observations"]
        @test length(data.graphs) == split_counts[split]

        for (i, g) in enumerate(data)
            @test g isa MLDatasets.Graph

            s, t = g.edge_index
            @test all(1 .<= s .<= g.num_nodes)
            @test all(1 .<= t .<= g.num_nodes)

        end
    end
end
