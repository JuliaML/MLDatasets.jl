@testset "MPI-FAUST" begin
    train_data  = FAUST()
    test_data  = FAUST(:test)
    @assert length(train_data.scans) == 100
    @assert length(train_data.scans) == length(train_data.registrations)
    @assert length(train_data.scans) == length(train_data.labels)
    @assert length(test_data.scans) == 200
end
