function dom = uso_pia(dom,dias)


%% Usos do lavatario

%  Sorteia a frequencia e vazao de uso da pia por morador / dia
    N = dom.nmoradores;
    for j = 1: dias
       for i = 1: N
            % sorteia a frequencia de uso
            freq = ceil(random('Poisson',24.88));
            dom.pia_cozinha(j).frequencia = freq;
            
            %  Sorteia a vaz�o    
            if freq == 0
                
                vazao   = 0;
                duracao = 0;
                
            else
        
               [duracao, vazao]=pia_cozinha_function(freq);
               dom = hor_pia(dom,dias,i,j,duracao);

            end
                dom.pia_cozinha(j).duracao = duracao;             
            
                dom.pia_cozinha(j).vazao = vazao;
                
                dom.pia_cozinha(j).consumo = sum(dom.pia_cozinha(j).duracao.*dom.pia_cozinha(j).vazao);
               
            
             
            
               
                                          
              
        end
        
    end
end



function dom = hor_pia(dom,dias,i,j,duracao)
% j -  dias de an�lise
% i - pessoa da an�lise            
%% Defini��o dos hor�rios de uso da pia sanit�ria 

            % Defini��o dos hor�rios das atividades
            pessoa = dom.pessoas(i);
            [time]= horario_function(dias,pessoa);
            

            freq      = dom.pia_cozinha(j).frequencia;            
            [hora_pia]= sorteio_hor_pia(time,j,freq,duracao);
            
            % Atualiza os hor�rios de uso do lavat�rio
            dom.pia_cozinha(j).horario = duration(0,0,hora_pia,'Format','dd:hh:mm:ss');
        
end