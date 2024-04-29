using Random


"""
	pivot!(polymer, step, Rot)

Pivot `polymer` via rotation matrix `Rot` at `step`.
"""
function pivot!(polymer::Polymer, step::Int, Rot::AbstractMatrix{Int})
	steps = length(polymer)
	point = polymer[step]		# Pivot point

	new_points = []
	pivot_steps = step < steps ? (step+1:steps) : 0:step
	for i in pivot_steps
		new_point = point + Rot * (polymer[i] - point)
		for i in get(polymer.pt2idx, new_point, Set(0))
			if 1 <= i <= step
				return false
			end
		end
		push!(new_points, new_point)
	end

	for i in pivot_steps
		polymer[i] = new_points[i - step]
	end
	return true
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
	return pivot!(polymer, step, Rot)
end


"""
	mix!(polymer, iter[, callbacks, seed])

Iteratively applies `iter` random pivot moves to `polymer`.
"""
function mix! end

mix!(polymer::Polymer, iter::Int, require_success::Bool=false) = mix!(polymer, iter, [], require_success)

function mix!(polymer::Polymer, iter::Int, callbacks::Array, require_success::Bool=false)
	return mix!(polymer, iter, callbacks, require_success, rand(UInt))
end

mix!(polymer::Polymer, iter::Int, seed::Integer, require_success::Bool=false) = mix!(polymer, iter, [], require_success, seed)

function mix!(polymer::Polymer, iter::Int, callbacks::Array, require_success::Bool, seed::Integer)
	interval = 10 ^ floor(log10(iter / 10))

	print("Mixing polymer\n")
	i = 0  # successful iterations
	j = 0  # total iterations
	while true
		# Diagnostics
		if j % interval == 0
			print("Iterations: $j / Successes: $i (success rate: $(i / j))\n")
			if !isempty(callbacks)
				print("Callbacks: ")
				for item in callbacks
					print(item(polymer), '\t')
				end
				print('\n')
			end
		end

		# Apply random pivot
		success = rand_pivot!(polymer, seed)
		i += Int(success)
		j += 1
		seed += 1

		if require_success
			if i == iter
				break
			end
		elseif j == iter
			break
		end
	end
	if !self_avoiding(polymer)
		throw(ArgumentError("Polymer is not self-avoiding"))
	end
end
