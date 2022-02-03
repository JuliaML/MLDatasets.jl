export BostonHousing

"""
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

The data file stored in this repo is a copy of the This is a copy of UCI ML housing dataset. 
https://archive.ics.uci.edu/ml/machine-learning-databases/housing/

# Interface

- [`BostonHousing.features`](@ref)
- [`BostonHousing.targets`](@ref)
- [`BostonHousing.feature_names`](@ref)
"""
module BostonHousing

using DataDeps
using DelimitedFiles

export features, targets, feature_names

const DATA = joinpath(@__DIR__, "boston_housing.csv")

"""
    targets(; dir = nothing)

Get the targets for the Boston housing dataset, 
a 506 element array listing the targets for each example.

```jldoctest
julia> using MLDatasets: BostonHousing

julia> target = BostonHousing.targets();

julia> summary(target)
"1×506 Matrix{Float64}"

julia> target[1]
24.0
```     
"""
function targets(; dir = nothing)
    housing = readdlm(DATA, ',')
    reshape(Vector{Float64}(housing[2:end,end]), (1, 506))
end

"""
    feature_names()

Return the  the names of the features provided in the dataset.
"""
function feature_names()
    ["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"]
end


"""
    features()

Return the features of the Boston Housing dataset. This is a 13x506 Matrix of Float64 datatypes.
The values are in the order ["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","b","lstat"].
It has 506 examples.

```jldoctest
julia> using MLDatasets: BostonHousing

julia> features = BostonHousing.features();

julia> summary(features)
"13×506 Matrix{Float64}"
```
"""
function features()
    housing = readdlm(DATA, ',')
    Matrix{Float64}(housing[2:end,1:13])' |> collect
end

end # module

