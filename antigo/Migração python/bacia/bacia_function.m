function [vaz,durac]= bacia_function(tipo_bacias,frequencia_bacia)
%% DURACAO DO USO DO WC 
% vai gerar um vetor de valores de duracao com o tamanho da frequencia
    %sorteio da bacia por tipo de cisterna e se possui opcao de reducao de consumo
        % 33.3% de chance 6L com reducao
         % 11.1% 6L s/ reducao
         % 33.3% 9L s/ reducao
         % 22.2 9L c/ reducao
    %chance de escovar os dentes
    
    vaz       = zeros(1,frequencia_bacia); 
    durac     = zeros(1,frequencia_bacia);

    if tipo_bacias == 0
        disp('nao ha bacia')
    end
 
 
    for n=1:frequencia_bacia
    
        switch tipo_bacias
 
        %bacia acquamac
        case 1
            vaz(n)   = 0.4;  % 9l s/ redu.
            durac(n) = 5;       

        case 2
            vaz(n)   = 0.042;  % 9l c/ redu.
            durac(n) = 1.8*60; 
        
        %tiago vasconcelos     
        case 3
            vaz(n)   = 0.25;  % 9l c/ redu.
            durac(n) = 60;          
 
        otherwise      %caso 4 
            vaz(n)   = 0.042;  % 9l c/ redu.
            durac(n) = 1.2*60; 
        
        end
    
    end

end
