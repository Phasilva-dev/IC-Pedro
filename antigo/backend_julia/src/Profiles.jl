using Distributions

abstract type AbstractProfile end

# Tipo base para rotinas
abstract type AbstractRoutineProfile <: AbstractProfile end

# Estrutura para representar os eventos de saída e retorno
struct LeaveReturnDist
    leaveTime::Normal
    returnTime::Normal
end

# Estrutura para rotina sem eventos
struct RoutineProfileWithoutEvents <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::Normal
    sleepTime::Normal
end

# Estrutura para rotina com um evento
struct RoutineProfileWithOneEvent <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::Normal
    sleepTime::Normal
    event::LeaveReturnDist  # Um único evento
end

# Estrutura para rotina com múltiplos eventos
struct RoutineProfileWithEvents <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::Normal
    sleepTime::Normal
    events::Vector{LeaveReturnDist}  # Vários eventos
end

# Função de criação da rotina para casos sem eventos
function create_routine_profile(name::Symbol, wakeUpTime::Normal,
                                sleepTime::Normal, leaveReturnTimes::Nothing)
    return RoutineProfileWithoutEvents(name, wakeUpTime, sleepTime)
end

# Função de criação da rotina para casos com um único evento
function create_routine_profile(name::Symbol, wakeUpTime::Normal,
                                sleepTime::Normal, leaveReturnTimes::LeaveReturnDist)
    return RoutineProfileWithOneEvent(name, wakeUpTime, sleepTime, leaveReturnTimes)
end

# Função de criação da rotina para casos com múltiplos eventos
function create_routine_profile(name::Symbol, wakeUpTime::Normal,
                                sleepTime::Normal, leaveReturnTimes::Vector{LeaveReturnDist})
    return RoutineProfileWithEvents(name, wakeUpTime, sleepTime, leaveReturnTimes)
end

