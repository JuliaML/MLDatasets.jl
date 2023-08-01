function __init__metrla()
    DEPNAME = "METRLA"
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/index.html"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """))
end

"""
    METRLA(; num_timesteps_in::Int = 12, num_timesteps_out::Int=12, dir=nothing, normalize = true)

The METR-LA dataset from the [Diffusion Convolutional Recurrent Neural Network: Data-Driven Traffic Forecasting](https://arxiv.org/abs/1707.01926) paper.

`METRLA` is a graph with 207 nodes representing traffic sensors in Los Angeles. 

The edge weights `w` are contained as a feature array in `edge_data` and represent the distance between the sensors. 

The node features are the traffic speed and the time of the measurements collected by the sensors, divided into `num_timesteps_in` time steps. 

The target values are the traffic speed of the measurements collected by the sensors, divided into `num_timesteps_out` time steps.

The `normalize` flag indicates whether the data are normalized using Z-score normalization.
"""
struct METRLA <: AbstractDataset
    graphs::Vector{Graph}
end

function METRLA(;num_timesteps_in::Int = 12, num_timesteps_out::Int=12, dir = nothing, normalize = true)
    s, t, w, x, y = processed_traffic("METRLA", num_timesteps_in, num_timesteps_out, dir, normalize)

    g = Graph(; num_nodes = 207,
              edge_index = (s, t),
              edge_data = w,
            node_data = (features = x, targets = y))
            
    return METRLA([g])
end

Base.length(d::METRLA) = length(d.graphs)
Base.getindex(d::METRLA, ::Colon) = d.graphs[1]
Base.getindex(d::METRLA, i) = getindex(d.graphs, i)
