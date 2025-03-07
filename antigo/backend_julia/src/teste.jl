#=module teste

using Distributions, Plots

function main()
    tamanho = 100000  # Pode ler de argumentos da linha de comando
    output_path = simul(tamanho)
    println("Histograma salvo em: ", output_path)
end

# Mantenha as funções simul e auxiliares aqui ou em includes

end # module=#

function simul(tamanho::Int64)
	# Definindo os parâmetros do perfil
	name = :clt
	dist1 = Normal(5.5 * 3600, 1800)   # Acordar (5.5h, 1h)
	dist2 = Normal(7.5 * 3600, 1800)    # Sair para o trabalho (7.5h, 30min)
	dist3 = Normal(18 * 3600, 1800)     # Voltar para casa (18h, 1h)
	dist4 = Normal(24 * 3600, 1800)     # Dormir (22h, 1h)
	leaveReturn = LeaveReturnDist(dist2, dist3)
	profile = RoutineProfileWithOneEvent(name, dist1, dist4, leaveReturn)
	
	# Inicializando o gerador de números aleatórios
	rng = MersenneTwister(42)
	minimum_gap = UInt16(300)  # gap mínimo de 5 minutos (300 segundos)
	
	# Criando 1000 instâncias de RoutineWithOneEvent
	routines = [create_routine(profile, rng, minimum_gap) for _ in 1:tamanho]
	
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