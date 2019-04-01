using Random


"""
	Polymer(polymer, step, Rot)

Return the polymer obtained by pivoting `polymer` via rotation matrix `Rot` at `step`.
"""
pivot(polymer::Polymer, step::Int, Rot::AbstractMatrix{Int}) = Polymer(polymer, step, Rot)


"""
	rand_pivot(polymer[, seed])

Return the `Polymer` obtained by applying a random pivot move to `polymer`.
"""
function rand_pivot end

rand_pivot(polymer::Polymer) = rand_pivot(polymer, rand(UInt))

function rand_pivot(polymer::Polymer, seed::Integer)
	steps = length(polymer)
	dim = length(polymer[1])

	# Sample random pivot point step and rotation
	Random.seed!(seed)
	step = rand(2:steps-1)		# Exclude trivial pivot points
	Rot = rand_lattice_rot(dim, seed)

	# Apply Pivot
	return pivot(polymer, step, Rot)
end


"""
	mix(polymer, iter[, callbacks, seed])

Return the result of iteratively applying `iter` random pivot moves to `polymer`.
"""
function mix end

mix(polymer::Polymer, iter::Int) = mix(polymer, iter, [])

function mix(polymer::Polymer, iter::Int, callbacks::Array)
	return mix(polymer, iter, callbacks, rand(UInt))
end

mix(polymer::Polymer, iter::Int, seed::Integer) = mix(polymer, iter, [], seed)

function mix(polymer::Polymer, iter::Int, callbacks::Array, seed::Integer)
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
		polymer = rand_pivot(polymer, seed)
		seed += 1
	end

	return polymer
end
