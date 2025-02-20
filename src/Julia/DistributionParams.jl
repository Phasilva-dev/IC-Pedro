abstract type DistParams end

struct NormalDistParams <: DistParams
	mean::Float64
	std::Float64
end

struct UniformDistParams <: DistParams
	low::Float64
	high::Float64
end

function NormalDistParams(mean, std)
	std > 0 || throw(ArgumentError("Desvio padrão deve ser positivo."))
	return NormalDistParams(Float64(mean), Float64(std))
end

function UniformDistParams(low, high)
	low < high || throw(ArgumentError("O limite inferior deve ser menor que o superior."))
	return UniformDistParams(Float64(low), Float64(high))
end
