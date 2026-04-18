# GCP MTG One-Click

在 GCP 云服务器上一键部署 Telegram MTProto Proxy（基于 [MTG](https://github.com/9seconds/mtg) Docker 镜像）。

这个脚本会自动完成以下操作：

- 安装 Docker（如果未安装）
- 删除已有的 `mtg` 容器
- 拉取最新 `nineseconds/mtg:2` 镜像
- 使用指定伪装域名生成新的 MTG secret
- 用 `simple-run 0.0.0.0:443` 启动 MTG
- 自动获取 GCP 公网 IP
- 输出可直接导入 Telegram 的代理链接

---

## Features

- 一键部署 MTG
- 自动生成新的 Secret
- 支持自定义伪装域名
- 自动输出 `tg://` 和 `https://t.me/proxy?...` 链接
- 适合 GCP Ubuntu / Debian 服务器

---

## Requirements

- 一台带公网 IP 的 GCP 云服务器
- 系统建议：Ubuntu / Debian
- 已放行 TCP 443 端口
- Root 权限或可使用 `sudo`

---

## Usage

### 方式 1：下载后运行

```bash
curl -fsSL https://raw.githubusercontent.com/hackjsw/GCP-mtg-onekey/refs/heads/main/mtg.sh -o mtg.sh
chmod +x mtg.sh
sudo ./mtg.sh
