function [horario]= sorteio_hor_maquina(time,pessoa,j,freq,duracao)

 get_up          =  time.get_up(j);
 work_time       =  time.work_time(j);
 sleep_time      =  time.sleep_time(j); 
 return_home     =  time.return_home(j);
 horario = zeros(1,freq);
if freq == 0
   horario=[];

else
    horario(freq) = 0;

    % HORARIO MAQUINA DE LAVAR
    for x= 1 : freq
        hora=86400*j;
        
            horario(x)= (random('LogLogistic',10.448,0.167418))+((j-1)*86400);     
        hora=horario(x);
       
    end
end
end 