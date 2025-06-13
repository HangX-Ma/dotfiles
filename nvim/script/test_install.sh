#!/bin/bash
set -e

echo "=== Testing basic installation ==="
./requirements.sh basic --prefix=$HOME/nvim-test

echo "=== Testing component installation ==="
components=(1 2 3 4 5 6 7 8 9)
for comp in "${components[@]}"; do
	echo "--- Testing component $comp ---"
	./requirement.sh component <<<"$comp"
done

echo "=== Verifying installations ==="
command -v nvim
command -v lazygit
command -v yazi
command -v batgrep
command -v clangd
command -v lua-language-server
python3 -c "import venv"
python3 -c "import debugpy"

echo "All tests passed successfully!"
