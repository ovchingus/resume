#!/usr/bin/env bash

docker build -t latex-resume:latest .

# Create a copy of resume.tex for English version
cp resume.tex resume_en.tex

# Create a copy of resume.tex for Russian version
cp resume.tex resume_ru.tex

# Set language flag to false for English version
sed -i '' 's/\\russiantrue/%\\russiantrue/' resume_en.tex

# Set language flag to true for Russian version  
sed -i '' 's/% \\russiantrue/\\russiantrue/' resume_ru.tex

# Generate English PDF
docker run --rm -v "$(pwd)":/workspace -w /workspace latex-resume:latest pdflatex -jobname=vladimir_ovechkin_resume_en resume_en.tex

# Generate Russian PDF
docker run --rm -v "$(pwd)":/workspace -w /workspace latex-resume:latest pdflatex -jobname=vladimir_ovechkin_resume_ru resume_ru.tex

# Generate image for English version with ImageMagick
docker run --rm -v "$(pwd)":/workspace -w /workspace latex-resume:latest convert -density 300 -quality 100 -flatten -sharpen 0x0.5 -background white -alpha remove -alpha off vladimir_ovechkin_resume_en.pdf vladimir_ovechkin_resume_en.png

# Clean up temporary files
rm resume_en.tex resume_ru.tex
