using DelimitedFiles

"""
    BostonHousing()

Boston Housing Dataset.

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


# Examples
    
```jldoctest
julia> using MLDatasets: BostonHousing

julia> dataset = BostonHousing()
BostonHousing dataset:
  feature_names : 13-element Vector{String}
  features : 13×506 Matrix{Float64}
  targets : 1×506 Matrix{Float64}

julia> dataset.feature_names
13-element Vector{String}:
 "crim"
 "zn"
 "indus"
 "chas"
 "nox"
 "rm"
 "age"
 "dis"
 "rad"
 "tax"
 "ptratio"
 "b"
 "lstat"
  
julia> dataset[1:2]
(features = [0.00632 0.02731; 18.0 0.0; … ; 396.9 396.9; 4.98 9.14], targets = [24.0 21.6])

julia> X, y = dataset[];
```
"""
struct BostonHousing <: AbstractDataset
    _path::String
    feature_names::Vector{String}
    features::Matrix{Float64}
    targets::Matrix{Float64}
end

function BostonHousing()
    path = joinpath(@__DIR__, "..", "..", "data", "boston_housing.csv")
    feature_names = ["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"]
    data = readdlm(path, ',')
    features = Matrix{Float64}(data[2:end,1:13])' |> collect
    targets = reshape(Vector{Float64}(data[2:end,end]), (1, 506))
    return BostonHousing(path, feature_names, features, targets)
end

Base.getindex(d::BostonHousing) = getobs((; d.features, d.targets))
Base.getindex(d::BostonHousing, i) = getobs((; d.features, d.targets), i)
Base.length(d::BostonHousing) = numobs(d.features)

function Base.getproperty(::Type{BostonHousing}, s::Symbol)
    d = BostonHousing()
    if s == :features
        @warn "BostonHousing.features() is deprecated, use `BostonHousing().features` instead."
        return () -> d.features
    elseif s == :targets
        @warn "BostonHousing.targets() is deprecated, use `BostonHousing().targets` instead."
        return () -> d.targets
    elseif s == :feature_names
        @warn "BostonHousing.feature_names() is deprecated, use `BostonHousing().feature_names` instead."
        return () -> d.feature_names
    else 
        return getfield(BostonHousing, s)
    end
end
