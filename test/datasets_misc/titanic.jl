d = Titanic()
X, Y = d.features, d.targets
names = d.feature_names
    
@test X isa Matrix
@test Y isa Matrix{Int}
@test size(X) == (11, 891)
@test size(Y) == (1, 891)
@test names == ["PassengerId","Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
@test d[1:2] == (features=X[:,1:2], targets=Y[:,1:2])
@test d[] === (features=X, targets=Y)
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
