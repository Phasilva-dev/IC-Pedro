function [time] = horario_function(dias,pessoa,dom)
 work_time      = linspace(0,0,dias);
 get_up         = linspace(0,0,dias);
 time_out       = linspace(0,0,dias);
 sleep_duration = linspace(0,0,dias);
 sleep_time     = linspace(0,0,dias);
 return_home    = linspace(0,0,dias); 
 
for d=1:dias
%% PESSOA TIPOS
% Tipo 1 : adulto que trabalha fora de casa
% Tipo 2 : adolescente matutino 
% Tipo 3 : idoso +65
% Tipo 4 : adolescente vespertino
% Tipo 5 : adulto que trabalha em casa|domestico|desempregado
% Tipo 6 : pessoa desocupada

      while  work_time(d)<get_up(d)+1800 
        T = (d-1)*86400.0;
        switch pessoa
 
        %ADULTO FORA DE CASA
        case 1 
            get_up(d)         = random('Normal',5.5*60*60,3600) + T;  % Hora que acorda 6.52+-1.85
            work_time(d)      = random('Normal',7.5*3600,1800) + T;  % Horario que vai trabalhar
            time_out(d)       = random('Normal',7.9*3600,1.8*3600);       % Tempo fora de casa
            sleep_duration(d) = random('Normal',7.5*3600,1.8*3600);       % Duracao do sono           
            
            % Horario que vai dormir
            if sleep_duration(d) > get_up(d)-T
                sleep_time(d) = get_up(d) + 86400 - sleep_duration(d);

            else
                sleep_time(d) = get_up(d) - sleep_duration(d);

            end
            
            return_home(d) = time_out(d) + work_time(d);
            
        %CRIANCA MATUTINO    
        case 2            
            get_up(d)         = random('Normal',5.75*3600,3600) + T;   % Hora que vai para o trabalho
            work_time(d)      = random('Normal',7*60*60,1800) + T;   % Tempo fora de casa
            time_out(d)       = random('Normal',6*3600,1800);   % Horario que retorna para casa apos trabalho
            sleep_duration(d) = random('Normal',9.5*60*60,3600) ;   %Duracao do sono            
            
            % Horario que vai dormir
            if sleep_duration(d) > get_up(d) -T
                sleep_time(d) = get_up(d)+86400 - sleep_duration(d);

            else
                sleep_time(d) = get_up(d) - sleep_duration(d);

            end
            
            return_home(d) = time_out(d) + work_time(d);          
        %IDOSO             
        case 3
            get_up(d)         = random('Normal',5.5*3600,3600) + T;        % Hora que vai para o trabalho
            work_time(d)      = random('Normal',10*3600,3*3600) + T;       % Tempo fora de casa
            time_out(d)       = abs(random('Normal',4*3600,4*3600));  % Horario que retorna para casa apos trabalho
            sleep_duration(d) = random('Normal',7.5*3600,1800);        %Duracao do sono
            
            % Horario que vai dormir
            if sleep_duration(d) > get_up(d)-T
                sleep_time(d) = get_up(d) + 86400 - sleep_duration(d);

            else
                sleep_time(d) = get_up(d) - sleep_duration(d);

            end
            
            return_home(d) = time_out(d) + work_time(d);         
        %CRIANCA VESPERTINO    
        case 4
            get_up(d)         = random('Normal',8*3600,3600) + T;   % Hora que vai para o trabalho
            work_time(d)      = random('Normal',12.5*3600,1800) + T;   % Tempo fora de casa
            time_out(d)       = random('Normal',6*3600,1800) ;   % Horario que retorna para casa apos trabalho
            sleep_duration(d) = random('Normal',7.5*3600,3600);   %Duracao do sono            
            
            % Hor�rio que vai dormir
            if sleep_duration(d) > get_up(d)-T
                sleep_time(d) = get_up(d)+86400 - sleep_duration(d);

            else
                sleep_time(d) = get_up(d) - sleep_duration(d);

            end
            
            return_home(d) = time_out(d) + work_time(d);         
          %ADULTO DESOCUPADO             
        otherwise      
            get_up(d)         = random('Normal',8*3600,3600) + T;       % Hora que vai para o trabalho
            work_time(d)      = random('Normal',10*3600,10800) + T;      % Tempo fora de casa
            time_out(d)       = abs(random('Normal',4*3600,4*3600)) ; % Horario que retorna para casa apos trabalho
            sleep_duration(d) = random('Normal',7.5*3600,3600) ;       %Duracao do sono            
            
            % Horario que vai dormir
            if sleep_duration(d) > get_up(d)-T
                sleep_time(d) = get_up(d)+86400 - sleep_duration(d);

            else
                sleep_time(d) = get_up(d) - sleep_duration(d);

            end
            
            return_home(d) = time_out(d) + work_time(d);         
      
        end 


      end
         
end
 
      time.get_up          =  get_up;
      time.work_time       =  work_time;
      time.out             =  time_out;
      time.sleep_duration  =  sleep_duration;
      time.sleep_time      =  sleep_time; 
      time.return_home     =  return_home;
end