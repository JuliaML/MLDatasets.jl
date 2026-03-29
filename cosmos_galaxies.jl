using MD5

function __init__cosmos_galaxies()
    DEPNAME = "COSMOSGalaxies"
    ARCHIVE = "COSMOS_25.2_training_sample.tar.gz"
    URL = "https://zenodo.org/records/3242143/files/$ARCHIVE/content"
    # MD5 checksum published on Zenodo for this file
    ZENODO_MD5 = "e05cfe60c037c645d61ac70545cc2a99"
    register(DataDep(
        DEPNAME,
        """
        Dataset: COSMOS real galaxy training sample (F814W < 25.2)
        Source: Zenodo record 3242143 (DOI: 10.5281/zenodo.3242143)
        License: CC-BY-4.0

        Real galaxy postage stamps and PSFs from the HST COSMOS survey, packaged
        for machine learning and GalSim. The download is large (~4.2 GB compressed).

        Mandelbaum, R., Lackner, C., Leauthaud, A., Rowe, B. (2019). COSMOS real galaxy dataset.
        """,
        URL,
        (MD5.md5, ZENODO_MD5);
        post_fetch_method = DataDeps.unpack,
    ))
end

function _find_cosmos_catalog_25_2(root::AbstractString)
    for (dirpath, _, fnames) in walkdir(root)
        idx = findfirst(==("real_galaxy_catalog_25.2.fits"), fnames)
        if idx !== nothing
            return joinpath(dirpath, fnames[idx])
        end
    end
    error(
        "Could not find real_galaxy_catalog_25.2.fits under \"$root\". " *
            "Ensure the COSMOS archive was downloaded and extracted.",
    )
end

function _cosmos_mag_column(df)
    for n in propertynames(df)
        if uppercase(string(n)) == "MAG"
            return n
        end
    end
    error("COSMOS catalog does not contain a MAG column.")
end

function _read_cosmos_catalog_df(catalog_path::AbstractString)
    FITS(catalog_path, "r") do f
        for hdu in f
            if hdu isa TableHDU
                df = DataFrames.DataFrame(hdu)
                try
                    _cosmos_mag_column(df)
                    return df
                catch
                    continue
                end
            end
        end
    end
    error("No suitable binary table found in \"$catalog_path\".")
end

"""
    COSMOSGalaxies(; dir = nothing)

HST COSMOS **real galaxy** dataset (F814W magnitude limit 25.2), as distributed on
[Zenodo](https://zenodo.org/record/3242143) for GalSim / ML ([issue #166](https://github.com/JuliaML/MLDatasets.jl/issues/166)).

The first download is large (~4.2 GB compressed; expands to several GB on disk).

# Supervised view

- `features`: a `DataFrame` of catalog columns other than `MAG` (identifiers,
  astrometry, FITS filenames / HDU indices, pixel scale, noise moments, weights, …).
  Variable-length FITS columns are omitted by the FITSIO → DataFrame path.
- `targets`: `MAG` (F814W `MAG_AUTO`) as `Vector{Float64}` for regression.

# Loading images

Postage stamps are not stored in `features` as arrays (sizes vary). Use:

- [`load_galaxy_image`](@ref)`(dataset, i)` — science stamp
- [`load_psf_image`](@ref)`(dataset, i)` — PSF stamp

[`convert2image`](@ref)`(dataset, i)` draws the galaxy stamp (requires `using ImageShow`).

# Arguments

$ARGUMENTS_SUPERVISED_ARRAY

# Fields

- `metadata`: A dictionary containing paths, DOI, and observation count.
- `features`: Catalog columns except `MAG` (`DataFrame`).
- `targets`: F814W magnitudes (`Vector{Float64}`).

# Methods

$METHODS_SUPERVISED_ARRAY
- [`load_galaxy_image`](@ref) / [`load_psf_image`](@ref) read FITS stamps for index `i`.

# Examples

```julia-repl
julia> using MLDatasets, DataFrames

julia> d = COSMOSGalaxies();  # triggers DataDeps download once

julia> length(d)  # one row per galaxy in the COSMOS 25.2 training sample

julia> img = load_galaxy_image(d, 1);
```

See `COSMOS_25.2_training_sample_readme.txt` in the data directory for column definitions.
"""
struct COSMOSGalaxies <: SupervisedDataset
    metadata::Dict{String, Any}
    features::Any
    targets::Vector{Float64}
end

function COSMOSGalaxies(; dir = nothing)
    DEPNAME = "COSMOSGalaxies"
    root = datadir(DEPNAME, dir)
    catalog_path = _find_cosmos_catalog_25_2(root)
    df_full = _read_cosmos_catalog_df(catalog_path)
    magcol = _cosmos_mag_column(df_full)

    targets = Float64.(df_full[!, magcol])
    features = DataFrames.select(df_full, DataFrames.Not(magcol))

    data_dir = dirname(catalog_path)
    meta = Dict{String, Any}()
    meta["rootdir"] = data_dir
    meta["catalog_path"] = catalog_path
    meta["n_observations"] = DataFrames.nrow(features)
    meta["doi"] = "10.5281/zenodo.3242143"
    meta["zenodo_record"] = 3242143
    meta["target_name"] = "MAG"

    return COSMOSGalaxies(meta, features, targets)
end

function _cosmos_rowfield(row, name::AbstractString)
    u = uppercase(name)
    for p in propertynames(row)
        uppercase(string(p)) == u && return row[p]
    end
    error("Dataset row has no column matching \"$name\".")
end

"""
    load_galaxy_image(dataset::COSMOSGalaxies, i::Integer)

Load the `i`-th galaxy postage stamp using `GAL_FILENAME` and `GAL_HDU` from the catalog.
Returns an `Array` matching the FITS pixel type (typically `Float32` / `Float64`).
"""
function load_galaxy_image(d::COSMOSGalaxies, i::Integer)
    row = d.features[i, :]
    path = joinpath(d.metadata["rootdir"], string(_cosmos_rowfield(row, "GAL_FILENAME")))
    hdu = Int(_cosmos_rowfield(row, "GAL_HDU"))
    FITS(path, "r") do f
        return Array(read(f[hdu]))
    end
end

"""
    load_psf_image(dataset::COSMOSGalaxies, i::Integer)

Load the `i`-th PSF stamp using `PSF_FILENAME` and `PSF_HDU` from the catalog.
"""
function load_psf_image(d::COSMOSGalaxies, i::Integer)
    row = d.features[i, :]
    path = joinpath(d.metadata["rootdir"], string(_cosmos_rowfield(row, "PSF_FILENAME")))
    hdu = Int(_cosmos_rowfield(row, "PSF_HDU"))
    FITS(path, "r") do f
        return Array(read(f[hdu]))
    end
end

function convert2image(::Type{<:COSMOSGalaxies}, x::AbstractMatrix{T}) where {T <: Real}
    x = permutedims(x, (2, 1))
    ImageCore = ImageShow.ImageCore
    return ImageCore.colorview(ImageCore.Gray, x)
end

convert2image(d::COSMOSGalaxies, i::Integer) = convert2image(COSMOSGalaxies, load_galaxy_image(d, i))
