#!/bin/bash
# E4S Container Initialization Script
# This script is sourced by /etc/bash.bashrc on login

# Only show message for interactive shells
if [[ $- == *i* ]]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║  Welcome to the Minimal E4S Container (Spack + MPICH)  ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "📖 Documentation and helper files are available in: /etc/e4s/"
    echo ""
    echo "   • README.md           - Usage guide, including package/environment install instructions"
    echo "   • spack.yaml          - E4S environment template"
    echo ""
    echo "💡 Quick tips:"
    echo "   • MPICH is pre-installed and auto-loaded"
    echo "   • To create a writable local Spack for read-only root filesystems use: /etc/e4s/e4s-chain-spack.sh"
    echo "   • View README: cat /etc/e4s/README.md"
    echo "   • Project website: https://e4s.io"
    echo ""
    
    # Try to copy README to home directory if it's safe to do so
    # Only copy if:
    # 1. Home directory is writable
    # 2. Home directory appears to be container-provided (mostly empty)
    # 3. README doesn't already exist
    
    if [[ -w "$HOME" ]] && [[ ! -f "$HOME/README.md" ]]; then
      # Count non-hidden files/dirs in home (excluding . and ..)
      home_items=$(find "$HOME" -mindepth 1 -maxdepth 1 ! -name '.*' 2>/dev/null | wc -l)
      
      # If home has 5 or fewer non-hidden items, assume it's a clean container home
      if [[ $home_items -le 5 ]]; then
        cp -n /etc/e4s/README.md "$HOME/README.md" 2>/dev/null && \
          echo "📄 README copied to your home directory: ~/README.md"
        echo ""
      fi
    fi
fi
