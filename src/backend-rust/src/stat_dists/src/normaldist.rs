use rand::Rng;
use rand_distr::{Normal, Distribution};
use serde::{Serialize, Deserialize, Deserializer, Serializer};
use std::fmt;

// Estrutura intermediária para serialização/desserialização
#[derive(Serialize, Deserialize)]
struct NormalDistData {
    mean: f64,
    std_dev: f64,
}

#[derive(Debug)]
pub struct NormalDist {
    mean: f64,
    std_dev: f64,
    normal: Normal<f64>,
}

impl NormalDist {
    pub fn new(mean: f64, std_dev: f64) -> Result<Self, Box<dyn std::error::Error>> {
        let normal = Normal::new(mean, std_dev)?;
        Ok(NormalDist { mean, std_dev, normal })
    }

    pub fn mean(&self) -> f64 {
        self.mean
    }

    pub fn std_dev(&self) -> f64 {
        self.std_dev
    }
}

impl fmt::Display for NormalDist {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Normal(μ={:.2}, σ={:.2})", self.mean, self.std_dev)
    }
}

impl super::Dist for NormalDist {
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Result<f64, Box<dyn std::error::Error>> {
        Ok(self.normal.sample(rng))
    }
}

// Implementação de Serialize
impl Serialize for NormalDist {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        // Serializa apenas mean e std_dev
        let data = NormalDistData {
            mean: self.mean,
            std_dev: self.std_dev,
        };
        data.serialize(serializer)
    }
}

// Implementação de Deserialize
impl<'de> Deserialize<'de> for NormalDist {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        // Desserializa em uma estrutura temporária
        let data = NormalDistData::deserialize(deserializer)?;
        // Recria o campo normal usando mean e std_dev
        let normal = Normal::new(data.mean, data.std_dev)
            .map_err(serde::de::Error::custom)?;
        Ok(NormalDist {
            mean: data.mean,
            std_dev: data.std_dev,
            normal,
        })
    }
}