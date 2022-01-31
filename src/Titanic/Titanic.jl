export Titanic

module Titanic
using DataDeps
using DelimitedFiles
"""
The titanic.csv file contains data for 887 of the real Titanic passengers. Each row represents one person. The columns describe different attributes about the person including whether they survived (S), their age (A), their passenger-class (C), their sex (G) and the fare they paid (X).
"""

export features, targets, feature_names
const DATA = joinpath(@__DIR__, "titanic.csv")