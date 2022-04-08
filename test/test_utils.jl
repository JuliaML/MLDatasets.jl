
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

    @test d[] === (d.features, d.targets)
    @test length(d) == n_obs
    idx = rand(1:n_obs)
    @test isequal(d[idx], getobs((d.features, d.targets), idx))
    idxs = rand(1:n_obs, 2)
    @test isequal(d[idxs], getobs((d.features, d.targets), idxs))
end
