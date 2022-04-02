module Titanic_Tests
using Test
using DataDeps
using MLDatasets


@testset "Titanic Dataset" begin
    X = Titanic.features()
    Y = Titanic.targets()
    names = Titanic.feature_names()
    
    first_row_expected = [
        1, 3, "Braund, Mr. Owen Harris", "male", 22, 1, 0, "A/5 21171", 7.25, "", "S"
    ]

    @test X isa Matrix{}
    @test Y isa Matrix{}
    @test names == ["PassengerId","Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
    @test size(X) == (11, 891)
    @test size(Y) == (1, 891)
    @test X[:, 1] == first_row_expected
end

end #module