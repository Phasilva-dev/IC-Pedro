function [Q] = totaliza2(aparelho,j,Q)
      
    % valores de uso dos equipamentos
    %freq   = aparelho.frequencia;
    freq   = size(aparelho.horario,2);
    
    [~,ind]= sort(aparelho.horario,2);
    
    inicio  = (seconds(aparelho.horario(ind)) - (86400 *(j-1)));
    delta   = aparelho.duracao(ind);
    vazao   = aparelho.vazao(ind);
    %consumo = aparelho.consumo(ind);    
    %final   = ini + delta;
    
    for k = 1:freq
        ini = int32(inicio(k));
        N   = round(delta(k))-1;
        fim = min(ini + N, 86400*j);

        if (N>0) && (ini>0) % horario de uso zerado.
        
            % vazao de uso na iteracao i
            q = vazao(k);
    
            % acumulo das vazoes
            Q(j,ini:fim) = Q(j,ini:fim) + q;
   
        end
    end    

end