using Distributions,Random

const DAY_IN_SECONDS = 24 * 60 * 60  # 86400 segundos
const DAYS_IN_WEEK = 7
#const DAYS_OF_WEEK = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

abstract type AbstractRoutine end  # Classe base abstrata

struct RoutineWithoutEvents <: AbstractRoutine
		name:: Symbol
    wakeUp::UInt32
    sleep::UInt32
end

struct RoutineWithOneEvent <: AbstractRoutine
		name:: Symbol
		wakeUp::UInt32
		sleep::UInt32
		events::Tuple{UInt32,UInt32}
end

struct RoutineWithEvents <: AbstractRoutine
		name::Symbol
    wakeUp::UInt32
    sleep::UInt32
    events::Vector{Tuple{UInt32, UInt32}}
end

function enforce_minimum_gap(entry_time::UInt32, exit_time::UInt32, gap::UInt32)
	if exit_time - (entry_time+gap) < gap
		exit_time = entry_time + gap
	end
	return exit_time
end

function create_routine(profile::RoutineProfileWithoutEvents, rng::AbstractRNG)
	wakeUp = generate_cyclic_time(rng, profile.wakeUpTime)
  sleep = generate_cyclic_time(rng, profile.sleepTime)
	return RoutineWithoutEvents(profile.name, wakeUp, sleep)
end

function create_routine(profile::RoutineProfileWithOneEvent, rng::AbstractRNG, minimum_time_gap::UInt32)
	wakeUp = generate_cyclic_time(rng, profile.wakeUpTime)
  sleep = generate_cyclic_time(rng, profile.sleepTime)

	leave_time = generate_cyclic_time(rng, profile.event.leaveTime)
	leave_time = enforce_minimum_gap(wakeUp,leave_time, minimum_time_gap)
	return_time = generate_cyclic_time(rng, profile.event.returnTime)

	event_tuple = (leave_time, return_time)

	# Retornando a estrutura com o Tuple como parte do argumento
	return RoutineWithOneEvent(profile.name,wakeUp, sleep, event_tuple)
end

function create_routine(profile::RoutineProfileWithEvents, rng::AbstractRNG, minimum_time_gap::UInt32)
	wakeUp = generate_cyclic_time(rng, profile.wakeUpTime)
  sleep = generate_cyclic_time(rng, profile.sleepTime)

	events = Matrix{UInt32}(undef, length(profile.leaveReturnTimes), 2)

    for i in eachindex(profile.leaveReturnTimes)
        events[i, 1] = generate_cyclic_time(rng, profile.leaveReturnTimes[i].leaveTime)  # Leave time
        events[i, 2] = generate_cyclic_time(rng, profile.leaveReturnTimes[i].returnTime)  # Return time
    end
	return RoutineWithEvents(profile.name,wakeUp, sleep, events)
end

function generate_cyclic_time(rng::AbstractRNG, dist::Normal)

    result = trunc(Int, rand(rng, dist))  # Gera número Normal com RNG específico e arredonda
		result = result % DAY_IN_SECONDS
		if result < 0
			result += DAY_IN_SECONDS
		end # Ajusta para o intervalo [0, 86400)
    return UInt32(result)  # Retorna como UInt32
end