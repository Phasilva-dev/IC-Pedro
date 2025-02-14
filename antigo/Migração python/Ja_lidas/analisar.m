    nome          = 'Teste aleatorio casas.mat';
    load(nome);
    analises       = ' Teste de criacao de arquivo';
    tipo_chuveiro = Dados.tipo_chuveiro;
    tipo_bacia    = Dados.tipo_bacia;
    dias          = Dados.dias;
    Ndoms         = Dados.doms;

    N     = 24 * 60 * 60; 
    Q     = zeros(dias,N);
                 
    Nh    = 24;
    
    for m=1:Ndoms
        [Q] = simul(Dados(m),dias,Q);
   
        
        
    end

     
    %% Plotar no formato horas

% domicilio a ser plotado

%vazao = [];





%{ 
%Plotar para todos
dt       = 1: (dias*N);

t = seconds(dt);

%
 plot (t,vazao,'DurationTickFormat','hh:mm');
% Formato hora
%xtickformat('hh')
% Rotulo eixo y
ylabel({'Q (L/s)'});

% Rotulo eixo x
xlabel({'HORA'});

% Titulo  
title({'C1:  500  domicilios'});
%}
%Plotar para todos

dt       = 1: (N);

t = seconds(dt);

%{
for i=2:5
    m(i)=mean(Qd(i,:));
    
    s(i)=(sum(Qd(i,:))-sum(Qd(i-1,:)))*100;
   
    
end

%}
txt = ' domicilios com aparelhos eficientes' ;
%TIRAR DEPOIS ABAIXO AS CHAVES E %

for i = 1:dias
    figure
    plot (t,Q(i,:),'DurationTickFormat','hh:mm');
    m = mean(Q(i,:));
        % Formato hora
    %xtickformat('hh')
    % Rotulo eixo y
    ylabel({'Q (L/s)'});

    % Rotulo eixo x
    xlabel({'HORA'});
    titulo = strcat(num2str(Ndoms),txt,num2str(i));
    % Titulo  
    title({titulo});

    end
    


%{
Q = Dom(1).Q;
Qt = sum(Q);

txt = 'C1:  500  domicilios  -  Dia --> ';
for i = 1:dias
    figure
    plot (t,Qt,'DurationTickFormat','hh:mm');
    m = mean(Qd(i,:));
    % Formato hora
    %xtickformat('hh')
    % Rotulo eixo y
    ylabel({'Q (L/s)'});

    % Rotulo eixo x
    xlabel({'HORA'});
    titulo = strcat(txt,num2str(i),'m�dia --> ',num2str(m) );
    % Titulo  
    title({titulo});

end

%}