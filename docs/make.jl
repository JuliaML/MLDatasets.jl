using Documenter, MLDatasets

makedocs(
    modules = [MLDatasets],
    clean = false,
    format = :html,
    assets = [
        joinpath("assets", "favicon.ico"),
    ],
    sitename = "MLDatasets.jl",
    authors = "Hiroyuki Shindo, Christof Stocker",
    linkcheck = !("skiplinks" in ARGS),
    pages = Any[
        "Home" => "index.md",
        "Available Datasets" => Any[
            "Image Classification" => Any[
                "MNIST handwritten digits" => "datasets/MNIST.md",
                "Fashion MNIST" => "datasets/FashionMNIST.md",
                "CIFAR-10" => "datasets/CIFAR10.md",
                "CIFAR-100" => "datasets/CIFAR100.md",
                "SVHN format 2" => "datasets/SVHN2.md",
            ],
        ],
        hide("Indices" => "indices.md"),
        "LICENSE.md",
    ],
    html_prettyurls = !("local" in ARGS),
)

deploydocs(
    repo = "github.com/JuliaML/MLDatasets.jl.git",
    target = "build",
    julia = "0.7",
    deps = nothing,
    make = nothing,
)
