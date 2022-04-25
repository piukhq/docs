# API Documentation

This project contains Open API Specification documents for Bink APIs. 
The project also uses the redoc-cli tool to convert YAML files to HTML. 

YAML files named as 'deploy-\*.yaml' will be automatically converted to reader-friendly HTML and served at the docs.\*.gb.bink.com URL.

e.g., The corresponding HTML document for deploy-dev.yaml can be viewed at: docs.dev.gb.bink.com

## Public Files:
[deploy-dev.md](deploy-dev.yaml)
[deploy-sandbox.md](deploy-sandbox.yaml)
[deploy-staging.md](deploy-staging.yaml)
[pandoc/CHANGELOG.md](pandoc/CHANGELOG.md)
[pandoc/appendix.md](pandoc/appendix.md)


## Local Usage

### Rendering Markdown files locally with pandoc

- Firstly, install pandoc with `brew install pandoc`
- Then, output a HTML file with `pandoc appendix.md -c style.css --self-contained -o appendix.html`
- Finally, open the file with `open appendix.html`
