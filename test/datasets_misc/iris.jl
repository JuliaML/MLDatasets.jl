data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"Iris"
end

d = Iris()
X, Y = d.features, d.targets
@test X isa Matrix{Float64}
@test Y isa Matrix{<:AbstractString}
@test size(X) == (4, 150)
@test size(Y) == (1, 150)
@test d[1:2] == (X[:,1:2], Y[:,1:2])
@test d[] === (X, Y)
@test length(d) == 150

@testset "deprecated interface" begin
    X  = Iris.features()
    Y  = Iris.labels()
    @test X isa Matrix{Float64}
    @test Y isa Vector{<:AbstractString}
    @test size(X) == (4, 150)
    @test size(Y) == (150,)
end
