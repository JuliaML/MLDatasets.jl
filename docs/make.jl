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

    authors = "Hiroyuki Shindo, Christof Stocker, Carlo Lucibello",
    
    pages = Any[
        "Home" => "index.md",
        "Datasets" => Any[
            "Graphs" => "datasets/graphs.md",
            "Miscellaneous" => "datasets/misc.md",
            "Text" => "datasets/text.md",
            "Vision" => "datasets/vision.md",
        ],
        "Utils" => "utils.md",
        "Data Containers" => "containers/overview.md",
        "LICENSE.md",
    ],
    strict = true,
    checkdocs = :exports
)

deploydocs(repo = "github.com/JuliaML/MLDatasets.jl.git")
