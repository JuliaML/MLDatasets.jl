
@testset "ml-100k" begin
    data = MovieLens("100k")
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph

    num_nodes = Dict("movie" => 1682,
                     "user" => 943)
    num_edges = Dict(("user", "rating", "movie") => 100000)

    for type in keys(num_nodes)
        @test type ∈ g.node_types
        @test g.num_nodes[type] == num_nodes[type]
        node_data = get(g.node_data, type, nothing)
        @test !isnothing(node_data)
        for (key, val) in node_data
            @test key ∈ [:release_date, :genres, :age, :occupation, :zipcode, :gender]
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
            @test key in [:timestamp, :rating]
            @test ndims(val) == 1
            @test size(val)[end] == num_edges[type]
        end
    end
end

@testset "ml-1m" begin
    data = MovieLens("1m")
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph

    num_nodes = Dict("movie" => 3883,
                     "user" => 6040)
    num_edges = Dict(("user", "rating", "movie") => 1000209)

    for type in keys(num_nodes)
        @test type ∈ g.node_types
        @test g.num_nodes[type] == num_nodes[type]
        node_data = get(g.node_data, type, nothing)
        @test !isnothing(node_data)
        for (key, val) in node_data
            @test key ∈ [:genres, :age, :occupation, :zipcode, :gender]
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
            @test key in [:timestamp, :rating]
            @test ndims(val) == 1
            @test size(val)[end] == num_edges[type]
        end
    end
end

@testset "ml-10m" begin
    data = MovieLens("10m")
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph

    num_nodes = Dict("tag" => 95580,
                     "movie" => 10681,
                     "user" => 69878)
    num_edges = Dict(("user", "tag", "movie") => 95580,
                     ("user", "rating", "movie") => 10000054)

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

@testset "ml-20m" begin
    data = MovieLens("20m")
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph

    num_nodes = Dict("tag" => 465564,
                     "movie" => 27278,
                     "user" => 138493)
    num_edges = Dict(("movie", "score", "tag") => 11709768,
                     ("user", "tag", "movie") => 465564,
                     ("user", "rating", "movie") => 20000263)

    for type in keys(num_nodes)
        @test type ∈ g.node_types
        @test g.num_nodes[type] == num_nodes[type]
        @test isempty(g.node_data)
    end

    for type in keys(num_edges)
        @test type ∈ g.edge_types
        @test g.num_edges[type] == num_edges[type]
        @test length(g.edge_indices[type][1]) == num_edges[type]
        @test length(g.edge_indices[type][2]) == num_edges[type]
        edge_data = g.edge_data[type]
        for (key, val) in edge_data
            @test key in [:timestamp, :tag_name, :rating, :score]
            @test ndims(val) == 1
            @test size(val)[end] == num_edges[type]
        end
    end
end

@testset "ml-25m" begin
    data = MovieLens("25m")
    @test length(data) == 1

    g = data[1]
    @test g == data[:]
    @test g isa MLDatasets.HeteroGraph

    num_nodes = Dict("tag" => 1093360,
                     "movie" => 62423,
                     "user" => 162541)
    num_edges = Dict(("movie", "score", "tag") => 15584448,
                     ("user", "tag", "movie") => 1093360,
                     ("user", "rating", "movie") => 25000095)

    for type in keys(num_nodes)
        @test type ∈ g.node_types
        @test g.num_nodes[type] == num_nodes[type]
        @test isempty(g.node_data)
    end

    for type in keys(num_edges)
        @test type ∈ g.edge_types
        @test g.num_edges[type] == num_edges[type]
        @test length(g.edge_indices[type][1]) == num_edges[type]
        @test length(g.edge_indices[type][2]) == num_edges[type]
        edge_data = g.edge_data[type]
        for (key, val) in edge_data
            @test key in [:timestamp, :tag_name, :rating, :score]
            @test ndims(val) == 1
            @test size(val)[end] == num_edges[type]
        end
    end
end

@testset "OGBDataset - ogbn-arxiv" begin
    d = OGBDataset("ogbn-arxiv")
    g = d[:]
    @test g.num_nodes == 169343
    @test g.num_edges == 1166243

    @test sum(count.([g.node_data.train_mask, g.node_data.test_mask, g.node_data.val_mask])) ==
          g.num_nodes
end

@testset "OGBDataset - ogbg-molhiv" begin
    d = OGBDataset("ogbg-molhiv")

    @test sum(count.([
                         d.graph_data.train_mask,
                         d.graph_data.test_mask,
                         d.graph_data.val_mask,
                     ])) == length(d)
end

@testset "Reddit_full" begin
    data = Reddit(full = true)
    @test length(data) == 1
    g = data[1]
    @test g.num_nodes == 232965
    @test g.num_edges == 114615892
    @test size(g.node_data.features) == (602, g.num_nodes)
    @test size(g.node_data.labels) == (g.num_nodes,)
    @test count(g.node_data.train_mask) == 153431
    @test count(g.node_data.val_mask) == 23831
    @test count(g.node_data.test_mask) == 55703
    s, t = g.edge_index
    @test length(s) == length(t) == g.num_edges
    @test minimum(s) == minimum(t) == 1
    @test maximum(s) == maximum(t) == g.num_nodes
