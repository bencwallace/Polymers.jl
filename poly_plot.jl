using Plots


function poly_plot(polymer)
	x = [item[1] for item in polymer]
	y = [item[2] for item in polymer]

	plot(x, y, legend=false)
end
