package distributions

import (
    "encoding/json"
    "errors"
    "golang.org/x/exp/rand"

)

// Distribution é a interface abstrata
type Distribution interface {
    Sample(rng rand.Source) float64
    String() string
    MarshalJSON() ([]byte, error)
}

// CreateDistribution cria uma distribuição com base no tipo e parâmetros
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

// UnmarshalDistribution desserializa um JSON em uma Distribution
func UnmarshalDistribution(data []byte) (Distribution, error) {
    var wrapper struct {
        Type   string    `json:"type"`
        Params []float64 `json:"params"`
    }
    if err := json.Unmarshal(data, &wrapper); err != nil {
        return nil, err
    }
    return CreateDistribution(wrapper.Type, wrapper.Params...)
}