end

@testset "Reddit_subset" begin
    data = Reddit(full = false)
    @test length(data) == 1
    g = data[1]
    @test g.num_nodes == 231443
    @test g.num_edges == 23213838
    @test size(g.node_data.features) == (602, g.num_nodes)
    @test size(g.node_data.labels) == (g.num_nodes,)
    @test count(g.node_data.train_mask) == 152410
    @test count(g.node_data.val_mask) == 23699
    @test count(g.node_data.test_mask) == 55334
    s, t = g.edge_index
    @test length(s) == length(t) == g.num_edges
    @test minimum(s) == minimum(t) == 1
    @test maximum(s) == maximum(t) == g.num_nodes
end

@testset "TUDataset - PROTEINS" begin
    data = TUDataset("PROTEINS")

    @test data.num_nodes == 43471
    @test data.num_edges == 162088
    @test data.num_graphs == 1113

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
    @test size(g.node_data.features) == (1, g.num_nodes)
    @test size(g.node_data.targets) == (g.num_nodes,)

    # edge data
    @test g.edge_data === nothing
end

@testset "TUDataset - QM9" begin
    data = TUDataset("QM9")

    @test data.num_nodes == 2333625
    @test data.num_edges == 4823498
    @test data.num_graphs == 129433

    @test data.num_nodes == sum(g -> g.num_nodes, data.graphs)
    @test data.num_edges == sum(g -> g.num_edges, data.graphs)
    @test data.num_edges == sum(g -> length(g.edge_index[1]), data.graphs)
    @test data.num_edges == sum(g -> length(g.edge_index[2]), data.graphs)
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

@testset "TUDataset - Fingerprint" begin
    @test_warn "" TUDataset("Fingerprint")
    data = TUDataset("Fingerprint")

    @test data.num_nodes == 15167
    @test data.num_edges == 24756
    @test data.num_graphs == 2149

    @test data.num_nodes == sum(g -> g.num_nodes, data.graphs)
    @test data.num_edges == sum(g -> g.num_edges, data.graphs)
    @test data.num_edges == sum(g -> length(g.edge_index[1]), data.graphs)
    @test data.num_edges == sum(g -> length(g.edge_index[2]), data.graphs)
    @test data.num_graphs == length(data) == length(data.graphs)

    i = rand(1:length(data))
    @test_throws DimensionMismatch data[i]
    g = data.graphs[i]
    @test g isa Graph
    @test all(1 .<= g.edge_index[1] .<= g.num_nodes)
    @test all(1 .<= g.edge_index[2] .<= g.num_nodes)

    # graph data
    @test size(data.graph_data.targets) == (2800,)

    # node data
    @test size(g.node_data.features) == (2, g.num_nodes)

    # edge data
    @test size(g.edge_data.features) == (2, g.num_edges)
end

@testset "OrganicMaterialsDB" begin
    data = OrganicMaterialsDB(split = :train)
    @test length(data) == 10000
    @test data[1].graphs isa MLDatasets.Graph
    @test data[1].bandgaps isa Number
    @test data[:].graphs isa Vector{MLDatasets.Graph}
    @test data[:].bandgaps isa Vector{<:Number}

    data = OrganicMaterialsDB(split = :test)
    @test length(data) == 2500
end

@testset "METR-LA" begin
    data = METRLA()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 207
    @test g.num_edges == 1722
    @test all(g.node_data.features[1][:,:,1][2:end,1] == g.node_data.targets[1][:,:,1][1:end-1])
end

@testset "PEMS-BAY" begin
    data = PEMSBAY()
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 325
    @test g.num_edges == 2694
    @test all(g.node_data.features[1][:,:,1][2:end,1] == g.node_data.targets[1][:,:,1][1:end-1])
end

@testset "TemporalBrains" begin
    data = TemporalBrains()
    @test data isa AbstractDataset
    @test length(data) == 1000
    g = data[1]
    @test g isa MLDatasets.TemporalSnapshotsGraph

    @test g.num_nodes == [102 for _ in 1:27]
    @test g.num_snapshots == 27
    @test g.snapshots[1] isa MLDatasets.Graph
    @test length(g.snapshots[1].node_data) == 102
end

@testset "WindMillEnergy" begin
    data = WindMillEnergy(size = "small")
    @test data isa AbstractDataset
    @test length(data) == 1
    g = data[1]
    @test g === data[:]
    @test g isa MLDatasets.Graph

    @test g.num_nodes == 11
    @test g.num_edges == 121
    @test all(g.node_data.features[1][:,:,2:end] == g.node_data.features[1][:,:,1:end-1])
end