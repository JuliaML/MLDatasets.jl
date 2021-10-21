data_dir = withenv("DATADEPS_ALWAY_ACCEPT"=>"true") do
    datadep"Mutagenesis"
end

@testset "Mutagenesis" begin
    train_x, train_y = Mutagenesis.traindata()
    test_x, test_y = Mutagenesis.testdata()
    val_x, val_y = Mutagenesis.valdata()

    @test length(train_x) == length(train_y) == 100
    @test length(test_x) == length(test_y) == 44
    @test length(val_x) == length(val_y) == 44
end
