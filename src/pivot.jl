using Random


function pivot(polymer, step, Rot)
	steps = length(polymer)
	point = polymer[step]		# Pivot point

	init_segment = Set(polymer[1:step])
	new_polymer = copy(polymer)

	# Try to parallelize this
	for i in step+1:steps
		new_point = point + Rot * (polymer[i] - point)
		if new_point in init_segment
			return polymer
		end

		new_polymer[i] = new_point
	end

	return new_polymer
end


function rand_pivot(polymer::Polymer, seed=nothing)
	steps = length(polymer)
	dim = length(polymer[1])

	# Sample random pivot point step and rotation
	if !isequal(seed, nothing)
		Random.seed!(seed)
	end
	step = rand(2:steps-1)		# Exclude trivial pivot points
	Rot = rand_lattice_rot(dim, seed)

	# Apply Pivot
	polymer_data = polymer.data
	new_polymer_data = pivot(polymer_data, step, Rot)
	return Polymer(steps, dim, new_polymer_data)
end


function mix(polymer::Polymer, iter::Int, callbacks=[], seed=nothing)
	# Need an initial seed
	if isequal(seed, nothing)
		seed = rand(UInt)
	end

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
