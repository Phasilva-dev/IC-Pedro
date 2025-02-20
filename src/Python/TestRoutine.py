import pytest
import numpy as np
from DistributionsParams import NormalParams
from RoutineProfile import LeaveReturnTimes, RoutineProfile
from Routine import generate_cyclic_time, DAY_IN_SECONDS
import matplotlib.pyplot as plt
#plt.use('Agg')

#pytest TestRoutine.py -v

# Fixture para o gerador aleatório com seed fixa
@pytest.fixture
def rng():
    return np.random.default_rng(seed=1234)

# Testes para LeaveReturnTimes
class TestLeaveReturnTimes:
    def test_leave_return_times_creation(self):
        leave_time = NormalParams(8 * 3600, 3600)
        return_time = NormalParams(18 * 3600, 3600)
        lrt = LeaveReturnTimes(leave_time, return_time)
        
        assert lrt.leaveTime.mean == 8 * 3600
        assert lrt.leaveTime.std == 3600
        assert lrt.returnTime.mean == 18 * 3600
        assert lrt.returnTime.std == 3600

# Testes para RoutineProfile
class TestRoutineProfile:
    def test_profile_without_events(self):
        wake_up = NormalParams(7 * 3600, 1800)
        sleep = NormalParams(23 * 3600, 1800)
        profile = RoutineProfile(wake_up, sleep)
        
        assert profile.wakeUpDist.mean == 7 * 3600
        assert profile.wakeUpDist.std == 1800
        assert profile.sleepDist.mean == 23 * 3600
        assert profile.sleepDist.std == 1800
        assert profile.leaveReturnDist is None

    def test_profile_with_events(self):
        wake_up = NormalParams(7 * 3600, 1800)
        sleep = NormalParams(23 * 3600, 1800)
        
        lrt1 = LeaveReturnTimes(
            NormalParams(8 * 3600, 1800),
            NormalParams(17 * 3600, 1800)
        )
        lrt2 = LeaveReturnTimes(
            NormalParams(9 * 3600, 1200),
            NormalParams(18 * 3600, 1200)
        )
        
        profile = RoutineProfile(wake_up, sleep, [lrt1, lrt2])
        
        assert len(profile.leaveReturnDist) == 2
        assert profile.leaveReturnDist[0].leaveTime.mean == 8 * 3600
        assert profile.leaveReturnDist[0].returnTime.mean == 17 * 3600
        assert profile.leaveReturnDist[1].leaveTime.mean == 9 * 3600
        assert profile.leaveReturnDist[1].returnTime.mean == 18 * 3600

# Testes para generate_cyclic_time
class TestGenerateCyclicTime:
    @pytest.mark.parametrize("mean, std, case_name", [
        (12 * 3600, 1800, "Caso 1 (12h, 30min)"),    # Caso 1
        (0, 3600, "Caso 2 (00h, 1h)"),              # Caso 2
        (23*3600 + 59*60, 3600, "Caso 3 (23h59, 1h)"),  # Caso 3
        (12 * 3600, 10 * 3600, "Caso 4 (12h, 10h)")   # Caso 4
    ])
    def test_time_ranges(self, rng, mean, std, case_name):
        dist = NormalParams(mean, std)
        times = [generate_cyclic_time(rng, dist) for _ in range(1000)]
        
        # Verificações
        assert all(0 <= t <= DAY_IN_SECONDS for t in times)
        assert min(times) >= 0
        assert max(times) <= DAY_IN_SECONDS

        # Plotagem
        self._plot_times(times, case_name)

    def _plot_times(self, times, case_name):
        plt.figure(figsize=(10, 6))
        
        # Histograma
        plt.hist(times, bins=50, range=(0, DAY_IN_SECONDS), alpha=0.7, label=case_name)
        
        # Configurações do gráfico
        plt.title(f"Distribuição de Tempos - {case_name}")
        plt.xlabel("Tempo (segundos)")
        plt.ylabel("Ocorrências")
        plt.xticks(ticks=range(0, DAY_IN_SECONDS + 1, 3600), labels=range(0, 25))  # Marcadores de hora em hora
        plt.grid(True)
        plt.legend()
        plt.tight_layout()
        plt.show()

    def test_edge_cases(self, rng):
        # Teste com valores extremos
        dist = NormalParams(-1e6, 1e6)
        time = generate_cyclic_time(rng, dist)
        assert 0 <= time <= DAY_IN_SECONDS

        dist = NormalParams(2 * DAY_IN_SECONDS, 1e6)
        time = generate_cyclic_time(rng, dist)
        assert 0 <= time <= DAY_IN_SECONDS