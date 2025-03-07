use rand::Rng;
use rand_distr::{Uniform, Distribution};
use serde::Serialize;
use std::fmt;

#[derive(Serialize)]
pub struct UniformDist {
    min: f64,
    max: f64,
}

impl UniformDist {
    pub fn new(min: f64, max: f64) -> Result<Self, String> {
        if min >= max {
            return Err("Min deve ser menor que max".to_string());
        }
        Ok(UniformDist { min, max })
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
        let uniform = Uniform::new(self.min, self.max);
        Ok(uniform.sample(rng))
    }
}