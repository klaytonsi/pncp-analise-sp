-- consulta
SELECT
    COUNT(*) AS total_registros,
    COUNT(valor_homologado) AS homologados_preenchidos,
    COUNT(*) - COUNT(valor_homologado) AS homologados_ausentes
FROM contratacoes;

-- consulta_participacao
SELECT
    municipio,
    COUNT(*) AS quantidade,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM contratacoes),
        2
    ) AS percentual_total
FROM contratacoes
GROUP BY municipio
ORDER BY quantidade DESC, municipio ASC
LIMIT 10;

-- consulta_situacoes
SELECT
    situacao,
    COUNT(*) AS quantidade,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM contratacoes),
        2
    ) AS percentual
FROM contratacoes
GROUP BY situacao
ORDER BY quantidade DESC, situacao ASC;

-- consulta_ausencia
SELECT
    situacao,
    COUNT(*) AS total,
    COUNT(*) - COUNT(valor_homologado) AS sem_valor,
    ROUND(
        100.0 * (COUNT(*) - COUNT(valor_homologado))
        / COUNT(*),
        2
    ) AS percentual_ausente
FROM contratacoes
GROUP BY situacao
ORDER BY percentual_ausente DESC, situacao ASC;

-- consulta_publicacoes
SELECT
    SUBSTR(data_publicacao, 1, 10) AS dia,
    COUNT(*) AS quantidade
FROM contratacoes
GROUP BY SUBSTR(data_publicacao, 1, 10)
ORDER BY dia;

-- Resumo das estimativas positivas: não representa pagamentos.
SELECT COUNT(*) AS quantidade, MIN(valor_estimado) AS minimo,
       AVG(valor_estimado) AS media, MAX(valor_estimado) AS maximo,
       SUM(valor_estimado) AS soma
FROM contratacoes WHERE valor_estimado > 0;
