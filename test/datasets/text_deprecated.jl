
@testset "PTBLM" begin
    x, y = PTBLM.traindata()
    x, y = PTBLM.testdata()

end

@testset "UD_English" begin
    x = UD_English.traindata()
    x = UD_English.devdata()
    x = UD_English.testdata()
end

@testset "SMS Spam Collection" begin
    X = SMSSpamCollection.features()
    y = SMSSpamCollection.targets()
    @test X isa Vector
    @test y isa Vector
    @test size(X) == (5574,)
    @test size(y) == (5574,)
end
