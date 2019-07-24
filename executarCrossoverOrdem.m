function filho = executarCrossoverOrdem(pai1, pai2)
    [linhas, colunas] = size(pai1);
    filho = zeros(1,colunas);    
            
    [faixaCorteIni, faixaCorteFim] = gerarFaixaCorte(colunas);
    tamCorte = faixaCorteFim - faixaCorteIni;
    
    %Montar o filho 
    filho(1, faixaCorteIni: faixaCorteFim) = pai1(1, faixaCorteIni: faixaCorteFim);
        
    pos = faixaCorteFim + 1;
    posFilho = faixaCorteFim + 1;

    qtdPermutacoes = length(pai1) - tamCorte - 1;
    %for i = 1 : qtdPermutacoes
    i = 1;
    while i <= qtdPermutacoes
        if pos > length(pai1)
            pos = 1;
        end
        
        if posFilho > length(pai1)
            posFilho = 1;
        end
        
        valor = pai2(1,pos);
        marcado = verificarMarcacao(pai2(1,pos), filho);
        if marcado == 0         
            filho(1, posFilho) = pai2(1, pos);
            pos = pos + 1;           

            if posFilho >= length(pai1)
                posFilho = 1;
            else                
                posFilho = posFilho + 1;
            end
        else
            pos = pos + 1;
            qtdPermutacoes = qtdPermutacoes + 1;
        end   
        i = i+1;
    end
    filho = filho;
    
 %   filhoTeste = validarIndividuo(filho, qtdFeaturesSelected, maxColuna, pai1, pai2);

end