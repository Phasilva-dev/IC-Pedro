function [duracao_maquina,intensidade_maquina]=maquina_function(frequencia_maquina)
duracao_maquina     = zeros(1,frequencia_maquina);
intensidade_maquina = zeros(1,frequencia_maquina);
    for n = 1:frequencia_maquina
   
        duracao_maquina(n)= 4*6*60;
   
    end

%% INTENSIDADE DE USO (vazao pia do banheiro)
%  probabilidade de gerar ser um chuveiro com reducao de agua O a 0.5 > sim,
% 0.5 a 1 > nao

    intensidade_maquina(n) = 0.1;

end
