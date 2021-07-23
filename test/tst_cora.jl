data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"Cora"
end

@testset "Cora" begin
    data  = Cora.alldata()
    @test data isa NamedTuple

    @test data.edges isa Matrix{Int}
    @test size(data.edges) == (5429, 2)
    @test data.node_labels isa Vector{Int}
    @test size(data.node_labels) == (2708,)
    @test data.directed
end
