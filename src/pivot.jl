using Random


"""
	pivot!(polymer, step, Rot)

Pivot `polymer` via rotation matrix `Rot` at `step`.
"""
function pivot!(polymer::Polymer, step::Int, Rot::AbstractMatrix{Int})
	steps = length(polymer)
	point = polymer[step]		# Pivot point

	# TODO: Try to parallelize this
	new_points = []
	for i in step+1:steps
		new_point = point + Rot * (polymer[i] - point)
		if 1 <= get(polymer.pt2idx, new_point, 0) <= step
			return polymer
		end
		push!(new_points, new_point)
	end

	for i in step+1:steps
		polymer[i] = new_points[i - step]
	end
end


"""
	rand_pivot!(polymer[, seed])

Apply a random pivot move to `polymer`.
"""
function rand_pivot! end

rand_pivot!(polymer::Polymer) = rand_pivot!(polymer, rand(UInt))

function rand_pivot!(polymer::Polymer, seed::Integer)
	steps = length(polymer)
	dim = polymer.dim

	# Sample random pivot point step and rotation
	Random.seed!(seed)
	step = rand(2:steps-1)		# Exclude trivial pivot points
	Rot = rand_lattice_rot(dim, seed)

	# Apply Pivot
	pivot!(polymer, step, Rot)
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
		rand_pivot!(polymer, seed)
		seed += 1
	end
end
