using Plots
include("pivot.jl")


function dist(polymer)
	return norm(polymer[end])
end


# Could also set foreground_color_text=:white
function poly_plot(polymer; kwargs...)
	dim = length(polymer[1])

	coords = [[item[i] for item in polymer] for i = 1:dim]
	plot(coords...; legend=false, grid=false, showaxis=false, foreground_color_text=:white,
		 kwargs...)
end


function anim(num_frames, init, file="./temp_polymer_anim.gif", seed=nothing)
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
