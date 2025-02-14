function [Dados] = normaliza_dom(Dados)

Ndias       = Dados.dias;
Npess       = size(Dados.pessoas,2);
d = duration(24,0,0,'Format','dd:hh:mm:ss');
for i = 1:Npess
    for j = 1:Ndias
        % chuveiro
        Dados.chuveiro(i).duracao(j).dia = Dados.chuveiro(i).duracao(1).dia;
        Dados.chuveiro(i).vazao(j).dia   = Dados.chuveiro(i).vazao(1).dia;
        Dados.chuveiro(i).horario(j).dia = Dados.chuveiro(i).horario(1).dia + (j-1)*d;
        
        % lavatorio
        Dados.lavatorio(i).duracao(j).dia = Dados.lavatorio(i).duracao(1).dia;
        Dados.lavatorio(i).vazao(j).dia   = Dados.lavatorio(i).vazao(1).dia;
        Dados.lavatorio(i).horario(j).dia = Dados.lavatorio(i).horario(1).dia + (j-1)*d;
        
        % bacia
        Dados.bacia(i).duracao(j).dia = Dados.bacia(i).duracao(1).dia;
        Dados.bacia(i).vazao(j).dia   = Dados.bacia(i).vazao(1).dia;
        Dados.bacia(i).horario(j).dia = Dados.bacia(i).horario(1).dia + (j-1)*d; 
        
        % morador
        Dados.morador(i).chuveiro(j).frequencia  = Dados.morador(i).chuveiro(1).frequencia;
        Dados.morador(i).lavatorio(j).frequencia = Dados.morador(i).lavatorio(1).frequencia;
        Dados.morador(i).bacia(j).frequencia     = Dados.morador(i).bacia(1).frequencia;
        
    end 
    

end


for i = 1:Ndias
    
   % pia_cozinha
   Dados.pia_cozinha(i).duracao    = Dados.pia_cozinha(1).duracao;
   Dados.pia_cozinha(i).vazao      = Dados.pia_cozinha(1).vazao;
   Dados.pia_cozinha(i).horario    = Dados.pia_cozinha(1).horario + (i-1)*d;   
   Dados.pia_cozinha(i).frequencia = Dados.pia_cozinha(1).frequencia;  
        
  % maquina
  Dados.maquina(i).duracao    = Dados.maquina(1).duracao;
  Dados.maquina(i).vazao      = Dados.maquina(1).vazao;
  Dados.maquina(i).horario    = Dados.maquina(1).horario + (i-1)*d;   
  Dados.maquina(i).frequencia = Dados.maquina(1).frequencia;  

  % tanque
  Dados.tanque(i).duracao    = Dados.tanque(1).duracao;
  Dados.tanque(i).vazao      = Dados.tanque(1).vazao;
  Dados.tanque(i).horario    = Dados.tanque(1).horario + (i-1)*d;   
  Dados.tanque(i).frequencia = Dados.tanque(1).frequencia;          


end