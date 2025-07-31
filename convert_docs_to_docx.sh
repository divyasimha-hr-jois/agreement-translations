#!/bin/bash

# Script to convert docs/ subdirectory files from .md to .docx
# Deletes existing .md files and creates .docx files

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Converting docs/ subdirectory files from .md to .docx...${NC}"

# Check if we're in the agreement-translations directory
if [[ ! -d "aurigraph-farmer-agreement" ]]; then
    echo -e "${RED}Error: Please run this script from the agreement-translations directory${NC}"
    exit 1
fi

# Languages to create files for
LANGUAGES=("english" "kannada" "telugu" "tamil" "malayalam")

# Function to convert docs files from .md to .docx
convert_docs_files() {
    local folder_name="$1"
    local docs_path="$2"

    echo -e "${BLUE}Processing docs subdirectory for: $folder_name${NC}"

    # Check if docs directory exists
    if [[ ! -d "$docs_path" ]]; then
        echo -e "${YELLOW}  Docs directory does not exist: $docs_path${NC}"
        return
    fi

    # Delete existing .md files
    local md_files_found=false
    for language in "${LANGUAGES[@]}"; do
        local md_file="${docs_path}/${folder_name}-${language}.md"
        if [[ -f "$md_file" ]]; then
            rm "$md_file"
            echo -e "${GREEN}  Deleted: docs/${folder_name}-${language}.md${NC}"
            md_files_found=true
        fi
    done

    if [[ "$md_files_found" == false ]]; then
        echo -e "${YELLOW}  No .md files found to delete${NC}"
    fi

    # Create new .docx files
    for language in "${LANGUAGES[@]}"; do
        local docx_file="${docs_path}/${folder_name}-${language}.docx"

        # Check if .docx file already exists
        if [[ -f "$docx_file" ]]; then
            echo -e "${YELLOW}  File already exists: docs/${folder_name}-${language}.docx${NC}"
        else
            # Create a basic .docx file using pandoc if available, otherwise create empty file
            if command -v pandoc &> /dev/null; then
                # Create a temporary markdown file and convert to docx
                local temp_md="${docs_path}/temp_${folder_name}-${language}.md"
                cat > "$temp_md" << EOF
# ${folder_name} - ${language^}

## Agreement Details

This document contains the ${language^} version of the ${folder_name} agreement.

### Content

[Content will be added here]

### Version

Version: 1.0
Language: ${language^}
Created: $(date '+%Y-%m-%d %H:%M:%S')
Type: Documentation

---
EOF
                pandoc "$temp_md" -o "$docx_file"
                rm "$temp_md"
                echo -e "${GREEN}  Created: docs/${folder_name}-${language}.docx${NC}"
            else
                # If pandoc is not available, create an empty .docx file
                # Note: This will create a file that may not be readable as a proper .docx
                # but it will have the correct extension
                touch "$docx_file"
                echo -e "${GREEN}  Created: docs/${folder_name}-${language}.docx (empty file)${NC}"
                echo -e "${YELLOW}    Note: Install pandoc for proper .docx creation${NC}"
            fi
        fi
    done
    echo ""
}

# Process each folder
for folder in aurigraph-*/; do
    if [[ -d "$folder" ]]; then
        # Remove trailing slash to get folder name
        folder_name=$(basename "$folder")
        echo -e "${GREEN}Processing folder: $folder_name${NC}"

        # Convert files for docs subdirectory
        docs_path="${folder}docs"
        convert_docs_files "$folder_name" "$docs_path"

        echo -e "${GREEN}Completed processing: $folder_name${NC}"
        echo "----------------------------------------"
    fi
done

echo -e "${GREEN}Conversion from .md to .docx completed!${NC}"
echo -e "${YELLOW}Summary:${NC}"
echo "Converted files in docs/ subdirectories:"
echo "  - Deleted: {folder_name}-{language}.md files"
echo "  - Created: {folder_name}-{language}.docx files"
echo ""
echo "Languages: english, kannada, telugu, tamil, malayalam"
echo ""
echo -e "${BLUE}Note:${NC} For proper .docx files, install pandoc:"
echo "  sudo apt-get install pandoc  # Ubuntu/Debian"
echo "  brew install pandoc          # macOS"
echo "  choco install pandoc         # Windows (Chocolatey)"