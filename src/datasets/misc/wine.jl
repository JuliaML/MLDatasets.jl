export Wine

"""
    Wine(; as_df = true, dir = nothing)

The UCI Wine dataset.
These data are the results of a chemical analysis of wines grown in the same region in Italy but derived from three different cultivars.
The analysis determined the quantities of 13 constituents found in each of the three types of wines. 

# Arguments

$ARGUMENTS_SUPERVISED_TABLE

# Fields

$FIELDS_SUPERVISED_TABLE

# Methods

$METHODS_SUPERVISED_TABLE

# Examples

```julia-repl
julia> using MLDatasets: Wine

julia> using DataFrames

julia> dataset = Wine()
dataset Wine:
  metadata   =>    Dict{String, Any} with 5 entries
  features   =>    178×13 DataFrame
  targets    =>    178×1 DataFrame
  dataframe  =>    178×14 DataFrame


julia> describe(dataset.dataframe)
14×7 DataFrame
 Row │ variable              mean        min     median   max      nmissing  eltype   
     │ Symbol                Float64     Real    Float64  Real     Int64     DataType 
─────┼────────────────────────────────────────────────────────────────────────────────
   1 │ Wine                    1.9382      1       2.0       3            0  Int64
   2 │ Alcohol                13.0006     11.03   13.05     14.83         0  Float64
   3 │ Malic.acid              2.33635     0.74    1.865     5.8          0  Float64
   4 │ Ash                     2.36652     1.36    2.36      3.23         0  Float64
   5 │ Acl                    19.4949     10.6    19.5      30.0          0  Float64
   6 │ Mg                     99.7416     70      98.0     162            0  Int64
   7 │ Phenols                 2.29511     0.98    2.355     3.88         0  Float64
   8 │ Flavanoids              2.02927     0.34    2.135     5.08         0  Float64
   9 │ Nonflavanoid.phenols    0.361854    0.13    0.34      0.66         0  Float64
  10 │ Proanth                 1.5909      0.41    1.555     3.58         0  Float64
  11 │ Color.int               5.05809     1.28    4.69     13.0          0  Float64
  12 │ Hue                     0.957449    0.48    0.965     1.71         0  Float64
  13 │ OD                      2.61169     1.27    2.78      4.0          0  Float64
  14 │ Proline               746.893     278     673.5    1680            0  Int64
```
"""
struct Wine <: SupervisedDataset
    metadata::Dict{String, Any}
    features
    targets
    dataframe
end

function Wine(; as_df = true, dir = nothing)
    @assert dir === nothing "custom `dir` is not supported at the moment."
    path = joinpath(@__DIR__, "..", "..", "..", "data", "wine.csv")
    df = read_csv(path)

    features = df[!, DataFrames.Not(:Wine)]
    targets = df[!, [:Wine]]
    
    metadata = Dict{String, Any}()
    metadata["path"] = path
    metadata["feature_names"] = names(features)
    metadata["target_names"] = names(targets)
    metadata["n_observations"] = size(df, 1)

    if !as_df
        features = df_to_matrix(features)
        targets = df_to_matrix(targets)
        df = nothing
    end

    return Wine(metadata, features, targets, df)
end
