#!/bin/bash

# Script to create language files for each folder in agreement-translations
# Creates files with pattern: {folder_name}-{language}.md

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Creating language files for agreement translations...${NC}"

# Get the current directory
CURRENT_DIR=$(pwd)

# Check if we're in the agreement-translations directory
if [[ ! -d "aurigraph-farmer-agreement" ]]; then
    echo -e "${RED}Error: Please run this script from the agreement-translations directory${NC}"
    exit 1
fi

# Languages to create files for
LANGUAGES=("english" "kannada" "telugu" "tamil" "malayalam")

# Function to create language files for a folder
create_language_files() {
    local folder_name="$1"
    local folder_path="$2"

    echo -e "${GREEN}Processing folder: $folder_name${NC}"

    # Create language files for each language
    for language in "${LANGUAGES[@]}"; do
        local file_name="${folder_name}-${language}.md"
        local file_path="${folder_path}/${file_name}"

        # Check if file already exists
        if [[ -f "$file_path" ]]; then
            echo -e "${YELLOW}  File already exists: $file_name${NC}"
        else
            # Create the file with a basic template
            cat > "$file_path" << EOF
# ${folder_name} - ${language^}

## Agreement Details

This document contains the ${language^} version of the ${folder_name} agreement.

### Content

[Content will be added here]

### Version

Version: 1.0
Language: ${language^}
Created: $(date '+%Y-%m-%d %H:%M:%S')

---
EOF
            echo -e "${GREEN}  Created: $file_name${NC}"
        fi
    done
    echo ""
}

# Process each folder
for folder in aurigraph-*/; do
    if [[ -d "$folder" ]]; then
        # Remove trailing slash to get folder name
        folder_name=$(basename "$folder")
        create_language_files "$folder_name" "$folder"
    fi
done

echo -e "${GREEN}Language file creation completed!${NC}"
echo -e "${YELLOW}Summary:${NC}"
echo "Created files for each folder with the following pattern:"
echo "  - {folder_name}-english.md"
echo "  - {folder_name}-kannada.md"
echo "  - {folder_name}-telugu.md"
echo "  - {folder_name}-tamil.md"
echo "  - {folder_name}-malayalam.md"