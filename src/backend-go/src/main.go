package main

import (
	"fmt"
	"math/rand"
)
func main() {
	rng := rand.New(rand.NewSource(42))

	for {
		fmt.Println("\nEscolha uma distribuição (normal, poisson, uniform) ou 'sair' para encerrar:")
		var distType string
		_, err := fmt.Scanln(&distType)
		if err != nil {
			fmt.Println("Erro ao ler o tipo de distribuição:", err)
			continue
		}

		if distType == "sair" {
			fmt.Println("Encerrando...")
			break
		}

		var params []float64
		switch distType {
		case "normal":
			fmt.Println("Digite a média (mean) e o desvio padrão (stdDev), separados por espaço (ex.: 0 1):")
			var mean, stdDev float64
			_, err := fmt.Scanln(&mean, &stdDev)
			if err != nil {
				fmt.Println("Erro ao ler os parâmetros:", err)
				continue
			}
			params = []float64{mean, stdDev}

		case "poisson":
			fmt.Println("Digite o lambda (ex.: 3):")
			var lambda float64
			_, err := fmt.Scanln(&lambda)
			if err != nil {
				fmt.Println("Erro ao ler o parâmetro:", err)
				continue
			}
			params = []float64{lambda}

		case "uniform":
			fmt.Println("Digite o mínimo (min) e o máximo (max), separados por espaço (ex.: 0 10):")
			var min, max float64
			_, err := fmt.Scanln(&min, &max)
			if err != nil {
				fmt.Println("Erro ao ler os parâmetros:", err)
				continue
			}
			params = []float64{min, max}

		default:
			fmt.Println("Tipo de distribuição inválido. Tente novamente.")
			continue
		}

		dist, err := CreateDistribution(distType, params...)
		if err != nil {
			fmt.Println("Erro ao criar a distribuição:", err)
			continue
		}

		sample := dist.Sample(rng)
		fmt.Printf("Distribuição: %s\n", dist.String())
		fmt.Printf("Amostra gerada: %.2f\n", sample)
	}
}