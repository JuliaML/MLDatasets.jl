n_obs = 506
n_features = 13
n_targets = 1
feature_names = ["CRIM", "ZN", "INDUS", "CHAS", "NOX", "RM", "AGE", "DIS", "RAD", "TAX", "PTRATIO", "B", "LSTAT"]
target_names = ["MEDV"]

d = BostonHousing()
test_inmemory_supervised_table_dataset(d;
    n_obs, n_features, n_targets, 
    feature_names, target_names)

d = BostonHousing(as_df=false)
test_inmemory_supervised_table_dataset(d;
    n_obs, n_features, n_targets,
    feature_names, target_names, 
    Tx=Float64, Ty=Float64)

@testset "deprecated interface" begin
    X  = BostonHousing.features()
    Y  = BostonHousing.targets()
    names = BostonHousing.feature_names()
    @test X isa Matrix{Float64}
    @test Y isa Matrix{Float64}
    @test names == lowercase.(feature_names)
    @test size(X) == (13, 506)
    @test size(Y) == (1, 506)
end
