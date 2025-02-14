function [varout] = criar()


%VALORES DE ENTRADA{%}

    nome          = 'Teste aleatorio casas';
    analise       = ' Teste de criacao de arquivo';
    tipo_chuveiro = 2;
    tipo_bacia    = 1;
    dias          = 1;
    Ndoms         = 500;
%}%}
    %% Inicia a estrutura da variavel de dados
    Dados = inicia_variaveis(Ndoms,dias,analise,tipo_chuveiro,tipo_bacia);
%    assignin('base', 'dados1', Dados);
%    nome = strcat(nome,'.mat');   
%    save(nome,'Dados');
%    varout = Dados;
    
    for m=1:Ndoms
    
        % Inicial variavel auxiliar dom como o m-esimo domicilio 
        dom = Dados(m);
    
        % uso do chuveiro
        dom = uso_chuveiro(dom,tipo_chuveiro,dias);   
        % uso do lavatorio
        dom = uso_lavatorio(dom,dias);
        % uso da maquina de lavar
        dom = uso_maquina(dom,dias); 
        % uso do bacia sanitaria
        dom = uso_bacia(dom,tipo_bacia,dias); 
        % uso da pia
        dom = uso_pia(dom,dias);   
        % uso do tanque
        dom = uso_tanque(dom,dias);
        % consumo por domic�cio
        dom = consumo(dom,dias);
    
        % Atualiza caso rodado
        Dados(m) = dom;      
    end
    
    assignin('base', 'Dados', Dados);
    nome = strcat(nome,'.mat');   
    save(nome,'Dados');
    varout = Dados;

end



function varout = inicia_variaveis(Ndoms,Ndias,nome,tipo_chuveiro,tipo_bacia)

    % Sorteia o numero de pessoas por domicilio
    N_pessoas = ceil(abs(random('Gamma',4.09588,0.636582,[1 Ndoms])));
    for i = 1: Ndoms
 
        varout(i).nome           = nome;
        varout(i).doms           = Ndoms;
        varout(i).dias           = Ndias;
        varout(i).tipo_chuveiro  = tipo_chuveiro;
        varout(i).tipo_bacia     = tipo_bacia;
        varout(i).nmoradores     = 0;
        varout(i).nsanitarios    = 0;
        
        % Variaveis de domicilio
       % nmoradores                = ceil(domicilios(pd_dom_normal));
        nmoradores                = N_pessoas(i);
        nsanitarios               = sorteia_sanitario(nmoradores);
        [pessoas, idades]         = sorteia_pessoas(nmoradores);
    
        varout(i).nmoradores      = nmoradores;
        varout(i).pessoas         = pessoas;
        varout(i).idades          = idades;    
        varout(i).nsanitarios     = nsanitarios;
        varout(i).consumo         = 0;
        
        % Vari�veis de aparelhos
       
        for j = 1: nmoradores  
   

            for k = 1: Ndias

                
                % Variaveis de aparelhos
                varout(i).chuveiro(j).duracao(k).dia        = [];
                varout(i).chuveiro(j).vazao(k).dia          = [];
                varout(i).chuveiro(j).horario(k).dia        = [];
                varout(i).chuveiro(j).consumo(k).dia        = [];
       
                varout(i).lavatorio(j).duracao(k).dia       = [];
                varout(i).lavatorio(j).vazao(k).dia         = [];
                varout(i).lavatorio(j).horario(k).dia       = [];
                varout(i).lavatorio(j).consumo(k).dia       = [];

                varout(i).bacia(j).duracao(k).dia           =  [];
                varout(i).bacia(j).vazao(k).dia             =  [];         
                varout(i).bacia(j).horario(k).dia           =  [];
                varout(i).bacia(j).consumo(k).dia           =  [];
                 
                varout(i).pia_cozinha(k).duracao(k).dia      =  [];
                varout(i).pia_cozinha(k).vazao(k).dia        =  [];         
                varout(i).pia_cozinha(k).horario(k).dia      =  [];
                varout(i).pia_cozinha(k).consumo(k).dia      =  [];
   
                varout(i).maquina(k).duracao(k).dia          =  [];
                varout(i).maquina(k).vazao(k).dia            =  [];        
                varout(i).maquina(k).horario(k).dia          =  [];
                varout(i).maquina(k).consumo(k).dia          =  [];
 
 
                varout(i).tanque(k).duracao(k).dia           =  [];
                varout(i).tanque(k).vazao(k).dia             =  [];  
                varout(i).tanque(k).horario(k).dia           =  [];
                varout(i).tanque(k).consumo(k).dia           =  [];

              
                varout(i).morador(j).chuveiro.frequencia     = [];                
                varout(i).morador(j).lavatorio.frequencia    = [];                
                varout(i).morador(j).bacia.frequencia        = [];
                varout(i).morador(j).bacia.frequencia        = [];
                
                

                varout(i).pia_cozinha(k).vazao   =  [];
                varout(i).pia_cozinha(k).duracao =  [];
                varout(i).pia_cozinha(k).horario =  [];         
                            
        
                varout(i).maquina(k).vazao       =  [];
                varout(i).maquina(k).duracao     =  []; 
                varout(i).maquina(k).horario     =  [];         
                         

                varout(i).tanque(k).vazao        =  [];
                varout(i).tanque(k).duracao      =  [];
                varout(i).tanque(k).horario     =   [];         
                       
            end
            
        end
        
    end
    
end


function ok = valida_nome(nome)

    i=[32,48:57 ,65:90, 95, 97:122];
    valid = char(i);
        
    n = length(nome);
    if n > 0
        ok = 1;
        for i= 1: n
            ok = ok & contains(valid,nome(i));
        end
    else
        ok =0;
    end


end


