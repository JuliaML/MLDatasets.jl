export Titanic

"""
    Titanic()

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

DATASET specs

NAME:	titanic3
TYPE:	Census
SIZE:	1309 Passengers, 14 Variables

DESCRIPTIVE ABSTRACT:

The titanic3 data frame describes the survival status of individual passengers on the Titanic.
The titanic3 data frame does not contain information for the crew, but it does contain actual and estimated ages for almost 80% of the passengers.

SOURCES:

Hind, Philip. Encyclopedia Titanica. Online-only resource. Retrieved 01Feb2012 from http://www.encyclopedia-titanica.org/

VARIABLE DESCRIPTIONS

Pclass	Passenger Class (1 = 1st; 2 = 2nd; 3 = 3rd)
survival	Survival (0 = No; 1 = Yes)
name	Name
sex	Sex
age	Age
sibsp	Number of Siblings/Spouses Aboard
parch	Number of Parents/Children Aboard
ticket	Ticket Number
fare	Passenger Fare (British pound)
cabin	Cabin
embarked	Port of Embarkation (C = Cherbourg; Q = Queenstown; S = Southampton)
boat	Lifeboat
body	Body Identification Number
home.dest	Home/Destination


SPECIAL NOTES

Pclass is a proxy for socio-economic status (SES) 1st ~ Upper; 2nd ~ Middle; 3rd ~ Lower

Age is in Years; Fractional if Age less than One (1) If the Age is estimated, it is in the form xx.5

Fare is in Pre-1970 British Pounds ()
Conversion Factors: 1 = 12s = 240d and 1s = 20d


With respect to the family relation variables (i.e. sibsp and parch) some relations were ignored. 
The following are the definitions used for sibsp and parch.

Sibling:	Brother, Sister, Stepbrother, or Stepsister of Passenger Aboard Titanic
Spouse:	Husband or Wife of Passenger Aboard Titanic (Mistresses and Fiances Ignored)
Parent:	Mother or Father of Passenger Aboard Titanic
Child:	Son, Daughter, Stepson, or Stepdaughter of Passenger Aboard Titanic

Other family relatives excluded from this study include cousins, nephews/nieces, aunts/uncles, and in-laws. 
Some children travelled only with a nanny, therefore parch=0 for them. 
    As well, some travelled with very close friends or neighbors in a village, however, the definitions do not support such relations.


An interesting result may be obtained using functions from the Hmisc library.

attach	(titanic3)
plsmo	(age, survived, group=sex, datadensity=T) 
# or group=pclass plot	(naclus	(titanic3)) # study patterns of missing values summary	(survived ~ age + sex + pclass + sibsp + parch, data=titanic3)


# Examples
    
```julia-repl
julia> using MLDatasets: Titanic

julia> dataset = Titanic()
Titanic dataset:
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
struct Titanic <: AbstractDataset
    _path::String
    feature_names::Vector{String}
    features::Matrix
    targets::Matrix{Int}
end

function Titanic()
    path = joinpath(@__DIR__, "..", "..", "data", "titanic.csv")
    data = readdlm(path, ',')
    targets = reshape(Vector{Int}(data[2:end, 2]), (1, 891))
    feature_names = ["PassengerId", "Pclass", "Name", "Sex", "Age", "SibSp", "Parch", "Ticket", "Fare", "Cabin", "Embarked"]
    features = reshape(Matrix(hcat(data[2:end, 1], data[2:end, 3:12])), (11, 891))
    Titanic(path, feature_names, features, targets)
end

function Base.getproperty(::Type{Titanic}, s::Symbol)
    if s == :features
        @warn "Titanic.features() is deprecated, use `Titanic().features` instead."
        return () -> Titanic().features
    elseif s == :targets
        @warn "Titanic.targets() is deprecated, use `Titanic().targets` instead."
        return () -> Titanic().targets
    elseif s == :feature_names
        @warn "Titanic.feature_names() is deprecated, use `Titanic().feature_names` instead."
        return () -> Titanic().feature_names
    else 
        return getfield(Titanic, s)
    end
end
