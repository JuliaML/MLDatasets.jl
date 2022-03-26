data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"PolBlogs"
end

@testset "PolBlogs" begin
    adj = PolBlogs.adjacency()
    lables = PolBlogs.lables()
    @test size(adj) == (19025,2)
    @test size(lables) == (1490,)
end