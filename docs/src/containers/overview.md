# Dataset Containers

MLDatasets.jl contains several reusable data containers for accessing datasets in common storage formats. This feature is a work-in-progress and subject to change.

```@docs
ArrayDataset
FileDataset
TableDataset
HDF5Dataset
Base.close(::HDF5Dataset)
JLD2Dataset
Base.close(::JLD2Dataset)
CachedDataset
MLDatasets.make_cache
```
