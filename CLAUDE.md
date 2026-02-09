# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Primary Commands

- `nix develop --command reload` - Apply nix-darwin configuration (includes Home Manager)
- `./bootstrap.sh` - Bootstrap the configuration on a new machine
- `nixfmt flake.nix` - Format Nix files using nixfmt
- `statix check` - Lint Nix code for best practices
- `flake-checker` - Check flake.nix for issues

### Development Shell

- `nix develop` - Enter development shell with reload command and pre-commit hooks
- Pre-commit hooks are automatically enabled in the dev shell for:
  - editorconfig-checker
  - nixfmt
  - statix

## Architecture Overview

This is a personal Nix configuration repository called "Nome" (Nix home) that uses:

### Core Structure

- **flake.nix** - Main flake configuration with inputs, outputs, and system definition
- **nix-darwin/** - macOS system-level configuration using nix-darwin
- **home-manager/** - User-level configuration using Home Manager
- **templates/** - Nix flake templates for new projects

### Key Configuration Files

- **home-manager/packages.nix** - All user packages organized by category (dev tools, language servers, etc.)
- **home-manager/programs.nix** - Program-specific configurations (git, vscode, etc.)
- **home-manager/default.nix** - Home Manager module entry point
- **nix-darwin/base/default.nix** - System-level macOS configuration

### Target System

- **Platform**: aarch64-darwin (Apple Silicon Mac)
- **User**: lucperkins
- **State Version**: 25.05

### Package Organization

Packages are categorized into groups like:

- Development tools (Rust, Go, Python, JS toolchains)
- Security tools (cosign, grype, syft)
- DevOps tools (kubectl, awscli2, flyctl)
- Version control tools (jujutsu, git tooling)

### Theme System

Centralized theming system in flake.nix overlays with Catppuccin themes for:

- bat, vscode, zellij, ghostty, spotify-player

### Custom Overlays

The flake defines custom overlays that provide:

- `reload` script for applying darwin-rebuild switch
- `rustToolchain` with fenix
- Theme configurations
- Custom lib functions (homeDirectory)
- Package references from unstable nixpkgs

## File Editing Guidelines

When modifying this configuration:

- Follow existing Nix formatting and structure patterns
- Add new packages to appropriate categories in packages.nix
- Program configurations go in dedicated files under home-manager/
- System-level changes go in nix-darwin/base/
- Use the existing theme system for consistent styling
- Test changes with `nix develop --command reload`
