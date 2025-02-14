function dom = uso_maquina(dom,dias)

%% Usos da máquina

%  Sorteia a frequencia e vazão de uso da maquina por morador / dia
    N = dom.nmoradores;
    for j = 1: dias
       for i = 1: N
            % sorteia a frequencia de uso
            freq = ceil(random('Poisson',0.37));
            dom.maquina(j).frequencia = freq;
            
            %  Sorteia a vazão    
            if freq == 0
                
                vazao   = [];
                duracao = [];
                dom.maquina(j).horario=[];
            else
        
               [duracao, vazao]=maquina_function(freq);
               dom = hor_maquina(dom,dias,i,j,duracao);

            end   
                dom.maquina(j).duracao   = duracao;            
                dom.maquina(j).vazao   = vazao;
                dom.maquina(j).consumo = sum(dom.maquina(j).vazao.*dom.maquina(j).duracao);
                dom = hor_maquina(dom,dias,i,j,duracao); 
        
                                                            
               
              
        end
        
    end
end


function dom = hor_maquina(dom,dias,i,j,duracao)
% j -  dias de análise
% i - pessoa da análise
%% Definição dos horários de uso da máquina de lavar 
            
            % Definição dos horários das atividades
            pessoa = dom.pessoas(i);
            [time]= horario_function(dias,pessoa);            
                      
            freq      = dom.maquina(j).frequencia;  
            if freq==0
                dom.maquina(j).horario=[];
            else
            [hora_maq]= sorteio_hor_maquina(time,pessoa,j,freq,duracao);
            
            % Atualiza os horários de uso da maquina
            dom.maquina(j).horario = duration(0,0,hora_maq,'Format','dd:hh:mm:ss');
            end
          
end
