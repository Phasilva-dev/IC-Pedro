import numpy as np
import attrs
from typing import Optional
from DistributionsParams import NormalParams
from RoutineProfile import RoutineProfile
# Constantes
DAY_IN_SECONDS = 24 * 60 * 60  # 86400 segundos
DAYS_IN_WEEK = 7

@attrs.define(slots= True) #, frozen= True
class Routine:
    wakeUp: np.int32
    sleep: np.int32
    events: Optional[np.ndarray] = attrs.field(default=None)
    
    @classmethod
    def from_profile(cls, profile: RoutineProfile, rng: np.random.Generator) -> "Routine":
        wakeUp = generate_cyclic_time(rng, profile.wakeUpDist)
        sleep = generate_cyclic_time(rng, profile.sleepDist)

        if profile.leaveReturnDist is None:
            events = None
        # Criando array NumPy para armazenar tuplas (saída, retorno)
        events = np.empty((len(profile.leaveReturnDist), 2), dtype=np.int32)

        for i in range(len(profile.leaveReturnDist)):
            events[i, 0] = generate_cyclic_time(rng, profile.leaveReturnDist[i].leaveTime)
            events[i, 1] = generate_cyclic_time(rng, profile.leaveReturnDist[i].returnTime)

        return cls(wakeUp=wakeUp, sleep=sleep, events=events)
            
def generate_cyclic_time(rng, dist: NormalParams) -> np.int32:
    result = np.int32(rng.normal(dist.mean, dist.std))
    result = result % DAY_IN_SECONDS
    if result < 0:
          result += DAY_IN_SECONDS
    return result
