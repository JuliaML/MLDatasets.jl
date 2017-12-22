__precompile__()
module MLDatasets

include("io/download.jl")
include("io/CoNLL.jl")

include("CIFAR10.jl")
include("CIFAR100.jl")
include("MNIST/MNIST.jl")
include("FashionMNIST/FashionMNIST.jl")
include("PTBLM.jl")
include("UD_English.jl")

end
