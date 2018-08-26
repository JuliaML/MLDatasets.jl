"""
    classnames() -> Vector{Int}

Return the 10 digits for the SVHN classes as a vector of integers.
"""
classnames() = CLASSES

for (FUN, PATH, COUNT, DESC) in (
        (:traintensor, TRAINDATA, 73257,  "training"),
        (:testtensor,  TESTDATA,  26032,  "test"),
        (:extratensor, EXTRADATA, 531131, "extra training"),
       )
    FUN_STR = string(FUN)
    @eval begin
        """
            $($FUN_STR)([T = N0f8], [indices]; [dir]) -> Array{T}

        Return the SVHN **$($DESC)** images corresponding to the
        given `indices` as a multi-dimensional array of eltype
        `T`.

        The image(s) is/are returned in the native vertical-major
        memory layout as a single numeric array. If `T <:
        Integer`, then all values will be within `0` and `255`,
        otherwise the values are scaled to be between `0` and
        `1`.

        If the parameter `indices` is omitted or an
        `AbstractVector`, the images are returned as a 4D array
        (i.e. a `Array{T,4}`), in which the first dimension
        corresponds to the pixel *columns* (y) of the image, the
        second dimension to the pixel *rows* (x) of the image,
        the third dimension the RGB color channels, and the
        fourth dimension denotes the index of the image.

        ```julia-repl
        julia> SVHN2.$($FUN_STR)() # load all $($DESC) images
        32×32×3×$($COUNT) Array{N0f8,4}:
        [...]

        julia> SVHN.$($FUN_STR)(Float32, 1:3) # first three images as Float32
        32×32×3×3 Array{Float32,4}:
        [...]
        ```

        If `indices` is an `Integer`, the single image is
        returned as `Array{T,3}` in vertical-major layout, which
        means that the first dimension denotes the pixel
        *columns* (y), the second dimension denotes the pixel
        *rows* (x), and the third dimension the RGB color
        channels of the image.

        ```julia-repl
        julia> SVHN2.$($FUN_STR)(1) # load first $($DESC) image
        32×32×3 Array{N0f8,3}:
        [...]
        ```

        As mentioned above, the color channel is encoded in the
        third dimension. You can use the utility function
        [`convert2image`](@ref) to convert an SVHN array into a
        Julia image with the appropriate `RGB` eltype.

        ```julia-repl
        julia> SVHN2.convert2image(SVHN2.$($FUN_STR)(1))
        32×32 Array{RGB{N0f8},2}:
        [...]
        ```

        $(download_docstring("SVHN2", DEPNAME))
        """
        function ($FUN)(args...; dir = nothing)
            ($FUN)(N0f8, args...; dir = dir)
        end

        function ($FUN)(::Type{T}; dir = nothing) where T
            path = datafile(DEPNAME, $PATH, dir)
            images = _matopen(io->read(io, "X"), path)::Array{UInt8,4}
            bytes_to_type(T, images)
        end

        function ($FUN)(::Type{T}, indices; dir = nothing) where T
            images = ($FUN)(T, dir = dir)#::Array{T,4}
            images[:,:,:,indices]
        end
    end
end

for (FUN, PATH, COUNT, DESC) in (
        (:trainlabels, TRAINDATA, 73257,  "training"),
        (:testlabels,  TESTDATA,  26032,  "test"),
        (:extralabels, EXTRADATA, 531131, "extra training"),
       )
    FUN_STR = string(FUN)
    @eval begin
        """
            $($FUN_STR)([indices]; [dir])

        Returns the SVHN **$($DESC)** labels corresponding to
        the given `indices` as an `Int` or `Vector{Int}`. The
        values of the labels denote the zero-based class-index
        that they represent (see [`SVHN2.classnames`](@ref) for
        the corresponding names). If `indices` is omitted, all
        labels are returned.

        ```julia-repl
        julia> SVHN2.$($FUN_STR)() # full $($DESC) set
        $($COUNT)-element Array{Int64,1}:
        [...]

        julia> SVHN2.$($FUN_STR)(1:3) # first three labels
        3-element Array{Int64,1}:
        [...]

        julia> SVHN2.$($FUN_STR)(1) # first label
        [...]

        julia> SVHN2.classnames()[SVHN2.$($FUN_STR)(1)] # corresponding class
        [...]
        ```

        $(download_docstring("SVHN2", DEPNAME))
        """
        function ($FUN)(; dir = nothing)
            path = datafile(DEPNAME, $PATH, dir)
            labels = _matopen(io->read(io, "y"), path)
            Vector{Int}(vec(labels))::Vector{Int}
        end

        function ($FUN)(indices; dir = nothing)
            labels = ($FUN)(dir = dir)::Vector{Int}
            labels[indices]
        end
    end
end

for (FUN, PATH, DESC) in (
        (:traindata, TRAINDATA, "trainset"),
        (:testdata,  TESTDATA,  "testset"),
        (:extradata, EXTRADATA, "extra trainset"),
       )
    FUN_STR = string(FUN)
    @eval begin
        """
            $($FUN_STR)([T = N0f8], [indices]; [dir]) -> images, labels

        Returns the SVHN **$($DESC)** corresponding to the given
        `indices` as a two-element tuple. If `indices` is omitted
        the full $($DESC) is returned. The first element of the
        return values will be the images as a multi-dimensional
        array, and the second element the corresponding labels as
        integers.

        The image(s) is/are returned in the native vertical-major
        memory layout as a single numeric array of eltype `T`. If
        `T <: Integer`, then all values will be within `0` and
        `255`, otherwise the values are scaled to be between `0`
        and `1`. You can use the utility function
        [`convert2image`](@ref) to convert an SVHN array into a
        Julia image with the appropriate `RGB` eltype. The
        integer values of the labels correspond 1-to-1 the digit
        that they represent with the exception of 0 which is
        encoded as `10`.

        Note that because of the nature of how the dataset is
        stored on disk, `SVHN2.$($FUN_STR)` will always load the
        full $($DESC), regardless of which observations are
        requested. In the case `indices` are provided by the
        user, it will simply result in a sub-setting. This option
        is just provided for convenience.

        ```julia
        images, labels = SVHN2.$($FUN_STR)() # full dataset
        images, labels = SVHN2.$($FUN_STR)(2) # only second observation
        images, labels = SVHN2.$($FUN_STR)(dir="./SVHN") # custom folder
        ```

        $(download_docstring("SVHN2", DEPNAME))
        """
        function ($FUN)(args...; dir = nothing)
            ($FUN)(N0f8, args...; dir = dir)
        end

        function ($FUN)(::Type{T}; dir = nothing) where T
            path = datafile(DEPNAME, $PATH, dir)
            vars = _matread(path)
            images = vars["X"]::Array{UInt8,4}
            labels = vars["y"]
            bytes_to_type(T, images), Vector{Int}(vec(labels))::Vector{Int}
        end

        function ($FUN)(::Type{T}, indices; dir = nothing) where T
            images, labels = ($FUN)(T, dir = dir)
            images[:,:,:,indices], labels[indices]
        end
    end
end
