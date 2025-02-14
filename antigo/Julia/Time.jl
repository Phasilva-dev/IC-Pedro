using Random, Distributions

const DAYS_IN_WEEK = 7
const SECONDS_IN_A_DAY = 86400

mutable struct Time
    get_up::Vector{UInt32}
    work::Vector{UInt32}
    return_home::Vector{UInt32}
    sleep_time::Vector{UInt32}
    local_gen::MersenneTwister

    function Time(profile=nothing)
        local_gen = MersenneTwister(rand(UInt64))
        get_up = zeros(UInt32, DAYS_IN_WEEK)
        work = zeros(UInt32, DAYS_IN_WEEK)
        return_home = zeros(UInt32, DAYS_IN_WEEK)
        sleep_time = zeros(UInt32, DAYS_IN_WEEK)
        
        obj = new(get_up, work, return_home, sleep_time, local_gen)
        
        if profile !== nothing
            for i in 1:DAYS_IN_WEEK
                obj.get_up[i] = generate_cyclic_time(obj, profile.get_up_mean[i], profile.get_up_std[i])
                obj.work[i] = generate_cyclic_time(obj, profile.work_mean[i], profile.work_std[i])
                obj.return_home[i] = generate_cyclic_time(obj, profile.return_home_mean[i], profile.return_home_std[i])
                obj.sleep_time[i] = generate_cyclic_time(obj, profile.sleep_mean[i], profile.sleep_std[i])
            end
        end
        
        return obj
    end
end

function generate_cyclic_time(time_obj::Time, mean::Float64, std::Float64)
    result = Int(round(rand(Normal(mean, std), time_obj.local_gen)))
    result = mod(result, SECONDS_IN_A_DAY)
    return UInt32(result)
end

function get_get_up(time_obj::Time, day::Int)
    return time_obj.get_up[day]
end

function get_work(time_obj::Time, day::Int)
    return time_obj.work[day]
end

function get_return_home(time_obj::Time, day::Int)
    return time_obj.return_home[day]
end

function get_sleep_time(time_obj::Time, day::Int)
    return time_obj.sleep_time[day]
end

function print_schedule(time_obj::Time)
    for i in 1:DAYS_IN_WEEK
        println("Dia ", i, ":")
        println("  Acordar: ", time_obj.get_up[i], " seg")
        println("  Trabalho: ", time_obj.work[i], " seg")
        println("  Retorno: ", time_obj.return_home[i], " seg")
        println("  Sono: ", time_obj.sleep_time[i], " seg\n")
    end
end