function [resultados] = principal(arquivoDados, totalExecucoes, qtdGeracoesEstaveis, taxaMutacao, taxaMutacaoMin, taxaDecrementoMutacao, qtdIndividuos, qtdCaracteristicasIni, qtdCaracteristicasFim, qtdCaracteristicasDecremento)

taxaMutacaoInicial = taxaMutacao;
iSeq = 1;
while qtdCaracteristicasIni >= qtdCaracteristicasFim    
    j = 1; % Variavel para alimentar resultadosPorTotalFeatures
    resultadosPorTotalFeatures = {};
    
    while taxaMutacao >= taxaMutacaoMin
        resultados = {};
        i = 1; 
        
        for e = 1 : totalExecucoes        
            [totalGeracoes, erroMin, populacaoFinal, graficoBestErro] = gerarCromossomosInteiro(arquivoDados, taxaMutacao, qtdGeracoesEstaveis, qtdIndividuos, qtdCaracteristicasIni);
           
            %Popula��o final que gerou o erro m�nimo para posteriormente poder utilizar esta popula��o.        
            resultado(iSeq,1) = {qtdCaracteristicasIni};
            resultado(iSeq,2) = {taxaMutacao};
            resultado(iSeq,3) = {totalGeracoes};
            resultado(iSeq,4) = {erroMin};
            resultado(iSeq,5) = {populacaoFinal}; 
            resultado(iSeq,6) = {graficoBestErro};        
            resultado(iSeq,7) = {0};
            
            %Usando o resultados para gravar os resultados conforme a
            %Telma solicitou, 1 arquivo de dados para cada configuracao
            resultados(i,:) = resultado(iSeq, :)
            i = i+1;
            
            %ResultadosPorTotalDeCaracter�sticas
            resultadosPorTotalFeatures(j,:) = resultado(iSeq, :);
            j = j+1;            
            
            iSeq = iSeq + 1;       
        end;    
        
        % Grava os resultados pela qtd caracter�sticas e tx. muta��o
        %filename = strcat('Results', num2str(qtdCaracteristicasIni), 'FeaturesMutation', num2str(taxaMutacao), '.mat')
        %save(filename, 'resultados');
        taxaMutacao = taxaMutacao - taxaDecrementoMutacao;
    end;
    
    %Gravando todos os resultados antes de decrementar a quantidade de
    %caracter�sticas
    filename = strcat('AllResultsWith', num2str(qtdCaracteristicasIni), '.mat')
    save(filename, 'resultadosPorTotalFeatures');
    
    
    qtdCaracteristicasIni = qtdCaracteristicasIni - qtdCaracteristicasDecremento;
    taxaMutacao = taxaMutacaoInicial;
end;
    
resultados = resultado; 

filename = strcat('AllResults.mat');
save(filename, 'resultados');
