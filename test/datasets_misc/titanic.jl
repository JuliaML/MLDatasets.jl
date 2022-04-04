d = Titanic()
X, Y = d.features, d.targets
@test X isa DataFrame
@test Y isa DataFrame
@test size(X) == (891, 11)
@test size(Y) == (891, 1)
@test DataFrames.names(X) == ["PassengerId","Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
@test d[2] == (X[2,:], Y[2,:])
@test d[] === (X, Y)
@test length(d) == 891

d = Titanic(as_df=false)
X, Y = d.features, d.targets
@test X isa Matrix
@test Y isa Matrix{Int}
@test size(X) == (11, 891)
@test size(Y) == (1, 891)
@test d.metadata["feature_names"] == ["PassengerId","Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
@test d[2] == (X[:,2], Y[:,2])
@test d[] === (X, Y)
@test length(d) == 891


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
