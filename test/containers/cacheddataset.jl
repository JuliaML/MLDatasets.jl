@testset "CachedDataset" begin
    @testset "CachedDataset(::FileDataset)" begin
        files = setup_filedataset_test()
        fdataset = FileDataset("root", "*.csv")
        cdataset = CachedDataset(fdataset)

        @test numobs(cdataset) == numobs(fdataset)
        @test cdataset.cache == getobs(fdataset, 1:numobs(fdataset))
        @test all(getobs(cdataset, i) == getobs(fdataset, i) for i in 1:numobs(fdataset))

        cleanup_filedataset_test()
    end

    @testset "CachedDataset(::HDF5Dataset)" begin
        paths, datas = setup_hdf5dataset_test()
        hdataset = HDF5Dataset("test.h5", "d1")
        cdataset = CachedDataset(hdataset, 5)

        @test numobs(cdataset) == numobs(hdataset)
        @test cdataset.cache isa Matrix{Float64}
        @test cdataset.cache == getobs(hdataset, 1:5)
        @test all(getobs(cdataset, i) == getobs(hdataset, i) for i in 1:10)

        close(hdataset)
        cleanup_hdf5dataset_test()
    end

    @testset "CachedDataset(::JLD2Dataset)" begin
        paths, datas = setup_jld2dataset_test()
        jdataset = JLD2Dataset("test.jld2", "d1")
        cdataset = CachedDataset(jdataset, 5)

        @test numobs(cdataset) == numobs(jdataset)
        @test cdataset.cache isa Matrix{Float64}
        @test cdataset.cache == getobs(jdataset, 1:5)
        @test all(@inferred(getobs(cdataset, i)) == getobs(jdataset, i) for i in 1:10)

        close(jdataset)
        cleanup_jld2dataset_test()
    end
end
