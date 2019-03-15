# Polymer

A Julia implementation of the pivot algorithm: a Markov chain Monte carlo (MCMC) sampler for the self-avoiding walk (SAW) model of a linear polymer chain.

## Related

My other repository, [*saw*](https://github.com/bencwallace/saw) includes a Python implementation of the pivot algorithm (as well as of the Metropolis-Hastings algorithm for simulating other models of linear polymers), emphasizes object-oriented design, and includes a pedagogical explanation of self-avoiding walk and MCMC methods in a Jupyter [notebook](https://github.com/bencwallace/saw/blob/master/saw-simulation.ipynb).

*Polymer*, on the other hand, places emphasis on speed of computation for the pivot algorithm using [Julia](https://julialang.org/).

## Optimization

This implementation of the pivot algorithm is optimized in the following ways.

* Lattice rotations are represented as `SparseArray` objects. Matrix multiplication by a sparse array can be performed in linear (rather than quadratic) time (in the dimension). The pivot algorithm performs linearly many (in the number of polymer steps) matrix multiplications *per iteration*. An additional advantage of sparse arrays is that they require far less memory.
* Prior to pivoting, the initial (un-pivoted) segment of a walk is converted to a `Set` object, which is a type of hash table, allowing for constant time lookups (as opposed to linear or, at best, logarithmic time for searching an array or list). The conversion itself requires linear time but need only be performed once (per iteration), whereas a linear number of lookups is required. Thus, the speedup per iteration is from quadratic (or at least super-linear) to linear time.

The following optimization would also be desirable.

* It should be possible to parallelize the pivot operation since every point on the tail (pivoted) segment of a walk is pivoted independently. This should lead to a roughly linear (in the number of available CPU cores) speedup.

## Examples

<table style="width:100%">
	<tr>
		<td><img src="examples/plot_10000_10000.png" style="width:100%" /></td>
		<td><img src="examples/anim_100_1000_pre_1000.gif" style="width:100%" /></td>
	</tr>
	<tr>
		<td><font size="1">SAW with 10000 steps</font></td>
		<td><font size="1">Pivot algorithm on 1000 steps</font></td>
	</tr>
</table>
