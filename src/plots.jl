using Plots


"""
	coordinates(polymer)

Return the array whose `i`-th element is the array of `i`-th components of the elements of
`polymer`.
"""
function coordinates(polymer::Polymer)
	dim = polymer.dim
	steps = polymer.steps

	return [[polymer[step][i] for step = 0:length(polymer)] for i = 1:dim]
end


"""
	poly_plot(polymer, interactive=true; kwargs...)

Display the plot of a 2- or 3-dimensional `Polymer`.

If `interactive` is set to `true`, display an interactive plot generated with the Plotly
backend.

# Keyword arguments

Any keyword arguments are passed on to the plotting function `Plots.plot`. Otherwise, the
following defaults are used:

* If `interactive=false`:
 * `legend=false`;
 * `grid=false`;
 * `showaxis=false`;
 * `foreground_color_text=:white`.
* If `interactive=true`:
 * `legend=false`

# Examples

Save the plot of `poly` as `poly.png`:

```julia
poly_plot(poly);
savefig('poly.png')
```

Post the plot of a 2D `Polymer` `poly2d` to the Plotly cloud:

```julia
x, y = coordinates(poly2d)
using Plotly
p = Plotly.plot([Plotly.scatter(x=x, y=y)]);
post(p)
```

Post the plot of a 3D `Polymer` `poly3d` to the Plotly cloud:

```julia
x, y, z = coordinates(poly3d)
using Plotly
p = Plotly.plot([Plotly.scatter3d(x=x, y=y, mode="lines)])
post(p)
```
"""
function poly_plot(polymer::Polymer, interactive=false; kwargs...)
	dim = polymer.dim

	coords = coordinates(polymer)

	if isequal(interactive, true)
		plotly()
		return Plots.plot(coords...; legend=false)
	else
		if !isequal(backend(), Plots.GRBackend())
			gr()
		end
		return Plots.plot(coords...; legend=false, grid=false, showaxis=false,
					foreground_color_text=:white, kwargs...)
	end
end


"""
	anim(num_frames, init, file[, seed; kwargs...])

Save an animation of `num_frames` successful pivot moves as a gif file specified by `file`.

If `init` is a `Polymer`, then it is used as the initial state of the algorithm.
If `init` is an integer, `Polymer(init)` is used as the initial state.

Any keyword arguments are passed on to the plotting function `Plots.plot`.
"""
function anim end

function anim(num_frames::Int, init::Int, file::String="./temp_polymer_anim.gif")
	return anim(num_frames, init, file, rand(UInt))
end

function anim(num_frames::Int, init::Int, file::String, seed::Integer)
	return anim(num_frames, Polymer(init), file, seed)
end

function anim(num_frames::Int, init::Polymer, file::String="./temp_polymer_anim.gif")
	return anim(num_frames, init, file, rand(UInt))
end

function anim(num_frames::Int, poly::Polymer, file::String, seed::Integer; kwargs...)
	# Initialize animation with first frame
	anim = Animation()
	poly_plot(poly; kwargs...)
	frame(anim)

	# Build animation
	for i = 1:num_frames
		seed += 1
		new_poly = rand_pivot!(poly, seed)

		# Only add new frames
		if new_poly != poly
			poly = new_poly
			poly_plot(poly; kwargs...)
			frame(anim)
		else
			i -= 1
		end
	end

	gif(anim, file, fps=2)
end
