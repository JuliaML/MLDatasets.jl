module BostonHousing_Tests
using Test
using DataDeps
using MLDatasets


@testset "Boston Housing" begin
    X = BostonHousing.features()
    Y = BostonHousing.targets()
    names = BostonHousing.feature_names()
    @test X isa Matrix{Float64}
    @test Y isa Matrix{Float64}
    @test names == ["x1", "Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
    @test size(X) == (13, 506)
    @test size(Y) == (1, 506)
end

end #module
