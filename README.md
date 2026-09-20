# PNCP — Pregões eletrônicos em São Paulo

Projeto de portfólio de **Klayton Silva**, desenvolvido para praticar coleta de dados, qualidade, SQL e análise exploratória.

## Recorte e perguntas
Publicações de **01 a 07/08/2026**, unidades de órgãos em **SP**, modalidade **Pregão Eletrônico**. Como os registros se distribuem por município, situação e dia? Qual é o preenchimento dos campos monetários e como se distribuem as estimativas positivas?

## Resultados
- **1.660 registros**, provenientes de 166 páginas; nenhum identificador ausente ou repetido.
- São Paulo reúne **374 registros (22,53%)**, seguido por Campinas (42) e Bauru (38).
- **1.588 registros (95,66%)** estavam como “Divulgada no PNCP” na coleta.
- O maior volume diário ocorreu em **05/08: 360 registros**.
- **942 valores homologados ausentes** e **283 estimativas iguais a zero**, preservados sem imputação.

Entre as 1.377 estimativas positivas, a mediana foi **R$ 249.200,00** e a média, **R$ 2.677.235,61**. A maior estimativa foi **R$ 1.114.547.331,60**, equivalente a **30,23%** da soma de **R$ 3.686.553.437,90**.

A diferença entre média e mediana e a participação do maior registro mostram a influência de valores altos. Isso não comprova erro: seria necessário verificar o objeto e o documento de origem antes de classificar um registro como incorreto. A soma descreve estimativas registradas; não é despesa executada, pagamento nem compromisso de gasto.

## Ferramentas
Python, requests (coleta original), Pandas, SQLite, SQL, Plotly e Google Colab. Não há serviço pago necessário para executar o projeto.

## Arquivos
| Arquivo | Uso |
|---|---|
| [pncp_analise_sp_final.ipynb](pncp_analise_sp_final.ipynb) | Notebook organizado, com saídas recalculadas |
| [pncp_sp.sqlite](pncp_sp.sqlite) | Banco com a tabela contratacoes |
| [consultas.sql](consultas.sql) | Consultas usadas na análise |
| [historico_coleta.ipynb](historico_coleta.ipynb) | Código original de aprendizagem, executado em etapas |
| [requirements.txt](requirements.txt) | Dependências da análise local |

## Executar no Colab
1. Abra o Colab e faça upload de `pncp_analise_sp_final.ipynb`.
2. Execute as células na ordem. Na primeira célula, envie `pncp_sp.sqlite` quando solicitado.
3. Confira as tabelas, os dois gráficos e as conclusões. O notebook abre o banco apenas para leitura.

Para execução local, coloque o notebook e o banco na mesma pasta e instale as dependências de `requirements.txt` no seu ambiente Python/Jupyter. O notebook de análise não acessa a API.

## Coleta e preparação
Fonte: [documentação oficial da API de consulta do PNCP](https://pncp.gov.br/api/consulta/swagger-ui/index.html).
Endpoint usado: `/v1/contratacoes/publicacao`. Parâmetros: `dataInicial=20260801`, `dataFinal=20260807`, `uf=SP`, `codigoModalidadeContratacao=6`, `tamanhoPagina=10`, páginas 1–166.

A coleta foi feita em etapas com checkpoints; houve falhas temporárias e retomadas. As páginas foram reunidas com Pandas, os campos selecionados foram renomeados e salvos em SQLite. O histórico preserva esse processo, mas não é um script de coleta automatizado para execução única. A data exata de coleta não está registrada no banco. O backup JSON bruto ficou fora deste pacote por não ter sido enviado na revisão.

## Dicionário do banco
| Coluna | Significado |
|---|---|
| id_contratacao | Número de controle PNCP |
| orgao | Razão social do órgão ou entidade |
| municipio, uf | Localização da unidade do órgão |
| objeto | Descrição do objeto da contratação |
| modalidade | Modalidade registrada |
| situacao | Situação na coleta |
| data_publicacao | Data e hora de publicação no PNCP |
| valor_estimado | Estimativa em reais |
| valor_homologado | Valor homologado informado, podendo estar ausente |

## Decisões e limites
- IDs, datas, recorte, ausências, zeros e integridade do SQLite foram verificados.
- Municípios representam unidades de órgãos municipais, estaduais e federais; não necessariamente o local de entrega.
- O calendário inclui o dia sem registros. Esse zero de contagem difere de valor monetário ausente.
- Estatísticas monetárias consideram apenas estimativas positivas; os zeros continuam preservados no banco.
- Situação e valores refletem a coleta. **Estimado e homologado não são valores pagos.** Não calculamos economia.
- Uma semana não sustenta tendência de longo prazo. Paginação validada não garante snapshot imutável.
- Valores `REAL` são adequados para esta descrição, não para fechamento contábil exato.

## Aprendizados e melhorias
Prática de API paginada, recuperação de falhas, transformação com Pandas, agregações SQL, visualização e interpretação responsável. Melhorias futuras: coletor automatizado com checkpoints, data de extração registrada e recorte temporal ampliado.

## Verificação desta versão
As 11 células de código do notebook final foram executadas em sequência em Python/IPython sobre o banco fornecido, com duas saídas Plotly geradas e sem erros. As consultas do arquivo SQL também foram executadas. A integridade do banco retornou `ok` e seu hash permaneceu idêntico ao arquivo recebido. O notebook também foi executado por completo no Google Colab, com todas as células concluídas sem erros.
