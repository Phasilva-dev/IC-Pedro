//! A biblioteca `stat_dists` para trabalhar com distribuições estatísticas personalizadas.
//!
//! Fornece uma trait `Dist` e uma enum `DistType` para representar diferentes tipos de
//! distribuições (Normal, Poisson, Uniforme). Inclui suporte para amostragem e criação de
//! distribuições a partir de parâmetros.

use rand::Rng;
use serde::Serialize;
use std::fmt;

mod normaldist;
mod poissondist;
mod uniformdist;

pub use normaldist::NormalDist;
pub use poissondist::PoissonDist;
pub use uniformdist::UniformDist;

/// Enumeração que representa diferentes tipos de distribuições estatísticas.
#[derive(Serialize)]
#[serde(untagged)]
pub enum DistType {
    Normal(NormalDist),
    Poisson(PoissonDist),
    Uniform(UniformDist),
}

impl fmt::Display for DistType {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            DistType::Normal(n) => n.fmt(f),
            DistType::Poisson(p) => p.fmt(f),
            DistType::Uniform(u) => u.fmt(f),
        }
    }
}

/// Trait para distribuições que suportam amostragem.
pub trait Dist: fmt::Display + Serialize {
    /// Gera uma amostra da distribuição usando um gerador de números aleatórios.
    /// 
    /// # Argumentos
    /// * `rng` - Referência mutável a um gerador de números aleatórios.
    ///
    /// # Retorno
    /// `Result<f64, Box<dyn std::error::Error>>` com a amostra gerada ou um erro.
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Result<f64, Box<dyn std::error::Error>>;
}

impl Dist for DistType {
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Result<f64, Box<dyn std::error::Error>> {
        match self {
            DistType::Normal(n) => n.sample(rng),
            DistType::Poisson(p) => p.sample(rng),
            DistType::Uniform(u) => u.sample(rng),
        }
    }
}


/// Cria uma distribuição com base no tipo e nos parâmetros fornecidos.
///
/// # Argumentos
/// * `dist_type` - String indicando o tipo de distribuição ("normal", "poisson", "uniform").
/// * `params` - Vetor de parâmetros (ex.: `[mean, std_dev]` para normal).
///
/// # Retorno
/// `Ok(DistType)` com a distribuição criada, ou `Err(String)` se os parâmetros forem inválidos.
///
/// # Exemplos
/// ```
/// let dist = stat_dists::create_distribution("normal", &[0.0, 1.0]).unwrap();
/// ```
pub fn create_distribution(dist_type: &str, params: &[f64]) -> Result<DistType, String> {
    match dist_type {
        "normal" => {
            if params.len() != 2 {
                return Err("Normal requer exatamente 2 parâmetros: mean e stdDev".to_string());
            }
            Ok(DistType::Normal(NormalDist::new(params[0], params[1])))
        }
        "poisson" => {
            if params.len() != 1 {
                return Err("Poisson requer exatamente 1 parâmetro: lambda".to_string());
            }
            Ok(DistType::Poisson(PoissonDist::new(params[0])?))
        }
        "uniform" => {
            if params.len() != 2 {
                return Err("Uniform requer exatamente 2 parâmetros: min e max".to_string());
            }
            Ok(DistType::Uniform(UniformDist::new(params[0], params[1])?))
        }
        _ => Err("Tipo de distribuição desconhecido".to_string()),
    }
}
/* 
// Testes unitários ajustados para usar StdRng
#[cfg(test)]
mod tests {
    use super::*;
    use rand::SeedableRng;
    use rand::rngs::StdRng;

    #[test]
    fn test_create_normal_distribution() {
        let dist = create_distribution("normal", &[0.0, 1.0]).unwrap();
        match dist {
            DistType::Normal(n) => {
                assert_eq!(n.mean(), 0.0);
                assert_eq!(n.std_dev(), 1.0);
                let mut rng = StdRng::seed_from_u64(42);
                let sample = n.sample(&mut rng).unwrap();
                assert!(sample.is_finite(), "Amostra deve ser finita");
            }
            _ => panic!("Esperava uma NormalDist"),
        }
    }

    #[test]
    fn test_create_poisson_distribution() {
        let dist = create_distribution("poisson", &[3.0]).unwrap();
        match dist {
            DistType::Poisson(p) => {
                assert_eq!(p.lambda(), 3.0);
                let mut rng = StdRng::seed_from_u64(42);
                let sample = p.sample(&mut rng).unwrap();
                assert!(sample >= 0.0, "Amostra Poisson deve ser não-negativa");
            }
            _ => panic!("Esperava uma PoissonDist"),
        }
    }

    #[test]
    fn test_create_uniform_distribution() {
        let dist = create_distribution("uniform", &[0.0, 10.0]).unwrap();
        match dist {
            DistType::Uniform(u) => {
                assert_eq!(u.min(), 0.0);
                assert_eq!(u.max(), 10.0);
                let mut rng = StdRng::seed_from_u64(42);
                let sample = u.sample(&mut rng).unwrap();
                assert!(
                    sample >= 0.0 && sample < 10.0,
                    "Amostra deve estar no intervalo [0, 10)"
                );
            }
            _ => panic!("Esperava uma UniformDist"),
        }
    }

    #[test]
    fn test_invalid_distribution() {
        let result = create_distribution("invalid", &[]);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Tipo de distribuição desconhecido");
    }

    #[test]
    fn test_wrong_params() {
        let result = create_distribution("normal", &[0.0]); // Faltando std_dev
        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err(),
            "Normal requer exatamente 2 parâmetros: mean e stdDev"
        );
    }
}
		*/
