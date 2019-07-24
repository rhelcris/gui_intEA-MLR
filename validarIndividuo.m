function [individuoValido] = validarIndividuo(individuo, qtdFeaturesSelected, maxFeatures, pai1, pai2)
    % Essa função não será necessária pois na geração do indivíduo é
    % utilizada a função randperm que não deixa repetir os elementos
    changedFeature = 0;
    for i = 1 : qtdFeaturesSelected - 1
        if individuo(1,i) == individuo(1, i+1)
            individuo(1, i+1) = round(randperm(maxFeatures,1));   %Telma: acho que não precisa de round, randperm já retorna numeros inteiros         
            changedFeature = 1;
        end;        
    end;
    
    if changedFeature == 1 % Chamada Recursiva para validar se está realmente correto
        individuo = sort(individuo);
        individuo = validarIndividuo(individuo, qtdFeaturesSelected, maxFeatures);
    end
    
    individuoValido = individuo;
end