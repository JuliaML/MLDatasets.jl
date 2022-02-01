module Titanic_Tests
using Test
using DataDeps
using MLDatasets


@testset "Titanic" begin
    X = Titanic.features()
    Y = Titanic.targets()
    names = Titanic.feature_names()
    @test X isa Matrix{Float64}
    @test Y isa Matrix{Float64}
    @test names == ["Pclass", "Name", "Sex", "Age", "Siblings/Spouses Aboard", "Parents/Children Aboard", "Fare"]
    @test size(X) == (7, 887)
    @test size(Y) == (1, 887)
end

end #module