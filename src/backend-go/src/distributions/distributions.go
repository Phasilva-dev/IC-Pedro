package distributions

import (
	"errors"
)

type Distribution interface {

	Sample(rng rand.Source) float64
	String() string

}

func CreateDistribution(distType string, params ...float64) (Distribution, error) {
	switch distType {
	case "normal":
			if len(params) != 2 {
					return nil, errors.New("normal requires exactly 2 parameters: mean and stdDev")
			}
			return NewNormal(params[0], params[1])
	case "poisson":
			if len(params) != 1 {
					return nil, errors.New("poisson requires exactly 1 parameter: lambda")
			}
			return NewPoisson(params[0])
	case "uniform":
			if len(params) != 2 {
					return nil, errors.New("uniform requires exactly 2 parameters: min and max")
			}
			return NewUniform(params[0], params[1])
	default:
			return nil, errors.New("unknown distribution type")
	}
}