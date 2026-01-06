
# AutoCAD LISP Files

Collection of AutoLISP (Common Lisp dialect) routines and utilities for AutoCAD.

> NOTE: This repository contains AutoLISP files (.lsp, .vlx, .fas) intended to be loaded and run inside AutoCAD or compatible CAD environments that support AutoLISP. These routines were created to automate common drafting tasks, add utility commands, and demonstrate AutoLISP techniques.

## Table of contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Common Commands / Examples](#common-commands--examples)
- [Repository structure](#repository-structure)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

This repo contains a set of AutoLISP routines intended to speed up repetitive drafting tasks in AutoCAD. Routines range from small one-off helpers to multi-function scripts. Each file typically contains documentation at the top describing its purpose and how to invoke the commands it provides.

## Features

- Handy drawing utilities and automation helpers.
- Small, focused AutoLISP routines that are easy to load or integrate into tool palettes.
- Examples demonstrating common AutoLISP patterns and workflows.

## Prerequisites

- AutoCAD (or any CAD application that supports AutoLISP).
- Basic familiarity with AutoCAD command line and the APPLOAD mechanism.
- Windows file system access to place/load .lsp files (or a network path accessible from AutoCAD).

Supported file extensions: `.lsp`, `.vlx`, `.fas` (where applicable).

AutoCAD versions: routines should work on modern releases that support AutoLISP; compatibility may vary — check individual file headers for version notes.

## Installation

1. Clone or download this repository:
   - Clone: `git clone https://github.com/adalkondan/AutoCAD-LISP-files.git`
   - Or download ZIP from the GitHub page and extract.

2. Copy the desired `.lsp` (or other) files to a folder that AutoCAD can access (for example, a folder in AutoCAD's Support File Search Path).

3. Load the LISP files into AutoCAD:
   - Use the `APPLOAD` command and browse to the `.lsp` file(s), or
   - Add the folder to AutoCAD's Support File Search Path and autoload from a startup LISP.

4. Optional: Add frequently used routines to a tool palette or create startup entries to load them automatically.

## Usage

- After loading a file, consult the top-of-file header comments for the provided command names.
- Most routines add one or more new command names (e.g., `MY-ALIGN`, `BATCH-EXPORT`) that you can invoke directly from the AutoCAD command line.
- For programmatic use, functions can typically be called in other LISP files via `(load "filename.lsp")` or `(require ...)` patterns depending on how you organize them.

Tips:
- Use `APPLOAD` to test a routine before adding it permanently.
- Keep backups of original drawings before running automated scripts on production files.
- Run routines on a copy of the drawing until you confirm behavior.

## Common Commands / Examples

Below are generic examples showing how to load and call LISP routines.

- Load a LISP file:
  - Command line: APPLOAD → select `example.lsp` → Close
  - Or programmatically: `(load "C:/path/to/example.lsp")`

- Call a routine:
  - If the routine defines command `EX-DO`, type `EX-DO` on the AutoCAD command line.

- Example snippet to load a file from a startup LISP:
  ```lisp
  ;; in acad.lsp or a startup lsp file
  (load "C:/AutoLISP/my-utilities.lsp")
  ```

(Check each file header for specific command names and usage examples.)

## Repository structure

- / — top-level AutoLISP files and documentation
- Each file contains a header comment with:
  - Short description
  - Provided command names
  - Usage examples
  - Author / license notes (if present)

If you add new routines, please include clear header comments describing usage and any side effects.

## Contributing

Contributions are welcome. Suggested workflow:

1. Fork the repository.
2. Add or improve AutoLISP routines in a clear, well-documented manner.
3. Update or add tests/examples in the file header.
4. Create a pull request describing the change and intended usage.

Guidelines:
- Keep routines focused and reversible (avoid destructive operations without explicit user confirmation).
- Include usage examples and note AutoCAD version compatibility if relevant.
- Respect existing naming conventions to avoid command name collisions.

