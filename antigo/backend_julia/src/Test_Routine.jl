using Test, Distributions, Random, Plots
include("Routine.jl")
include("Profiles.jl")

# Teste para a struct LeaveReturnDist
@testset "LeaveReturnDist Tests" begin
    # Criação de uma instância de LeaveReturnDist
    leaveTime = Normal(8 * 3600, 3600)  # 8:00 com desvio padrão de 1 hora
    returnTime = Normal(18 * 3600, 3600)  # 18:00 com desvio padrão de 1 hora
    leave_return = LeaveReturnDist(leaveTime, returnTime)
    
    # Testes de assertiva
    @test leave_return.leaveTime.μ == 8 * 3600
    @test leave_return.leaveTime.σ == 3600
    @test leave_return.returnTime.μ == 18 * 3600
    @test leave_return.returnTime.σ == 3600
end

@testset "RoutineProfile Tests" begin
	# Criando parâmetros de distribuição para os horários
	wakeUp = Normal(7 * 3600, 1800)  # Acordar às 7:00 com desvio de 30 min
	sleep = Normal(23 * 3600, 1800)   # Dormir às 23:00 com desvio de 30 min

	# Caso 1: Rotina sem eventos
	profile_without_events = create_routine_profile(:default, wakeUp, sleep, nothing)

	@test profile_without_events isa RoutineProfileWithoutEvents
	@test profile_without_events.wakeUpTime.μ == 7 * 3600
	@test profile_without_events.wakeUpTime.σ == 1800
	@test profile_without_events.sleepTime.μ == 23 * 3600
	@test profile_without_events.sleepTime.σ == 1800
	@test !isdefined(profile_without_events, :events)  # Não deve ter eventos

	# Criando eventos de saída e retorno
	leave_time_1 = Normal(8 * 3600, 1800)   # Saída às 8:00
	return_time_1 = Normal(17 * 3600, 1800) # Retorno às 17:00
	leave_return_1 = LeaveReturnDist(leave_time_1, return_time_1)

	leave_time_2 = Normal(9 * 3600, 1200)   # Saída às 9:00
	return_time_2 = Normal(18 * 3600, 1200) # Retorno às 18:00
	leave_return_2 = LeaveReturnDist(leave_time_2, return_time_2)

	# Caso 2: Rotina com múltiplos eventos
	profile_with_events = create_routine_profile(:worker, wakeUp, sleep, [leave_return_1, leave_return_2])

	@test profile_with_events isa RoutineProfileWithEvents
	@test profile_with_events.wakeUpTime.μ == 7 * 3600
	@test profile_with_events.sleepTime.μ == 23 * 3600
	@test length(profile_with_events.events) == 2

	# Verificando primeiro evento
	@test profile_with_events.events[1].leaveTime.μ == 8 * 3600
	@test profile_with_events.events[1].returnTime.μ == 17 * 3600

	# Verificando segundo evento
	@test profile_with_events.events[2].leaveTime.μ == 9 * 3600
	@test profile_with_events.events[2].returnTime.μ == 18 * 3600

	# Caso 3: Rotina com um único evento
	profile_single_event = create_routine_profile(:student, wakeUp, sleep, leave_return_1)
	
	@test profile_single_event isa RoutineProfileWithOneEvent
	@test profile_single_event.event.leaveTime.μ == 8 * 3600
	@test profile_single_event.event.returnTime.μ == 17 * 3600
end


@testset "Routine Test" begin
	# Definindo os parâmetros do perfil
	name = :clt
	dist1 = Normal(5.5 * 3600, 1800)   # Acordar (5.5h, 1h)
	dist2 = Normal(7.5 * 3600, 1800)    # Sair para o trabalho (7.5h, 30min)
	dist3 = Normal(18 * 3600, 1800)     # Voltar para casa (18h, 1h)
	dist4 = Normal(24 * 3600, 1800)     # Dormir (22h, 1h)
	tamanho = 1000000
	leaveReturn = LeaveReturnDist(dist2, dist3)
	profile = RoutineProfileWithOneEvent(name, dist1, dist4, leaveReturn)
	
	# Inicializando o gerador de números aleatórios
	rng = MersenneTwister(42)
	minimum_gap = UInt16(300)  # gap mínimo de 5 minutos (300 segundos)
	
	# Criando 1000 instâncias de RoutineWithOneEvent
	routines = [create_routine(profile, rng, minimum_gap) for _ in 1:tamanho]
	
	# Verificando se foram criadas 1000 instâncias
	@test length(routines) == tamanho
	
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


