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
            horario(f)=0;
            while horario(f)==0 || (horario(f)>=work_time && horario(f)<=return_home)||(horario(f)>=work_time && horario(f)<=return_home 
        p_hf =random('Uniform',0,1);
              if p_hf*100<0.4
                       horario(f)=random('Uniform',0.1*j,3600*j);
              elseif p_hf*100<0.5
                       horario(f)=random('Uniform',3600*j,7200*j);
              elseif  p_hf*100<0.6
                        horario(f)=random('Uniform',7200*j,10800*j);
             
           for a=1:length(dom.chuveiro)
                for b=1:length(dom.chuveiro(a).horario(j).dia)
                    if horario(f)>=seconds(dom.chuveiro(a).horario(j).dia(b)) &&  horario(f)<=(seconds(dom.chuveiro(a).horario(j).dia(b)+seconds(dom.chuveiro(a).duracao(j).dia(b))))
                        horario(f) = seconds(dom.chuveiro(a).horario(j).dia(b)+dom.chuveiro(a).duracao(j).dia(b));
                    end
                end
            end
             hora_chuv=horario(f);
         end
     end    
  end
 

end 