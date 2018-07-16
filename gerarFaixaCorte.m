function [faixaCorteIni, faixaCorteFim] = gerarFaixaCorte(qtdFeatures)
    
    faixaCorte = sort(randi(qtdFeatures, 2, 1)');
    faixaCorteIni = faixaCorte(1,1);
    faixaCorteFim = faixaCorte(1,2);

    if faixaCorteIni == faixaCorteFim 
        gerarFaixaCorte(qtdFeatures);
    end
end