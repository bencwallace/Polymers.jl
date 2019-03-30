using Random


function pivot(polymer::Polymer, step::Int, Rot::AbstractMatrix{Int})
	return Polymer(polymer, step, Rot)
end


function rand_pivot end

function rand_pivot(polymer::Polymer)
	return rand_pivot(polymer, rand(UInt))
end

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


# To do: Implement multiple dispatch for optional arguments
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
