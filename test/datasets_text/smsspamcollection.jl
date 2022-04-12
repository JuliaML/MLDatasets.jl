n_obs = 5574
n_targets = 1
n_features = ()
Tx=String
Ty=String

d = SMSSpamCollection()

test_supervised_array_dataset(d;
    n_obs, n_targets, n_features,
    Tx, Ty)
    