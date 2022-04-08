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

    # TODO remove
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

    # TODO remove
    @testset "deprecated interface" begin
        X  = Iris.features()
        Y  = Iris.labels()
        @test X isa Matrix{Float64}
        @test Y isa Vector{<:AbstractString}
        @test size(X) == (4, 150)
        @test size(Y) == (150,)
    end
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

    @testset "deprecated interface" begin
        train_x, train_y = Mutagenesis.traindata()
        test_x, test_y = Mutagenesis.testdata()
        val_x, val_y = Mutagenesis.valdata()

        @test length(train_x) == length(train_y) == 100
        @test length(test_x) == length(test_y) == 44
        @test length(val_x) == length(val_y) == 44
        # test that label is not contained in features
        @test !any(haskey.(train_x, :mutagenic))
        @test !any(haskey.(test_x, :mutagenic))
        @test !any(haskey.(val_x, :mutagenic))
        # test data is materialized
        @test train_x isa Vector{<:Dict}
        @test test_x isa Vector{<:Dict}
        @test val_x isa Vector{<:Dict}
    end
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

    # TODO remove
    @testset "deprecated interface" begin
        X = Titanic.features()
        Y = Titanic.targets()
        names = Titanic.feature_names()
        @test X isa Matrix
        @test Y isa Matrix
        @test names == feature_names
        @test size(X) == (11, 891)
        @test size(Y) == (1, 891)
    end
end
