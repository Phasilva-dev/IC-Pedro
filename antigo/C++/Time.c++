#include <iostream>
#include <cstdint>
#include <random>
#include <unordered_map>
#include <limits>



class Time {
private:
    static constexpr int DAYS_IN_WEEK = 7;
    static constexpr int SECONDS_IN_A_DAY = 86400;
    static std::mt19937 gen; // Gerador estatico
    
    std::uniform_int_distribution<uint64_t> seed_dist; // Agora apenas declarado, sem inicialização
    std::mt19937 local_gen; //Gerador local suporta 2**64-1 seeds diferentes

    using TimeArray = std::array<std::uint32_t, DAYS_IN_WEEK>;
    TimeArray getUp{}, work{}, returnHome{}, sleepTime{};

public:
    // Construtor padrão
    Time() 
        : seed_dist(0, std::numeric_limits<uint64_t>::max()), // Agora inicializado corretamente
          local_gen(seed_dist(gen)), 
          getUp{}, work{}, returnHome{}, sleepTime{} {}


		// Construtor baseado em perfil
    Time(const TimeProfile &profile) 
        : Time() { // Chama o construtor padrão para inicializar os membros
        for (int i = 0; i < DAYS_IN_WEEK; ++i) {
            std::normal_distribution<double> getUpDist(profile.get_up_mean[i], profile.get_up_std[i]);
            std::normal_distribution<double> workDist(profile.work_mean[i], profile.work_std[i]);
            std::normal_distribution<double> returnHomeDist(profile.return_home_mean[i], profile.return_home_std[i]);
            std::normal_distribution<double> sleepDist(profile.sleep_mean[i], profile.sleep_std[i]);

            getUp[i] = generate_cyclic_time(getUpDist);
            work[i] = generate_cyclic_time(workDist);
            returnHome[i] = generate_cyclic_time(returnHomeDist);
            sleepTime[i] = generate_cyclic_time(sleepDist);
        }
    }

    uint32_t generate_cyclic_time(std::normal_distribution<double> &dist) {
        int64_t result = static_cast<int64_t>(dist(local_gen));
        result = (result % SECONDS_IN_A_DAY + SECONDS_IN_A_DAY) % SECONDS_IN_A_DAY;
        return static_cast<uint32_t>(result);
    }

    // Destrutor
    ~Time() = default;

    // Métodos GET
    uint32_t getGetUp(int day) const { return getUp[day]; }
    uint32_t getWork(int day) const { return work[day]; }
    uint32_t getReturnHome(int day) const { return returnHome[day]; }
    uint32_t getSleepTime(int day) const { return sleepTime[day]; }

    // Método para imprimir os horários
    void printSchedule() const {
        for (int i = 0; i < DAYS_IN_WEEK; ++i) {
            std::cout << "Dia " << i << ":\n"
                      << "  Acordar: " << getUp[i] << " seg\n"
                      << "  Trabalho: " << work[i] << " seg\n"
                      << "  Retorno: " << returnHome[i] << " seg\n"
                      << "  Sono: " << sleepTime[i] << " seg\n\n";
        }
    }
};

std::mt19937 Time::gen(std::random_device{}());
