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

@testset "deprecated interface" begin
    X = Titanic.features()
    Y = Titanic.targets()
    names = Titanic.feature_names()
    @test X isa Matrix
    @test Y isa Matrix
    @test names == ["PassengerId","Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
    @test size(X) == (11, 891)
    @test size(Y) == (1, 891)
end
