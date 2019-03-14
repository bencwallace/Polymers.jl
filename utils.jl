using Plots
include("pivot.jl")


function dist(polymer)
	return norm(polymer[end])
end


function poly_plot(polymer)
	x = [item[1] for item in polymer]
	y = [item[2] for item in polymer]

	plot(x, y, legend=false)
end


function anim(num_frames, steps, seed=nothing)
	# Need an initial seed
	if isequal(seed, nothing)
		seed = rand(Int)
	end

	poly = line(steps)

	anim = Animation()
	poly_plot(poly)
	frame(anim)

	for i = 1:num_frames
		seed += 1
		new_poly = rand_pivot(poly, seed)

		if new_poly != poly
			poly = new_poly
			poly_plot(poly)
			frame(anim)
			continue
		end

		# No frame added if this point reached
		i -= 1
	end

	gif(anim, "./test.gif", fps=2)
end
