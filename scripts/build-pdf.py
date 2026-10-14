#!/usr/bin/env python3
"""Converte um relatório Markdown em PDF usando o Chrome/Chromium em modo headless.

Uso: python3 scripts/build-pdf.py rea/relatorio.md rea/rea-relatorio-cobertura.pdf
Requisitos: markdown-it-py e google-chrome (ou chromium) no PATH.
"""
import shutil
import subprocess
import sys
import tempfile
from html import escape
from pathlib import Path

from markdown_it import MarkdownIt

CSS = """
@page { size: A4; margin: 18mm 16mm; }
body { font-family: "DejaVu Sans", Arial, sans-serif; font-size: 10.5pt;
       line-height: 1.45; color: #1a1a1a; }
h1 { font-size: 18pt; border-bottom: 2px solid #333; padding-bottom: 4px; }
h2 { font-size: 13.5pt; margin-top: 18px; border-bottom: 1px solid #bbb; }
h3 { font-size: 11.5pt; }
table { border-collapse: collapse; width: 100%; margin: 8px 0; font-size: 9.5pt;
        page-break-inside: avoid; }
th, td { border: 1px solid #999; padding: 3px 6px; text-align: left; }
th { background: #e8e8e8; }
td:not(:first-child) { white-space: nowrap; }
code { font-family: "DejaVu Sans Mono", monospace; font-size: 9pt;
       background: #f2f2f2; padding: 0 2px; }
pre { background: #f2f2f2; padding: 8px; font-size: 8.5pt; white-space: pre-wrap; }
pre code { background: none; }
"""


def main(src: str, dst: str) -> None:
    text = Path(src).read_text(encoding="utf-8")
    title = next((line[2:].strip() for line in text.splitlines() if line.startswith("# ")), Path(src).stem)
    body = MarkdownIt("commonmark").enable("table").render(text)
    html = f'<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><title>{escape(title)}</title><style>{CSS}</style></head><body>{body}</body></html>'

    chrome = shutil.which("google-chrome") or shutil.which("chromium")
    if chrome is None:
        sys.exit("google-chrome/chromium não encontrado no PATH")

    with tempfile.TemporaryDirectory() as tmp:
        page = Path(tmp) / "relatorio.html"
        page.write_text(html, encoding="utf-8")
        subprocess.run(
            [chrome, "--headless", "--disable-gpu", "--no-pdf-header-footer",
             f"--user-data-dir={tmp}/profile",
             f"--print-to-pdf={Path(dst).resolve()}", page.as_uri()],
            check=True, stderr=subprocess.DEVNULL,
        )


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2])
