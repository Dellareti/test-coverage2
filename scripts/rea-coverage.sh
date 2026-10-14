#!/usr/bin/env bash
# Executa a suíte de testes do REA (TypeScript/Vitest) e gera o relatório HTML
# de cobertura (provider V8, reporter HTML do Istanbul).
# Requisitos: git, Node.js ^24.11 ou >=26 e npm.
set -euo pipefail

REPO=https://github.com/morluto/rea
COMMIT=41a2e846470bd2af40dd298d975b1a1d2fef5786
WORK=${WORK:-$PWD/work}
OUT=${OUT:-$PWD/out/rea}

mkdir -p "$WORK" "$OUT"
[ -d "$WORK/rea" ] || git clone "$REPO" "$WORK/rea"
cd "$WORK/rea"
git checkout --quiet "$COMMIT"

export HUSKY=0
npm ci --no-audit --no-fund

# reportOnFailure: gera o relatório mesmo que algum teste dependente do
# ambiente falhe (por padrão o Vitest descarta a cobertura nesse caso).
npm run test:coverage -- \
  --coverage.reportOnFailure=true \
  --coverage.reporter=html \
  --coverage.reporter=json-summary \
  --coverage.reporter=text-summary \
  --coverage.reportsDirectory="$OUT/coverage" 2>&1 | tee "$OUT/test-run.log"
