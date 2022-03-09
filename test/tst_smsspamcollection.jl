module SMSSpamCollection_Tests
using Test
using MLDatasets

@testset "SMS Spam Collection" begin
    X = SMSSpamCollection.features()
    y = SMSSpamCollection.targets()
    @test X isa Matrix{}
    @test y isa Matrix{}
    @test size(X) == (1, 5574)
    @test size(y) == (1, 5574)
end

end # module