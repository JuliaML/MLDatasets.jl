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
        hdataset = HDF5Dataset("test.h5", ["d1"])
        cdataset = CachedDataset(hdataset, 5)

        @test numobs(cdataset) == numobs(hdataset)
        @test cdataset.cache == getobs(hdataset, 1:5)
        @test all(getobs(cdataset, i) == getobs(hdataset, i) for i in 1:10)

        cleanup_hdf5dataset_test()
    end
end
