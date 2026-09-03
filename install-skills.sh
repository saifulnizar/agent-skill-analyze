#!/usr/bin/env bash
# ==============================================================================
# Agent Skill Analyze - Universal One-Liner Installer
# Supports: Antigravity IDE / Gemini Agent, Cursor, and Local Workspace
# ==============================================================================

set -e

# ANSI Color Codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

REPO_RAW_BASE="https://raw.githubusercontent.com/Lionparcel/agent-knowledge-workflow/main"
LOCAL_SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"

echo -e "\n${CYAN}${BOLD}======================================================${NC}"
echo -e "${CYAN}${BOLD}       🚀 AGENT SKILL ANALYZE - INSTALLER           ${NC}"
echo -e "${CYAN}${BOLD}======================================================${NC}\n"

# 1. Target Directory Detection
echo -e "${BLUE}🔍 Detecting Agent configuration environments...${NC}"

TARGET_DIRS=()

# Antigravity / Gemini Global Customization Root
GEMINI_DIR="$HOME/.gemini/config/skills"
if [ -d "$HOME/.gemini" ] || [ -d "$HOME/.gemini/antigravity-ide" ]; then
    TARGET_DIRS+=("$GEMINI_DIR")
fi

# Cursor Global Customization Root
CURSOR_DIR="$HOME/.cursor/skills"
if [ -d "$HOME/.cursor" ]; then
    TARGET_DIRS+=("$CURSOR_DIR")
fi

# If neither exists or user is in a project workspace, provide local workspace option
CURRENT_WORKSPACE="$(pwd)/.agents/skills"
TARGET_DIRS+=("$CURRENT_WORKSPACE")

echo -e "${GREEN}✔ Found installation target locations:${NC}"
for dir in "${TARGET_DIRS[@]}"; do
    echo -e "  - ${YELLOW}$dir${NC}"
done
echo ""

# 2. Perform Installation
SKILLS=("arch" "plan" "spec")

for target in "${TARGET_DIRS[@]}"; do
    echo -e "${BLUE}📦 Installing skills into: ${BOLD}$target${NC}"
    if ! mkdir -p "$target" 2>/dev/null; then
        echo -e "   ${YELLOW}⚠ Skipped $target (Permission restricted in current sandbox/session)${NC}"
        continue
    fi

    if [ -d "$LOCAL_SKILLS_DIR" ]; then
        # Local source mode
        for skill in "${SKILLS[@]}"; do
            if [ -d "$LOCAL_SKILLS_DIR/$skill" ]; then
                cp -R "$LOCAL_SKILLS_DIR/$skill" "$target/" 2>/dev/null || true
                echo -e "   ${GREEN}✔ Installed $skill${NC}"
            fi
        done
    else
        # Remote download mode (via curl / git archive)
        echo -e "   ${YELLOW}Downloading latest skills from repository...${NC}"
        TEMP_DIR=$(mktemp -d)
        git clone --depth 1 "https://github.com/Lionparcel/agent-knowledge-workflow.git" "$TEMP_DIR" > /dev/null 2>&1 || true
        
        if [ -d "$TEMP_DIR/.agents/skills" ]; then
            for skill in "${SKILLS[@]}"; do
                cp -R "$TEMP_DIR/.agents/skills/$skill" "$target/" 2>/dev/null || true
                echo -e "   ${GREEN}✔ Installed $skill${NC}"
            done
        fi
        rm -rf "$TEMP_DIR"
    fi
done

echo -e "\n${GREEN}${BOLD}======================================================${NC}"
echo -e "${GREEN}${BOLD}  🎉 SUCCESS! ALL GENERIC SKILLS ARE NOW INSTALLED!   ${NC}"
echo -e "${GREEN}${BOLD}======================================================${NC}\n"

echo -e "${BOLD}You can now use these slash commands in your Agent chat:${NC}\n"
echo -e "  1. ${CYAN}/arch [path/to/prd.md] [--lang=indo]${NC}"
echo -e "     -> Generates full architectural TRD with grounded systems engineering.\n"
echo -e "  2. ${CYAN}/plan [path/to/trd.md] [--lang=indo]${NC}"
echo -e "     -> Slices TRD into atomic task cards (T-01, T-02, ...) with DAG.\n"
echo -e "  3. ${CYAN}/spec [T-NN] [--lang=indo]${NC}"
echo -e "     -> Produces ready-to-code implementation contract with unit tests.\n"
