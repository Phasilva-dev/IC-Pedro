function dom = uso_lavatorio(dom,dias)

%% Usos do lavat�rio

%  Sorteia a frequencia e vazao de uso do lavatario por morador / dia
    N = dom.nmoradores;
    for i = 1: N
        for j = 1: dias
            % sorteia a frequencia de uso
            freq = ceil(random('Poisson',5.93));
            dom.morador(i).lavatorio(j).frequencia = freq;
            
            %  Sorteia a vaz�o    
            if freq == 0
                
                vazao   = 0;
                duracao = 0;
                
            else
        
               [duracao, vazao]=lavatorio_function(freq);
               

                duracoes = dom.lavatorio(i).duracao(j).dia;
                duracoes = incrementa(duracao,duracoes);
                dom.lavatorio(i).duracao(j).dia = duracoes;
                        
                vazoes   = dom.lavatorio(i).vazao(j).dia;            
                vazoes   = incrementa(vazao,vazoes);
                
                dom.lavatorio(i).vazao(j).dia   = vazoes;
                dom.lavatorio(i).consumo(j).dia   = sum(dom.lavatorio(i).vazao(j).dia.*dom.lavatorio(i).duracao(j).dia);
                dom = hor_lavatorio(dom,dias,i,j,duracao); 
 %{           
                dom.morador(i).lavatorio(j).duracao = duracoes;
                dom.morador(i).lavatorio(j).vazao   = vazoes;
                dom.morador(i).lavatorio(j).consumo = consumo;
 %}           
                   
                         
        end
        
        end
  
end 
end
function dom = hor_lavatorio(dom,dias,i,j,duracao)  
% j -  dias de an�lise
% i - pessoa da an�lise
 %% Defini��o dos hor�rios de uso do lavat�rio     

            % Defini��o dos hor�rios das atividades
            pessoa = dom.pessoas(i);
            [time]= horario_function(dias,pessoa,dom);
           
            
            % Defini��o dos hor�rios de uso do lavat�rio              
            freq       = dom.morador(i).lavatorio(j).frequencia;            
            [hora_lav] = sorteio_hor_lavatorio(time,j,freq,duracao,dom);
            
            % Atualiza os hor�rios de uso do lavat�rio
       %     dom.morador(i).lavatorio(j).horario=hora_lav;

            horas = dom.lavatorio(i).horario(j).dia;
            horas = incrementa(hora_lav,horas);          
            dom.lavatorio(i).horario(j).dia = duration(0,0,horas,'Format','dd:hh:mm:ss');  
            
end
