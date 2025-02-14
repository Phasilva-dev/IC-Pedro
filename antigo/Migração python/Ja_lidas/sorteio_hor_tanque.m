function [horario]= sorteio_hor_tanque(time,j,freq)

 get_up          =  time.get_up(j);
 work_time       =  time.work_time(j);
 sleep_time      =  time.sleep_time(j); 
 return_home     =  time.return_home(j);
 horario = zeros(1,freq);
if freq == 0
    horario = [];
else 
    horario(freq)=0;
    % HORARIO tanque
    for x= 1 : freq
        n=random('Uniform',0,1);
        % Ti esta com valores menores que tf em determinadas vezes da
        % NAN e as vezes atende a duas condicoes
        ti = get_up+3600;
        tf = work_time-1800;
        if  ti > tf
            if sleep_time>return_home
                horario(x)=random('Uniform',return_home+1800,sleep_time-1800);
            else
                horario(x)=random('Uniform',return_home+1800,86400*j);
            end
        else
            horario(x)=random('Uniform',get_up+3600,work_time-1800);
        end
    end
end 