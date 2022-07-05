# Graph Datasets

A collection of datasets with an underlying graph structure.
Some of these datasets contain a single graph, that can be accessed
with `dataset[:]` or `dataset[1]`. Others contain many graphs, 
accessed through `dataset[i]`. Graphs are represented by the [`MLDatasets.Graph`](@ref) 
and [`MLDatasets.HeteroGraph`](@ref) type.

## Index

```@index
Pages = ["graphs.md"]
```

## Documentation

```@docs
MLDatasets.Graph
MLDatasets.HeteroGraph
```

```@docs
CiteSeer
Cora
KarateClub
MovieLens
OGBDataset
PolBlogs
PubMed
Reddit
TUDataset
```
