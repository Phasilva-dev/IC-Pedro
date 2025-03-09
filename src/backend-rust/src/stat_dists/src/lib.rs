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
/// `Ok(DistType)` com a distribuição criada, ou `Err(Box<dyn std::error::Error>)` se os parâmetros forem inválidos.
///
/// # Exemplos
/// ```
/// let dist = stat_dists::create_distribution("normal", &[0.0, 1.0]).unwrap();
/// ```
pub fn create_distribution(dist_type: &str, params: &[f64]) -> Result<DistType, Box<dyn std::error::Error>> {
    match dist_type {
        "normal" => {
            if params.len() != 2 {
                return Err("Normal requer exatamente 2 parâmetros: mean e stdDev".into());
            }
            let normal = NormalDist::new(params[0], params[1])?;
            Ok(DistType::Normal(normal))
        }
        "poisson" => {
            if params.len() != 1 {
                return Err("Poisson requer exatamente 1 parâmetro: lambda".into());
            }
            let poisson = PoissonDist::new(params[0])?;
            Ok(DistType::Poisson(poisson))
        }
        "uniform" => {
            if params.len() != 2 {
                return Err("Uniform requer exatamente 2 parâmetros: min e max".into());
            }
            let uniform = UniformDist::new(params[0], params[1])?;
            Ok(DistType::Uniform(uniform))
        }
        _ => Err("Tipo de distribuição desconhecido".into()),
    }
}