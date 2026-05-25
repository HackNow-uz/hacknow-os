#!/bin/bash
# Go-based pentesting toollarni o'rnatish
set -e

echo "[HackNow] Go toollar o'rnatilmoqda..."

export GOPATH=/opt/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

TOOLS=(
    "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    "github.com/projectdiscovery/katana/cmd/katana@latest"
    "github.com/ffuf/ffuf/v2@latest"
    "github.com/tomnomnom/waybackurls@latest"
    "github.com/tomnomnom/assetfinder@latest"
    "github.com/OJ/gobuster/v3@latest"
    "github.com/sensepost/gowitness@latest"
)

for tool in "${TOOLS[@]}"; do
    NAME=$(basename "${tool%%@*}")
    echo "  -> $NAME"
    go install "$tool" 2>/dev/null || echo "    [!] $NAME o'rnatilmadi"
done

# Copy to system PATH
cp $GOPATH/bin/* /usr/local/bin/ 2>/dev/null || true

echo "[HackNow] Go toollar tayyor!"
