d = BostonHousing(as_df=false)
X, Y = d.features, d.targets
@test X isa Matrix{Float64}
@test Y isa Matrix{Float64}
@test d.metadata["feature_names"] == uppercase.(["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"])
@test size(X) == (13, 506)
@test size(Y) == (1, 506)
@test d[2] == (X[:,2], Y[:,2])
@test d[] === (X, Y)
@test length(d) == 506
@test d.dataframe === nothing

d = BostonHousing()
X, Y = d.features, d.targets
@test X isa DataFrame
@test Y isa DataFrame
@test DataFrames.names(X) == uppercase.(["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"])
@test DataFrames.names(Y) == ["MEDV"]
@test size(X) == (506, 13)
@test size(Y) == (506, 1)
@test d[2] == (X[2,:], Y[2,:])
@test d[] === (X, Y)
@test length(d) == 506
@test d.dataframe isa DataFrame
@test size(d.dataframe) == (506, 14)

@testset "deprecated interface" begin
    X  = BostonHousing.features()
    Y  = BostonHousing.targets()
    names = BostonHousing.feature_names()
    @test X isa Matrix{Float64}
    @test Y isa Matrix{Float64}
    @test names == ["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"]
    @test size(X) == (13, 506)
    @test size(Y) == (1, 506)
end
