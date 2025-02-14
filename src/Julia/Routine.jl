const DAY_IN_SECONDS = 24 * 60 * 60  # 86400 segundos
const DAYS_IN_WEEK = 7
const DAYS_OF_WEEK = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

abstract type RoutineBase end  # Classe base abstrata

struct RoutineNoEvents <: RoutineBase
    wakeUp::Int32
    sleep::Int32
end

struct RoutineWithEvents <: RoutineBase
    wakeUp::Int32
    sleep::Int32
    events::Vector{Tuple{Int32, Int32}}
end

function create_routine(profile::RoutineProfile, rng::AbstractRNG)
    wakeUp = generate_cyclic_time(rng, profile.wakeUpTime)
    sleep = generate_cyclic_time(rng, profile.sleepTime)

    if profile.events === nothing
        return RoutineNoEvents(wakeUp, sleep)  # Sem eventos
    end

    events = [(generate_cyclic_time(rng, e[1]), generate_cyclic_time(rng, e[2])) for e in profile.events]

		# Posso antes do return criar uma função para garantir que os events e wakeUp e etc estejam a uma distancia
		# configuravel de um do outro no minimo (Exemplo, para sair de casa após acordar precisa de pelo menos 3 mins)
    return RoutineWithEvents(wakeUp, sleep, events)  # Com eventos
end

function generate_cyclic_time(rng::AbstractRNG, dist::NormalDistParams)
    result = round(Int, rand(Normal(rng, dist.mean, dist.std)))  # Gera número normal e arredonda
    result = (result % DAY_IN_SECONDS + DAY_IN_SECONDS) % DAY_IN_SECONDS  # Ajusta para o intervalo [0, 86400)
    return UInt32(result)  # Retorna como UInt32
end