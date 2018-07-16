% Tipos de Crossover: 
%   1 - Crossover Multipontos;
%   2 - Crossover Permuta��o - Ordem
%   3 - Crossover Permuta��o - Posi��o
function [result,bestError] = gerarNovaPopulacaoInteiro( erro, populacao, taxaMutacao, qtdIndividuos, qtdFeaturesSelected, maxColuna, tipoCrossover )
    [linhas, colunas] = size(populacao);     
    taxaMutacao = taxaMutacao;  
    qtdMelhoresIndividuosMantidos = 10;
   
    bestError = 0;
    for i = 1 : qtdMelhoresIndividuosMantidos %Telma: N�o seria mais ordenar a popula��o pelo erro e pegar os 10 primeiros?
        [val, pos] = min(erro);
        if(bestError == 0)
            bestError = val;
        end
        erro(pos) = val + 100;    
        novaPopulacao(i,:) = sort(populacao(pos, :));  %Telma: por que ordena de novo? J� n�o est� ordenado na cria��o dos indiv�duos?
    end; 
    
    candidatosTorneio = randi(qtdIndividuos, 2, qtdIndividuos)';
          
    i = 1;
    iMax = qtdIndividuos - qtdMelhoresIndividuosMantidos;
    while i <= iMax
        
        %Ser�o feitos 2 torneios 1 com os 10 melhores indiv�duos que est�o
        %armazenados na novaPopula��o
        pos1 = candidatosTorneio(i,1);
        pos2 = candidatosTorneio(i,2);

        erroCandidato1 = erro(1, pos1);
        erroCandidato2 = erro(1, pos2);

        if erroCandidato1 <= erroCandidato2
            pai1 = populacao(pos1, :);
           % bestError = erroCandidato1;
        elseif erroCandidato1 > erroCandidato2
            pai1 = populacao(pos2, :);   
           % bestError = erroCandidato2;
        end
             
        erroCandidato1 = erro(1, candidatosTorneio(i+1,1));
        erroCandidato2 = erro(1, candidatosTorneio(i+1,2));
             
        if erroCandidato1 <= erroCandidato2
            pai2 = populacao(candidatosTorneio(i+1,1), :);
            %if erroCandidato1 < bestError
             %   bestError = erroCandidato1;
            %end
        elseif erroCandidato1 > erroCandidato2
            pai2 = populacao(candidatosTorneio(i+1,2), :);    
           % if erroCandidato2 < bestError
           %     bestError = erroCandidato2; 
           % end
        end
               
        %Executar o crossover
        filho1 = executarCrossoverOrdem(pai1, pai2);
        filho2 = executarCrossoverOrdem(pai2, pai1);

        % Verificar se o indiv�duo gerado pelo processo de crossover � v�lido.
        individuo = sort(filho1);             
        filho1 = validarIndividuo(individuo, qtdFeaturesSelected, maxColuna, pai1, pai2);
        individuo = sort(filho2);
        filho2 = validarIndividuo(individuo, qtdFeaturesSelected, maxColuna, pai2, pai1);
 
        vetorMutacao = randi(100, qtdFeaturesSelected, 1)';
        for x = 1 : qtdFeaturesSelected
            if vetorMutacao(1,x) <= taxaMutacao
                filho1(1,x) = round(randperm(maxColuna,1));
            end
        end
        
        %Muta��o no PAI 2
        vetorMutacao = randi(100, qtdFeaturesSelected, 1)';
        for x = 1 : qtdFeaturesSelected
            if vetorMutacao(1,x) <= taxaMutacao
                filho2(1,x) = round(randperm(maxColuna,1));
            end
        end

        % Verificar se o indiv�duo gerado ap�s o processo de muta��o � v�lido.
        individuo = sort(filho1);             
        filho1 = validarIndividuo(individuo, qtdFeaturesSelected, maxColuna, pai1, pai2);
        individuo = sort(filho2);
        filho2 = validarIndividuo(individuo, qtdFeaturesSelected, maxColuna, pai2, pai1);

        novaPopulacao(i+qtdMelhoresIndividuosMantidos, :)   = sort(filho1(1, :));
        novaPopulacao(i+1+qtdMelhoresIndividuosMantidos, :) = sort(filho2(1, :));

        i = i+2;          
         
    end
    result = novaPopulacao;
end

