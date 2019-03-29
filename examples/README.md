# Examples

This directory contains some pre-generated examples. These include:

* [Julia Data](https://github.com/JuliaIO/JLD.jl) (.jld) files, containing polymers named "poly";
* plots in png format; and
* animations in gif format.

Descriptions of the available examples are included in `examples.txt`.

## Loading from JLD

Polymers can be loaded from jld files using the JLD package. JLD can be installed as follows:

```julia
using Pkg
Pkg.add("JLD")
```

Once JLD is installed, a polymer can be loaded as follows:

```julia
using JLD

# Replace "poly2d_10000_100000.jld" by desired jld file
poly = load("poly2d_10000_100000.jld")["poly"];
```

## List of examples

### JLD

* poly2d.jld
 * 2 dimensions
 * 10 000 steps
 * initialized with line
 * 100 000 iterations
 * https://plot.ly/~bencwallace/4
* poly2d_long.jld
 * 2 dimensions
 * 100 000 steps
 * initialized with line
 * 10 000 iterations
 * https://plot.ly/~bencwallace/12
* poly2d_bridge.jld
 * 2 dimensions
 * 100 000 steps
 * initialized with bridge
 * 10 000 iterations
 * https://plot.ly/~bencwallace/10
* poly3d.jld
 * 3 dimensions
 * 10 000 steps
 * initialized with line
 * 100 000 iterations
 * https://plot.ly/~bencwallace/8

### PNG

* plot2d.png
 * generated from poly2d.jld
* plot2d_long.png
 * generated from poly2d_long.jld
* plot2d_bridge.png
 * generated from poly2d_bridge.jld
* plot3d.png
 * generated from poly3d.jld

### GIF

* anim2d.gif
 * initialized with poly2d.jld
 * 100 frames
* anim3d.gif
 * initialized with poly3d.jld
 * 100 frames