@testset "Multi-Day Routine Simulation Test" begin
	# Configurações iniciais
	rng = MersenneTwister(42)
	num_days = 1  # Agora simula 4 dias
	routines_per_day = 10000
	#DAY_IN_SECONDS = 86400
	colors = [:gray :blue :green :red]
	labels = ["Horário de Acordar" "Horário de Dormir" "Horário de Saída" "Horário de Retorno"]
	
	# Estrutura para armazenar os dados de múltiplos dias
	day_data = Vector{Dict{Symbol, Vector{Int32}}}(undef, num_days + 1)
	for i in 1:(num_days + 1)
			day_data[i] = Dict(:wakeUp => Int32[], :sleep => Int32[], 
												:leave => Int32[], :return => Int32[])
	end

	# Parâmetros do perfil
	profile = RoutineProfileWithOneEvent(
			:worker,
			Normal(7 * 3600, 1800),   # Acordar 7h ± 30min
			Normal(23 * 3600, 3600),  # Dormir 23h ± 1h
			LeaveReturnDist(
					Normal(9 * 3600, 1800),   # Saída 9h ± 30min
					Normal(18 * 3600, 1800)   # Retorno 18h ± 30min
			)
	)

	# Simulação para múltiplos dias
	for day in 1:num_days
			routines = [create_routine(profile, rng, UInt16(300)) for _ in 1:routines_per_day]
			
			for routine in routines
					# Processa cada tempo e ajusta para o dia correto
					for (event, time) in [
							(:wakeUp, routine.wakeUp),
							(:sleep, routine.sleep),
							(:leave, routine.events[1]),
							(:return, routine.events[2])
							]
							
							# Calcula o dia real e ajusta o tempo
							total_sec = time + (day-1)*DAY_IN_SECONDS
							target_day = div(total_sec, DAY_IN_SECONDS) + 1
							adjusted_time = total_sec % DAY_IN_SECONDS
							
							# Armazena no dia correto (até dia 4)
							if target_day <= num_days+1
									push!(day_data[target_day][event], adjusted_time)
							end
					end
			end
	end

	# Plotagem dos histogramas (um gráfico por dia)
	for day in 1:num_days+1
			data = day_data[day]
			
			# Plota apenas se houver dados
			if !isempty(data[:wakeUp])
					p = histogram(data[:wakeUp],
												bins = 50,
												xlims = (0, DAY_IN_SECONDS),
												label = labels[1],
												alpha = 0.5,
												color = colors[1],
												xlabel = "Tempo (horas)",
												ylabel = "Ocorrências",
												title = "Distribuição de Tempos - Dia $day",
												xticks = (0:3600:DAY_IN_SECONDS, string.(0:24)),
												grid = true)
					
					histogram!(p, data[:sleep],
										 bins = 50,
										 xlims = (0, DAY_IN_SECONDS),
										 label = labels[2],
										 alpha = 0.5,
										 color = colors[2])
					
					histogram!(p, data[:leave],
										 bins = 50,
										 xlims = (0, DAY_IN_SECONDS),
										 label = labels[3],
										 alpha = 0.5,
										 color = colors[3])
					
					histogram!(p, data[:return],
										 bins = 50,
										 xlims = (0, DAY_IN_SECONDS),
										 label = labels[4],
										 alpha = 0.5,
										 color = colors[4])
					
					display(p)
			end
	end
	
	# Testes de consistência
	@test !isempty(day_data[1][:wakeUp])  # Dia 1 deve ter dados
	@test sum(length.(values(day_data[num_days+1]))) < routines_per_day*num_days  # Dia 4 deve ter menos eventos
	@test maximum(vcat(day_data[1][:sleep]...)) <= DAY_IN_SECONDS
end