using Documenter, MLDatasets

## Commented out since gives warning
# DocMeta.setdocmeta!(MLDatasets, :DocTestSetup, :(using MLDatasets); recursive=true)

# Build documentation.
# ====================

makedocs(
    modules = [MLDatasets],
    doctest = true,
    clean = false,
    sitename = "MLDatasets.jl",
    format = Documenter.HTML(
        canonical = "https://juliadata.github.io/MLDatasets.jl/stable/",
        assets = ["assets/favicon.ico"],
        prettyurls = get(ENV, "CI", nothing) == "true",
        collapselevel=3,
    ),

    authors = "Hiroyuki Shindo, Christof Stocker",
    # TODO: automatize `pages` creation
    pages = Any[
        "Home" => "index.md",
        "Available Datasets" => Any[
            "Vision" => Any[
                "MNIST" => "datasets/MNIST.md",
                "EMNIST" => "datasets/EMNIST.md",
                "FashionMNIST" => "datasets/FashionMNIST.md",
                "CIFAR-10" => "datasets/CIFAR10.md",
                "CIFAR-100" => "datasets/CIFAR100.md",
                "SVHN format 2" => "datasets/SVHN2.md",
            ],
            "Miscellaneous" => "datasets/misc.md",
            "Text" => Any[
                "PTBLM" => "datasets/PTBLM.md",
                "UD_English" => "datasets/UD_English.md",
            ],

            "Graphs" => "datasets/graphs.md",

        ],
        "Utils" => "utils.md",
        "Data Containers" => "containers/overview.md",
        "LICENSE.md",
    ],
    strict = true,
    checkdocs = :exports
)


deploydocs(repo = "github.com/JuliaML/MLDatasets.jl.git")
