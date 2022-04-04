
d = Iris()
X, Y = d.features, d.targets
@test X isa DataFrame
@test Y isa DataFrame
@test size(X) == (150, 4)
@test size(Y) == (150, 1)
@test d[1:2] == (X[1:2,:], Y[1:2,:])
@test d[] === (X, Y)
@test length(d) == 150


d = Iris(as_df=false)
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
