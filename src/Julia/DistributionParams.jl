struct NormalDistParams
	mean::Float64
	std::Float64
end

struct UniformDistParams
	low::Float64
	high::Float64
end

# Funções para criar instâncias com validação
function create_normal_params(mean::Float64, std::Float64)
	return NormalDistParams(mean, std)
end

function create_uniform_params(low::Float64, high::Float64)
	return UniformDistParams(low, high)
end