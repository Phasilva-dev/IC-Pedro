function [vetor] = incrementa(valor,vetor)

    
% testa se o vetor ? tem dimensao nula
    if isvector(vetor)
        
        i = size(vetor,2);
        N = size(valor,2) + i;
        vetor(i+1:N) = valor;

    else

            vetor = valor;

    end    

    
end