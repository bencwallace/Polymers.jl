module Polymers

export Polymer, stairs, bridge
export mix
export dist
export poly_plot, anim

include("core.jl")

# The following use core
include("pivot.jl")
include("plots.jl")

end
