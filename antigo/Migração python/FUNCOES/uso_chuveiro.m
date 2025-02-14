function dom = uso_chuveiro(dom,tipo_chuveiro,dias)


%% FREQUENCIA| VAZAO | DURACAO CHUVEIRO

%  Sorteia a frequencia e vazao de uso do chuveiro por morador / dia
    N = dom.nmoradores;
    
    for i = 1: N
        for j = 1: dias
            % sorteia a frequencia
            freq = ceil(random('Poisson',1.08));
            dom.morador(i).chuveiro(j).frequencia = freq;
            Acumulado = 0;
            %  Sorteia a vazao    
            if freq == 0
                
                vazao   = 0;
                duracao = 0;
                
            else
        
               [duracao,vazao]=chuveiro_function(tipo_chuveiro,freq);
               
                duracoes = dom.chuveiro(i).duracao(j).dia;
                duracoes = incrementa(duracao,duracoes);
                dom.chuveiro(i).duracao(j).dia = duracoes;
                
                vazoes   = dom.chuveiro(i).vazao(j).dia;            
                vazoes   = incrementa(vazao,vazoes);
                dom.chuveiro(i).vazao(j).dia   = vazoes;
                dom.chuveiro(i).consumo(j).dia   = sum(dom.chuveiro(i).vazao(j).dia.*dom.chuveiro(i).duracao(j).dia);
                %{
                dom.morador(i).chuveiro(j).duracao = duracoes;
                dom.morador(i).chuveiro(j).vazao   = vazoes;
                dom.morador(i).chuveiro(j).consumo = consumo;
                %}                
                dom = hor_chuveiro(dom,dias,i,j,duracao);

            end
        end 
    end
    
end

function dom = hor_chuveiro(dom,dias,i,j,duracao)
% j -  dias de analise
% i - pessoa da analise      
            
            % Definicao dos hor�rios das atividades
            pessoa = dom.pessoas(i);
            [time]= horario_function(dias,pessoa);
            dom.morador(i).time=time;

            %% Definicao dos horarios de uso do chuveiro 
            freq        = dom.morador(i).chuveiro(j).frequencia;
            
            
            [hora_chuv] = sorteio_hor_chuveiro(time,j,freq,duracao,dom);
           
            % Atualiza os horarios de uso de chuveiro de lavatario
            %dom.morador(i).chuveiro(j).horario=hora_chuv;
            
            horas = dom.chuveiro(i).horario(j).dia;
            horas = incrementa(hora_chuv,horas);          
            dom.chuveiro(i).horario(j).dia=duration(0,0,horas,'Format','dd:hh:mm:ss');             
                
 end