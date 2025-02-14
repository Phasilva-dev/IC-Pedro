function [horario]= sorteio_hor_lavatorio(time,j,freq,duracao,dom)
%o uso do lavatorio deve acontecer 
 get_up          =  time.get_up(j);
 work_time       =  time.work_time(j);
 sleep_time      =  time.sleep_time(j); 
 return_home     =  time.return_home(j);
 horario         = zeros(1,freq);

 if freq == 0
   horario=[];
 else
   
    for f=1:freq
        hora=86400*j; 
        while (hora+duracao(f))>86400*j
        ph_pia=random('Uniform',0,1);
        %para os casos em que a diferenca do horario em que o usuario
        %acorda e levanta eh inferior ao horario de pico da manha (30min
        %depois de acordar e 30min antes de sair)
          if work_time-get_up<3600
            if ph_pia<((work_time-get_up-duracao(f))/(work_time-get_up+3600))
                horario(f)=random('Uniform',get_up,work_time);
            elseif (((work_time-get_up)/(work_time-get_up+3600))<=ph_pia) && (ph_pia<(work_time-get_up+1800)/(work_time-get_up+3600))
                horario(f)=random('Uniform',return_home,return_home+1800);
            else
                if sleep_time<1800
                    p=random('Uniform',0,1);
                    if p<(sleep_time/1800)
                        horario(f)=random('Uniform',0,sleep_time);
                    else
                        horario(f)=random('Uniform',86400-1800+sleep_time,86400);
                    end
                else
                    horario(f)=random('Uniform',sleep_time-1800,sleep_time);
                end
            end
          else
              if ph_pia<0.15
                  horario(f)=random('Uniform',get_up,get_up+1800);
              elseif ph_pia>=0.15 && ph_pia<.35
                  horario(f)=random('Uniform',work_time-1800, work_time);
              elseif ph_pia>=.35 && ph_pia<0.75
                  horario(f)=random('Uniform',return_home,return_home+1800);
              else 
                  if sleep_time<1800
                    p=random('Uniform',0,1);
                    if p<(sleep_time/1800)
                        horario(f)=random('Uniform',0,sleep_time);
                    else
                        horario(f)=random('Uniform',86400-1800+sleep_time,86400);
                    end
                  else
                    horario(f)=random('Uniform',sleep_time-1800,sleep_time);
                  end
              end
          end
                  
              
         hora=horario(f);           
        end
    for a=1:length(dom.lavatorio)
        for b=1:length(dom.lavatorio(a).horario(j).dia)
            if horario(f)>=seconds(dom.lavatorio(a).horario(j).dia(b)) &&  horario(f)<=(seconds(dom.lavatorio(a).horario(j).dia(b))+seconds(dom.lavatorio(a).duracao(j).dia(b)))
               horario(f) = seconds(dom.lavatorio(a).horario(j).dia(b)+dom.lavatorio(a).duracao(j).dia(b));
            end
        end
    end
   end
 end
end