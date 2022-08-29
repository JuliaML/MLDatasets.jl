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

"""
    MovieLens(name; dir=nothing)

Datasets from the [MovieLens website](https://movielens.org) collected and maintained by [GroupLens](https://grouplens.org/datasets/movielens/).
The MovieLens datasets are presented in a Graph format.
For license and usage resitrictions please refer to the Readme.md of the datasets.

There are 6 versions of movielens datasets currently supported: "100k",  "1m",  "10m", "20m", "25m", "latest-small".
The 100k and 1k datasets contain movie data and rating data along with demographic data.
Starting from the 10m dataset, Movielens datasets no longer contain the demographic data.
These datasets contain movie data, rating data, and tag information.

The 20m and 25m datasets additionally contain [genome tag scores](http://files.grouplens.org/papers/tag_genome.pdf).
Each movie in these datasets contains tag relevance scores for every tag.

Each dataset contains an heterogeneous graph, with two kinds of nodes,
`movie` and `user`. The rating is represented by an edge between them: `(user, rating, movie)`.
20m, 25m, and latest-small datasets also contain `tag` nodes and edges of type `(user, tag, movie)` and
optionally `(movie, score, tag)`.

# Examples

## MovieLens 100K dataset

```julia-repl
julia> data = MovieLens("100k")
MovieLens 100k:
  metadata    =>    Dict{String, Any} with 2 entries
  graphs      =>    1-element Vector{MLDatasets.HeteroGraph}

julia> metadata = data.metadata
Dict{String, Any} with 2 entries:
  "genre_labels"      => ["Unknown", "Action", "Adventure", "Animation", "Children", "Comedy", "Crime", "Documentary", "Drama", "Fa…
  "movie_id_to_title" => Dict(1144=>"Quiet Room, The (1996)", 1175=>"Hugo Pool (1997)", 719=>"Canadian Bacon (1994)", 1546=>"Shadow…

julia> g = data[:]
  Heterogeneous Graph:
    node_types    =>    2-element Vector{String}
    edge_types    =>    1-element Vector{Tuple{String, String, String}}
    num_nodes     =>    Dict{String, Int64} with 2 entries
    num_edges     =>    Dict{Tuple{String, String, String}, Int64} with 1 entry
    edge_indices  =>    Dict{Tuple{String, String, String}, Tuple{Vector{Int64}, Vector{Int64}}} with 1 entry
    node_data     =>    Dict{String, Dict} with 2 entries
    edge_data     =>    Dict{Tuple{String, String, String}, Dict} with 1 entry

### Acess the user information
julia> user_data = g.node_data["user"]
Dict{Symbol, AbstractVector} with 4 entries:
  :age        => [24, 53, 23, 24, 33, 42, 57, 36, 29, 53  …  61, 42, 24, 48, 38, 26, 32, 20, 48, 22]
  :occupation => ["technician", "other", "writer", "technician", "other", "executive", "administrator", "administrator", "student",…
  :zipcode    => ["85711", "94043", "32067", "43537", "15213", "98101", "91344", "05201", "01002", "90703"  …  "22902", "66221", "3…
  :gender     => Bool[1, 0, 1, 1, 0, 1, 1, 1, 1, 1  …  1, 1, 1, 1, 0, 0, 1, 1, 0, 1]

### Access rating information
julia> g.edge_data[("user", "rating", "movie")]
Dict{Symbol, Vector} with 2 entries:
  :timestamp => [881250949, 891717742, 878887116, 880606923, 886397596, 884182806, 881171488, 891628467, 886324817, 883603013  …  8…
  :rating    => Float16[3.0, 3.0, 1.0, 2.0, 1.0, 4.0, 2.0, 5.0, 3.0, 3.0  …  4.0, 4.0, 3.0, 2.0, 3.0, 3.0, 5.0, 1.0, 2.0, 3.0]
```

## MovieLens 100K dataset

```julia-repl
julia> data = MovieLens("20m")
MovieLens 20m:
  metadata    =>    Dict{String, Any} with 4 entries
  graphs      =>    1-element Vector{MLDatasets.HeteroGraph}

### There is only 1 graph in MovieLens dataset
julia> g = data[1]
Heterogeneous Graph:
  node_types    =>    3-element Vector{String}
  edge_types    =>    3-element Vector{Tuple{String, String, String}}
  num_nodes     =>    Dict{String, Int64} with 3 entries
  num_edges     =>    Dict{Tuple{String, String, String}, Int64} with 3 entries
  edge_indices  =>    Dict{Tuple{String, String, String}, Tuple{Vector{Int64}, Vector{Int64}}} with 3 entries
  node_data     =>    Dict{String, Dict} with 0 entries
  edge_data     =>    Dict{Tuple{String, String, String}, Dict} with 3 entries

### Apart from user rating a movie, a user assigns tag to movies and there are genome-scores for movie-tag pairs
julia> g.edge_indices
  Dict{Tuple{String, String, String}, Tuple{Vector{Int64}, Vector{Int64}}} with 3 entries:
    ("movie", "score", "tag")   => ([1, 1, 1, 1, 1, 1, 1, 1, 1, 1  …  131170, 131170, 131170, 131170, 131170, 131170, 131170, 131170,…
    ("user", "tag", "movie")    => ([18, 65, 65, 65, 65, 65, 65, 65, 65, 65  …  3489, 7045, 7045, 7164, 7164, 55999, 55999, 55999, 55…
    ("user", "rating", "movie") => ([1, 1, 1, 1, 1, 1, 1, 1, 1, 1  …  60816, 61160, 65682, 66762, 68319, 68954, 69526, 69644, 70286, …

### Access the rating
julia> g.edge_data[("user", "rating", "movie")]
Dict{Symbol, Vector} with 2 entries:
  :timestamp => [1112486027, 1112484676, 1112484819, 1112484727, 1112484580, 1094785740, 1094785734, 1112485573, 1112484940, 111248…
  :rating    => Float16[3.5, 3.5, 3.5, 3.5, 3.5, 3.5, 4.0, 4.0, 4.0, 4.0  …  4.5, 4.0, 4.5, 4.5, 4.5, 4.5, 4.5, 3.0, 5.0, 2.5]

### Access the movie-tag scores
score = g.edge_data[("movie", "score", "tag")][:score]
23419536-element Vector{Float64}:
 0.025000000000000022
 0.025000000000000022
 0.057750000000000024
 ⋮
```

# References

[1] [GroupLens Website](https://grouplens.org/datasets/movielens/)

[2] [TensorFlow MovieLens Implementation](https://www.tensorflow.org/datasets/catalog/movielens)

[3] Jesse Vig, Shilad Sen, and John Riedl. 2012. The Tag Genome: Encoding Community Knowledge to Support Novel Interaction. ACM Trans. Interact. Intell. Syst. 2, 3, Article 13 (September 2012), 44 pages. https://doi.org/10.1145/2362394.2362395.

[4] F. Maxwell Harper and Joseph A. Konstan. 2015. The MovieLens Datasets: History and Context. ACM Trans. Interact. Intell. Syst. 5, 4, Article 19 (January 2016), 19 pages. https://doi.org/10.1145/2827872
"""
struct MovieLens <: GraphDataset
    name::String
    metadata::Dict{String, Any}
    graphs::Vector{HeteroGraph}
