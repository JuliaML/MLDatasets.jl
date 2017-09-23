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

    include(joinpath("Reader","Reader.jl"))
    import .Reader.download_helper
    include("interface.jl")
    include(joinpath("..", "MNIST", "utils.jl"))

    Reader.download_helper(; nargs...) = Reader.download_helper(DEFAULT_DIR; nargs...)
end
