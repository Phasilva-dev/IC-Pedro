package distributions

import (
	"encoding/json"
	"errors"
	"fmt"
	"golang.org/x/exp/rand" // Substitua golang.org/x/exp/rand

	"gonum.org/v1/gonum/stat/distuv"
)

// Uniform representa uma distribuição uniforme
type Uniform struct {
	min  float64
	max  float64
	dist distuv.Uniform
}

// NewUniform cria uma nova distribuição uniforme
func NewUniform(min, max float64) (*Uniform, error) {
	if min > max {
		return nil, errors.New("min must be less than or equal to max")
	}
	return &Uniform{
		min:  min,
		max:  max,
		dist: distuv.Uniform{Min: min, Max: max, Src: nil},
	}, nil
}

func (u *Uniform) Sample(rng *rand.Rand) float64 { // Atualizado para *math/rand/v2.Rand
	u.dist.Src = rng
	return u.dist.Rand()
}

func (u *Uniform) String() string {
	return fmt.Sprintf("Uniform(min=%.2f, max=%.2f)", u.min, u.max)
}

func (u *Uniform) MarshalJSON() ([]byte, error) {
	return json.Marshal(struct {
		Type   string    `json:"type"`
		Params []float64 `json:"params"`
	}{
		Type:   "uniform",
		Params: []float64{u.min, u.max},
	})
}