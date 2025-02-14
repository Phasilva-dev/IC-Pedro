function [pessoa, Idade_moradores] = sorteia_pessoas(N)

   Idade_moradores = abs(floor(random('Weibull',35.8311,1.58364,[1 N])));
   % N eh numero de moradores 
   pessoa = zeros(1,N);
   for i = 1: N
        %Idade_morador        = ceil(idade(pd_normal_idade));
        
        if Idade_moradores(i) < 18
                prob=random('Uniform',0,1);
                if Idade_moradores(i)<=14
                    if prob < 0.5                    
                        pessoa(i) = 2;
                    else
                        pessoa(i) = 4;
                    end
                else
                    if prob < 0.45                    
                        pessoa(i) = 2;
                    elseif prob <0.9
                        pessoa(i) = 4;
                    else
                        pessoa(i)= 5;
                    end
                end
                
        elseif Idade_moradores(i) >= 65            
                pessoa(i) = 3;
        
        else
                prob=random('Uniform',0,1);
                if prob < 0.9
                    pessoa(i) = 1;
                else
                    pessoa(i) = 5;
                end
         end
   end