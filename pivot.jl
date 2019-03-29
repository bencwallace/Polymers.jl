using Random
include("rot.jl")


# ------------------------- Initializers ------------------------- #


function basis(i, dim=2)
	e = zeros(Int, dim)
	e[i] = 1
	return e
end


function line(steps, dim=2)
	return [i * basis(1, dim) for i in 0:steps]
end


function stairs(steps, dim=2)
	horizontal = [Int(ceil(i / 2)) * basis(1, dim) for i=0:steps]
	vertical = [Int(floor(i / 2)) * basis(2, dim) for i=0:steps]

	return horizontal + vertical
end


function bridge(steps, dim=2)
	e = [basis(i, dim) for i=1:dim]
	options = [e..., [-item for item in e[2:dim]]...]

	summands = Array{Array{Int, 1}}(undef, steps+1)
	summands[1] = zeros(Int, dim)
	for i=2:steps+1
		valid = false
		candidate = nothing
		while !valid
			candidate = rand(options)
			if candidate == e[1] || candidate != -summands[i-1]
				valid = true
			end
		end
		summands[i] = candidate
	end

	output = Array{Array{Int, 1}}(undef, steps+1)
	output[1] = summands[1]
	for i=2:steps+1
		output[i] = summands[i] + output[i-1]
	end
	return output
end


# ------------------------ Pivot algorithm ------------------------ #


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


function rand_pivot(polymer, seed=nothing)
	steps = length(polymer)
	dim = length(polymer[1])

	# Sample random pivot point step and rotation
	if !isequal(seed, nothing)
		Random.seed!(seed)
	end
	step = rand(2:steps-1)		# Exclude trivial pivot points
	Rot = rand_lattice_rot(dim, seed)

	# Apply Pivot
	new_polymer = pivot(polymer, step, Rot)
	return new_polymer
end


function mix(polymer, iter, callbacks=[], seed=nothing)
	# Need an initial seed
	if isequal(seed, nothing)
		seed = rand(UInt)
	end

	interval = 10 ^ floor(log10(iter / 10))

	for i in 0:iter-1
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
