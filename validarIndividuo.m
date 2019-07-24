function [individuoValido] = validarIndividuo(individuo, qtdFeaturesSelected, maxFeatures, pai1, pai2)
    % Essa fun��o n�o ser� necess�ria pois na gera��o do indiv�duo �
    % utilizada a fun��o randperm que n�o deixa repetir os elementos
    changedFeature = 0;
    for i = 1 : qtdFeaturesSelected - 1
        if individuo(1,i) == individuo(1, i+1)
            individuo(1, i+1) = round(randperm(maxFeatures,1));   %Telma: acho que n�o precisa de round, randperm j� retorna numeros inteiros         
            changedFeature = 1;
        end;        
    end;
    
    if changedFeature == 1 % Chamada Recursiva para validar se est� realmente correto
        individuo = sort(individuo);
        individuo = validarIndividuo(individuo, qtdFeaturesSelected, maxFeatures);
    end
    
    individuoValido = individuo;
end