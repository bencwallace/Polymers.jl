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
