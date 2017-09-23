export FashionMNIST
module FashionMNIST
    using ImageCore
    using ColorTypes

    export

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        convert2image,
        convert2features,

        download_helper

    const DEFAULT_DIR = abspath(joinpath(dirname(@__FILE__), "..", "..", "datasets", "fashion_mnist"))

    include("reader.jl")
    include("interface.jl")
    include(joinpath("..", "MNIST", "utils.jl"))
end
