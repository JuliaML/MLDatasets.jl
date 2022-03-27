data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"PolBlogs"
end

@testset "PolBlogs" begin
    adj = PolBlogs.adjacency()
    labels = PolBlogs.labels()
    @test adj isa Matrix{Int64}
    @test labels isa Matrix{Int64}
    @test size(adj) == (19025,2)
    @test size(labels) == (1490,1)
end