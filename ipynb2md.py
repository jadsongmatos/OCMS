from pathlib import Path
import nbformat
from nbconvert import MarkdownExporter

# Caminho do arquivo notebook
notebook_path = Path("display7d.ipynb")

# Carregar notebook
with open(notebook_path, "r", encoding="utf-8") as f:
    notebook = nbformat.read(f, as_version=4)

# Converter notebook para Markdown
exporter = MarkdownExporter()
markdown_body, resources = exporter.from_notebook_node(notebook)

# Salvar como arquivo .md
markdown_path = notebook_path.with_suffix(".md")
with open(markdown_path, "w", encoding="utf-8") as f:
    f.write(markdown_body)

print(markdown_path.name)
