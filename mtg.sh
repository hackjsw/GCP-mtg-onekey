#!/usr/bin/env bash
set -euo pipefail

FAKE_HOST="${1:-www.nazhumi.com}"
IMAGE="nineseconds/mtg:2"
NAME="mtg"

if [ "$EUID" -ne 0 ]; then
  echo "请用 root 运行：sudo bash mtg.sh [伪装域名]"
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  apt update
  apt install -y docker.io curl
  systemctl enable --now docker
else
  systemctl enable --now docker >/dev/null 2>&1 || true
fi

docker rm -f "$NAME" >/dev/null 2>&1 || true
docker pull "$IMAGE"

SECRET="$(docker run --rm "$IMAGE" generate-secret --hex "$FAKE_HOST")"

docker run -d \
  --name "$NAME" \
  --restart unless-stopped \
  --network host \
  "$IMAGE" \
  simple-run 0.0.0.0:443 "$SECRET" >/dev/null

sleep 2

PUBLIC_IP="$(curl -fsS -H 'Metadata-Flavor: Google' \
  'http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip')"

echo
echo "Fake host : $FAKE_HOST"
echo "Public IP : $PUBLIC_IP"
echo "Secret    : $SECRET"
echo
echo "tg://proxy?server=$PUBLIC_IP&port=443&secret=$SECRET"
echo "https://t.me/proxy?server=$PUBLIC_IP&port=443&secret=$SECRET"
