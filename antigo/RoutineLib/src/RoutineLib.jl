module RoutineLib
using Distributions, Random, Plots

# Constantes
const DAY_IN_SECONDS = 24 * 60 * 60
const DAYS_IN_WEEK = 7

# Tipos exportados
export AbstractProfile, AbstractRoutineProfile, LeaveReturnDist,
       RoutineProfileWithoutEvents, RoutineProfileWithOneEvent, RoutineProfileWithEvents,
       AbstractRoutine, RoutineWithoutEvents, RoutineWithOneEvent, RoutineWithEvents

# Funções exportadas
export create_routine_profile, create_routine, simul

# Definições de tipos
abstract type AbstractProfile end
abstract type AbstractRoutineProfile <: AbstractProfile end

struct LeaveReturnDist
    leaveTime::Normal
    returnTime::Normal
end

struct RoutineProfileWithoutEvents <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::Normal
    sleepTime::Normal
end

struct RoutineProfileWithOneEvent <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::Normal
    sleepTime::Normal
    event::LeaveReturnDist
end

struct RoutineProfileWithEvents <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::Normal
    sleepTime::Normal
    events::Vector{LeaveReturnDist}
end

abstract type AbstractRoutine end

struct RoutineWithoutEvents <: AbstractRoutine
    name::Symbol
    wakeUp::Int32
    sleep::Int32
end

struct RoutineWithOneEvent <: AbstractRoutine
    name::Symbol
    wakeUp::Int32
    sleep::Int32
    events::Tuple{Int32,Int32}
end

struct RoutineWithEvents <: AbstractRoutine
    name::Symbol
    wakeUp::Int32
    sleep::Int32
    events::Vector{Tuple{Int32,Int32}}
end

# Funções internas (não exportadas)
function enforce_minimum_gap(entry_time::Int32, exit_time::Int32, gap::UInt16)
    if exit_time - (entry_time + gap) < gap
        exit_time = entry_time + gap
    end
    return exit_time
end

# Funções exportadas
function create_routine_profile(name::Symbol, wakeUpTime::Normal, sleepTime::Normal, leaveReturnTimes::Nothing)
    return RoutineProfileWithoutEvents(name, wakeUpTime, sleepTime)
end

function create_routine_profile(name::Symbol, wakeUpTime::Normal, sleepTime::Normal, leaveReturnTimes::LeaveReturnDist)
    return RoutineProfileWithOneEvent(name, wakeUpTime, sleepTime, leaveReturnTimes)
end

function create_routine_profile(name::Symbol, wakeUpTime::Normal, sleepTime::Normal, leaveReturnTimes::Vector{LeaveReturnDist})
    return RoutineProfileWithEvents(name, wakeUpTime, sleepTime, leaveReturnTimes)
end

function create_routine(profile::RoutineProfileWithoutEvents, rng::AbstractRNG)
    wakeUp = trunc(Int32, rand(rng, profile.wakeUpTime))
    sleep = trunc(Int32, rand(rng, profile.sleepTime))
    return RoutineWithoutEvents(profile.name, wakeUp, sleep)
end

function create_routine(profile::RoutineProfileWithOneEvent, rng::AbstractRNG, minimum_time_gap::UInt16)
    wakeUp = trunc(Int32, rand(rng, profile.wakeUpTime))
    sleep = trunc(Int32, rand(rng, profile.sleepTime))
    leave_time = trunc(Int32, rand(rng, profile.event.leaveTime))
    leave_time = enforce_minimum_gap(wakeUp, leave_time, minimum_time_gap)
    return_time = trunc(Int32, rand(rng, profile.event.returnTime))
    event_tuple = (leave_time, return_time)
    return RoutineWithOneEvent(profile.name, wakeUp, sleep, event_tuple)
end

function create_routine(profile::RoutineProfileWithEvents, rng::AbstractRNG, minimum_time_gap::UInt16)
    wakeUp = trunc(Int32, rand(rng, profile.wakeUpTime))
    sleep = trunc(Int32, rand(rng, profile.sleepTime))
    events = Matrix{Int32}(undef, length(profile.events), 2)
    for i in eachindex(profile.events)
        events[i, 1] = trunc(Int32, rand(rng, profile.events[i].leaveTime))
        events[i, 2] = trunc(Int32, rand(rng, profile.events[i].returnTime))
    end
    return RoutineWithEvents(profile.name, wakeUp, sleep, events)
end

function simul(tamanho::Int64)
    name = :clt
    dist1 = Normal(5.5 * 3600, 1800)
    dist2 = Normal(7.5 * 3600, 1800)
    dist3 = Normal(18 * 3600, 1800)
    dist4 = Normal(24 * 3600, 1800)
    leaveReturn = LeaveReturnDist(dist2, dist3)
    profile = RoutineProfileWithOneEvent(name, dist1, dist4, leaveReturn)
    
    rng = MersenneTwister(42)
    minimum_gap = UInt16(300)
    
    routines = [create_routine(profile, rng, minimum_gap) for _ in 1:tamanho]
    
    wakeUp_times = [routine.wakeUp for routine in routines]
    sleep_times = [routine.sleep for routine in routines]
    leave_times = [routine.events[1] for routine in routines]
    return_times = [routine.events[2] for routine in routines]
    
    p = histogram(wakeUp_times, bins=50, xlims=(0, DAY_IN_SECONDS), label="Horário de Acordar",
                  alpha=0.5, color=:gray, xlabel="Tempo (horas)", ylabel="Ocorrências",
                  title="Distribuição de Tempos - clt", xticks=(0:3600:DAY_IN_SECONDS, string.(0:24)), grid=true)
    histogram!(p, sleep_times, bins=50, xlims=(0, DAY_IN_SECONDS), label="Horário de Dormir", alpha=0.5, color=:blue)
    histogram!(p, leave_times, bins=50, xlims=(0, DAY_IN_SECONDS), label="Horário de Saída", alpha=0.5, color=:green)
    histogram!(p, return_times, bins=50, xlims=(0, DAY_IN_SECONDS), label="Horário de Retorno", alpha=0.5, color=:red)
    
    return p
end

end # fim do módulo