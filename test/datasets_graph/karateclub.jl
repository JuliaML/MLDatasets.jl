@testset "KarateClub" begin
    data = KarateClub
    edge_idx = data.edge_index()
    club_labels = data.labels(:club)
    com_labels = data.labels(:community)

    @test size(edge_idx) == (2,)
    @test size(edge_idx[1]) == (156,)
    @test size(edge_idx[2]) == (156,)
    @test size(com_labels) == (34,)
    @test size(club_labels) == (34,)
    @test maximum(club_labels) == 1
    @test minimum(club_labels) == 0
    @test length(unique(club_labels)) == 2
    @test maximum(com_labels) == 3
    @test minimum(com_labels) == 0
    @test length(unique(com_labels)) == 4
end