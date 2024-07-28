> [!NOTE]
> For an even faster implementation of the pivot algorithm, see [pivot](https://github.com/bencwallace/pivot).

# Polymers.jl

A Julia implementation of the pivot algorithm: a Markov chain Monte carlo (MCMC) sampler for the self-avoiding walk (SAW) model of a linear polymer chain.

## Interactive examples

Click on any of the (static) images below to view interactive examples (generated with [Plotly](https://plot.ly/)).

<table style="width:100%">
	<!-- 2D -->
	<!-- Images -->
	<tr>
		<td>
			<a href="https://plot.ly/~bencwallace/14/" target="_blank">
			<img src="examples/plot2d_bridge.png" style="width:100%" />
			</a>
		</td>
		<td><img src="examples/anim2d.gif" style="width:100%" /></td>
	</tr>
	<!-- Captions -->
	<tr>
		<td><font size="1">2D SAW with 100 000 steps</font></td>
		<td><font size="1">Pivot algorithm in 2D for a walk with 10 000 steps</font></td>
	</tr>
	<!-- 3D -->
	<!-- Images -->
	<tr>
		<td>
			<a href="https://plot.ly/~bencwallace/16/" target="_blank">
			<img src="examples/plot3d_bridge.png" style="width:100%" />
			</a>
		</td>
		<td><img src="examples/anim3d.gif" style="width:100%" /></td>
	</tr>
	<!-- Captions -->
	<tr>
		<td><font size="1">3D SAW with 100 000 steps</font></td>
		<td><font size="1">Pivot algorithm in 3D for a walk with 10 000 steps</font></td>
	</tr>
</table>

## Usage

### Setup

**Requirements** 

Julia 1.1-1.3 is required.

Specifically, this project was developed using Julia 1.1.0 and appears to work up to Julia 1.3.
Later versions either don't produce walks correctly or don't plot them correctly.

### Quick start

Start by activating the project environment in the Julia REPL:

```
julia> ]
(v1.1) pkg> activate .
(Polymers) pkg> instantiate
```

Initialize a 3-dimensional polymer as a straight line with 1000 steps:

```julia
using Polymers

poly3d = Polymer(1000, 3)
```

Initialize a 2-dimensional polymer and run the pivot algorithm for 10000 iterations:

```julia
poly = Polymer(1000)
mix!(poly, 10000)
```

Plot a polymer:

```julia
poly_plot(poly)
```

Make an interactive plot:
```julia
poly_plot(poly, true)
```

Produce an animation of the pivot algorithm run for 100 *successful* steps and save it to "pivot_anim.gif":

```julia
anim(100, Polymer(100), "pivot_anim.gif")
```

### Other initializers

The `stairs` function initializes a polymer in the shape of a staircase.

The `bridge` function initializes a polymeer in the shape of a self-avoiding bridge, which is Markovian and does not take long to generate. This initialization appears to greatly improve mixing, as apparent from the following examples, both of which have 100000 steps and are the result of running the pivot algorithm for 10000 iterations.

<table style="width:100%">
	<!-- Images -->
	<tr>
		<td>
			<a href="https://plot.ly/~bencwallace/12/" target="_blank">
			<img src="examples/plot2d_long.png" style="width:100%" />
			</a>
		</td>
		<td>
			<a href="https://plot.ly/~bencwallace/14/" target="_blank">
			<img src="examples/plot2d_bridge.png" style="width:100%" />
			</a>
		</td>
	</tr>
	<!-- Captions -->
	<tr>
		<td><font size="1">2D SAW initialized from a line</font></td>
		<td><font size="1">2D SAW initialized from a bridge</font></td>
	</tr>
</table>

## To do

* It should be possible to parallelize the pivot operation since every point on the tail (pivoted) segment of a walk is pivoted independently. This should lead to a roughly linear (in the number of available CPU cores) speedup. However, note this requires some Julia implementation of (parallel) map-reduce (see [Folds.jl](https://juliafolds.github.io/Folds.jl/dev/)).
* Hashing lattice sites in order to update the reverse index associated with a `Polymer` struct currently appears to be a bottleneck.
* Interactive animations generated with Plotly.
