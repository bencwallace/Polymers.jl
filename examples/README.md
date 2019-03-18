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
