use rand::Rng;
use rand_distr::{Uniform, Distribution};
use serde::{Serialize, Deserialize, Deserializer, Serializer};
use std::fmt;

// Estrutura intermediária para serialização/desserialização
#[derive(Serialize, Deserialize)]
struct UniformDistData {
    min: f64,
		//#[serde(skip_serializing)] // Ignora o campo uniform durante serialização/desserialização
    max: f64,
}

#[derive(Debug)]
pub struct UniformDist {
    min: f64,
    max: f64,
    
    uniform: Uniform<f64>,
}

impl UniformDist {
    pub fn new(min: f64, max: f64) -> Result<Self, String> {
        if min >= max {
            return Err("Min deve ser menor que max".to_string());
        } else {
            let uniform = Uniform::new(min, max);
            Ok(UniformDist { min, max, uniform })
        }
    }

    pub fn min(&self) -> f64 {
        self.min
    }

    pub fn max(&self) -> f64 {
        self.max
    }
}

impl fmt::Display for UniformDist {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Uniform(min={:.2}, max={:.2})", self.min, self.max)
    }
}

impl super::Dist for UniformDist {
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Result<f64, Box<dyn std::error::Error>> {
        Ok(self.uniform.sample(rng))
    }
}

// Implementação de Serialize
impl Serialize for UniformDist {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        // Serializa apenas min e max
        let data = UniformDistData { min: self.min, max: self.max };
        data.serialize(serializer)
    }
}

// Implementação de Deserialize
impl<'de> Deserialize<'de> for UniformDist {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        // Desserializa em uma estrutura temporária
        let data = UniformDistData::deserialize(deserializer)?;
        // Recria o campo uniform usando min e max
        let uniform = Uniform::new(data.min, data.max);
        Ok(UniformDist {
            min: data.min,
            max: data.max,
            uniform,
        })
    }
}