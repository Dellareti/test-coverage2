# Cobertura de Testes

## Objetivo
Utilizar e explorar ferramentas de cobertura de testes em dois sistemas reais.

## Descrição

1. **Executar os testes de dois projetos populares**. Selecione **dois** projetos de código aberto populares no GitHub e aprenda a executar os seus testes. Dependendo do projeto selecionado, talvez seja necessário ler a documentação.
   
2. **Gerar relatório HTML de cobertura de testes**. Após executar os testes, gere o relatório HTML de cobertura de testes para o projeto selecionado. Note que a ferramenta de cobertura vai depender da linguagem de programação do projeto selecionado, por exemplo, [Coverage.py](https://coverage.readthedocs.io/) (Python), [JaCoCo](https://www.eclemma.org/jacoco) (Java), [Istanbul](https://istanbul.js.org/) (JavaScript), entre outras.

3. **Analisar cobertura de testes**. Discuta brevemente os resultados gerados no relatório de cobertura, por exemplo, se o projeto possui boa cobertura, os arquivos que possuem mais e menos cobertura, os códigos que não são cobertos por testes, etc.

## Submissão

Você deve submeter via Moodle quatro arquivos (dois para cada projeto)

- Projeto 1: Relatório de análise de cobertura do (formato PDF).
- Projeto 1: Relatório HTML gerado pela ferramenta de cobertura (formato ZIP).
- Projeto 2: Relatório de análise de cobertura do (formato PDF).
- Projeto 2: Relatório HTML gerado pela ferramenta de cobertura (formato ZIP).

## Entrega

| Projeto | Linguagem | Ferramenta de cobertura | Relatório de análise (PDF) | Relatório HTML (ZIP) |
|---------|-----------|-------------------------|----------------------------|----------------------|
| [REA](https://github.com/morluto/rea) | TypeScript | Vitest + V8 (formato Istanbul) | [`rea/rea-relatorio-cobertura.pdf`](rea/rea-relatorio-cobertura.pdf) | [`rea/rea-cobertura-html.zip`](rea/rea-cobertura-html.zip) |
| [ArtCraft](https://github.com/storytold/artcraft) | Rust | cargo-llvm-cov (LLVM source-based coverage) | [`artcraft/artcraft-relatorio-cobertura.pdf`](artcraft/artcraft-relatorio-cobertura.pdf) | [`artcraft/artcraft-cobertura-html.zip`](artcraft/artcraft-cobertura-html.zip) |

O texto de cada análise está em `rea/relatorio.md` e `artcraft/relatorio.md`.

### Reprodução

```bash
./scripts/rea-coverage.sh        # requer Node.js ^24.11 ou >=26
./scripts/artcraft-coverage.sh   # requer Rust estável + cargo-llvm-cov
python3 scripts/build-pdf.py rea/relatorio.md rea/rea-relatorio-cobertura.pdf
python3 scripts/build-pdf.py artcraft/relatorio.md artcraft/artcraft-relatorio-cobertura.pdf
```

Os scripts clonam cada projeto no commit analisado em `work/` e gravam os resultados em `out/`. Os dois diretórios são ignorados pelo Git.
