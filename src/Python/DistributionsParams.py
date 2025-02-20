import numpy as np
import attrs

@attrs.define(slots= True, frozen= True)
class NormalParams:
    mean: np.float64
    std: np.float64
