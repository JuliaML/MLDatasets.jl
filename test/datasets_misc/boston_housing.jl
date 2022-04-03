d = BostonHousing(as_df=false)
X, Y = d.features, d.targets
names = d.metadata["feature_names"]
@test X isa Matrix{Float64}
@test Y isa Matrix{Float64}
@test names == uppercase.(["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"])
@test size(X) == (13, 506)
@test size(Y) == (1, 506)
@test d[1:2] == (X[:,1:2], Y[:,1:2])
@test d[] === (X, Y)
@test length(d) == 506

@testset "deprecated interface" begin
    X  = BostonHousing.features()
    Y  = BostonHousing.targets()
    names = BostonHousing.feature_names()
    @test X isa Matrix{Float64}
    @test Y isa Matrix{Float64}
    @test names == uppercase.(["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"])
    @test size(X) == (13, 506)
    @test size(Y) == (1, 506)
end