end

function MovieLens(name::String; dir=nothing)
    name = lowercase(name)
    create_default_dir("MovieLens")
    dir = movielens_datadir(name, dir)
    # format varied in older generations of MovieLens datasets
    if name == "100k"
        data = read_100k_data(dir)
    elseif name == "1m"
        data = read_1m_data(dir)
    elseif name == "10m"
        data = read_10m_data(dir)
    elseif name in ["20m", "25m", "latest-small"]
        data = read_current_data(dir)
    else
        error("Functionality for ml-$name has not been implemented yet")
    end
    g = generate_movielens_graph(data...)
    metadata = get_movielens_metadata(data)
    return MovieLens(name, metadata, [g])
end

function read_100k_data(dir::String)
    user_data = read_100k_user_data(dir)
    movie_data = read_100k_movie_data(dir)
    rating_data = read_100k_rating_data(dir)
    return (user_data, movie_data, rating_data)
end

function read_1m_data(dir::String)
    user_data = read_1m_user_data(dir)
    movie_data = read_1m_movie_data(dir)
    rating_data = read_1m_rating_data(dir)
    return (user_data, movie_data, rating_data)
end

function read_10m_data(dir::String)
    rating_data = read_10m_rating_data(dir)
    movies_data = read_10m_movie_data(dir)
    user_tag_data = read_10m_user_tag_data(dir)
    return (movies_data, rating_data, user_tag_data, Dict(), Dict())
