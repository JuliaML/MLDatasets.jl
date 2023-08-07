function __init__pemsbay()
    DEPNAME = "PEMSBAY"
    LINK = "http://www-sop.inria.fr/members/Aurora.Rossi/index.html"
    register(ManualDataDep(DEPNAME,
                           """
                           Dataset: $DEPNAME
                           Website : $LINK
                           """))
end

"""
    PEMSBAY(; num_timesteps_in::Int = 12, num_timesteps_out::Int=12, dir=nothing, normalize = true)

The PEMS-BAY dataset described in the [Diffusion Convolutional Recurrent Neural Network: Data-Driven Traffic Forecasting](https://arxiv.org/abs/1707.01926) paper.
It is collected by California Transportation Agencies (Cal-
Trans) Performance Measurement System (PeMS).

`PEMSBAY` is a graph with 325 nodes representing traffic sensors in the Bay Area. 

The edge weights `w` are contained as a feature array in `edge_data` and represent the distance between the sensors. 

The node features are the traffic speed and the time of the measurements collected by the sensors, divided into `num_timesteps_in` time steps. 

The target values are the traffic speed of the measurements collected by the sensors, divided into `num_timesteps_out` time steps.

The `normalize` flag indicates whether the data are normalized using Z-score normalization.
"""
struct PEMSBAY <: AbstractDataset
    graphs::Vector{Graph}
end

function PEMSBAY(;num_timesteps::Int = 12, dir = nothing, normalize = true)
    s, t, w, x, y = processed_traffic("PEMSBAY", num_timesteps, dir, normalize)

    g = Graph(; num_nodes = 325,
              edge_index = (s, t),
              edge_data = w,
            node_data = (features = x, targets = y))
            
    return PEMSBAY([g])
end

Base.length(d::PEMSBAY) = length(d.graphs)
Base.getindex(d::PEMSBAY, ::Colon) = d.graphs[1]
Base.getindex(d::PEMSBAY, i) = getindex(d.graphs, i)
