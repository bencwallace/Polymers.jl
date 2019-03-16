using Plots
include("pivot.jl")


function dist(polymer)
	return norm(polymer[end])
end


function poly_plot(polymer; legend=false, grid=false, showaxis=false, kwargs...)
	dim = length(polymer[1])

	coords = [[item[i] for item in polymer] for i = 1:dim]
	plot(coords...; legend=legend, grid=grid, showaxis=showaxis, kwargs...)
end


function anim(num_frames, init, file="./temp_polymer_anim.gif", seed=nothing)
	# Need an initial seed
	if isequal(seed, nothing)
		seed = rand(UInt)
	end

	if isa(init, Int)
		poly = line(init)
	else
		poly = init
	end

	anim = Animation()
	poly_plot(poly)
	frame(anim)

	for i = 1:num_frames
		seed += 1
		new_poly = rand_pivot(poly, seed)

		# Only add new frames
		if new_poly != poly
			poly = new_poly
			poly_plot(poly)
			frame(anim)
		else
			i -= 1
		end
	end

	gif(anim, file, fps=2)
end
