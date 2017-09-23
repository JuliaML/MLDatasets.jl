export MNIST
module MNIST
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

    const DEFAULT_DIR = abspath(joinpath(dirname(@__FILE__), "..", "..", "datasets", "mnist"))

    include(joinpath("Reader","Reader.jl"))
    include("interface.jl")
    include("utils.jl")
end
