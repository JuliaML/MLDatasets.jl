function __init__movielens()
    DEPNAME = "MovieLens"
    DOCS = "https://grouplens.org/datasets/movielens/"

    register(ManualDataDep(
        DEPNAME,
        """
        Datahub: $DEPNAME.
        Website: $DOCS
        """,
    ))
end

struct MovieLens
  metadata::Dict{String, Any}
  graphs::Vector{HeteroGraph}
end

function MovieLens(name::String; dir=nothing)
    create_default_dir("MovieLens")
    dir = movielens_datadir(name, dir)
    ratings_data_file = "u.data"
    movie_data_file = "u.item"
    user_data_file = "u.user"

    metadata = Dict()
    node_data = Dict()

    # movie information
    movie_df = read_csv_asdf(joinpath(dir, movie_data_file), header=false, dateformat="dd-u-yyyy")
    movie_ids = movie_df[!, 1]
    metadata["movie_names"] = movie_df[!, 2]
    release_date = movie_df[!, 3]
    movie_genres = movie_df[!, 6:end] |> Matrix{Bool}
    @assert minimum(movie_ids) == 1

    # information obtained from 
    metadata["genre_labels"] = [ "Unknown", "Action", "Adventure", "Animation", "Children", "Comedy",
        "Crime", "Documentary", "Drama", "Fantasy", "Film-Noir", "Horror", "Musical",
        "Mystery", "Romance", "Sci-Fi", "Thriller", "War", "Western" ]

    node_data["movie"] = Dict("genres" => movie_genres, "release_date" => release_date)

    # user
    user_df = read_csv_asdf(joinpath(dir, user_data_file), header=false)
    user_ids = user_df[!, 1]
    user_age = user_df[!, 2]
    user_gender = user_df[!, 3] .== "M" # I hope I don't get cancelled for binarizing this field
    user_occupation = user_df[!, 4]
    user_zipcode = user_df[!, 5]
    @assert minimum(user_ids) == 1

    node_data["user"] = Dict("age" => user_age, "gender" => user_gender, "occupation" => user_occupation, "zipcode" => user_zipcode)
    num_nodes = Dict("user" => length(user_ids), "movie" => length(movie_ids))

    # rating
    ratings_data = read_csv(joinpath(dir, ratings_data_file), header=false)
    @assert size(ratings_data)[2] == 4
    user_id, movie_id = ratings_data[:, 1], ratings_data[:, 2]
    # check the user_id and movie_ids maximum and minimum values
    edge_indices = Dict(("user", "rating", "movie") => ([user_id; movie_id], [movie_id; user_id]))
    edge_data = Dict(("user", "rating", "movie") => Dict("rating" => ratings_data[:, 3], "timestamp" => ratings_data[:, end]))

    g = HeteroGraph(;num_nodes, edge_indices, node_data, edge_data)
    return MovieLens(metadata, [g])
end

function movielens_datadir(name, dir = nothing)
    dir = isnothing(dir) ? datadep"MovieLens" : dir
    dname = "ml-" * lowercase(name)
    LINK = "https://files.grouplens.org/datasets/movielens/$dname.zip"
    d  = joinpath(dir, dname)
    if !isdir(d)
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "$dname.zip"))
        cd(currdir)
    end
    @assert isdir(d)
    return d
end
