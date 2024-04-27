using Random


"""
	pivot!(polymer, step, Rot)

Pivot `polymer` via rotation matrix `Rot` at `step`.
"""
function pivot(polymer::Polymer, step::Int, Rot::AbstractMatrix{Int})
	steps = length(polymer)
	point = polymer[step]		# Pivot point

	new_points = []
	# pivot_steps = step < steps ? (step+1:steps) : 0:step
	pivot_steps = step+1:steps
	for i in pivot_steps
		new_point = point + Rot * (polymer[i] - point)
		if 1 <= get(polymer.pt2idx, new_point, 0) <= step
			return false
		end
		push!(new_points, new_point)
	end
	return new_points
end


"""
	rand_pivot!(polymer[, seed])

Apply a random pivot move to `polymer`.
"""
function rand_pivot! end

rand_pivot!(polymer::Polymer, start_step) = rand_pivot!(polymer, start_step, rand(UInt))

function rand_pivot!(polymer::Polymer, start_step, seed::Integer)
	steps = length(polymer)
	dim = polymer.dim

	# Sample random pivot point step and rotation
	Random.seed!(seed)
	Rot = rand_lattice_rot(dim, seed)

	# Apply Pivot
	step_range = start_step:min(start_step + Threads.nthreads() - 1, steps)
	proposals = Vector{Threads.Ref}(undef, length(step_range))
	Threads.@threads for i in eachindex(step_range)
		proposals[i] = Threads.Ref(pivot(polymer, step_range[i], Rot))
	end
	for i in eachindex(step_range)
		new_points = proposals[i][]
		if new_points != false
			step = step_range[i]
			pivot_steps = step+1:steps
			for j in pivot_steps
				polymer[j] = new_points[j - step]
			end
			return true, step
		end
	end
	return false, start_step + Threads.nthreads() - 1
end


"""
	mix!(polymer, iter[, callbacks, seed])

Iteratively applies `iter` random pivot moves to `polymer`.
"""
function mix! end

mix!(polymer::Polymer, iter::Int) = mix!(polymer, iter, [])

function mix!(polymer::Polymer, iter::Int, callbacks::Array)
	return mix!(polymer, iter, callbacks, rand(UInt))
end

mix!(polymer::Polymer, iter::Int, seed::Integer) = mix!(polymer, iter, [], seed)

function mix!(polymer::Polymer, iter::Int, callbacks::Array, seed::Integer)
	interval = 10 ^ floor(log10(iter / 10))

	print("Mixing polymer\n")
	start_step = 1
	successes = 0
	for i in 1:iter
		# Diagnostics
		if i % interval == 0
			print("Iteration $i\n")
			if !isempty(callbacks)
				print("Callbacks: ")
				for item in callbacks
					print(item(polymer), '\t')
				end
				print('\n')
			end
		end

		# Apply random pivot and increment seed
		success, step = rand_pivot!(polymer, start_step, seed)
		start_step = (step + 1) % length(polymer)
		successes += success
		seed += 1
	end
	print("Success rate: $(successes / iter)\n")
end
