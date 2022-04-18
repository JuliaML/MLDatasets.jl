@testset "BostonHousing" begin
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
end

@testset "Iris" begin
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
end

@testset "Mutagenesis" begin
    dtrain = Mutagenesis(split=:train)
    dtest = Mutagenesis(split=:test)
    dval = Mutagenesis(split=:val)
    dall = Mutagenesis(split=:all)

    train_x, train_y = dtrain[]
    test_x, test_y = dtest[]
    val_x, val_y = dval[]
    all_x, all_y = dall[]

    @test length(train_x) == length(train_y) == 100
    @test length(test_x) == length(test_y) == 44
    @test length(val_x) == length(val_y) == 44
    @test length(all_x) == length(all_y) == 188

    # test that label is not contained in features
    @test !any(haskey.(train_x, :mutagenic))
    @test !any(haskey.(test_x, :mutagenic))
    @test !any(haskey.(val_x, :mutagenic))
    # test data is materialized
    @test train_x isa Vector{<:Dict}
    @test test_x isa Vector{<:Dict}
    @test val_x isa Vector{<:Dict}

    x, y = dtrain[1:2]
    @test x isa Vector{Dict{Symbol, Any}}
    @test length(x) == 2
    @test y isa Vector{Int}
    @test length(y) == 2
end

@testset "Titanic" begin
    n_obs = 891
    n_features = 11
    n_targets = 1
    feature_names = ["PassengerId","Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
    target_names = ["Survived"]

    d = Titanic()
    test_inmemory_supervised_table_dataset(d;
        n_obs, n_features, n_targets,
        feature_names, target_names)

    
    d = Titanic(as_df=false)
    test_inmemory_supervised_table_dataset(d;
        n_obs, n_features, n_targets,
        feature_names, target_names, 
        Tx=Any, Ty=Int)

    @test isequal(d[1].features, [1, 3, "Braund, Mr. Owen Harris", "male", 22, 1, 0, "A/5 21171", 7.25, missing, "S"])
end
