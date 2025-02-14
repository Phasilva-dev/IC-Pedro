function [horario]= sorteio_hor_bacia(time,j,freq_bacia,duracao,dom)

 get_up          =  time.get_up(j);
 work_time       =  time.work_time(j);
 sleep_time      =  time.sleep_time(j); 
 return_home     =  time.return_home(j);
 sleep_duration  =  time.sleep_duration(j);
 horario         = zeros(1,freq_bacia);
 
if freq_bacia == 0
   horario=[];
else
% Definicao dos horarios de uso da bacia sanitaria

    for x=1:freq_bacia
        hora=86400*j;
        while (duracao(x)+hora)>=86400*j
            n=random('Uniform',0,1);
    %     if pessoa==3 || pessoa == 5
    %             domicilio(m).morador(p).bacia(d).horario(x)=random('Uniform',get_up(d)+1800,sleep_time(d)-1800);
    %else
            if n<0.025
                horario(x)=random('Uniform',get_up-sleep_duration+86400,86400);
            elseif (0.025<=n) && (n<0.05)
                horario(x)=random('Uniform',0,get_up);

            elseif (0.05<=n) && (n<0.15)
                horario(x)=random('Uniform',get_up,get_up+1800);
            elseif (0.15<=n) && (n<0.20)
                horario(x)=random('Uniform',get_up+1800,work_time-1800);
            elseif (0.2<=n) && (n<0.325)
                horario(x)=random('Uniform',work_time-1800,work_time);
            elseif (0.325<=n) && (n<0.45)
                horario(x)=random('Uniform',return_home,return_home+1800);

            elseif (0.45<=n) && (n<0.55)
                horario(x)=random('Uniform',sleep_time-1800,sleep_time);

            else
                horario(x)=random('Uniform',return_home+1800,sleep_time-1800);
            end
           for a=1:length(dom.bacia)
                for b=1:length(dom.bacia(a).horario(j).dia)
                    if horario(x)>=seconds(dom.bacia(a).horario(j).dia(b)) &&  horario(x)<=(seconds(dom.bacia(a).horario(j).dia(b)+seconds(dom.bacia(a).duracao(j).dia(b))))
                        horario(x) = seconds(dom.bacia(a).horario(j).dia(b)+dom.bacia(a).duracao(j).dia(b));
                    end
                end
            end 
        hora=horario(x);
       end
    end        
end            
end 

