FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-recommends apt-utils 2>&1

# Verify git and needed tools are installed
RUN apt-get install --no-install-recommends -y git procps && \
    apt-get -y install --no-install-recommends \
    texlive-latex-base \
    texlive-extra-utils \
    texlive-latex-extra \
    biber chktex latexmk make python3-pygments python3-pkg-resources \
    texlive-lang-cyrillic \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-font-utils \
    cm-super

# latexindent modules
RUN apt-get install --no-install-recommends -y curl
RUN curl -L http://cpanmin.us | perl - App::cpanminus && \
    cpanm Log::Dispatch::File && \
    cpanm YAML::Tiny && \
    cpanm File::HomeDir && \
    cpanm Unicode::GCString

# Install ImageMagick for PDF to image conversion
RUN apt-get update && apt-get install -y --no-install-recommends \
    imagemagick \
    ghostscript

# Clean up
RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8