end

function read_current_data(dir::String)
    rating_data = read_current_rating_data(dir)
    genome_tag_data = read_genome_tag_data(dir)
    user_tag_data = read_current_user_tag_data(dir)
    movies_data = read_current_movie_data(dir)
    link_data = read_link_data(dir)
    return (movies_data, rating_data, user_tag_data, genome_tag_data, link_data)
end

function read_10m_rating_data(dir::String)
    rating_data_file = "ratings.dat"
    rating_df = read_csv_asdf(joinpath(dir, rating_data_file), header=false, delim="::", quoted=false)
    @assert size(rating_df)[2] == 4

    rating_data = Dict()
    rating_data["user_movie"] = rating_df[!, 1:2] |> Matrix{Int}
    rating_data["rating"] = rating_df[!, 3] |> Vector{Float16}
    rating_data["timestamp"] = rating_df[!, 4] |> Vector{Int}
    return rating_data
end

function read_10m_movie_data(dir::String)
    movie_data_file = "movies.dat"
    movie_df = read_csv_asdf(joinpath(dir, movie_data_file), header=false, delim="::", quoted=false)
    movie_data = Dict()

    movie_ids = movie_df[!, 1]
    @assert minimum(movie_ids) == 1
    movie_data["num_movies"] = length(movie_ids)
    movie_titles = movie_df[!, 2]

    # bit of data cleaning
    movie_titles[9811] = "\"Great Performances\" Cats (1998)"
    genres = movie_df[!, 3]
    # children's and children are same
    genres = replace.(genres, "Children's"=> "Children")
    genres = split.(genres, "|")
    movie_data["genres"] = genres |> Vector{Vector{String}}# user needs to do the one hot matrix using Flux.onehot

    movie_data["metadata"] =  Dict(
        "movie_id_to_title" => Dict( movie_ids .=> movie_df[!, 2]))
    return movie_data
end

function read_10m_user_tag_data(dir::String)
    tag_data_file = "tags.dat"
    tag_df = read_csv(joinpath(dir, tag_data_file), header=false, delim="::", quoted=false)

    tag_data = Dict{String, Any}()
    tag_data["user_movie"] = tag_df[!, 1:2] |> Matrix{Int}
    tag_data["tag_name"] = tag_df[!, 3] |> Vector{String}
    tag_data["timestamp"] = tag_df[!, 4] |> Vector
    return tag_data
end

function read_link_data(dir::String)::Dict
    link_csv = "links.csv"
    link_df = read_csv(joinpath(dir, link_csv))

    movieId  = link_df[:, :movieId]
    imdbId = link_df[:, :imdbId]
    tmdbId = link_df[:, :imdbId]
    metadata = Dict()
    metadata["movieId_to_imdbID"] = Dict(movieId .=> imdbId)
    metadata["movieId_to_tmdbID"] = Dict(movieId .=> tmdbId)
    return Dict("metadata" => metadata)
end

function read_current_rating_data(dir::String)::Dict
    rating_csv = "ratings.csv"
    rating_df = read_csv(joinpath(dir, rating_csv))
    @assert size(rating_df)[2] == 4

    rating_data = Dict()
    rating_data["user_movie"] = rating_df[:, [:userId, :movieId]] |> Matrix{Int}
    rating_data["rating"] = rating_df[:, :rating] |> Vector{Float16}
    rating_data["timestamp"] = rating_df[:, :timestamp] |> Vector{Int}
    return rating_data
end

