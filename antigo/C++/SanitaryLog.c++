#include <iostream>
#include <vector>
#include <string>

class SanitaryLog
{
private:
		//Ponteiro para qual SanitaryDevice foi usado (Exemplo, Torneira tigre vazao 2L)
		//Ponteiro para qual Resident gerou esse registro de uso
		//(Formato dos residents sempre vai ser nunmero = numero da ksa e letra = integrante, 1a = residente 1 da casa 1)
		//Ponteiro para House?
		//Dia da simulação
		//Start Time
		//Duração
		//Vazão durante esse tempo???
    std::vector<std::string> logs; // Para armazenar as mensagens de log

public:
    // Construtor
    SanitaryLog();

    // Destruidor
    ~SanitaryLog();

    // Método para adicionar uma entrada de log
    void addLog(const std::string& logMessage);

    // Método para exibir todos os logs
    void showLogs() const;
