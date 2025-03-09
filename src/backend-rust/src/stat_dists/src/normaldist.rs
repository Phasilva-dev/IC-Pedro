use rand::Rng;
use rand_distr::{Distribution, Normal};
use serde::Serialize;
use std::fmt;

#[derive(Serialize)]
pub struct NormalDist {
    mean: f64,
    std_dev: f64,
}

impl NormalDist {
    pub fn new(mean: f64, std_dev: f64) -> Self {
        NormalDist { mean, std_dev }
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
        let normal = Normal::new(self.mean, self.std_dev)
            .map_err(|e| Box::new(e) as Box<dyn std::error::Error>)?;
        Ok(normal.sample(rng))
    }
}
