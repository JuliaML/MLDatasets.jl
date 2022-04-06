n_obs = 150
n_features = 4
n_targets = 1

d = Iris()
test_inmemory_supervised_table_dataset(d;
    n_obs, n_features, n_targets)

d = Iris(as_df=false)
test_inmemory_supervised_table_dataset(d;
    n_obs, n_features, n_targets, 
    Tx=Float64, Ty=AbstractString)


@testset "deprecated interface" begin
    X  = Iris.features()
    Y  = Iris.labels()
    @test X isa Matrix{Float64}
    @test Y isa Vector{<:AbstractString}
    @test size(X) == (4, 150)
    @test size(Y) == (150,)
end
