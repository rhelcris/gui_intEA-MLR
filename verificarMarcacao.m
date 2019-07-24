function achou = verificarMarcacao(valor, vetor)
    %Função que verifica se o valor que deseja incluir já se encontra no
    %vetor
    achou = 0;
    i = 1;
    while i < length(vetor)
        if vetor(1,i) == valor
            achou = 1;
            break;
        end;
        i = i + 1;
    end
end