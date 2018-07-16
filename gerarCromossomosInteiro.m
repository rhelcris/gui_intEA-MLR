function [totalGeracoes, erroMin, populacaoFinal, graficoBestErro] = gerarCromossomos(arquivoDados, taxaMutacao, qtdGeracoesEstaveis, qtdIndividuos, qtdCaracteristicas )
    erro = [];
    totalGeracoesEstaveis = qtdGeracoesEstaveis;
    
    % Verificando se a quantidade indivíduos da população é maior que a
    % base de dados
    clc;
    load(arquivoDados);
    
    [qtdLinhasDB, qtdColunasDB] = size(Xcal);
        
    if qtdCaracteristicas > qtdColunasDB
       qtdCaracteristicas = qtdColunasDB; 
    end
        
    % ****** Dentro deste bloco de código irei criar a população inicial
    % ****** com números inteiros
    maxColuna = qtdColunasDB;
    qtdFeaturesSelected = qtdCaracteristicas;
    individuo = sort(round(randperm(maxColuna,qtdFeaturesSelected)));
    % A função randperm não deixa repetir os elementos
    % individuo = validarIndividuo(individuo, qtdFeaturesSelected, maxColuna);
    
    % Gerando a população inicial
    for i = 1 : qtdIndividuos % alteração 25/10/2016 - tirei o tamanho da população que era fixa em 100 para o informado nos parâmetros 
       populacaoInteira(i, :) = individuo(1,:); 
    
       % A função randperm não deixa repetir os elementos
       individuo = sort(round(randperm(maxColuna,qtdFeaturesSelected)));
       % A função randperm não deixa repetir os elementos
       %individuo = validarIndividuo(individuo, qtdFeaturesSelected, maxColuna);
    end 
    
    % Calculando o erro de predição para a população inicial    
    erro = calcularErroPredicaoInteiro(populacaoInteira, Xcal, Xpred, Ycal, Ypred);
    
    erros_matriz(1, :) = erro(1,:);
    
    contadorEstavel = 1;
    valorErroEstavel = 0;
       
    i = 1; %contador para montar a matriz de erros  
    %while contadorEstavel < totalGeracoesEstaveis % aqui eu coloco o
    %criterio de para para 30 erros constantes
    while i < 200
        minErro = min(erro)

        if minErro ~= valorErroEstavel
            valorErroEstavel = min(erro);
            contadorEstavel  = 0;
        end;
        [novaPopulacao, bestError(i)] = gerarNovaPopulacaoInteiro(erro, populacaoInteira, taxaMutacao, qtdIndividuos, qtdFeaturesSelected, maxColuna, 2 );
        erro = calcularErroPredicaoInteiro(novaPopulacao, Xcal, Xpred, Ycal, Ypred);    
        erros_matriz(i+1, :) = erro(1,:);
        populacaoInteira = novaPopulacao;
        i = i + 1;
        contadorEstavel = contadorEstavel + 1;
    end;
    
    plot(bestError)
    % menores erros de cada cruzamento
    linhas = i; % aqui eu coloquei para linhas receber i pois houve casos que 20 gerações estabilizaram antes de executar 100
    for i = 1 : linhas
        erroAtual = erros_matriz(i, :);
        for j = 1 : 5
            [val, pos] = min(erroAtual(1,:));
            erroAtual(pos) = val + 100;    
            erros_matriz_menores(i,j) = val;
        end
    end;

    totalGeracoes = i;
    erroMin = minErro;
    populacaoFinal = populacaoInteira;
    graficoBestErro = bestError;
    
    
end 





 