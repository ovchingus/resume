#!/bin/bash

# Install inotify-tools if not already present
apt-get update && apt-get install -y inotify-tools

# Function to compile both resume versions
compile_resume() {
    echo "Changes detected, recompiling resumes..."

    # Create a copy of resume.tex for English version
    cp /workspace/resume.tex /workspace/resume_en.tex

    # Create a copy of resume.tex for Russian version
    cp /workspace/resume.tex /workspace/resume_ru.tex

    # Set language flag to false for English version
    sed -i 's/\\russiantrue/%\\russiantrue/' /workspace/resume_en.tex

    # Ensure language flag is true for Russian version
    sed -i 's/%\\russiantrue/\\russiantrue/' /workspace/resume_ru.tex

    # Run compilations in parallel
    pdflatex -jobname=vladimir_ovechkin_resume_en /workspace/resume_en.tex &
    pdflatex -jobname=vladimir_ovechkin_resume_ru /workspace/resume_ru.tex &
    
    # Wait for both processes to complete
    wait

    # Clean up temporary files
    rm /workspace/resume_en.tex /workspace/resume_ru.tex

    echo "Compilation complete."
}

# Initial compilation
compile_resume

# Watch for changes
echo "Watching for changes to resume.tex..."
while true; do
    inotifywait -e modify /workspace/resume.tex
    compile_resume
done
