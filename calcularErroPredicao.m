function e = calcularErroPredicao( populacaoCandidata, Xcal, Xval, Ycal, Yval )

    for i = 1 : size(populacaoCandidata,1)
        cromossomo = populacaoCandidata(i,:);
        variaveis = find(cromossomo);

        % Regressao  --- b é o coeficiente de regressao
        b = ( Xcal(:, variaveis) ) \ Ycal;
        Ypredito = Xval(:, variaveis) * b;

        % Calculo do erro predito pelo 
        erro(i) = sumsqr(Ypredito - Yval)/ size(Yval, 1);    
    end;
    
    e = erro;
end
