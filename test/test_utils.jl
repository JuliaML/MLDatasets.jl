
### TRAITS CHECKS ###########

function test_inmemory_supervised_table_dataset(d::D;
        n_obs, n_features, n_targets,
        feature_names=nothing, target_names=nothing, 
        Tx=Any, Ty=Any) where {D<:SupervisedDataset}
        
    @test hasfield(D, :metadata)
    @test hasfield(D, :features)
    @test hasfield(D, :targets)
    @test hasfield(D, :dataframe)
    @test d.metadata isa Dict{String, Any} 
    
    as_df = d.features isa DataFrame

    if as_df
        @test d.features isa DataFrame
        @test d.targets isa DataFrame
        @test d.dataframe isa DataFrame
        @test isempty(intersect(names(d.features), names(d.targets)))
        @test size(d.dataframe) == (n_obs, n_features + n_targets)
        @test size(d.features) == (n_obs, n_features)
        @test size(d.targets) == (n_obs, n_targets)
        
        # check that dataframe shares the same storage of features and targets
        for c in names(d.dataframe)
            if c in names(d.targets)
                @test d.dataframe[!, c] === d.targets[!,c] 
            else
                @test d.dataframe[!, c] === d.features[!,c]
            end
        end

        if feature_names !== nothing
            @test names(d.features) == feature_names
        end
        if target_names !== nothing
            @test names(d.targets) == target_names
        end
    else
        @test d.features isa Matrix{<:Tx}
        @test d.targets isa Matrix{<:Ty}
        @test d.dataframe === nothing
        @test size(d.features) == (n_features, n_obs)
        @test size(d.targets) == (n_targets, n_obs)

        if feature_names !== nothing
            @test d.metadata["feature_names"] == feature_names
        end
        if target_names !== nothing
            @test d.metadata["target_names"] == target_names
        end
    end

    @test d[] === (; d.features, d.targets)
    @test length(d) == n_obs
    @test numobs(d) == n_obs
    idx = rand(1:n_obs)
    @test isequal(d[idx], getobs((; d.features, d.targets), idx))
    @test isequal(d[idx], getobs(d, idx))
    idxs = rand(1:n_obs, 2)
    @test isequal(d[idxs], getobs((; d.features, d.targets), idxs))
    @test isequal(d[idxs], getobs(d, idxs))
end


function test_supervised_array_dataset(d::D;
        n_obs, n_features, n_targets,
        Tx=Any, Ty=Any,
        conv2img=false) where {D<:SupervisedDataset}
        
    if n_features isa Int
        @assert n_features != 0 "use n_features=() if you don't want features dimensions"
        Nx == 2
    else # tuple
        Nx = length(n_features) + 1
    end
    Ny = map(x -> x == 1 ? 1 : 2, n_targets)

    @test d.features isa Array{Tx, Nx}
    @test size(d.features) == (n_features..., n_obs)
    
    if Ny isa NamedTuple
        for k in keys(Ny)
            ny = Ny[k]
            @test d.targets[k] isa Array{Ty, ny}
            if ny == 1
                @test size(d.targets[k]) == (n_obs,)
            else 
                @test size(d.targets[k]) == (ny, n_obs)
            end
        end
    else 
        @assert Ny isa Int
        if Ny == 1
            @test size(d.targets) == (n_obs,)
        else 
            @test size(d.targets) == (Ny, n_obs)
        end
    end

    @test length(d) == n_obs
    @test numobs(d) == n_obs
    X, y = d[]
    @test X === d.features
    @test y === d.targets 

    idx = rand(1:n_obs)
    @test isequal(d[idx], getobs((; d.features, d.targets), idx))
    @test isequal(d[idx], getobs(d, idx))
    idxs = rand(1:n_obs, 2)
    @test isequal(d[idxs], getobs((; d.features, d.targets), idxs))
    @test isequal(d[idxs], getobs(d, idxs))
    
    if conv2img
        img = convert2image(d, 1)
        @test img isa AbstractArray{<:Color}
        x = d[1].features
        @test convert2image(D, x) == img
        @test convert2image(d, x) == img
    end 
end


function test_unsupervised_array_dataset(d::D;
        n_obs, n_features,
        Tx=Any,
        conv2img=false) where {D<:UnsupervisedDataset}
        
    n_features = n_features === nothing ? () : n_features
    if n_features isa Int
        @assert n_features != 0 "use n_features = () if you don't want features dimensions"
        Nx == 2
    else # tuple
        Nx = length(n_features) + 1
    end
  
    @test d.features isa Array{Tx, Nx}
    @test size(d.features) == (n_features..., n_obs)
    
    @test length(d) == n_obs
    @test numobs(d) == n_obs
    X = d[]
    @test X === d.features
    
    idx = rand(1:n_obs)
    @test isequal(d[idx], getobs(d.features, idx))
    @test isequal(d[idx], getobs(d, idx))
    idxs = rand(1:n_obs, 2)
    @test isequal(d[idxs], getobs(d.features, idxs))
    @test isequal(d[idxs], getobs(d, idxs))
    
    if conv2img
        img = convert2image(d, 1)
        @test img isa AbstractArray{<:Color}
        x = d[1].features
        @test convert2image(D, x) == img
        @test convert2image(d, x) == img
    end 
end