function read_genome_tag_data(dir::String)::Dict
    tag_csv = "genome-tags.csv"
    score_csv = "genome-scores.csv"
    # return empty dict if the genome files are not present
    isfile(joinpath(dir, tag_csv)) || return Dict()

    tag_df = read_csv(joinpath(dir, tag_csv))
    score_df = read_csv(joinpath(dir, score_csv))

    tag_data = Dict{String, Any}()
    tag_ids = tag_df[:, :tagId]
    @assert minimum(tag_ids) == 1
    tag_data["num_tags"] = maximum(tag_ids)
    tag_data["metadata"] = Dict("tag_id_to_name" => Dict(tag_ids .=> tag_df[:, :tag] |> Vector))
    tag_data["movie_tag"] = score_df[:, [:movieId, :tagId]] |> Matrix{Int}
    tag_data["score"] = score_df[:, :relevance] |> Vector

    return tag_data
end

function read_current_user_tag_data(dir::String)::Dict
    # user tagged a movie to be a certain category
    tag_data_csv = "tags.csv"
    tag_df = read_csv(joinpath(dir, tag_data_csv))

    tag_data = Dict{String, Any}()
    tag_data["tag_name"] = tag_df[:, :tag] |> Vector{String}
    tag_data["user_movie"] = tag_df[:, [:userId, :movieId]] |> Matrix{Int}
    tag_data["timestamp"] = tag_df[:, :timestamp] |> Vector
    return tag_data
end

function read_current_movie_data(dir::String)::Dict
    movie_csv = "movies.csv"
    movie_df = read_csv(joinpath(dir, movie_csv))

    movie_data = Dict{String, Any}()
    movie_data["metadata"] = Dict{String, Vector{String}}()
    movie_ids = movie_df[:, :movieId] |> Vector{Int}
    @assert minimum(movie_ids) == 1
    # @assert maximum(movie_ids) == length(movie_ids)
    movie_data["num_movies"] = length(movie_ids)
    movie_data["metadata"] = Dict(
        "movie_id_to_title" => Dict( movie_ids .=> movie_df[:, :title] |> Vector{String}))

    return movie_data
end

function read_1m_user_data(dir::String)::Dict
    user_data_file = "users.dat"
    user_df = read_csv_asdf(joinpath(dir, user_data_file), header=false, delim="::")
    user_data = Dict()

    occupation_names = [
        "other/not specified",
        "academic/educator",
        "artist",
        "clerical/admin",
        "college/grad student",
        "customer service",
        "doctor/health care",
        "executive/managerial",
        "farmer",
        "homemaker",
        "K-12 student",
        "lawyer",
        "programmer",
        "retired",
        "sales/marketing",
        "scientist",
        "self-employed",
        "technician/engineer",
        "tradesman/craftsman",
        "unemployed",
        "writer",
    ]
    user_ids = user_df[!, 1]
    @assert minimum(user_ids) == 1
    @assert maximum(user_ids) == length(user_ids)
    user_data["num_users"] = maximum(user_ids)
    user_data["gender"] = user_df[!, 2] .== "M"
    user_data["age"] = user_df[!, 3]  |> Vector{Int}
    ouccupation_ids = user_df[!, 4] .+ 1
    user_data["occupation"] = [occupation_names[i] for i in ouccupation_ids]
    user_data["zipcode"] = user_df[!, 5] |> Vector{String}
    return user_data
end

function read_1m_movie_data(dir::String)::Dict
    movie_data_file = "movies.dat"
    movie_df = read_csv_asdf(joinpath(dir, movie_data_file), header=false, delim="::")
    movie_data = Dict()

    movie_ids = movie_df[!, 1]
    @assert minimum(movie_ids) == 1
    movie_data["num_movies"] = length(movie_ids)
    genres = movie_df[!, 3]
    # children's and children are same
    genres = replace.(genres, "Children's"=> "Children")
    genres = split.(genres, "|")
    movie_data["genres"] = genres |> Vector{Vector{String}} # user needs to do the one hot matrix using Flux.onehot

    movie_data["metadata"] = Dict(
        "movie_id_to_title" => Dict( movie_ids .=> movie_df[!, 2]))
    return movie_data
end

