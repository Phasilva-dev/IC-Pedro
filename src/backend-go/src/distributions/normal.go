package distributions

import (
	"errors"
	"math/rand"

	"gonum.org/v1/gonum/stat/distuv"
)

type Normal struct {
	mean   float64
	stdDev float64
}

func NewNormal(mean, stdDev float64) (*Normal, error) {
	if stdDev <= 0 {
		return nil, errors.New("stdDev must be greater than 0")
	}
	return &Normal{
		mean:   mean,
		stdDev: stdDev,
	}, nil
}

func (n *Normal) Sample(rng rand.Source) float64 {
	dist := distuv.Normal{
		Mu:    n.mean,
		Sigma: n.stdDev,
		Src:   rng,
	}
	return dist.Rand()
}
