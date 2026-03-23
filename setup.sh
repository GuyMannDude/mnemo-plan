#!/bin/bash

# Sparks Brain — Setup Script
# One command to give Claude Code a persistent memory.

set -e

BRAIN_DIR="$(cd "$(dirname "$0")" && pwd)"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         ⚡ Sparks Brain ⚡            ║${NC}"
echo -e "${BLUE}║   Persistent Memory for Claude Code  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""

# Step 1: Check if brain files already have real content
echo -e "${YELLOW}Checking brain files...${NC}"
TEMPLATE_COUNT=0
for f in "$BRAIN_DIR/brain/"*.md; do
  if grep -q "Delete.*template\|Delete everything above\|delete this and add" "$f" 2>/dev/null; then
    TEMPLATE_COUNT=$((TEMPLATE_COUNT + 1))
  fi
done

if [ "$TEMPLATE_COUNT" -gt 0 ]; then
  echo -e "  Found ${TEMPLATE_COUNT} brain files still using templates."
  echo -e "  ${GREEN}That's fine — CC will fill them in as you work.${NC}"
  echo -e "  Or edit them now in brain/ to give CC a head start."
else
  echo -e "  ${GREEN}Brain files look populated. Nice.${NC}"
fi

# Step 2: Link to project CLAUDE.md
echo ""
echo -e "${YELLOW}Setting up CLAUDE.md integration...${NC}"

# Find the parent project directory (one level up from .brain, or current dir)
PROJECT_DIR="$(dirname "$BRAIN_DIR")"
CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"

# Check if this is a standalone install or nested in a project
if [ "$BRAIN_DIR" = "$PROJECT_DIR" ]; then
  echo -e "  Sparks Brain is standalone (not nested in a project)."
  echo -e "  ${GREEN}CC will read CLAUDE.md from this directory.${NC}"
else
  # Check if project already has a CLAUDE.md
  if [ -f "$CLAUDE_MD" ]; then
    # Check if it already references sparks-brain
    if grep -q "sparks-brain\|brain/" "$CLAUDE_MD" 2>/dev/null; then
      echo -e "  ${GREEN}CLAUDE.md already references Sparks Brain.${NC}"
    else
      echo ""
      echo -e "  Found existing CLAUDE.md at: $CLAUDE_MD"
      echo -e "  ${YELLOW}Add Sparks Brain reference? (y/n)${NC}"
      read -r REPLY
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "" >> "$CLAUDE_MD"
        echo "# Sparks Brain — Persistent Memory" >> "$CLAUDE_MD"
        echo "# Read brain files at session start: $(basename "$BRAIN_DIR")/brain/" >> "$CLAUDE_MD"
        echo "# See $(basename "$BRAIN_DIR")/CLAUDE.md for brain operating instructions." >> "$CLAUDE_MD"
        echo -e "  ${GREEN}Added Sparks Brain reference to CLAUDE.md${NC}"
      else
        echo -e "  Skipped. You can add it manually later."
      fi
    fi
  else
    echo ""
    echo -e "  No CLAUDE.md found at project root."
    echo -e "  ${YELLOW}Create one with Sparks Brain reference? (y/n)${NC}"
    read -r REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "# Project Configuration for Claude Code" > "$CLAUDE_MD"
      echo "" >> "$CLAUDE_MD"
      echo "# Sparks Brain — Persistent Memory" >> "$CLAUDE_MD"
      echo "# Read brain files at session start: $(basename "$BRAIN_DIR")/brain/" >> "$CLAUDE_MD"
      echo "# See $(basename "$BRAIN_DIR")/CLAUDE.md for brain operating instructions." >> "$CLAUDE_MD"
      echo -e "  ${GREEN}Created CLAUDE.md with Sparks Brain reference${NC}"
    else
      echo -e "  Skipped. You can create it manually later."
    fi
  fi
fi

# Step 3: Git init if needed
echo ""
echo -e "${YELLOW}Checking Git...${NC}"
if [ -d "$BRAIN_DIR/.git" ]; then
  echo -e "  ${GREEN}Git already initialized.${NC}"
elif [ -d "$PROJECT_DIR/.git" ]; then
  echo -e "  ${GREEN}Part of existing Git repo at $PROJECT_DIR${NC}"
else
  echo -e "  ${YELLOW}Initialize Git for brain tracking? (y/n)${NC}"
  read -r REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$BRAIN_DIR"
    git init -q
    git add -A
    git commit -q -m "brain: initial setup"
    echo -e "  ${GREEN}Git initialized with first commit.${NC}"
  else
    echo -e "  Skipped. You can init Git later."
  fi
fi

# Step 4: Create .gitignore if needed
if [ ! -f "$BRAIN_DIR/.gitignore" ]; then
  echo "# Don't track secrets or temp files" > "$BRAIN_DIR/.gitignore"
  echo "*.secrets" >> "$BRAIN_DIR/.gitignore"
  echo "*.tmp" >> "$BRAIN_DIR/.gitignore"
  echo ".DS_Store" >> "$BRAIN_DIR/.gitignore"
fi

# Done
echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       ⚡ Brain is ready. ⚡           ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo "  Next steps:"
echo "  1. Edit the brain files in brain/ with your project context"
echo "     (or let CC fill them in organically — your choice)"
echo "  2. Start a Claude Code session in your project"
echo "  3. CC reads the brain, works with you, writes back what it learns"
echo ""
echo "  The knowledge compounds. Every session makes the next one better."
echo ""
