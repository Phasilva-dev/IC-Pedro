function [duracao_lavatorio,intensidade_lavatorio]=lavatorio_function(frequencia_lavatorio)

duracao_lavatorio=linspace(0,0,frequencia_lavatorio); 
intensidade_lavatorio=linspace(0,0,frequencia_lavatorio);

for n = 1:frequencia_lavatorio
    %sorteio do uso, 33% de chance de escovar dentes ou fazer barba, 67% de
    %chance de escovar os dentes
    
    duracao_lavatorio (n)= random('Lognormal',3.3551,0.8449);
    
    

%% INTENSIDADE DE USO (vazao pia do banheiro)
%  probabilidade de gerar ser um chuveiro com reducao de agua O a 0.5 > sim,
% 0.5 a 1 > nao
%Para o uso do restritor, considerar o while:
    intensidade_lavatorio(n)=1;
   %while intensidade_lavatorio(n) > (2/60)
        intensidade_lavatorio(n) = random('Lognormal',-2.6677,0.3275);
   %end
    
end

Lognormal

media 
desvio
