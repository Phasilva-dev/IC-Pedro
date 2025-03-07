package distributions

import (
	"encoding/json"
	"errors"
	"fmt"
	"golang.org/x/exp/rand" // Substitua golang.org/x/exp/rand

	"gonum.org/v1/gonum/stat/distuv"
)

// Normal representa uma distribuição normal
type Normal struct {
	mean   float64
	stdDev float64
	dist   distuv.Normal
}

// NewNormal cria uma nova distribuição normal
func NewNormal(mean, stdDev float64) (*Normal, error) {
	if stdDev <= 0 {
		return nil, errors.New("stdDev must be greater than 0")
	}
	return &Normal{
		mean:   mean,
		stdDev: stdDev,
		dist:   distuv.Normal{Mu: mean, Sigma: stdDev, Src: nil},
	}, nil
}

func (n *Normal) Sample(rng *rand.Rand) float64 { // Atualizado para *math/rand/v2.Rand
	n.dist.Src = rng
	return n.dist.Rand()
}

func (n *Normal) String() string {
	return fmt.Sprintf("Normal(μ=%.2f, σ=%.2f)", n.mean, n.stdDev)
}

func (n *Normal) MarshalJSON() ([]byte, error) {
	return json.Marshal(struct {
		Type   string    `json:"type"`
		Params []float64 `json:"params"`
	}{
		Type:   "normal",
		Params: []float64{n.mean, n.stdDev},
	})
}