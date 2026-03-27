#!/bin/bash
#
# brainkey install script
# Run this after cloning to set up your personal Second Brain vault.
#

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo ""
echo -e "${BOLD}  brainkey${NC} — Personal Knowledge Management"
echo -e "  ────────────────────────────────────────"
echo ""

# 1. Check we're in the right place
if [ ! -f "CLAUDE.md" ] || [ ! -d "_templates" ]; then
    echo -e "${RED}Error:${NC} Run this script from the brainkey project root."
    echo "  cd /path/to/brainkey && bash install.sh"
    exit 1
fi

echo -e "${BLUE}[1/5]${NC} Checking prerequisites..."

# 2. Check for Claude Code
if command -v claude &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Claude Code found"
else
    echo -e "  ${RED}✗${NC} Claude Code not found"
    echo ""
    echo "  brainkey requires Claude Code to run."
    echo "  Install it: https://docs.anthropic.com/en/docs/claude-code/overview"
    echo ""
    exit 1
fi

# 3. Check for optional tools
echo ""
echo -e "${BLUE}[2/5]${NC} Checking optional tools..."

if command -v firecrawl &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} firecrawl found (better URL scraping)"
else
    echo -e "  ${YELLOW}○${NC} firecrawl not found (optional — URLs will use WebFetch fallback)"
    echo "    Install later with: npm install -g firecrawl"
fi

if command -v obsidian &> /dev/null || [ -d "/Applications/Obsidian.app" ] || [ -d "$HOME/Applications/Obsidian.app" ]; then
    echo -e "  ${GREEN}✓${NC} Obsidian found (for browsing your vault)"
else
    echo -e "  ${YELLOW}○${NC} Obsidian not found (optional — for visual browsing of your vault)"
    echo "    Install later from: https://obsidian.md"
fi

# 4. Create folder structure
echo ""
echo -e "${BLUE}[3/5]${NC} Setting up vault folders..."

folders=(
    "00-inbox"
    "01-sources"
    "02-concepts"
    "03-arguments"
    "04-models"
    "05-synthesis"
    "06-briefs"
    "07-maps"
    "08-library"
    "09-reviews"
    "09-reviews/daily"
    "09-reviews/weekly"
    "09-reviews/monthly"
    "_meta"
    "_meta/tags"
    "_meta/sources"
)

created=0
for folder in "${folders[@]}"; do
    if [ ! -d "$folder" ]; then
        mkdir -p "$folder"
        ((created++))
    fi
done

if [ $created -gt 0 ]; then
    echo -e "  ${GREEN}✓${NC} Created $created folders"
else
    echo -e "  ${GREEN}✓${NC} All folders already exist"
fi

# 5. Verify key files exist
echo ""
echo -e "${BLUE}[4/5]${NC} Verifying vault files..."

missing=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "  ${GREEN}✓${NC} $1"
    else
        echo -e "  ${RED}✗${NC} $1 — missing"
        ((missing++))
    fi
}

check_file "CLAUDE.md"
check_file "_meta/domains-registry.md"
check_file "_templates/source-article.md"
check_file "_templates/concept.md"
check_file "_templates/memory-index.md"

if [ $missing -gt 0 ]; then
    echo ""
    echo -e "  ${YELLOW}Warning:${NC} $missing files missing. Your clone may be incomplete."
    echo "  Try: git checkout -- ."
fi

# 6. Done
echo ""
echo -e "${BLUE}[5/5]${NC} ${GREEN}Setup complete!${NC}"
echo ""
echo -e "  ${BOLD}Get started:${NC}"
echo ""
echo "  1. Open Claude Code in this folder:"
echo -e "     ${BOLD}claude${NC}"
echo ""
echo "  2. On first run, you'll be asked for your areas of interest"
echo "     (e.g., AI, philosophy, business). Skip if you prefer"
echo "     domains to emerge organically as you add content."
echo ""
echo "  3. Start adding content:"
echo -e "     ${BOLD}/knowledge-ingest${NC} https://example.com/article"
echo -e "     ${BOLD}/knowledge-search${NC} find articles on [topic]"
echo ""
echo "  4. (Optional) Open this folder as an Obsidian vault"
echo "     for visual browsing with backlinks and graph view."
echo ""
echo -e "  ${BOLD}All skills:${NC}"
echo "    /knowledge-ingest    — Add content (URLs, text, files)"
echo "    /knowledge-search    — Search the web, review, then ingest"
echo "    /knowledge-chat      — Ask your knowledge base"
echo "    /knowledge-connect   — Find connections between notes"
echo "    /knowledge-synthesize — Surface cross-source patterns"
echo "    /knowledge-brief     — Generate documents from your knowledge"
echo "    /knowledge-status    — Vault health dashboard"
echo "    /knowledge-review    — Daily/weekly/monthly learning reviews"
echo ""
echo -e "  Docs: ${BOLD}README.md${NC}"
echo ""
