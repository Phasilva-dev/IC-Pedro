abstract type AbstractProfile end

# Tipo base para rotinas
abstract type AbstractRoutineProfile <: AbstractProfile end

# Estrutura para representar os eventos de saída e retorno
struct LeaveReturnDist
    leaveTime::NormalDistParams
    returnTime::NormalDistParams
end

# Estrutura para rotina sem eventos
struct RoutineProfileWithoutEvents <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::NormalDistParams
    sleepTime::NormalDistParams
end

# Estrutura para rotina com um evento
struct RoutineProfileWithOneEvent <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::NormalDistParams
    sleepTime::NormalDistParams
    event::LeaveReturnDist  # Um único evento
end

# Estrutura para rotina com múltiplos eventos
struct RoutineProfileWithEvents <: AbstractRoutineProfile
    name::Symbol
    wakeUpTime::NormalDistParams
    sleepTime::NormalDistParams
    leaveReturnTimes::Vector{LeaveReturnDist}  # Vários eventos
end

# Função de criação da rotina para casos sem eventos
function create_routine_profile(name::Symbol, wakeUpTime::NormalDistParams,
                                sleepTime::NormalDistParams, leaveReturnTimes::Nothing)
    return RoutineProfileWithoutEvents(name, wakeUpTime, sleepTime)
end

# Função de criação da rotina para casos com um único evento
function create_routine_profile(name::Symbol, wakeUpTime::NormalDistParams,
                                sleepTime::NormalDistParams, leaveReturnTimes::LeaveReturnDist)
    return RoutineProfileWithOneEvent(name, wakeUpTime, sleepTime, leaveReturnTimes)
end

# Função de criação da rotina para casos com múltiplos eventos
function create_routine_profile(name::Symbol, wakeUpTime::NormalDistParams,
                                sleepTime::NormalDistParams, leaveReturnTimes::Vector{LeaveReturnDist})
    return RoutineProfileWithEvents(name, wakeUpTime, sleepTime, leaveReturnTimes)
end

