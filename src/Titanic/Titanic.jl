export Titanic

module Titanic
using DataDeps
using DelimitedFiles

export features, targets, feature_names
const DATA = joinpath(@__DIR__, "titanic.csv")