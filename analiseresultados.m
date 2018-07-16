    maiorMenorMedia = [];
    [linhas, colunas] = size(resultados);
    
    i = 1; iSeq = 1; iBest = 1;
    while i <= linhas
        taxaMutacao = resultados(i,2);
        
        populacao = resultados(i,5);
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
            nextMutation = resultados(i+1,2);
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
%    figure;
%maior
plot(maiorMenorMedia(:, 1), maiorMenorMedia(:, 2),'k-*','LineWidth',1,'MarkerSize',6);  hold on;
%grid
  %plot(maiorMenorMedia(:, 1), maiorMenorMedia(:, 2:4)); hold on;
%menor
plot(maiorMenorMedia(:, 1), maiorMenorMedia(:, 3), 'k-o','LineWidth',1,'MarkerSize',6); hold on;
plot(maiorMenorMedia(:, 1), maiorMenorMedia(:, 4),'-d','LineWidth',1,'MarkerSize',6); hold on;
xlabel('Taxa de Mutação'),ylabel('RMSEP')
%h = gca; XLim = get(h,'XLim');Xlim = get(h,'Xlim');
%h = line(XLim,Xlim);
title('RMSEP por Taxa de Mutação');
%title(['PRESS = ' num2str(PRESS) ', RMSEP = ' num2str(RMSEP) ', SDV = ' num2str(SDV) ', BIAS = ' num2str(BIAS) ', r = ' num2str(r)])
