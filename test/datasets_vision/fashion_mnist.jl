n_features = (28, 28)
n_targets = 1

d = FashionMNIST()

@test d.split == :train
@test extrema(d.features) == (0, 1)

test_supervised_array_dataset(d;
    n_features, n_targets, n_obs=60000,
    Tx=Float32, Ty=Int)
    

d = FashionMNIST(split=:test, Tx=UInt8)

@test d.split == :test
@test extrema(d.features) == (0, 255)

test_supervised_array_dataset(d;
    n_features, n_targets, n_obs=10000,
    Tx=UInt8, Ty=Int)
    