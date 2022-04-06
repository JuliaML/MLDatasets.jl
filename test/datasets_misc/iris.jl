n_obs = 150
n_features = 4
n_targets = 1

feature_names = ["sepallength", "sepalwidth", "petallength", "petalwidth"]
target_names = ["class"]

d = Iris()
test_inmemory_supervised_table_dataset(d;
    n_obs, n_features, n_targets,
    feature_names, target_names)

d = Iris(as_df=false)
test_inmemory_supervised_table_dataset(d;
    n_obs, n_features, n_targets,
    feature_names, target_names,
    Tx=Float64, Ty=AbstractString)


@testset "deprecated interface" begin
    X  = Iris.features()
    Y  = Iris.labels()
    @test X isa Matrix{Float64}
    @test Y isa Vector{<:AbstractString}
    @test size(X) == (4, 150)
    @test size(Y) == (150,)
end
