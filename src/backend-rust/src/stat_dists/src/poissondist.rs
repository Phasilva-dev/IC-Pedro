use rand::Rng;
use rand_distr::{Poisson, Distribution};
use serde::Serialize;
use std::fmt;

#[derive(Serialize)]
pub struct PoissonDist {
    lambda: f64,
}

impl PoissonDist {
	pub fn new(lambda: f64) -> Result<Self, String> {
    if lambda <= 0.0 {
        Err("Lambda deve ser maior que 0".to_string())
    } else {
        Ok(PoissonDist { lambda })
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
        let poisson = Poisson::new(self.lambda)
            .map_err(|e| Box::new(e) as Box<dyn std::error::Error>)?;
        Ok(poisson.sample(rng))
    }
}