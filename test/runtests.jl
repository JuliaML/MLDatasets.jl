using Base.Test
using MLDatasets

# CIFAR10
x, y = CIFAR10.traindata()
x, y = CIFAR10.testdata()

# CIFAR100
x, y = CIFAR100.traindata()
x, y = CIFAR100.testdata()

# MNIST
x, y = MNIST.traindata()
@test size(x) == (28,28,60000)
@test size(y) == (60000,)

x, y = MNIST.testdata()
@test size(x) == (28,28,10000)
@test size(y) == (10000,)

# PTBLM
x, y = PTBLM.traindata()
x, y = PTBLM.testdata()