function read_1m_rating_data(dir::String)::Dict
    rating_data_file = "ratings.dat"

    rating_info = read_csv(joinpath(dir, rating_data_file), Matrix{Int}, header=false, delim="::")
    @assert size(rating_info)[2] == 4

    rating_data = Dict()
    rating_data["user_movie"] = rating_info[:, 1:2]
    rating_data["rating"] = rating_info[:, 3] |> Vector{Float16}
    rating_data["timestamp"] = rating_info[:, 4]
    return rating_data
end

function read_100k_user_data(dir::String)::Dict
    user_data_file = "u.user"
    user_data = Dict()
    user_df = read_csv_asdf(joinpath(dir, user_data_file), header=false)

    user_ids = user_df[!, 1]
    @assert minimum(user_ids) == 1
    @assert maximum(user_ids) == length(user_ids)
    user_data["num_users"] = maximum(user_ids)
    user_data["age"] = user_df[!, 2] |> Vector{Int}
    user_data["gender"] = user_df[!, 3] .== "M" # I hope I don't get cancelled for binarizing this field
    user_data["occupation"] = user_df[!, 4] |> Vector{String}
    user_data["zipcode"] = user_df[!, 5]  |> Vector{String}
    return user_data
end

function read_100k_rating_data(dir::String)::Dict
    rating_data_file = "u.data"
    rating_info = read_csv(joinpath(dir, rating_data_file), Matrix{Int}, header=false)
    @assert size(rating_info)[2] == 4

    rating_data = Dict()
    rating_data["user_movie"] = rating_info[:, 1:2]
    rating_data["rating"] = rating_info[:, 3] |> Vector{Float16}
    rating_data["timestamp"] = rating_info[:, 4]
    return rating_data
end

function read_100k_movie_data(dir::String)::Dict
    movie_data_file = "u.item"
    movie_df = read_csv_asdf(joinpath(dir, movie_data_file), header=false, dateformat="dd-u-yyyy")
    movie_data = Dict()

    genre_labels = [ "Unknown", "Action", "Adventure", "Animation", "Children", "Comedy",
    "Crime", "Documentary", "Drama", "Fantasy", "Film-Noir", "Horror", "Musical",
    "Mystery", "Romance", "Sci-Fi", "Thriller", "War", "Western" ]
    movie_ids = movie_df[!, 1]
    @assert minimum(movie_ids) == 1
    @assert maximum(movie_ids) == length(movie_ids)
    movie_data["num_movies"] = maximum(movie_ids)
    movie_data["release_date"] = movie_df[!, 3]
    genres = movie_df[!, 6:end] |> Matrix{Bool}
    genres = permutedims(genres, (2, 1))
    movie_data["genres"] = genres

    movie_data["metadata"] = Dict()
    movie_data["metadata"]["movie_id_to_title"] = Dict( movie_ids .=> movie_df[!, 2])
    movie_data["metadata"]["genre_labels"] = genre_labels
    return movie_data
end

function generate_movielens_graph(user_data::Dict, movie_data::Dict, rating_data::Dict)::HeteroGraph
    num_nodes = Dict("user" => user_data["num_users"], "movie" => movie_data["num_movies"])
    node_data = Dict()
    node_data["user"] = Dict(Symbol(k) => maybesqueeze(v) for (k, v) in user_data if k ∉ ["num_users", "metadata"])
    node_data["movie"] = Dict(Symbol(k) => maybesqueeze(v) for (k, v) in movie_data if k ∉ ["num_movies", "metadata"])

    user_rates_movie = rating_data["user_movie"]
    user_ids, movie_ids = user_rates_movie[:, 1], user_rates_movie[:, 2]
    edge_indices = Dict(("user", "rating", "movie") => ([user_ids; movie_ids], [movie_ids; user_ids]))

    edge_data = Dict(("user", "rating", "movie") => Dict(Symbol(k) => maybesqueeze([v;v]) for (k, v) in rating_data if  k ∉ ["user_movie", "metadata"]))

    return HeteroGraph(; num_nodes, edge_indices, node_data, edge_data)
end

