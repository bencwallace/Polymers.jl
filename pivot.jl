using Random
include("rot.jl")


function line(steps, dim=2)
	e1 = zeros(Int, dim)
	e1[1] = 1

	return [i * e1 for i in 0:steps]
end


function pivot(polymer, index, Rot)
	steps = length(polymer)
	point = polymer[index]		# Pivot point

	init_segment = polymer[1:index]
	new_polymer = copy(polymer)

	for i in index+1:steps
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

	# Sample random pivot point index and rotation
	if !isequal(seed, nothing)
		Random.seed!(seed)
	end
	index = rand(2:steps-1)		# Exclude trivial pivot points
	Rot = rand_lattice_rot(dim, seed)

	# Apply pivot
	new_polymer = pivot(polymer, index, Rot)
	return new_polymer
end


function mix(polymer, iter, seed=nothing)
	for i in 1:iter
		if !isequal(seed, nothing)
			seed += i
		end
		polymer = rand_pivot(polymer, seed)
	end

	return polymer
end
