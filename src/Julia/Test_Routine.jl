using Test, Distributions, Random, Plots
gr()
include("DistributionParams.jl")
include("Routine.jl")
include("RoutineProfile.jl")

# Teste para a struct LeaveReturnDist
@testset "LeaveReturnDist Tests" begin
    # Criação de uma instância de LeaveReturnDist
    leaveTime = NormalDistParams(8 * 3600, 3600)  # 8:00 com desvio padrão de 1 hora
    returnTime = NormalDistParams(18 * 3600, 3600)  # 18:00 com desvio padrão de 1 hora
    leave_return = LeaveReturnDist(leaveTime, returnTime)
    
    # Testes de assertiva
    @test leave_return.leaveTime.mean == 8 * 3600
    @test leave_return.leaveTime.std == 3600
    @test leave_return.returnTime.mean == 18 * 3600
    @test leave_return.returnTime.std == 3600
end

@testset "RoutineProfile Tests" begin
	# Criando parâmetros de distribuição para os horários
	wakeUp = NormalDistParams(7 * 3600, 1800)  # Acordar às 7:00 com desvio de 30 min
	sleep = NormalDistParams(23 * 3600, 1800)   # Dormir às 23:00 com desvio de 30 min

	# Caso 1: Rotina sem eventos
	profile_without_events = create_routine_profile(:default, wakeUp, sleep, nothing)

	@test profile_without_events isa RoutineProfileWithoutEvents
	@test profile_without_events.wakeUpTime.mean == 7 * 3600
	@test profile_without_events.wakeUpTime.std == 1800
	@test profile_without_events.sleepTime.mean == 23 * 3600
	@test profile_without_events.sleepTime.std == 1800
	@test !isdefined(profile_without_events, :leaveReturnTimes)  # Não deve ter eventos

	# Criando eventos de saída e retorno
	leave_time_1 = NormalDistParams(8 * 3600, 1800)   # Saída às 8:00
	return_time_1 = NormalDistParams(17 * 3600, 1800) # Retorno às 17:00
	leave_return_1 = LeaveReturnDist(leave_time_1, return_time_1)

	leave_time_2 = NormalDistParams(9 * 3600, 1200)   # Saída às 9:00
	return_time_2 = NormalDistParams(18 * 3600, 1200) # Retorno às 18:00
	leave_return_2 = LeaveReturnDist(leave_time_2, return_time_2)

	# Caso 2: Rotina com múltiplos eventos
	profile_with_events = create_routine_profile(:worker, wakeUp, sleep, [leave_return_1, leave_return_2])

	@test profile_with_events isa RoutineProfileWithEvents
	@test profile_with_events.wakeUpTime.mean == 7 * 3600
	@test profile_with_events.sleepTime.mean == 23 * 3600
	@test length(profile_with_events.leaveReturnTimes) == 2

	# Verificando primeiro evento
	@test profile_with_events.leaveReturnTimes[1].leaveTime.mean == 8 * 3600
	@test profile_with_events.leaveReturnTimes[1].returnTime.mean == 17 * 3600

	# Verificando segundo evento
	@test profile_with_events.leaveReturnTimes[2].leaveTime.mean == 9 * 3600
	@test profile_with_events.leaveReturnTimes[2].returnTime.mean == 18 * 3600

	# Caso 3: Rotina com um único evento
	profile_single_event = create_routine_profile(:student, wakeUp, sleep, leave_return_1)
	
	@test profile_single_event isa RoutineProfileWithOneEvent
	@test profile_single_event.event.leaveTime.mean == 8 * 3600
	@test profile_single_event.event.returnTime.mean == 17 * 3600
end

@testset "generate_cyclic_time Tests" begin
	rng = MersenneTwister(1234)

	# Função para plotar histogramas
	function plot_histogram(times, case_name)
			histogram(times,
					bins = 50,
					xlims = (0, DAY_IN_SECONDS),
					label = case_name,
					alpha = 0.7,
					color = :gray,
					xlabel = "Tempo (segundos)",
					ylabel = "Ocorrências",
					title = "Distribuição de Tempos - $case_name",
					xticks = (0:3600:DAY_IN_SECONDS, string.(0:24)),  # Marcadores de hora em hora
					grid = true,
					legend = :topleft
			)
	end

	# Gerar dados para cada caso
	cases = [
			(12 * 3600, 1800, "Caso 1 (12h, 30min)"),
			(0, 3600, "Caso 2 (00h, 1h)"),
			(23*3600 + 59*60, 3600, "Caso 3 (23h59, 1h)"),
			(12 * 3600, 10 * 3600, "Caso 4 (12h, 10h)")
	]

	# Plotar cada caso em uma figura separada
	for (mean, std, name) in cases
			dist = NormalDistParams(mean, std)
			times = [generate_cyclic_time(rng, dist) for _ in 1:1000]
			
			@test all(0 .<= times .<= DAY_IN_SECONDS)
			plot_histogram(times, name)
			display(plot!(size = (800, 400)))  # Tamanho da figura
	end
end


@testset "Routine Test" begin
	# Definindo os parâmetros do perfil
	name = :clt
	dist1 = NormalDistParams(5.5 * 3600, 3600)   # Acordar (5.5h, 1h)
	dist2 = NormalDistParams(7.5 * 3600, 1800)    # Sair para o trabalho (7.5h, 30min)
	dist3 = NormalDistParams(18 * 3600, 3600)     # Voltar para casa (18h, 1h)
	dist4 = NormalDistParams(22 * 3600, 3600)     # Dormir (22h, 1h)
	
	leaveReturn = LeaveReturnDist(dist2, dist3)
	profile = RoutineProfileWithOneEvent(name, dist1, dist4, leaveReturn)
	
	# Inicializando o gerador de números aleatórios
	rng = MersenneTwister(42)
	minimum_gap = Int32(300)  # gap mínimo de 5 minutos (300 segundos)
	
	# Criando 1000 instâncias de RoutineWithOneEvent
	routines = [create_routine(profile, rng, minimum_gap) for _ in 1:1000]
	
	# Verificando se foram criadas 1000 instâncias
	@test length(routines) == 1000
	
	# Extraindo os tempos de interesse de cada rotina
	wakeUp_times = [routine.wakeUp for routine in routines]
	sleep_times  = [routine.sleep for routine in routines]
	leave_times  = [routine.events[1] for routine in routines]
	return_times = [routine.events[2] for routine in routines]
	
	# Plotando as 4 distribuições sobrepostas em um único plot
	p = histogram(wakeUp_times,
								bins = 50,
								xlims = (0, DAY_IN_SECONDS),
								label = "Horário de Acordar",
								alpha = 0.5,
								color = :gray,
								xlabel = "Tempo (horas)",
								ylabel = "Ocorrências",
								title = "Distribuição de Tempos - clt",
								xticks = (0:3600:DAY_IN_SECONDS, string.(0:24)),
								grid = true)
	
	histogram!(p,
						 sleep_times,
						 bins = 50,
						 xlims = (0, DAY_IN_SECONDS),
						 label = "Horário de Dormir",
						 alpha = 0.5,
						 color = :blue)
	
	histogram!(p,
						 leave_times,
						 bins = 50,
						 xlims = (0, DAY_IN_SECONDS),
						 label = "Horário de Saída",
						 alpha = 0.5,
						 color = :green)
	
	histogram!(p,
						 return_times,
						 bins = 50,
						 xlims = (0, DAY_IN_SECONDS),
						 label = "Horário de Retorno",
						 alpha = 0.5,
						 color = :red)
	
	display(p)
end