#!/bin/bash

# Script to organize markdown files into md/ subdirectories
# Moves .md files from parent directories to md/ subdirectories

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Organizing markdown files into md/ subdirectories...${NC}"

# Check if we're in the agreement-translations directory
if [[ ! -d "aurigraph-farmer-agreement" ]]; then
    echo -e "${RED}Error: Please run this script from the agreement-translations directory${NC}"
    exit 1
fi

# Languages to process
LANGUAGES=("english" "kannada" "telugu" "tamil" "malayalam")

# Function to organize md files for a folder
organize_md_files() {
    local folder_name="$1"
    local folder_path="$2"

    echo -e "${BLUE}Processing folder: $folder_name${NC}"

    # Create md directory if it doesn't exist
    local md_path="${folder_path}md"
    if [[ ! -d "$md_path" ]]; then
        mkdir -p "$md_path"
        echo -e "${GREEN}  Created md directory${NC}"
    fi

    # Move .md files from parent directory to md/ subdirectory
    local files_moved=0
    for language in "${LANGUAGES[@]}"; do
        local source_file="${folder_path}${folder_name}-${language}.md"
        local target_file="${md_path}/${folder_name}-${language}.md"

        if [[ -f "$source_file" ]]; then
            # Check if target file already exists
            if [[ -f "$target_file" ]]; then
                echo -e "${YELLOW}  File already exists in md/: ${folder_name}-${language}.md${NC}"
            else
                mv "$source_file" "$target_file"
                echo -e "${GREEN}  Moved: ${folder_name}-${language}.md to md/${NC}"
                ((files_moved++))
            fi
        else
            echo -e "${YELLOW}  Source file not found: ${folder_name}-${language}.md${NC}"
        fi
    done

    if [[ $files_moved -gt 0 ]]; then
        echo -e "${GREEN}  Total files moved: $files_moved${NC}"
    else
        echo -e "${YELLOW}  No files moved for this folder${NC}"
    fi
    echo ""
}

# Process each folder
for folder in aurigraph-*/; do
    if [[ -d "$folder" ]]; then
        # Remove trailing slash to get folder name
        folder_name=$(basename "$folder")

        # Organize md files for this folder
        organize_md_files "$folder_name" "$folder"

        echo -e "${GREEN}Completed processing: $folder_name${NC}"
        echo "----------------------------------------"
    fi
done

echo -e "${GREEN}Markdown file organization completed!${NC}"
echo -e "${YELLOW}Summary:${NC}"
echo "Moved .md files from parent directories to md/ subdirectories:"
echo "  - {folder_name}-english.md → md/{folder_name}-english.md"
echo "  - {folder_name}-kannada.md → md/{folder_name}-kannada.md"
echo "  - {folder_name}-telugu.md → md/{folder_name}-telugu.md"
echo "  - {folder_name}-tamil.md → md/{folder_name}-tamil.md"
echo "  - {folder_name}-malayalam.md → md/{folder_name}-malayalam.md"
echo ""
echo "Languages: english, kannada, telugu, tamil, malayalam"