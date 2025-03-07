using Distributions,Random

const DAY_IN_SECONDS = 24 * 60 * 60  # 86400 segundos
const DAYS_IN_WEEK = 7
#const DAYS_OF_WEEK = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

abstract type AbstractRoutine end  # Classe base abstrata

struct RoutineWithoutEvents <: AbstractRoutine
		name:: Symbol
    wakeUp::Int32
    sleep::Int32
end

struct RoutineWithOneEvent <: AbstractRoutine
		name:: Symbol
		wakeUp::Int32
		sleep::Int32
		events::Tuple{Int32,Int32}
end

struct RoutineWithEvents <: AbstractRoutine
		name::Symbol
    wakeUp::Int32
    sleep::Int32
    events::Vector{Tuple{Int32, Int32}}
end

function enforce_minimum_gap(entry_time::Int32, exit_time::Int32, gap::UInt16)
	if exit_time - (entry_time+gap) < gap
		exit_time = entry_time + gap
	end
	return exit_time
end

function create_routine(profile::RoutineProfileWithoutEvents, rng::AbstractRNG)
	wakeUp = trunc(Int32, rand(rng, profile.wakeUpTime))  # Gera número normal e arredonda
  sleep = trunc(Int32, rand(rng, profile.sleepTime))
	return RoutineWithoutEvents(profile.name, wakeUp, sleep)
end

function create_routine(profile::RoutineProfileWithOneEvent, rng::AbstractRNG, minimum_time_gap::UInt16)
	wakeUp = trunc(Int32, rand(rng, profile.wakeUpTime))
  sleep = trunc(Int32, rand(rng, profile.sleepTime))

	leave_time = trunc(Int32, rand(rng, profile.event.leaveTime))
	leave_time = enforce_minimum_gap(wakeUp,leave_time, minimum_time_gap)
	return_time = trunc(Int32, rand(rng, profile.event.returnTime))

	event_tuple = (leave_time, return_time)

	# Retornando a estrutura com o Tuple como parte do argumento
	return RoutineWithOneEvent(profile.name,wakeUp, sleep, event_tuple)
end

function create_routine(profile::RoutineProfileWithEvents, rng::AbstractRNG, minimum_time_gap::UInt16)
	wakeUp = trunc(Int32, rand(rng, profile.wakeUpTime))
  sleep = trunc(Int32, rand(rng, profile.sleepTime))

	events = Matrix{Int32}(undef, length(profile.events), 2)

    for i in eachindex(profile.events)
        events[i, 1] = trunc(Int32, rand(rng, profile.events[i].leaveTime))  # Leave time
        events[i, 2] = trunc(Int32, rand(rng, profile.events[i].returnTime))  # Return time
    end
	return RoutineWithEvents(profile.name,wakeUp, sleep, events)
end