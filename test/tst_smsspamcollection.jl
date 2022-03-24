module SMSSpamCollection_Tests
using Test
using MLDatasets

@testset "SMS Spam Collection" begin
    X = SMSSpamCollection.features()
    y = SMSSpamCollection.targets()
    @test X isa Vector
    @test y isa Vector
    @test size(X) == (5574,)
    @test size(y) == (5574,)
end

end # module