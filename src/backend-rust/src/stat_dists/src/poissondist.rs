use rand::Rng;
use rand_distr::{Poisson, Distribution};
use serde::{Serialize, Deserialize, Deserializer, Serializer};
use std::fmt;

// Estrutura intermediária para serialização/desserialização
#[derive(Serialize, Deserialize)]
struct PoissonDistData {
    lambda: f64,
}

#[derive(Debug)]
pub struct PoissonDist {
    lambda: f64,
    poisson: Poisson<f64>,
}

impl PoissonDist {
    pub fn new(lambda: f64) -> Result<Self, String> {
        if lambda <= 0.0 {
            return Err("Lambda deve ser maior que 0".to_string());
        } else {
            let poisson = Poisson::new(lambda)
                .map_err(|e| e.to_string())?;
            Ok(PoissonDist { lambda, poisson })
        }
    }

    pub fn lambda(&self) -> f64 {
        self.lambda
    }
}

impl fmt::Display for PoissonDist {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Poisson(λ={:.2})", self.lambda)
    }
}

impl super::Dist for PoissonDist {
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Result<f64, Box<dyn std::error::Error>> {
        Ok(self.poisson.sample(rng))
    }
}

// Implementação de Serialize
impl Serialize for PoissonDist {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        // Serializa apenas lambda
        let data = PoissonDistData { lambda: self.lambda };
        data.serialize(serializer)
    }
}

// Implementação de Deserialize
impl<'de> Deserialize<'de> for PoissonDist {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        // Desserializa em uma estrutura temporária
        let data = PoissonDistData::deserialize(deserializer)?;
        // Recria o campo poisson usando lambda
        let poisson = Poisson::new(data.lambda)
            .map_err(serde::de::Error::custom)?;
        Ok(PoissonDist {
            lambda: data.lambda,
            poisson,
        })
    }
}