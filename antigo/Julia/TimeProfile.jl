using Random

const SECONDS_IN_A_DAY = 86400
const DAYS_IN_WEEK = 7
const WEEK_DAYS = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"]

mutable struct TimeProfile
    get_up_mean::Vector{Float64}
    get_up_std::Vector{Float64}
    work_mean::Vector{Float64}
    work_std::Vector{Float64}
    return_home_mean::Vector{Float64}
    return_home_std::Vector{Float64}
    sleep_mean::Vector{Float64}
    sleep_std::Vector{Float64}

    function TimeProfile(; get_up_mean=nothing, get_up_std=nothing,
                          work_mean=nothing, work_std=nothing,
                          return_home_mean=nothing, return_home_std=nothing,
                          sleep_mean=nothing, sleep_std=nothing)
        new_profile = new(
            get_up_mean === nothing ? zeros(DAYS_IN_WEEK) : get_up_mean,
            get_up_std === nothing ? zeros(DAYS_IN_WEEK) : get_up_std,
            work_mean === nothing ? zeros(DAYS_IN_WEEK) : work_mean,
            work_std === nothing ? zeros(DAYS_IN_WEEK) : work_std,
            return_home_mean === nothing ? zeros(DAYS_IN_WEEK) : return_home_mean,
            return_home_std === nothing ? zeros(DAYS_IN_WEEK) : return_home_std,
            sleep_mean === nothing ? zeros(DAYS_IN_WEEK) : sleep_mean,
            sleep_std === nothing ? zeros(DAYS_IN_WEEK) : sleep_std
        )
        validate_values(new_profile)
        return new_profile
    end
end

function validate_day(day::Int)
    if !(1 <= day <= DAYS_IN_WEEK)
        throw(ArgumentError("O dia deve estar entre 1 e 7 (Segunda a Domingo)."))
    end
end

function validate_values(profile::TimeProfile)
    for i in 1:DAYS_IN_WEEK
        if !(0 <= profile.get_up_mean[i] <= SECONDS_IN_A_DAY &&
             0 <= profile.work_mean[i] <= SECONDS_IN_A_DAY &&
             0 <= profile.return_home_mean[i] <= SECONDS_IN_A_DAY &&
             0 <= profile.sleep_mean[i] <= SECONDS_IN_A_DAY)
            throw(ArgumentError("Valores de tempo devem estar entre 0 e 86400 segundos."))
        end
        if any(x -> x < 0, [profile.get_up_std[i], profile.work_std[i],
                             profile.return_home_std[i], profile.sleep_std[i]])
            throw(ArgumentError("Desvios padrão não podem ser negativos."))
        end
    end
end

function get_mean_std(profile::TimeProfile, attribute::Symbol, day::Int)
    validate_day(day)
    return getfield(profile, attribute)[day]
end

function set_mean_std!(profile::TimeProfile, attribute::Symbol, day::Int, value::Float64)
    validate_day(day)
    if occursin("std", String(attribute)) && value < 0
        throw(ArgumentError("O desvio padrão não pode ser negativo."))
    end
    if occursin("mean", String(attribute)) && !(0 <= value <= SECONDS_IN_A_DAY)
        throw(ArgumentError("O tempo deve estar entre 0 e 86400 segundos."))
    end
    getfield(profile, attribute)[day] = value
end

function print_profile(profile::TimeProfile)
    println("================ PERFIL SEMANAL =================")
    for i in 1:DAYS_IN_WEEK
        println("$(WEEK_DAYS[i]):")
        println("  Acordar  -> Média: $(round(profile.get_up_mean[i], digits=2)) s | Desvio: $(round(profile.get_up_std[i], digits=2)) s")
        println("  Trabalho -> Média: $(round(profile.work_mean[i], digits=2)) s | Desvio: $(round(profile.work_std[i], digits=2)) s")
        println("  Retorno  -> Média: $(round(profile.return_home_mean[i], digits=2)) s | Desvio: $(round(profile.return_home_std[i], digits=2)) s")
        println("  Sono     -> Média: $(round(profile.sleep_mean[i], digits=2)) s | Desvio: $(round(profile.sleep_std[i], digits=2)) s")
        println("-----------------------------------------------")
    end
end
