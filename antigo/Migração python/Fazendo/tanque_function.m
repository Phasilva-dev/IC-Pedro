function [duracao_tanque,vazao_tanque]=tanque_function(frequencia_tanque)
duracao_tanque=linspace(0,0,frequencia_tanque);
vazao_tanque=linspace(0,0,frequencia_tanque);    
for n = 1:frequencia_tanque
%% DURAÇÃO
      duracao_tanque(n)= random('Lognormal',3.2905,0.8918);
      
%% INTENSIDADE DE USO 
%CONSIdERAR O WHILE PARA RED CONSUMO
       %while vazao_tanque(n)<= (12/60)
         vazao_tanque(n) = random('Lognormal',-2.3485,0.3279);
       %end
    end
end