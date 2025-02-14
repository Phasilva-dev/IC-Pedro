function [horario]= sorteio_hor_pia(time,j,freq,duracao)

 get_up          =  time.get_up(j);
 work_time       =  time.work_time(j);
 sleep_time      =  time.sleep_time(j); 
 return_home     =  time.return_home(j);
 sleep_duration  =  time.sleep_duration(j);
 horario = zeros(1,freq);
if freq == 0
   horario=[];
else
    horario(freq)=0;
    % HORARIO PIA DA COZINHA
    for x= 1:freq
        hora=86400*j;
        while (duracao(x)+hora)>=86400*j
        n=random('Uniform',0,1);
            if sleep_time > return_home
                if n<0.025
                    horario(x)=random('Uniform',get_up-sleep_duration+86400,86400);
                elseif (0.025<=n) && (n<0.05)
                    horario(x)=random('Uniform',(j-1)*86400,get_up);
                elseif (0.05<=n) && (n<0.3)
                    horario(x)=random('Uniform',get_up,work_time);
                else
                    horario(x)=random('Uniform',return_home,sleep_time);
                end
            else
                if (n<0.025)
                    horario(x)=random('Uniform',sleep_time,get_up);
                elseif (0.025<=n) && (n<0.3)
                    horario(x)=random('Uniform',get_up,work_time);
                else
                    if sleep_time< return_home
                        sorteio=random('Uniform',0,1);
                        if sorteio < (((86400*j)-return_home)/((86400*j)-return_home+sleep_time))
                            horario(x)=random('Uniform',return_home,86400*j);
                        else 
                            horario(x)=random('Uniform',(j-1)*86400,sleep_time);
                        end
                    else
                        horario(x)=random('Uniform',return_home,sleep_time);
                    end
                end
            end
    hora=horario(x);
        end
    end
end