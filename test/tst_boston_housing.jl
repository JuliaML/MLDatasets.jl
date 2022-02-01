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
    @test names == ["crim", "zn", "indus", "chas", "nox", "rm", "age", "dis", "rad", "tax", "ptratio", "b", "lstat"]
    @test size(X) == (13, 506)
    @test size(Y) == (1, 506)
end

end #module
