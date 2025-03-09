package distributions

import (
    "encoding/json"
    "errors"
    "fmt"
    "golang.org/x/exp/rand"
    "gonum.org/v1/gonum/stat/distuv"
)

// Poisson representa uma distribuição de Poisson
type Poisson struct {
    lambda float64
    dist   distuv.Poisson
}

func NewPoisson(lambda float64) (*Poisson, error) {
    if lambda <= 0 {
        return nil, errors.New("lambda must be greater than 0")
    }
    return &Poisson{
        lambda: lambda,
        dist:   distuv.Poisson{Lambda: lambda},
    }, nil
}

func (p *Poisson) Sample(rng rand.Source) float64 {
    p.dist.Src = rng
    return p.dist.Rand()
}

func (p *Poisson) String() string {
    return fmt.Sprintf("Poisson(λ=%.2f)", p.lambda)
}

func (p *Poisson) MarshalJSON() ([]byte, error) {
    return json.Marshal(struct {
        Type   string    `json:"type"`
        Params []float64 `json:"params"`
    }{
        Type:   "poisson",
        Params: []float64{p.lambda},
    })
}