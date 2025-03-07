//! Uma biblioteca para trabalhar com distribuições estatísticas personalizadas.
//!
//! Esta biblioteca fornece uma trait `Dist` e uma enum `Dists` para representar
//! diferentes tipos de distribuições (Normal, Poisson, Uniforme). Inclui suporte
//! para amostragem e criação de distribuições a partir de parâmetros.

use rand::Rng;
use serde::Serialize;
use std::fmt;

mod normaldist;
mod poissondist;
mod uniformdist;

pub use normaldist::NormalDist;
pub use poissondist::PoissonDist;
pub use uniformdist::UniformDist;

#[derive(Serialize)]
#[serde(untagged)]
pub enum Dists {
    Normal(NormalDist),
    Poisson(PoissonDist),
    Uniform(UniformDist),
}

pub trait Dist: fmt::Display + Serialize {
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Result<f64, Box<dyn std::error::Error>>;
}

impl fmt::Display for Dists {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Dists::Normal(n) => n.fmt(f),
            Dists::Poisson(p) => p.fmt(f),
            Dists::Uniform(u) => u.fmt(f),
        }
    }
}

impl Dist for Dists {
	fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Result<f64, Box<dyn std::error::Error>> {
			match self {
					Dists::Normal(n) => n.sample(rng),
					Dists::Poisson(p) => p.sample(rng),
					Dists::Uniform(u) => u.sample(rng),
			}
	}
}

pub fn create_distribution(dist_type: &str, params: &[f64]) -> Result<Dists, String> {
    match dist_type {
        "normal" => {
            if params.len() != 2 {
                return Err("Normal requer exatamente 2 parâmetros: mean e stdDev".to_string());
            }
            Ok(Dists::Normal(NormalDist::new(params[0], params[1])))
        }
        "poisson" => {
            if params.len() != 1 {
                return Err("Poisson requer exatamente 1 parâmetro: lambda".to_string());
            }
            Ok(Dists::Poisson(PoissonDist::new(params[0])?))
        }
        "uniform" => {
            if params.len() != 2 {
                return Err("Uniform requer exatamente 2 parâmetros: min e max".to_string());
            }
            Ok(Dists::Uniform(UniformDist::new(params[0], params[1])?))
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
            Dists::Normal(n) => {
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
            Dists::Poisson(p) => {
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
            Dists::Uniform(u) => {
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
