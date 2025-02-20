import numpy as np
from DistributionsParams import NormalParams
import attrs
from typing import Optional

@attrs.define(slots= True, frozen= True)
class LeaveReturnTimes:
    leaveTime: NormalParams
    returnTime: NormalParams

@attrs.define(slots= True, frozen= True)
class RoutineProfile:
    wakeUpDist: NormalParams
    sleepDist: NormalParams
    leaveReturnDist: Optional[np.ndarray] = attrs.field(default=None)
    
    def __attrs_post_init__(self):
        # Converte para np.array apenas se leaveReturnTimes não for None
        if self.leaveReturnDist is not None:
            object.__setattr__(self, "leaveReturnDist", np.array(self.leaveReturnDist, dtype=object))