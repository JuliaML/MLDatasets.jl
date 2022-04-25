"""
    BostonHousing(; as_df = true, dir = nothing)

The classical Boston Housing tabular dataset.

Sources:
   (a) Origin:  This dataset was taken from the StatLib library which is
                maintained at Carnegie Mellon University.
   (b) Creator:  Harrison, D. and Rubinfeld, D.L. 'Hedonic prices and the 
                 demand for clean air', J. Environ. Economics & Management,
                 vol.5, 81-102, 1978.
   (c) Date: July 7, 1993

Number of Instances: 506

Number of Attributes: 13 continuous attributes (including target
                            attribute "MEDV"), 1 binary-valued attribute.

# Arguments

$ARGUMENTS_SUPERVISED_TABLE

# Fields

$FIELDS_SUPERVISED_TABLE

# Methods

$METHODS_SUPERVISED_TABLE

# Examples
    
```julia-repl
julia> using MLDatasets: BostonHousing

julia> dataset = BostonHousing()
BostonHousing:
  metadata => Dict{String, Any} with 5 entries
  features => 506×13 DataFrame
  targets => 506×1 DataFrame
  dataframe => 506×14 DataFrame


julia> dataset[1:5][1]
5×13 DataFrame
 Row │ CRIM     ZN       INDUS    CHAS   NOX      RM       AGE      DIS      RAD    TAX    PTRATIO  B        LSTAT   
     │ Float64  Float64  Float64  Int64  Float64  Float64  Float64  Float64  Int64  Int64  Float64  Float64  Float64 
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 0.00632     18.0     2.31      0    0.538    6.575     65.2   4.09        1    296     15.3   396.9      4.98
   2 │ 0.02731      0.0     7.07      0    0.469    6.421     78.9   4.9671      2    242     17.8   396.9      9.14
   3 │ 0.02729      0.0     7.07      0    0.469    7.185     61.1   4.9671      2    242     17.8   392.83     4.03
   4 │ 0.03237      0.0     2.18      0    0.458    6.998     45.8   6.0622      3    222     18.7   394.63     2.94
   5 │ 0.06905      0.0     2.18      0    0.458    7.147     54.2   6.0622      3    222     18.7   396.9      5.33

julia> dataset[1:5][2]
5×1 DataFrame
Row │ MEDV    
    │ Float64 
────┼─────────
  1 │    24.0
  2 │    21.6
  3 │    34.7
  4 │    33.4
  5 │    36.2  

julia> X, y = BostonHousing(as_df=false)[]
([0.00632 0.02731 … 0.10959 0.04741; 18.0 0.0 … 0.0 0.0; … ; 396.9 396.9 … 393.45 396.9; 4.98 9.14 … 6.48 7.88], [24.0 21.6 … 22.0 11.9])
```
"""
struct BostonHousing <: SupervisedDataset
    metadata::Dict{String, Any}
    features
    targets
    dataframe
end

function BostonHousing(; as_df = true, dir = nothing)
    @assert dir === nothing "custom `dir` is not supported at the moment."
    path = joinpath(@__DIR__, "..", "..", "..", "data", "boston_housing.csv")
    df = read_csv(path)
    features = df[!, Not(:MEDV)]
    targets = df[!, [:MEDV]]
    
    metadata = Dict{String, Any}()
    metadata["path"] = path
    metadata["feature_names"] = names(features)
    metadata["target_names"] = names(targets)
    metadata["n_observations"] = size(targets, 1)
    metadata["description"] = BOSTONHOUSING_DESCR
    
    if !as_df 
        features = df_to_matrix(features) 
        targets = df_to_matrix(targets)
        df = nothing
    end
    
    return BostonHousing(metadata, features, targets, df)
end

const BOSTONHOUSING_DESCR = """
The Boston Housing Dataset.

Sources:
   (a) Origin:  This dataset was taken from the StatLib library which is
                maintained at Carnegie Mellon University.
   (b) Creator:  Harrison, D. and Rubinfeld, D.L. 'Hedonic prices and the 
                 demand for clean air', J. Environ. Economics & Management,
                 vol.5, 81-102, 1978.
   (c) Date: July 7, 1993

Number of Instances: 506

Number of Attributes: 13 continuous attributes (including target
                            attribute "MEDV"), 1 binary-valued attribute.

Features:

    1. CRIM      per capita crime rate by town
    2. ZN        proportion of residential land zoned for lots over 25,000 sq.ft.
    3. INDUS     proportion of non-retail business acres per town
    4. CHAS      Charles River dummy variable (= 1 if tract bounds river; 0 otherwise)
    5. NOX       nitric oxides concentration (parts per 10 million)
    6. RM        average number of rooms per dwelling
    7. AGE       proportion of owner-occupied units built prior to 1940
    8. DIS       weighted distances to five Boston employment centres
    9. RAD       index of accessibility to radial highways
    10. TAX      full-value property-tax rate per 10,000 dollars
    11. PTRATIO  pupil-teacher ratio by town
    12. B        1000(Bk - 0.63)^2 where Bk is the proportion of blacks by town
    13. LSTAT    % lower status of the population
        
Target:
    
    14. MEDV     Median value of owner-occupied homes in 1000's of dollars   

Note: Variable #14 seems to be censored at 50.00 (corresponding to a median price of \\\$50,000); 
Censoring is suggested by the fact that the highest median price of exactly \\\$50,000 is reported in 16 cases, 
while 15 cases have prices between \\\$40,000 and \\\$50,000, with prices rounded to the nearest hundred. 
Harrison and Rubinfeld do not mention any censoring.

The data file stored in this repo is a copy of the UCI ML housing dataset. 
https://archive.ics.uci.edu/ml/machine-learning-databases/housing/
"""

# Deprecated in v0.6,
function Base.getproperty(::Type{BostonHousing}, s::Symbol)
    if s == :features
        @warn "BostonHousing.features() is deprecated, use `BostonHousing().features` instead."
        return () -> BostonHousing(as_df=false).features
    elseif s == :targets
        @warn "BostonHousing.targets() is deprecated, use `BostonHousing().targets` instead."
        return () -> BostonHousing(as_df=false).targets
    elseif s == :feature_names
        @warn "BostonHousing.feature_names() is deprecated, use `BostonHousing().feature_names` instead."
        return () -> lowercase.(BostonHousing().metadata["feature_names"])
    else
        return getfield(BostonHousing, s)
    end
end
