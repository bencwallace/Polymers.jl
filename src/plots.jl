using Plots


function coordinates(polymer::Polymer)
	dim = polymer.dim
	steps = polymer.steps

	return [[polymer[step][i] for step = 0:length(polymer)] for i = 1:dim]
end


# To post a 2D polymer `poly` to Plotly:
# >>> x, y = coordinates(poly)
# >>> using Plotly
# >>> p = Plotly.plot([Plotly.scatter(x=x, y=y)]);
# >>> post(p)
# For a 3D polymer, use scatter3d instead (with option mode="lines")
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

function anim(num_frames::Int, init::Polymer, file::String, seed::Integer; kwargs...)
	# Initialize animation with first frame
	anim = Animation()
	poly_plot(poly; kwargs...)
	frame(anim)

	# Build animation
	for i = 1:num_frames
		seed += 1
		new_poly = rand_pivot(poly, seed)

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
