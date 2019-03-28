using Plots
include("pivot.jl")

function dist(polymer)
	return norm(polymer[end])
end


function poly_plot(polymer, interactive=false; kwargs...)
	dim = length(polymer[1])

	coords = [[item[i] for item in polymer] for i = 1:dim]

	if isequal(interactive, true)
		plotly()
		Plots.plot(coords...; legend=false)
	else
		if !isequal(backend(), Plots.GRBackend())
			gr()
		end
		Plots.plot(coords...; legend=false, grid=false, showaxis=false,
					foreground_color_text=:white, kwargs...)
	end
end


function anim(num_frames, init, file="./temp_polymer_anim.gif", seed=nothing; kwargs...)
	# Initialize default arguments
	if isequal(seed, nothing)
		seed = rand(UInt)
	end

	if isa(init, Int)
		poly = line(init)
	else
		poly = init
	end

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
