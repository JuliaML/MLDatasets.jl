
"""
    datasetpath(name)

Return the folder that dataset `name` is stored.

If it hasn't been downloaded yet, you will be asked if you want to
download it. See [`Datasets.DATASETS`](#) for a list of available datasets.
"""
function datasetpath(name)
    datadeppath = @datadep_str "fastai-$name"
    return Path(joinpath(datadeppath, name))
end


# Classification datasets

"""
     loaddataclassification(dir; split = false)

Load a data container for image classification with observations
`(input = image, target = class)`.

If `split` is `true`, returns a tuple of the data containers split by
the name of the grandparent folder.

`dir` should contain the data in the following canonical format:

- dir
    - split (e.g. "train", "valid"...)
        - class (e.g. "cat", "dog"...)
            - image32434.{jpg/png/...}
            - ...
        - ...
    - ...
"""
function loaddataclassification(
        dir,
        split=false,
        filterparent= (!=("test")),
        kwargs...)
    data = filterobs(FileDataset(dir)) do path
        isimagefile(path) && filterparent(filename(parent(path)))
    end
    if split
        datas = groupobs(data) do path
            filename(parent(parent(path)))
        end
        return Tuple(mapobs(
            (input = loadfile, target = path -> filename(parent(path))),
            data
        ) for data in datas)
    else
        return mapobs(
            (input = loadfile, target = path -> filename(parent(path))),
            data
        )
    end
end


"""
    getclassesclassification(dir::AbstractPath)
    getclassesclassification(name::String)

Get the list of classes for classification dataset saved in `dir`.

Corresponds to all unique names of parent folders that contain images.

"""
function getclassesclassification(dir)
    data = mapobs(filterobs(isimagefile, FileDataset(dir))) do path
        return filename(parent(path))
    end
    return unique(collect(eachobsparallel(data, useprimary=true, buffered=false)))
end
getclassesclassification(name::String) = getclassesclassification(datasetpath(name))

# Segmentation datasets

"""
    loaddatasegmentation(dir; split = false)

Load a data container for image segmentation with observations
`(input = image, target = mask)`.

If `split` is `true`, returns a tuple of the data containers split by
the name of the grandparent folder.
"""
function loaddatasegmentation(
        dir;
        split=false,
        kwargs...)
    imagedata = mapobs(loadfile, filterobs(isimagefile, FileDataset(joinpath(dir, "images"))))
    maskdata = mapobs(maskfromimage ∘ loadfile, filterobs(isimagefile, FileDataset(joinpath(dir, "labels"))))
    return mapobs((input = obs -> obs[1], target = obs -> obs[2]), (imagedata, maskdata))
end


"""
    getclassessegmentation(dir::AbstractPath)
    getclassessegmentation(name::String)

Get the list of classes for segmentation dataset saved in `dir`.

Should be saved as a new-line delimited file called "codes.txt" in `dir`.
"""
function getclassessegmentation(dir::AbstractPath)
    classes = readlines(open(joinpath(dir, "codes.txt")))
    return classes
end
getclassessegmentation(name::String) = getclassessegmentation(datasetpath(name))




maskfromimage(a::AbstractArray{<:Gray{T}}) where T = maskfromimage(reinterpret(T, a))
maskfromimage(a::AbstractArray{<:Normed{T}}) where T = maskfromimage(reinterpret(T, a))
function maskfromimage(a::AbstractArray{I}) where {I<:Integer}
    return a .+ one(I)
end