function generate_movielens_graph(movie_data::Dict, rating_data::Dict, user_tag_data::Dict, genome_tag_data::Dict, link_data::Dict)::HeteroGraph

    edge_indices = Dict()
    user_rates_movie = rating_data["user_movie"]
    user_ids, movie_ids = user_rates_movie[:, 1], user_rates_movie[:, 2]
    num_users = user_ids |> unique |> length # Calculate the number of users
    edge_indices[("user", "rating", "movie")] = ([user_ids; movie_ids], [movie_ids; user_ids])

    user_tags_movie = user_tag_data["user_movie"]
    user_ids, movie_ids = user_tags_movie[:, 1], user_tags_movie[:, 2]
    num_users = max(num_users, user_ids |> unique |> length)
    edge_indices[("user", "tag", "movie")] = ([user_ids; movie_ids], [movie_ids; user_ids])

    if !isempty(genome_tag_data)
        movie_score_tag = genome_tag_data["movie_tag"]
        movie_ids, tag_ids = movie_score_tag[:, 1], movie_score_tag[:, 1]
        edge_indices[("movie", "score", "tag")] = ([movie_ids; tag_ids], [movie_ids; tag_ids])
    end

    # ideally the HeteroGraph function should be able to compute the number of egdes,
    # but we know other 2 values, so it is ifefficient to compute other two again
    # num_nodes = Dict("user" => num_users, "tag" => genome_tag_data["num_tags"], "movie" => movie_data["num_movies"])
    num_nodes = Dict("user" => num_users, "tag" => length(user_tag_data["tag_name"]), "movie" => movie_data["num_movies"])

    _edge_data = Dict()
    _edge_data[("user", "rating", "movie")] = Dict(
        Symbol(k) => maybesqueeze([v;v]) for (k, v) in rating_data if  k ∉ ["user_movie", "metadata"])
    _edge_data[("user", "tag", "movie")] = Dict(
        Symbol(k) => maybesqueeze([v;v]) for (k, v) in user_tag_data if  k ∉ ["user_movie", "metadata"])
    isempty(genome_tag_data) || (_edge_data[("movie", "score", "tag")] = Dict(
        Symbol(k) => maybesqueeze([v;v]) for (k, v) in genome_tag_data if  k ∉ ["movie_tag", "metadata", "num_tags"]))

    edge_data = Dict(k=>v for (k,v) in _edge_data if !isempty(v))

    _node_data = Dict()
    _node_data["movie"] = Dict(Symbol(k) => maybesqueeze(v) for (k, v) in movie_data if k ∉ ["num_movies", "metadata"])
    node_data = Dict(k=>v for (k,v) in _node_data if !isempty(v))

    return HeteroGraph(; num_nodes, edge_indices, node_data, edge_data)
end

function get_movielens_metadata(data::Tuple)::Dict
    # the recieved data in generally user_data, movie_data and rating_data
    metadata = Dict()
    for d in data
        if haskey(d, "metadata")
            for (k, v) in d["metadata"]
                metadata[k] = v
            end
        end
    end
    return metadata
end

function movielens_datadir(name, dir = nothing)
    dir = isnothing(dir) ? datadep"MovieLens" : dir
    dname = "ml-" * name
    LINK = "https://files.grouplens.org/datasets/movielens/$dname.zip"
    d  = joinpath(dir, dname)
    if !isdir(d)
        DataDeps.fetch_default(LINK, dir)
        currdir = pwd()
        cd(dir) # Needed since `unpack` extracts in working dir
        DataDeps.unpack(joinpath(dir, "$dname.zip"))
        # conditions when unzipped folder is our required data dir
        if name == "10m"
            unzipped = joinpath(dir, "ml-10M100K")
            mv(unzipped, d) # none of them are relative path
        end
        cd(currdir)
    end
    @assert isdir(d)
    return d
end

function Base.show(io::IO, ::MIME"text/plain", d::MovieLens)
    recur_io = IOContext(io, :compact => false)

    print(io, "MovieLens $(d.name):")  # if the type is parameterized don't print the parameters

    for f in fieldnames(MovieLens)
        if !startswith(string(f), "_") && f != :name
            fstring = leftalign(string(f), 10)
            print(recur_io, "\n  $fstring  =>    ")
            # show(recur_io, MIME"text/plain"(), getfield(d, f))
            # println(recur_io)
            print(recur_io, "$(_summary(getfield(d, f)))")
        end
    end
end
