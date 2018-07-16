function varargout = GAInteger_2(varargin)
% GAINTEGER_2 MATLAB code for GAInteger_2.fig
%      GAINTEGER_2, by itself, creates a new GAINTEGER_2 or raises the existing
%      singleton*.
%
%      H = GAINTEGER_2 returns the handle to a new GAINTEGER_2 or the handle to
%      the existing singleton*.
%
%      GAINTEGER_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAINTEGER_2.M with the given input arguments.
%
%      GAINTEGER_2('Property','Value',...) creates a new GAINTEGER_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GAInteger_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GAInteger_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GAInteger_2

% Last Modified by GUIDE v2.5 25-Mar-2017 13:56:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GAInteger_2_OpeningFcn, ...
                   'gui_OutputFcn',  @GAInteger_2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GAInteger_2 is made visible.
function GAInteger_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GAInteger_2 (see VARARGIN)

% Choose default command line output for GAInteger_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GAInteger_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GAInteger_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
initialize_gui(hObject, handles, false);


function initialize_gui(fig_handle, handles, isreset)

handles.metricdata.edtTotalExecucoesPorTxMutacao   = 25;
handles.metricdata.edtResultadoRmsepConstantes     = 30;
handles.metricdata.edtTxMutacaoInicial             = 10;
handles.metricdata.edtTxMutacaoFinal               = 0;
handles.metricdata.edtTaxaDecrementoMutacao        = 0.5;
handles.metricdata.edtQtdIndividuos                = 100;
handles.metricdata.edtQtdCaracteristicasIni        = 100;
handles.metricdata.edtQtdCaracteristicasFim        = 10;
handles.metricdata.edtQtdCaracteristicasDecremento = 10;

%Criar a variavel que irá armazenar os resultados geral da predicao:
%txMutacao, Maior erro, Menor Erro, Média Erro
handles.metricdata.resultadosPredicaoGeral         = [];

handles.metricdata.resultados = [];

set(handles.edtResultadoRmsepConstantes,            'String', handles.metricdata.edtTotalExecucoesPorTxMutacao);
set(handles.edtResultadoRmsepConstantes,            'String', handles.metricdata.edtResultadoRmsepConstantes);
set(handles.edtTxMutacaoInicial,                    'String', handles.metricdata.edtTxMutacaoInicial);
set(handles.edtTxMutacaoFinal,                      'String', handles.metricdata.edtTxMutacaoFinal);
set(handles.edtTaxaDecrementoMutacao,               'String', handles.metricdata.edtTaxaDecrementoMutacao);
set(handles.edtQtdIndividuos,                       'String', handles.metricdata.edtQtdIndividuos);
set(handles.edtQtdCaracteristicasIni,               'String', handles.metricdata.edtQtdCaracteristicasIni);
set(handles.edtQtdCaracteristicasFim,               'String', handles.metricdata.edtQtdCaracteristicasFim);
set(handles.edtQtdCaracteristicasDecremento,        'String', handles.metricdata.edtQtdCaracteristicasDecremento);

% Update handles structure
guidata(handles.figure1, handles);


