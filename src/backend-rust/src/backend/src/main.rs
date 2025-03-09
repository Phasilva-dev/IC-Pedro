use stat_dists::{create_distribution , Dist}; // Removido Dist
use rand::SeedableRng;
use rand::rngs::StdRng;
use std::io::{self, BufRead};


fn main() {
    // Cria um RNG com semente fixa para resultados reproduzíveis
    let mut rng = StdRng::seed_from_u64(42);

    // Loop interativo
    loop {
        println!("\nEscolha uma distribuição (normal, poisson, uniform) ou 'sair' para encerrar:");
        let stdin = io::stdin();
        let mut lines = stdin.lock().lines();

        let dist_type = if let Some(Ok(line)) = lines.next() {
            line.trim().to_lowercase()
        } else {
            println!("Erro ao ler o tipo de distribuição.");
            continue;
        };

        // Verifica se o usuário quer sair
        if dist_type == "sair" {
            println!("Encerrando...");
            break;
        }

        // Solicita parâmetros com base no tipo
        let params: Vec<f64> = match dist_type.as_str() {
            "normal" => {
                println!("Digite a média (mean) e o desvio padrão (stdDev), separados por espaço (ex.: 0 1):");
                read_floats(&mut lines, 2)
            }
            "poisson" => {
                println!("Digite o lambda (ex.: 3):");
                read_floats(&mut lines, 1)
            }
            "uniform" => {
                println!("Digite o mínimo (min) e o máximo (max), separados por espaço (ex.: 0 10):");
                read_floats(&mut lines, 2)
            }
            _ => {
                println!("Tipo de distribuição inválido. Tente novamente.");
                continue;
            }
        };

        // Cria a distribuição
        match create_distribution(&dist_type, &params) { // Adicionado & antes de params
            Ok(dist) => {
                // Gera e exibe uma amostra
                match dist.sample(&mut rng) {
                    Ok(sample) => {
                        println!("Distribuição: {}", dist);
                        println!("Amostra gerada: {:.2}", sample);
                    }
                    Err(e) => println!("Erro ao gerar amostra: {}", e),
                }
            }
            Err(e) => println!("Erro ao criar a distribuição: {}", e),
        }
    }
}

// Função auxiliar para ler múltiplos floats da entrada
fn read_floats(lines: &mut io::Lines<io::StdinLock>, count: usize) -> Vec<f64> {
    let mut params = Vec::new();

    while params.len() < count {
        if let Some(Ok(line)) = lines.next() {
            for token in line.split_whitespace() {
                if params.len() >= count {
                    break;
                }
                if let Ok(num) = token.parse::<f64>() {
                    params.push(num);
                }
            }
        } else {
            println!("Erro ao ler os parâmetros.");
            break;
        }
        if params.len() < count {
            println!("Por favor, forneça mais {} número(s) (separados por espaço):", count - params.len());
        }
    }

    params
}