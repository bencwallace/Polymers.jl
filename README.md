# Polymer

A Julia implementation of the pivot algorithm: a Markov chain Monte carlo (MCMC) sampler for the self-avoiding walk (SAW) model of a linear polymer chain.

**Related**

My other repository, [*saw*](https://github.com/bencwallace/saw) includes a Python implementation of the pivot algorithm (as well as of the Metropolis-Hastings algorithm for simulating other models of linear polymers), emphasizes object-oriented design, and includes a pedagogical explanation of self-avoiding walk and MCMC methods in a Jupyter [notebook](https://github.com/bencwallace/saw/blob/master/saw-simulation.ipynb).

*Polymer*, on the other hand, places emphasis on speed of computation for the pivot algorithm using [Julia](https://julialang.org/).

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
