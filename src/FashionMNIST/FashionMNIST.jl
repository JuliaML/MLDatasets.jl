export FashionMNIST

"""
Fashion-MNIST

- Authors: Han Xiao, Kashif Rasul, Roland Vollgraf
- Website: https://github.com/zalandoresearch/fashion-mnist

Fashion-MNIST is a dataset of Zalando's article images—consisting
of a training set of 60,000 examples and a test set of 10,000
examples. Each example is a 28x28 grayscale image, associated
with a label from 10 classes. It can serve as a drop-in
replacement for MNIST.

## Interface

- [`FashionMNIST.traintensor`](@ref), [`FashionMNIST.trainlabels`](@ref), [`FashionMNIST.traindata`](@ref)
- [`FashionMNIST.testtensor`](@ref), [`FashionMNIST.testlabels`](@ref), [`FashionMNIST.testdata`](@ref)

## Utilities

- [`FashionMNIST.download`](@ref)

Also, the `FashionMNIST` module is re-exporting [`convert2image`](@ref MNIST.convert2image) from the [`MNIST`](@ref) module.
"""
module FashionMNIST
    using DataDeps
    using FixedPointNumbers
    using ..MLDatasets: bytes_to_type, datafile, download_dep, download_docstring
    import ..MNIST
    using ..MNIST: convert2image
    using ..MNIST.Reader

    export

        classnames,

        traintensor,
        testtensor,

        trainlabels,
        testlabels,

        traindata,
        testdata,

        convert2image,

        download

    const DEPNAME = "FashionMNIST"
    const TRAINIMAGES = "train-images-idx3-ubyte.gz"
    const TRAINLABELS = "train-labels-idx1-ubyte.gz"
    const TESTIMAGES  = "t10k-images-idx3-ubyte.gz"
    const TESTLABELS  = "t10k-labels-idx1-ubyte.gz"

    const CLASSES = [
        "T-Shirt",
        "Trouser",
        "Pullover",
        "Dress",
        "Coat",
        "Sandal",
        "Shirt",
        "Sneaker",
        "Bag",
        "Ankle boot"
    ]

    """
        download([dir]; [i_accept_the_terms_of_use])

    Trigger the (interactive) download of the full dataset into
    "`dir`". If no `dir` is provided the dataset will be
    downloaded into "~/.julia/datadeps/$DEPNAME".

    This function will display an interactive dialog unless
    either the keyword parameter `i_accept_the_terms_of_use` or
    the environment variable `DATADEPS_ALWAYS_ACCEPT` is set to
    `true`. Note that using the data responsibly and respecting
    copyright/terms-of-use remains your responsibility.
    """
    download(args...; kw...) = download_dep(DEPNAME, args...; kw...)

    include("interface.jl")

    function __init__()
        register(DataDep(
            DEPNAME,
            """
            Dataset: Fashion-MNIST
            Authors: Han Xiao, Kashif Rasul, Roland Vollgraf
            Website: https://github.com/zalandoresearch/fashion-mnist
            License: MIT

            [Han Xiao et al. 2017]
                Han Xiao, Kashif Rasul, and Roland Vollgraf.
                "Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms."
                arXiv:1708.07747

            The files are available for download at the offical
            website linked above. Note that using the data
            responsibly and respecting copyright remains your
            responsibility.
            """,
            "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/" .* [TRAINIMAGES, TRAINLABELS, TESTIMAGES, TESTLABELS],
            "c916b6e00d3083643332b70f3c5c3543d3941334b802e252976893969ee6af67",
        ))
    end
end
