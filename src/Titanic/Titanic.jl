export Titanic
"""
Titanic Dataset

The titanic and titanic2 data frames describe the survival status of individual passengers on the Titanic. 

The titanic data frame does not contain information from the crew, but it does contain actual ages of half of the passengers. 
The principal source for data about Titanic passengers is the Encyclopedia Titanica. 
The datasets used here were begun by a variety of researchers. 
One of the original sources is Eaton & Haas (1994) 
Titanic: Triumph and Tragedy, Patrick Stephens Ltd, which includes a passenger list created by many researchers and edited by Michael A. Findlay.

The variables on our extracted dataset are pclass, survived, name, age, embarked, home.dest, room, ticket, boat, and sex. 
pclass refers to passenger class (1st, 2nd, 3rd), and is a proxy for socio-economic class. 
Age is in years, and some infants had fractional values. 
The titanic2 data frame has no missing data and includes records for the crew, but age is dichotomized at adult vs. child. 
These data were obtained from Robert Dawson, Saint Mary's University, E-mail. 
The variables are pclass, age, sex, survived. 
These data frames are useful for demonstrating many of the functions in Hmisc as well as 
demonstrating binary logistic regression analysis using the Design library. 
For more details and references see Simonoff, Jeffrey S (1997): The "unusual episode" and a second statistics course. 
J Statistics Education, Vol. 5 No. 1. Thomas Cason of UVa has greatly updated and improved the titanic data frame 
using the Encyclopedia Titanica and created a new dataset called titanic3. 
These datasets reflects the state of data available as of 2 August 1999. 
Some duplicate passengers have been dropped, many errors corrected, many missing ages filled in, and new variables created.

# Interface

- [`Titanic.features`](@ref)
- [`Titanic.targets`](@ref)
- [`Titanic.feature_names`](@ref)

"""

module Titanic

using DataDeps
using DelimitedFiles

export features, targets, feature_names

const DATA = joinpath(@__DIR__, "titanic.csv")

"""
    targets(; dir = nothing)

Get the targets for the Titanic dataset, 
a 891 element array listing the targets for each example.

```jldoctest
julia> using MLDatasets: Titanic

julia> target = Titanic.targets();

julia> summary(target)
"1×891 Matrix{Float64}"
     
"""

function targets(; dir = nothing)
    titanic_data = readdlm(DATA, ',')
    reshape(Vector{Float64}(titanic_data[2:end, end]), (1, 891))
end

"""
    feature_names()

Return the  the names of the features provided in the dataset.
"""

function feature_names()
    ["PassengerId", "Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
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
    titanic_data = readdlm(DATA, ',')
    Matrix{Float64}(titanic_data[2:end, 1:13])' |> collect
end

end # module