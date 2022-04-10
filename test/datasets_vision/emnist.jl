
if parse(Bool, get(ENV, "CI", "false"))
    @info "CI detected: skipping dataset download"
else
    data_dir = datadep"EMNIST"

    n_features = (28, 28)
    n_targets = 1

    for (name, n_obs) in [(:balanced,  (112800, 18800)),
                          (:byclass,  (697932, 116323)),
                          (:bymerge,  (697932, 116323)),
                          (:digits,  (240000, 40000)),
                          (:letters,  (124800, 20800)),
                          (:mnist,  (60000, 10000))]
        
        d = EMNIST(name)

        @test d.name == name
        @test d.split == :train
        @test extrema(d.features) == (0, 1)
        @test convert2image(d, 1) isa AbstractMatrix{<:Gray}
        @test convert2image(d, 1:2) isa AbstractArray{<:Gray, 3}

        test_supervised_array_dataset(d;
            n_features, n_targets, n_obs=n_obs[1],
            Tx=Float32, Ty=Int,
            conv2img=true)
        
        
        d = EMNIST(name, split=:test, Tx=UInt8)

        @test d.name == name
        @test d.split == :test
        @test extrema(d.features) == (0, 255)
        @test convert2image(d, 1) isa AbstractMatrix{<:Gray}
    
        test_supervised_array_dataset(d;
            n_features, n_targets, n_obs=n_obs[2],
            Tx=UInt8, Ty=Int,
            conv2img=true)
    end
end
