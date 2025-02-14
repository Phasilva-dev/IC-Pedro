function [horario]= sorteio_hor_chuveiro(time,j,freq,duracao,dom)

 get_up          =  time.get_up(j);
 work_time       =  time.work_time(j);
 sleep_time      =  time.sleep_time(j); 
 return_home     =  time.return_home(j);
 horario         = zeros(1,freq);

 
 if freq == 0
   horario=[];
else

    for f=1:freq
        hora_chuv=86400*j;
        while (hora_chuv+duracao(f))>=((j)*86400)
        p_hf =random('Uniform',0,1);
    %     if pessoa==3 || pessoa == 5
    %            domicilio(m).morador(p).chuveiro.horario(f)=random('Uniform',get_up+1800,sleep_time-1800);
             if work_time-get_up<3600
                if p_hf<((work_time-get_up)/(work_time-get_up+3600))
                       horario(f)=random('Uniform',get_up,work_time);
                elseif (((work_time-get_up)/(work_time-get_up+3600))<=p_hf) && (p_hf<(work_time-get_up+1800)/(work_time-get_up+3600))
                       horario(f)=random('Uniform',return_home,return_home+1800);
                else
                        horario(f)=random('Uniform',sleep_time-1800,sleep_time);
                end    
             else
                if p_hf<0.15
                       horario(f)=random('Uniform',get_up,get_up+1800);
                elseif (0.15<=p_hf)&& (p_hf<0.3)
                       horario(f)=random('Uniform',work_time-1800,work_time-duracao(f));
                elseif (0.4<=p_hf)&& (p_hf<0.9)
                    if return_home>((18*3600)+((j-1)*86400))
                        horario(f)=random('Uniform',return_home,return_home+1800);
                    else
                        horario(f)=random('Uniform',return_home,sleep_time-1800);
                    end
                else
                    horario(f)=random('Uniform',sleep_time-1800,sleep_time);
                end
             end
           for a=1:length(dom.chuveiro)
                for b=1:length(dom.chuveiro(a).horario(j).dia)
                    if horario(f)>=seconds(dom.chuveiro(a).horario(j).dia(b)) &&  horario(f)<=(seconds(dom.chuveiro(a).horario(j).dia(b)+seconds(dom.chuveiro(a).duracao(j).dia(b))))
                        
                        horario(f) = seconds(dom.chuveiro(a).horario(j).dia(b)+dom.chuveiro(a).duracao(j).dia(b));
                    end
                end
            
             hora_chuv=horario(f);
           end
     end    
  end
 

end 
