function [Q] = totaliza(aparelho,i,Q)
      
    % valores de uso dos equipamentos
    %freq   = aparelho.frequencia;
    freq   = size(aparelho.horario(i).dia,2);
    [~,ind]= sort(aparelho.horario(i).dia,2);
    
        
        inicio  = (seconds(aparelho.horario(i).dia(ind)) - (86400 *(i-1)));
        delta   = aparelho.duracao(i).dia(ind);
        vazao   = aparelho.vazao(i).dia(ind);
        %consumo = aparelho.consumo(ind);    
        %final   = ini + delta;

        for j=1:freq

            ini = int32(inicio(j));%duration(0,0,ini,'Format','dd:hh:mm:ss')
            N   = round(delta(j))-1;
            fim = min(ini + N, 86400*j);%duration(0,0,fim,'Format','dd:hh:mm:ss')

            if (N>0) && (ini>0) % horario de uso zerado.

                % vazao de uso na iteracao i
                q = vazao(j);

                % acumulo das vazoes
                Q(i,ini:fim) = Q(i,ini:fim) + q;

            end
        end    
    
end