function [duracao_pia_cozinha,vazao_pia_cozinha]=pia_cozinha_function(frequencia_pia_cozinha)
duracao_pia_cozinha=linspace(0,0,frequencia_pia_cozinha);
vazao_pia_cozinha=linspace(0,0,frequencia_pia_cozinha); 
for n = 1:frequencia_pia_cozinha
    %sorteio do uso, 33% de chance de escovar dentes ou fazer barba, 67% de
    %chance de escovar os dentes

          duracao_pia_cozinha (n)= random('Lognormal',3.1763,0.785);
 
%% INTENSIDADE DE USO (vazio pia do banheiro)

% Para restritor de vazio de 6L/min, usar o while
     %while vazao_pia_cozinha(n)<= 0.1

           vazao_pia_cozinha(n) = random('Weibull',0.0569,1.5871);
     %end
end