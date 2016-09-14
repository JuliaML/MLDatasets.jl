using Base.Test
using MLDatasets

# MNIST
x,y = MNIST.traindata()
@test size(x) == (28,28,60000)
@test size(y) == (60000,)

x,y = MNIST.testdata()
@test size(x) == (28,28,10000)
@test size(y) == (10000,)
