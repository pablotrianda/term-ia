
#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/ask"
BASHRC="$HOME/.bashrc"

echo "==> Instalando term-ai"

# Dependencias
if ! command -v curl >/dev/null ||
   ! command -v jq >/dev/null; then
    if command -v apt-get >/dev/null; then
        sudo apt-get update
        sudo apt-get install -y curl jq
    else
        echo "Instalá curl y jq antes de continuar."
        exit 1
    fi
fi

mkdir -p "$BIN_DIR" "$CONFIG_DIR"

# Instalar comandos
install -m 755 "$REPO_DIR/bin/ask" "$BIN_DIR/ask"
install -m 755 "$REPO_DIR/bin/chat" "$BIN_DIR/chat"

# Configuración de API
if [[ ! -f "$CONFIG_DIR/env" ]]; then
    cat > "$CONFIG_DIR/env" <<'EOF'
export GROQ_API_KEY="PEGAR_API_KEY_AQUI"
EOF
    chmod 600 "$CONFIG_DIR/env"
    echo "Creado $CONFIG_DIR/env"
else
    echo "Configuración existente conservada."
fi

# Configurar aliases sin duplicarlos
touch "$BASHRC"

if ! grep -qF '# term-ai aliases' "$BASHRC"; then
    cat >> "$BASHRC" <<'EOF'

# term-ai aliases
alias '?'='ask'
alias '??'='chat'
EOF
fi

# Asegurar que ~/.local/bin esté en PATH
if ! grep -qF 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
fi

echo
echo "Instalación terminada."
echo "1. Configurá tu API key en $CONFIG_DIR/env"
echo "2. Ejecutá: source ~/.bashrc"
echo "3. Probá: ? como ver los containers de Docker"
echo "4. Probá: ??"

