function [durac,vaz]= chuveiro_function(tipo_chuveiro,frequencia_chuveiro)

%% TIPOLOGIA CHUVEIRO 
% vai gerar uma matriz 1x1 com o tipo de chuveiro da residencia
    %TIPO 1 - CHUVEIRO ECONOMICO DE VAZAO 3L/min e DURACAO 5MIN(OMS)
    %TIPO 2 - CHUVEIRO NORMAL DE VAZAO

vaz       = zeros(1,frequencia_chuveiro); 
durac     = zeros(1,frequencia_chuveiro); 

for n=1:frequencia_chuveiro
    
    switch tipo_chuveiro
        
    case 1
        vaz(n)     =   random(makedist('Triangular','A',3,'B',4,'C',5))/60; 
        durac(n)   = 60*random(makedist('Triangular','A',2,'B',3.5,'C',5));        

    otherwise
        
        vaz(n)    = random('Lognormal',-2.4205,0.2014);
        durac(n)  = random('Gamma',6.5216,0.7668)*60;
    end
    
end