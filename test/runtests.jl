using Base.Test
using MLDatasets

include("MNIST/runtests.jl")
include("FashionMNIST/runtests.jl")

# CIFAR10
x, y = CIFAR10.traindata()
x, y = CIFAR10.testdata()

# CIFAR100
x, y = CIFAR100.traindata()
x, y = CIFAR100.testdata()

# PTBLM
x, y = PTBLM.traindata()
x, y = PTBLM.testdata()

# UD_English
x = UD_English.traindata()
x = UD_English.devdata()
x = UD_English.testdata()
nothing
