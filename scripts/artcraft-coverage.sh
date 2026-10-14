#!/usr/bin/env bash
# Executa os testes do workspace Rust do ArtCraft e gera o relatório HTML de
# cobertura com cargo-llvm-cov (instrumentação de cobertura nativa do LLVM).
# Requisitos: git, Rust estável (rustup), componente llvm-tools-preview e
# cargo-llvm-cov (https://github.com/taiki-e/cargo-llvm-cov).
set -euo pipefail

REPO=https://github.com/storytold/artcraft
COMMIT=d4e4ac69bbd93d237eaf5d0260bc6a5ff3a5e373
WORK=${WORK:-$PWD/work}
OUT=${OUT:-$PWD/out/artcraft}

mkdir -p "$WORK" "$OUT"
[ -d "$WORK/artcraft" ] || git clone "$REPO" "$WORK/artcraft"
cd "$WORK/artcraft"
git checkout --quiet "$COMMIT"

rustup component add llvm-tools-preview

# A cobertura do LLVM não depende de debuginfo; desligá-la reduz bastante o
# tamanho de target/.
export CARGO_PROFILE_DEV_DEBUG=0 CARGO_INCREMENTAL=0

# Usa o cache de consultas .sqlx/ do repositório (conforme _docs/dev_setup.md)
# em vez de exigir um banco SQLite na compilação.
export SQLX_OFFLINE=true

# boring-sys2 (BoringSSL) gera bindings com bindgen/libclang. Sem os headers
# internos do clang (pacote libclang-common-*-dev), o stddef.h não é
# encontrado; os headers equivalentes do GCC resolvem.
if [ -z "${BINDGEN_EXTRA_CLANG_ARGS:-}" ]; then
  GCC_INCLUDE=$(dirname "$(gcc -print-file-name=include/stddef.h)")
  export BINDGEN_EXTRA_CLANG_ARGS="-I$GCC_INCLUDE"
fi

# Os aplicativos desktop (Tauri e egui) exigem bibliotecas de GUI do sistema
# (webkit2gtk/GTK) e não fazem parte da lógica testável em modo headless.
EXCLUDE=(--exclude artcraft --exclude tauri-plugin-http --exclude artcraft_native)

# --no-fail-fast: executa todos os crates mesmo se algum teste falhar.
cargo llvm-cov --workspace "${EXCLUDE[@]}" --no-fail-fast --no-report 2>&1 | tee "$OUT/test-run.log"
cargo llvm-cov report --html --output-dir "$OUT/coverage"
cargo llvm-cov report --json --summary-only --output-path "$OUT/coverage-summary.json"
cargo llvm-cov report | tee "$OUT/coverage-text.txt"