% -------- Função para plotar o gráfico do erro residual --------- %
function [y,yhat,spe, RMSEP,SEP,BIAS,r] = plotarGraficoErroResidual(Xcal,ycal,Xval,yval,var_sel)
    if size(Xval,1) > 0 % Validation with a separate set
        y = yval;
    else % Cross-validation
        y = ycal;
    end

    [yhat,e] = validation(Xcal,ycal,Xval,yval,var_sel);

    PRESS = e'*e;
    N = length(e);
    RMSEP = sqrt(PRESS/N);
    BIAS = mean(e);

    % Calcular o SEP
    somaerro = sum(e);
    SEP = sqrt((PRESS - ((somaerro*somaerro)/N))/(N-1));

    ec = e - BIAS; % Mean-centered error values
    SDV = sqrt(ec'*ec/(N - 1));
    yhat_as = (yhat - mean(yhat))/std(yhat); % Autoscaling
    y_as = (y - mean(y))/std(y); % Autoscaling
    r = (yhat_as'*y_as)/(N-1);
    % Statistical Prediction Errors
    spe = statistical_prediction_error(Xcal,ycal,Xval,yval,var_sel);

    % Plot of Predicted vs Reference values
 %   figure, hold on, grid
%    hold on;
%    errorbar(y,yhat,spe,'o')
%    plot(y,yhat,'o')
%    % plot(y,yhat,'o')
%    xlabel('Reference y value'),ylabel('Predicted y value')
%    h = gca; XLim = get(h,'XLim');Xlim = get(h,'Xlim');
%    h = line(XLim,Xlim);
%    % Linha sem o SEP
%    %title(['PRESS = ' num2str(PRESS) ', RMSEP = ' num2str(RMSEP) ', SDV = ' num2str(SDV) ', BIAS = ' num2str(BIAS) ', r = ' num2str(r)])
%    % Padrao Shoot-Out
%    title(['RMSEP = ' num2str(RMSEP) ', SEP = ' num2str(SEP) ', BIAS = ' num2str(BIAS) ', r^2 = ' num2str(r)])

     
  
       



% --------------------------------------------------------------------
function arquivo_Callback(hObject, eventdata, handles)
% hObject    handle to arquivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function carregar_dados_Callback(hObject, eventdata, handles)
% hObject    handle to carregar_dados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
        {'*.m;*.fig;*.mat;*.slx;*.mdl',...
         'MATLAB Files (*.m,*.fig,*.mat,*.slx,*.mdl)';
           '*.m',  'Code files (*.m)'; ...
           '*.fig','Figures (*.fig)'; ...
           '*.mat','MAT-files (*.mat)'; ...
           '*.mdl;*.slx','Models (*.slx, *.mdl)'; ...
           '*.*',  'All Files (*.*)'}, ...
           'Pick a file');
fullpathname = strcat(pathname, filename); 
set(handles.lblPath, 'String', fullpathname);


% --- Executes on button press in btnExecTreinamento.
function btnExecTreinamento_Callback(hObject, eventdata, handles)
% hObject    handle to btnExecTreinamento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
qtdGeracoesEstaveis             = handles.metricdata.edtResultadoRmsepConstantes; 
qtdExecucoesPorMutacao          = handles.metricdata.edtTotalExecucoesPorTxMutacao;
mutacaoIni                      = handles.metricdata.edtTxMutacaoInicial; 
mutacaoFim                      = handles.metricdata.edtTxMutacaoFinal;
taxaDecremento                  = handles.metricdata.edtTaxaDecrementoMutacao;
qtdIndividuos                   = handles.metricdata.edtQtdIndividuos; 
qtdCaracteristicasIni           = handles.metricdata.edtQtdCaracteristicasIni;
qtdCaracteristicasFim           = handles.metricdata.edtQtdCaracteristicasFim;
qtdCaracteristicasDecremento    = handles.metricdata.edtQtdCaracteristicasDecremento;
arquivoDados                    = get(handles.lblPath,'String');

result = principalInteger(arquivoDados, qtdExecucoesPorMutacao, qtdGeracoesEstaveis, mutacaoIni, mutacaoFim, taxaDecremento, qtdIndividuos, qtdCaracteristicasIni, qtdCaracteristicasFim, qtdCaracteristicasDecremento);

handles.resultadoExec = result;
guidata(hObject, handles);

% Apresentar os resultados
%resultado = handles.resultadoExec;
data = result(:,1:4);
set(handles.tblResultados, 'Data', data);

% 
% melhorErro = result(:, 5);
% populacao  = result(:, 6);
% 
% data = get(handles.tblResultados, 'data');
% %data(end+1,:) = 0;
% data = {result};
% set(handles.tblResultados, 'Data', data);


% --- Executes on button press in btnResetarParametros.
function btnResetarParametros_Callback(hObject, eventdata, handles)
% hObject    handle to btnResetarParametros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x = get(handles.tblPredicaoMaiorMenor, 'data');

olhaEu = 10;

initialize_gui(gcbf, handles, true);


% Descobrir o linha selecionada na tabela
function CallBack(hObj,evt)
    disp(evt);



% --- Executes when selected cell(s) is changed in tblResultados.
function tblResultados_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tblResultados (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
    if(~isempty(eventdata.Indices))
        currow = eventdata.Indices(1);
        curcol = eventdata.Indices(2);
        
        resultado = handles.resultadoExec;
        
        data = resultado(currow, 6); %Plotando Gráfico do erro
        data = data{1, 1};
        plot(data);
        
        % Gráfico do Erro
        axes(handles.graficoErro); 
        plot (data); 
        title('RMSEP vs Amount of Generations'); 
        xlabel('Amount of Generations'); 
        ylabel('RMSEP'); 
        guidata(hObject, handles);
        
                
        data = resultado(currow, 5); %Pegando a população
        data = data{1, 1};
        set(handles.tblPopulacao, 'Data', data);
        
        % Aqui agora vou percorrer todos os indivíduos finais e ir calculando a
        % predição para eles
        %Carregando os dados
        arquivoDados             = get(handles.lblPath,'String');
        load(arquivoDados); 
        
        [linhas, colunas] = size(data);
        i = 1; iSeq = 1; resultadoPredicao = [];
        while i <= linhas 
            individuoPredicao = data(i,:);
            
            [PRESS,RMSEP,SDV,BIAS,r] = validation_metrics_GA_Integer(Xcal, Ycal, Xval, Yval, individuoPredicao);
            %resultadoPredicao(i, 1) = {individuoPredicao};
            if RMSEP < 0.0016
                resultadoPredicao(iSeq, 1) = i;
                resultadoPredicao(iSeq, 2) = RMSEP;
                resultadoPredicao(iSeq, 3) = PRESS;
                resultadoPredicao(iSeq, 4) = SDV;
                resultadoPredicao(iSeq, 5) = BIAS;
                resultadoPredicao(iSeq, 6) = r;
                
                iSeq = iSeq + 1;
            end
            
            i = i + 1;
        end;
        set(handles.uitable7, 'Data', resultadoPredicao);
        handles.uitable7.ColumnName = {'Subject','RMSEP','PRESS','SDV','Bias','r²'};

        
        %Gravar no handles a tabela: resultadoPredicao para ser utilizado
        %para geração do gráfico
        filename = strcat('mediasParaGrafico.mat');
        save(filename, 'resultadoPredicao');
        %handles.metricdata.resultadosDaPredicao = resultadoPredicao; 
        %guidata(hObject,handles);
        
        
        %if resultadoPredicao ~= []
            mediasPredicao = mean(resultadoPredicao);
            set(handles.tblMediaResultadosPredicao, 'Data', mediasPredicao); 

            RMSEP = resultadoPredicao(:,2);
            maior = max(RMSEP);
            menor = min(RMSEP);
            media = mean(RMSEP);

            maiorMenorMedia(1,1) = maior;
            maiorMenorMedia(1,2) = menor;
            maiorMenorMedia(1,3) = media;
       % end;
      %  set(handles.tblPredicaoMaiorMenor, 'Data', maiorMenorMedia); 
        
        %maior_menor(1, :) = 
        
        %tblPredicaoMaiorMenor
        
        %Estou criando a variável "resultadoSelecionado" para ser utilizada
        %no cálculo da predição. Sendo que, informará qual foi o resultado
        %na tabela de resultados selecionada.     
        handles.metricdata.resultadoSelecionado = currow; 
        guidata(hObject,handles);  
        
%         adata=get(handles.tblResultados,'Data');
%         if adata{currow,curcol} == 'V'
%           adata{currow,curcol} = '';
%         else 
%            adata{currow,curcol} = 'V';
%         end
% 
%         set(hObject,'Data',adata);
    end


% --- Executes on key press with focus on tblResultados and none of its controls.
function tblResultados_KeyPressFcn(hObject, eventdata, handles) 
    % parece que não esá funcionando
    if(~isempty(eventdata.Indices))
        currow = eventdata.Indices(1);
        curcol = eventdata.Indices(2);
        
        resultado = handles.resultadoExec;
             
        data = resultado(currow, 4); %Pegando a população
        data = data{1, 1}
        set(handles.tblPopulacao, 'Data', data);
        
        data = resultado(currow, 5); %Plotando Gráfico
        data = data{1, 1}
        handles.graficoErro.plot(data);
    %    plot(data);
    end






% ----- AQUI VOU COLOCAR PARA RECEBER OS DADOS DOS EDITS ------- %

function edtTotalExecucoesPorTxMutacao_Callback(hObject, eventdata, handles)
    edtTotalExecucoesPorTxMutacao = str2double(get(hObject, 'String'));
    if isnan(edtTotalExecucoesPorTxMutacao)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtTotalExecucoesPorTxMutacao = edtTotalExecucoesPorTxMutacao;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edtTotalExecucoesPorTxMutacao_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edtResultadoRmsepConstantes_Callback(hObject, eventdata, handles)
    edtResultadoRmsepConstantes = str2double(get(hObject, 'String'));
    if isnan(edtResultadoRmsepConstantes)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtResultadoRmsepConstantes = edtResultadoRmsepConstantes;
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edtResultadoRmsepConstantes_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edtTxMutacaoInicial_Callback(hObject, eventdata, handles)
    edtTxMutacaoInicial = str2double(get(hObject, 'String'));
    if isnan(edtTxMutacaoInicial)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtTxMutacaoInicial = edtTxMutacaoInicial;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtTxMutacaoInicial_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edtTxMutacaoFinal_Callback(hObject, eventdata, handles)
    edtTxMutacaoFinal = str2double(get(hObject, 'String'));
    if isnan(edtTxMutacaoFinal)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtTxMutacaoFinal = edtTxMutacaoFinal;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtTxMutacaoFinal_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edtTaxaDecrementoMutacao_Callback(hObject, eventdata, handles)
    edtTaxaDecrementoMutacao = str2double(get(hObject, 'String'));
    if isnan(edtTaxaDecrementoMutacao)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtTaxaDecrementoMutacao = edtTaxaDecrementoMutacao;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtTaxaDecrementoMutacao_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edtQtdIndividuos_Callback(hObject, eventdata, handles)
    edtQtdIndividuos = str2double(get(hObject, 'String'));
    if isnan(edtQtdIndividuos)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtQtdIndividuos = edtQtdIndividuos;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtQtdIndividuos_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edtQtdCaracteristicasIni_Callback(hObject, eventdata, handles)
    edtQtdCaracteristicasIni = str2double(get(hObject, 'String'));
    if isnan(edtQtdCaracteristicasIni)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtQtdCaracteristicasIni = edtQtdCaracteristicasIni;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtQtdCaracteristicasIni_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function edtQtdCaracteristicasFim_Callback(hObject, eventdata, handles)
    edtQtdCaracteristicasFim = str2double(get(hObject, 'String'));
    if isnan(edtQtdCaracteristicasFim)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtQtdCaracteristicasFim = edtQtdCaracteristicasFim;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtQtdCaracteristicasFim_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edtQtdCaracteristicasDecremento_Callback(hObject, eventdata, handles)
    edtQtdCaracteristicasDecremento = str2double(get(hObject, 'String'));
    if isnan(edtQtdCaracteristicasDecremento)
        set(hObject, 'String', 0);
        errordlg('Input must be a number','Error');
    end

    % Save the new volume value
    handles.metricdata.edtQtdCaracteristicasDecremento = edtQtdCaracteristicasDecremento;
    guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtQtdCaracteristicasDecremento_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    



% --- Executes on button press in btnCalcularPredicao.
function btnCalcularPredicao_Callback(hObject, eventdata, handles)
    % hObject    handle to btnCalcularPredicao (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    resultadoSelecionado = handles.metricdata.resultadoSelecionado;
    individuoPredicao    = handles.metricdata.individuoSelecionado;     
    
    resultado = handles.resultadoExec; 
        
    data = resultado(resultadoSelecionado, 5); %Pegando a população
    data = data{1, 1}  
    individuo = data(individuoPredicao, :);
    
    %Carregando os dados
    arquivoDados             = get(handles.lblPath,'String');
    load(arquivoDados);    
    
    %b = ( Xcal(:, individuo) ) \ Ycal;
    %Ypredito = Xpred(:, individuo) * b;
    %Calculo do erro predito pelo 
    %erroPredicao = sumsqr(Ypredito - Ypred)/ size(Ypred, 1); 
    
    [PRESS,RMSEP, SEP, SDV,BIAS,r] = validation_metrics(Xcal, Ycal, Xval, Yval, individuo)
    
    %Essa minha função copia o validation_metrics e exclui o grafico
    %[PRESS,RMSEP,SDV,BIAS,r] = validation_metrics_GA_Integer(Xcal, Ycal, Xpred, Ypred, individuo)
    %resultadoPredicao(1, 1) = PRESS;
   %resultadoPredicao(1, 2) = RMSEP;
   %resultadoPredicao(1, 3) = SDV;
   %resultadoPredicao(1, 4) = BIAS;
   resultadoPredicao(1, 5) = r;
   

% --- Executes when selected cell(s) is changed in tblPopulacao.
function tblPopulacao_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tblPopulacao (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
    if(~isempty(eventdata.Indices))
        currow = eventdata.Indices(1);
        
        %Estou criando a variável "individuoSelecionado", para ser utilizado no cálculo da predição.
        %É o cromossomo do indivíduo que irá selecionar as variáveis na predição.
        handles.metricdata.individuoSelecionado = currow;   
        guidata(hObject,handles);                     
        
        resultadoSelecionado = handles.metricdata.resultadoSelecionado;
        individuoPredicao    = handles.metricdata.individuoSelecionado;     

        resultado = handles.resultadoExec; 

        data = resultado(resultadoSelecionado, 5); %Pegando a população
        data = data{1, 1};
        individuo = data(individuoPredicao, :);

        %Carregando os dados
        arquivoDados             = get(handles.lblPath,'String');
        load(arquivoDados);
        
        [y,yhat,spe, RMSEP,SEP,BIAS,r] = plotarGraficoErroResidual(Xcal, Ycal, Xval, Yval, individuo);
       
        % Gráfico do Erro
        axes(handles.graficoErroResidual); 
        cla reset;
        errorbar(y,yhat,spe,'o');  hold on;
        grid        
        plot(y,yhat,'o'); 
        title(['RMSEP = ' num2str(RMSEP) ', SEP = ' num2str(SEP) ', BIAS = ' num2str(BIAS) ', r^2 = ' num2str(r)])
        %title('RMSEP vs Amount of Generations');
        xlabel('Reference y value'),ylabel('Predicted y value');
        h = gca; XLim = get(h,'XLim');Xlim = get(h,'Xlim');
        h = line(XLim,Xlim);
        
        guidata(hObject, handles);
    end;


% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when uipanel3 is resized.
function uipanel3_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function qtdCaracteristicasFim_Callback(hObject, eventdata, handles)
% hObject    handle to qtdCaracteristicasFim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qtdCaracteristicasFim as text
%        str2double(get(hObject,'String')) returns contents of qtdCaracteristicasFim as a double
edtQtdCaracteristicasFim = str2double(get(hObject, 'String'));
if isnan(edtQtdCaracteristicasFim)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end


% --------------------------------------------------------------------
function carregar_resultados_obtidos_Callback(hObject, eventdata, handles)
    [filename, pathname] = uigetfile( ...
        {'*.mat',...
         'MATLAB Files (*.m,*.fig,*.mat,*.slx,*.mdl)';
           '*.m',  'Code files (*.m)'; ...
           '*.fig','Figures (*.fig)'; ...
           '*.mat','MAT-files (*.mat)'; ...
           '*.mdl;*.slx','Models (*.slx, *.mdl)'; ...
           '*.*',  'All Files (*.*)'}, ...
           'Pick a file');
    fullpathname = strcat(pathname, filename); 
    load(fullpathname);
    
    % Pegar os resulatdos parciais 
    resultados = resultadosPorTotalFeatures; 
    
    result = resultados;

    handles.resultadoExec = result;
    guidata(hObject, handles);

    % Apresentar os resultados
    data = result(:,1:4);
    set(handles.tblResultados, 'Data', data); % Não preciso dar o set
    handles.tblResultados.ColumnName = {'Features Selected','Mutation Rate','Amount of Generations','Min Error'};

    %Limpar a grid Resultados por Configuração
    maiorMenorMedia = [];
    set(handles.tblPredicaoMaiorMenor, 'Data', maiorMenorMedia);



% --- Executes on button press in btnMediasResultados.
function btnMediasResultados_Callback(hObject, eventdata, handles)  
    dados = handles.resultadoExec;
    arquivoDados = get(handles.lblPath,'String');
    load(arquivoDados); 
    
    maiorMenorMedia = [];
    set(handles.tblPredicaoMaiorMenor, 'Data', maiorMenorMedia);
    
    [linhas, colunas] = size(dados);
    
    i = 1; iSeq = 1; iBest = 1;
    while i <= linhas
        taxaMutacao = dados(i,2);
        
        populacao = dados(i,5);
        populacao = populacao{1, 1};
        
        [linhasIndividuos, colunasIndividuos] = size(populacao);
        j = 1; 
        resultadoPredicao = [];
        while j <= linhasIndividuos
            individuoPredicao = populacao(j,:);
            
            [PRESS,RMSEP,SDV,BIAS,r] = validation_metrics_GA_Integer(Xcal, Ycal, Xval, Yval, individuoPredicao);
            
            resultadoPredicao(j, 1) = i;
            resultadoPredicao(j, 2) = j;
            resultadoPredicao(j, 3) = RMSEP;
            resultadoPredicao(j, 4) = PRESS;
            resultadoPredicao(j, 5) = SDV;
            resultadoPredicao(j, 6) = BIAS;
            resultadoPredicao(j, 7) = r;
            
            j = j+1;
        end
        [M,I] = min(resultadoPredicao);
        
        bestPrediction(iBest, :) = resultadoPredicao(I(1,3),:);
        
        if i < linhas
            nextMutation = dados(i+1,2);
            if taxaMutacao{1,1} ~= nextMutation{1,1}
                RMSEP = bestPrediction(:,3);
                maior = max(RMSEP);
                menor = min(RMSEP);
                media = mean(RMSEP);

                maiorMenorMedia(iSeq,1) = taxaMutacao{1,1};
                maiorMenorMedia(iSeq,2) = maior;
                maiorMenorMedia(iSeq,3) = menor;
                maiorMenorMedia(iSeq,4) = media;

                iSeq = iSeq + 1;
                iBest = 0;
                bestPrediction = [];
            end
        else  
            RMSEP = bestPrediction(:,3);
            maior = max(RMSEP);
            menor = min(RMSEP);
            media = mean(RMSEP);

            maiorMenorMedia(iSeq,1) = taxaMutacao{1,1};
            maiorMenorMedia(iSeq,2) = maior;
            maiorMenorMedia(iSeq,3) = menor;
            maiorMenorMedia(iSeq,4) = media;

            iSeq = iSeq + 1;
            iBest = 0;
            bestPrediction = [];   
        end
            
        iBest = iBest + 1;        
        i = i + 1;
    end
        
    set(handles.tblPredicaoMaiorMenor, 'Data', maiorMenorMedia); 
        
    
    


% --- Executes on button press in btnGraficoMedias.
function btnGraficoMedias_Callback(hObject, eventdata, handles)
    resultadosPredicao = get(handles.tblPredicaoMaiorMenor, 'data');
    [linhas, colunas] = size(resultadosPredicao);
    
    
    plot(resultadosPredicao(:, 1), resultadosPredicao(:, 2:4));
 %   for i = 1 : linhas
        
  %  end
    %plot(resultadosPredicao(:, 1), resultadosPredicao(:, 2:4), 'ko', Colors = [RGB::Orange, RGB::Yellow, RGB::Magenta]))
    
    hold on;
    
figure, hold on, grid
hold on;
%errorbar(y,yhat,spe,'o')
%plot(y,yhat,'o')
% plot(y,yhat,'o')
plot(resultadosPredicao(:, 1), resultadosPredicao(:, 2:4)); hold on;
plot(resultadosPredicao(:, 1), resultadosPredicao(:, 2:4), 'o');
xlabel('Mutation Taxa'),ylabel('Prediction Error')
%h = gca; XLim = get(h,'XLim');Xlim = get(h,'Xlim');
%h = line(XLim,Xlim);
title('Prediction Error per Mutation Taxa');
%title(['PRESS = ' num2str(PRESS) ', RMSEP = ' num2str(RMSEP) ', SDV = ' num2str(SDV) ', BIAS = ' num2str(BIAS) ', r = ' num2str(r)])


    
    
    
    %plot(matriz(:, 1), matriz(:, 4), 'ko')
    

%dadosPredicao    = handles.metricdata.resultadosDaPredicao;


        
        
% Plot of Predicted vs Reference values
%figure, hold on, grid
%hold on;
%errorbar(y,yhat,spe,'o')
%plot(y,yhat,'o')
% plot(y,yhat,'o')
%xlabel('Mutation Taxa'),ylabel('Prediction Error')
%h = gca; XLim = get(h,'XLim');Xlim = get(h,'Xlim');
%h = line(XLim,Xlim);
%title(['PRESS = ' num2str(PRESS) ', RMSEP = ' num2str(RMSEP) ', SDV = ' num2str(SDV) ', BIAS = ' num2str(BIAS) ', r = ' num2str(r)])


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)    
    dados = handles.resultadoExec;
    arquivoDados = get(handles.lblPath,'String');
    load(arquivoDados); 
    
    maiorMenorMedia = [];
    set(handles.tblPredicaoMaiorMenor, 'Data', maiorMenorMedia);
    
    [linhas, colunas] = size(dados);
    
    i = 1; iSeq = 1; iBest = 1;
    while i <= linhas
        taxaMutacao = dados(i,2);
        
        if taxaMutacao{1,1} == 8  
            populacao = dados(i,5);
            populacao = populacao{1, 1};
        
            [linhasIndividuos, colunasIndividuos] = size(populacao);
            j = 1; 
            resultadoPredicao = [];
            while j <= linhasIndividuos
                individuoPredicao = populacao(j,:);

                [PRESS,RMSEP, SEP, SDV,BIAS,r] = validation_metrics_GA_Integer(Xcal, Ycal, Xval, Yval, individuoPredicao);

                resultadoPredicao(j, 1) = i;
                resultadoPredicao(j, 2) = j;
                resultadoPredicao(j, 3) = RMSEP;
                resultadoPredicao(j, 4) = PRESS;
                resultadoPredicao(j, 5) = SDV;
                resultadoPredicao(j, 6) = BIAS;
                resultadoPredicao(j, 7) = r;
                resultadoPredicao(j, 8) = SEP;
                

                j = j+1;
            end
            
            [menorRMSEP, individuo] = min(resultadoPredicao(:,3));
            melhorPorGeracao(iSeq, 1) = resultadoPredicao(individuo,3); % RMSEP           
            melhorPorGeracao(iSeq, 2) = resultadoPredicao(individuo,8); % SEP
            melhorPorGeracao(iSeq, 3) = resultadoPredicao(individuo,6); % Bias
            melhorPorGeracao(iSeq, 4) = resultadoPredicao(individuo,7); % r            
            melhorPorGeracao(iSeq, 5) = dados{i,3}; % qtdGeracoes
            
            iSeq = iSeq+1;
        end
        i = i + 1;
    end
    
    okoko = [10,20,12,17,16];
    dp = desvioPadrao(okoko);
        
    desvioPadraoRMSEP = desvioPadrao(melhorPorGeracao(:,1)');    
    desvioPadraoSEP = desvioPadrao(melhorPorGeracao(:,2)');
    desvioPadraoBias = desvioPadrao(melhorPorGeracao(:,3)');
    desvioPadraoR = desvioPadrao(melhorPorGeracao(:,4)');
        
    set(handles.tblPredicaoMaiorMenor, 'Data', maiorMenorMedia); 
    
    
    
        
