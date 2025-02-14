#include <iostream>
#include <random>
#include <cstdint>
#include <array>
#include <iomanip>

constexpr int SECONDS_IN_A_DAY = 86400;

class TimeProfile {
private:
    static constexpr int DAYS_IN_WEEK = 7;
    std::array<double, DAYS_IN_WEEK> get_up_mean{};
    std::array<double, DAYS_IN_WEEK> get_up_std{};
    std::array<double, DAYS_IN_WEEK> work_mean{};
    std::array<double, DAYS_IN_WEEK> work_std{};
    std::array<double, DAYS_IN_WEEK> return_home_mean{};
    std::array<double, DAYS_IN_WEEK> return_home_std{};
    std::array<double, DAYS_IN_WEEK> sleep_mean{};
    std::array<double, DAYS_IN_WEEK> sleep_std{};

		static constexpr const char* WEEK_DAYS[DAYS_IN_WEEK] = {
        "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"
    };

		// Valida se um dia é válido (0 a 6)
    void validateDay(int day) const {
        if (day < 0 || day >= DAYS_IN_WEEK) {
            throw std::out_of_range("O dia deve estar entre 0 e 6 (domingo a sábado).");
        }
    }

public:
    // Construtor padrão (inicializa tudo com zero)
    TimeProfile() = default;

    // Construtor parametrizado
    TimeProfile(
        const std::array<double, DAYS_IN_WEEK>& get_up_m,
        const std::array<double, DAYS_IN_WEEK>& get_up_s,
        const std::array<double, DAYS_IN_WEEK>& work_m,
        const std::array<double, DAYS_IN_WEEK>& work_s,
        const std::array<double, DAYS_IN_WEEK>& return_m,
        const std::array<double, DAYS_IN_WEEK>& return_s,
        const std::array<double, DAYS_IN_WEEK>& sleep_m,
        const std::array<double, DAYS_IN_WEEK>& sleep_s)
        : get_up_mean(get_up_m), get_up_std(get_up_s),
          work_mean(work_m), work_std(work_s),
          return_home_mean(return_m), return_home_std(return_s),
          sleep_mean(sleep_m), sleep_std(sleep_s)
    {
        // Valida se os valores estão dentro de um intervalo aceitável (0 a 86400 segundos)
        for (int i = 0; i < DAYS_IN_WEEK; ++i) {
            if (get_up_mean[i] < 0 || get_up_mean[i] > 86400 ||
                work_mean[i] < 0 || work_mean[i] > 86400 ||
                return_home_mean[i] < 0 || return_home_mean[i] > 86400 ||
                sleep_mean[i] < 0 || sleep_mean[i] > 86400) 
            {
                throw std::out_of_range("Valores de tempo devem estar entre 0 e 86400 segundos.");
            }

            if (get_up_std[i] < 0 || work_std[i] < 0 || return_home_std[i] < 0 || sleep_std[i] < 0) {
                throw std::invalid_argument("Desvios padrão não podem ser negativos.");
            }
        }
    }


    // Destrutor
    ~TimeProfile() = default;

    // Métodos GET
    double getGetUpMean(int day) const { 
        validateDay(day);
        return get_up_mean[day]; 
    }

    double getGetUpStd(int day) const { 
        validateDay(day);
        return get_up_std[day]; 
    }

    double getWorkMean(int day) const { 
        validateDay(day);
        return work_mean[day]; 
    }

    double getWorkStd(int day) const { 
        validateDay(day);
        return work_std[day]; 
    }

    double getReturnHomeMean(int day) const { 
        validateDay(day);
        return return_home_mean[day]; 
    }

    double getReturnHomeStd(int day) const { 
        validateDay(day);
        return return_home_std[day]; 
    }

    double getSleepMean(int day) const { 
        validateDay(day);
        return sleep_mean[day]; 
    }

    double getSleepStd(int day) const { 
        validateDay(day);
        return sleep_std[day]; 
    }

    // Métodos SET
    void setGetUpMean(int day, double value) { 
        validateDay(day);
        if (value < 0 || value > SECONDS_IN_A_DAY) {
            throw std::out_of_range("O tempo deve estar entre 0 e 86400 segundos.");
        }
        get_up_mean[day] = value; 
    }

    void setGetUpStd(int day, double value) { 
        validateDay(day);
        if (value < 0) {
            throw std::invalid_argument("O desvio padrão não pode ser negativo.");
        }
        get_up_std[day] = value; 
    }

    void setWorkMean(int day, double value) { 
        validateDay(day);
        if (value < 0 || value > SECONDS_IN_A_DAY) {
            throw std::out_of_range("O tempo deve estar entre 0 e 86400 segundos.");
        }
        work_mean[day] = value; 
    }

    void setWorkStd(int day, double value) { 
        validateDay(day);
        if (value < 0) {
            throw std::invalid_argument("O desvio padrão não pode ser negativo.");
        }
        work_std[day] = value; 
    }

    void setReturnHomeMean(int day, double value) { 
        validateDay(day);
        if (value < 0 || value > SECONDS_IN_A_DAY) {
            throw std::out_of_range("O tempo deve estar entre 0 e 86400 segundos.");
        }
        return_home_mean[day] = value; 
    }

    void setReturnHomeStd(int day, double value) { 
        validateDay(day);
        if (value < 0) {
            throw std::invalid_argument("O desvio padrão não pode ser negativo.");
        }
        return_home_std[day] = value; 
    }

    void setSleepMean(int day, double value) { 
        validateDay(day);
        if (value < 0 || value > SECONDS_IN_A_DAY) {
            throw std::out_of_range("O tempo deve estar entre 0 e 86400 segundos.");
        }
        sleep_mean[day] = value; 
    }

    void setSleepStd(int day, double value) { 
        validateDay(day);
        if (value < 0) {
            throw std::invalid_argument("O desvio padrão não pode ser negativo.");
        }
        sleep_std[day] = value; 
    }



	// Método para imprimir os valores
  void printProfile() const {
        std::cout << std::fixed << std::setprecision(2);
        std::cout << "================ PERFIL SEMANAL =================\n";

        for (int i = 0; i < DAYS_IN_WEEK; ++i) {
            std::cout << WEEK_DAYS[i] << ":\n";
            std::cout << "  Acordar  -> Média: " << std::setw(6) << get_up_mean[i] << " s | Desvio: " << std::setw(6) << get_up_std[i] << " s\n";
            std::cout << "  Trabalho -> Média: " << std::setw(6) << work_mean[i] << " s | Desvio: " << std::setw(6) << work_std[i] << " s\n";
            std::cout << "  Retorno  -> Média: " << std::setw(6) << return_home_mean[i] << " s | Desvio: " << std::setw(6) << return_home_std[i] << " s\n";
            std::cout << "  Sono     -> Média: " << std::setw(6) << sleep_mean[i] << " s | Desvio: " << std::setw(6) << sleep_std[i] << " s\n";
            std::cout << "-----------------------------------------------\n";
        }
    }

};
    
