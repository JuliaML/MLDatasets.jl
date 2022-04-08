export Titanic

"""
    Titanic(; as_df = true, dir = nothing)

The Titanic dataset, describing the survival of passengers on the Titanic ship.

# Arguments

$ARGUMENTS_SUPERVISED_TABLE

# Fields

$FIELDS_SUPERVISED_TABLE

# Methods

$METHODS_SUPERVISED_TABLE

# Examples

```julia-repl
julia> using MLDatasets: Titanic

julia> using DataFrames

julia> dataset = Titanic()
Titanic:
  metadata => Dict{String, Any} with 5 entries
  features => 891×11 DataFrame
  targets => 891×1 DataFrame
  dataframe => 891×12 DataFrame


julia> describe(dataset.dataframe)
12×7 DataFrame
 Row │ variable     mean      min                  median   max                          nmissing  eltype                   
     │ Symbol       Union…    Any                  Union…   Any                          Int64     Type                     
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ PassengerId  446.0     1                    446.0    891                                 0  Int64
   2 │ Survived     0.383838  0                    0.0      1                                   0  Int64
   3 │ Pclass       2.30864   1                    3.0      3                                   0  Int64
   4 │ Name                   Abbing, Mr. Anthony           van Melkebeke, Mr. Philemon         0  String
   5 │ Sex                    female                        male                                0  String7
   6 │ Age          29.6991   0.42                 28.0     80.0                              177  Union{Missing, Float64}
   7 │ SibSp        0.523008  0                    0.0      8                                   0  Int64
   8 │ Parch        0.381594  0                    0.0      6                                   0  Int64
   9 │ Ticket                 110152                        WE/P 5735                           0  String31
  10 │ Fare         32.2042   0.0                  14.4542  512.329                             0  Float64
  11 │ Cabin                  A10                           T                                 687  Union{Missing, String15}
  12 │ Embarked               C                             S                                   2  Union{Missing, String1}
```
"""
struct Titanic <: SupervisedDataset
    metadata::Dict{String, Any}
    features
    targets
    dataframe
end

function Titanic(; as_df = true, dir = nothing)
    @assert dir === nothing "custom `dir` is not supported at the moment."
    path = joinpath(@__DIR__, "..", "..", "data", "titanic.csv")
    df = read_csv(path)
    features = df[!, Not(:Survived)]
    targets = df[!, [:Survived]]
    
    metadata = Dict{String, Any}()
    metadata["path"] = path
    metadata["feature_names"] = names(features)
    metadata["target_names"] = names(targets)
    metadata["n_observations"] = size(df, 1)
    metadata["description"] = TITANIC_DESCR

    if !as_df
        features = df_to_matrix(features)
        targets = df_to_matrix(targets)
        df = nothing
    end

    return Titanic(metadata, features, targets, df)
end

const TITANIC_DESCR = """
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
"""

function Base.getproperty(::Type{Titanic}, s::Symbol)
    if s == :features
        @warn "Titanic.features() is deprecated, use `Titanic().features` instead."
        return () -> Titanic(as_df=false).features
    elseif s == :targets
        @warn "Titanic.targets() is deprecated, use `Titanic().targets` instead."
        return () -> Titanic(as_df=false).targets
    elseif s == :feature_names
        @warn "Titanic.feature_names() is deprecated, use `Titanic().feature_names` instead."
        return () -> Titanic().metadata["feature_names"]
    else 
        return getfield(Titanic, s)
    end
end
