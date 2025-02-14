function [vazao] = simul(domicilio,dias,vazao)

    N = domicilio.nmoradores; % Numero de moradores no domicilio
    Q = vazao;
    for i=1:N
        for j=1:dias
            
            [Q] = totaliza(domicilio.chuveiro(i),j,Q);

            [Q] = totaliza(domicilio.lavatorio(i),j,Q);

            [Q] = totaliza(domicilio.bacia(i),j,Q);
          
                    

        end
    end 
    for j=1:dias
         [Q] = totaliza2(domicilio.tanque(j),j,Q);
         [Q] = totaliza2(domicilio.pia_cozinha(j),j,Q);
         [Q] = totaliza2(domicilio.maquina(j),j,Q); 
    end
     
    vazao = Q;
end

