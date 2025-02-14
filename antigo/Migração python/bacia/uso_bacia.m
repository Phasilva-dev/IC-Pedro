function dom = uso_bacia(dom,tipo,dias)

%% FREQUENCIA| VAZAO | DURACAO BACIA SANITARIA

%  Sorteia a frequencia e vazao de uso do bacia por morador / dia
    N = dom.nmoradores;
    for i = 1: N
        for j = 1: dias
            % sorteia a frequencia
            freq = ceil(random('Poisson',2.75));
            dom.morador(i).bacia(j).frequencia = freq;
            
            %  Sorteia a vazao    
            if freq == 0
                
                vazao   = 0;
                duracao = 0;
                
            else
        
               [vazao,duracao]=bacia_function(tipo,freq);
 
                duracoes = dom.bacia(i).duracao(j).dia;
                duracoes = incrementa(duracao,duracoes);
                dom.bacia(i).duracao(j).dia = duracoes;           
            
                vazoes   = dom.bacia(i).vazao(j).dia;            
                vazoes   = incrementa(vazao,vazoes);
                dom.bacia(i).vazao(j).dia   = vazoes; 
                dom.bacia(i).consumo(j).dia   = sum(dom.bacia(i).vazao(j).dia.*dom.bacia(i).duracao(j).dia);
%{            
                dom.morador(i).bacia(j).duracao = duracoes;
                dom.morador(i).bacia(j).vazao   = vazoes;
                dom.morador(i).bacia(j).consumo = consumo;            
 %}
                               
                dom = hor_bacia(dom,dias,i,j,duracao);                             
               
            end  
            
        end
        
    end
end

function dom = hor_bacia(dom,dias,i,j,duracao)   
% j -  dias de analise
% i - pessoa da analise
            %% Definicao dos horarios de uso da bacia sanitaria 
            
            
            % Definicao dos horarios das atividades
            pessoa = dom.pessoas(i);
            [time]= horario_function(dias,pessoa);

            freq        = dom.morador(i).bacia(j).frequencia;            
            [hora_bacia]= sorteio_hor_bacia(time,j,freq,duracao,dom);
            
            % Atualiza os horarios de uso do lavatorio
         %   dom.morador(i).bacia(j).horario = hora_bacia;

            horas = dom.bacia(i).horario(j).dia;
            horas = incrementa(hora_bacia,horas);          
            dom.bacia(i).horario(j).dia = duration(0,0,horas,'Format','dd:hh:mm:ss'); 
end            