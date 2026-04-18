# GCP MTG One-Click

在 GCP 云服务器上一键部署 Telegram MTProto Proxy（基于 MTG Docker 镜像）。

脚本会自动完成这些操作：

- 安装 Docker（如果未安装）
- 删除旧的 `mtg` 容器（如果存在）
- 拉取最新 `nineseconds/mtg:2` 镜像
- 使用指定伪装域名生成新的 MTG secret
- 用 `simple-run 0.0.0.0:443` 启动 MTG
- 自动获取 GCP 公网 IP
- 输出可直接导入 Telegram 的代理链接

---

## 环境要求

- GCP 云服务器
- Ubuntu / Debian
- 已绑定公网 IP
- 已放行 TCP `443`
- root 权限或可使用 `sudo`

---

## 使用方法

### 1）首次安装

下载脚本并运行：

```bash
curl -fsSL https://raw.githubusercontent.com/hackjsw/GCP-mtg-onekey/refs/heads/main/mtg.sh -o mtg.sh
chmod +x mtg.sh
sudo ./mtg.sh
````

默认伪装域名是：

```text
www.microsoft.com
```

执行成功后会输出：

* 公网 IP
* Secret
* `tg://proxy?...`
* `https://t.me/proxy?...`

把输出的链接发到 Telegram 并点击即可导入。

---

### 2）指定伪装域名安装

例如使用 `bing.com`：

```bash
curl -fsSL https://raw.githubusercontent.com/hackjsw/GCP-mtg-onekey/refs/heads/main/mtg.sh -o mtg.sh
chmod +x mtg.sh
sudo ./mtg.sh bing.com
```

其他示例：

```bash
sudo ./mtg.sh baidu.com
sudo ./mtg.sh www.microsoft.com
sudo ./mtg.sh www.cloudflare.com
```

---

### 3）一条命令直接运行

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/hackjsw/GCP-mtg-onekey/refs/heads/main/mtg.sh) www.microsoft.com
```

---

## 如何更换 Secret

**更换 secret 的方法很简单：重新运行脚本即可。**

脚本每次执行都会：

1. 删除旧的 `mtg` 容器
2. 重新生成一个新的 secret
3. 用新的 secret 启动 MTG
4. 输出新的代理链接

### 重新生成 secret，但保持同一个伪装域名

例如继续使用 `www.microsoft.com`：

```bash
sudo ./mtg.sh www.microsoft.com
```

这会生成一个**全新的 secret**。
注意：**旧链接会失效**，你需要使用脚本新输出的链接。

---

### 更换 secret，并同时更换伪装域名

例如从 `www.microsoft.com` 换成 `bing.com`：

```bash
sudo ./mtg.sh bing.com
```

这会：

* 删除旧容器
* 生成 `bing.com` 对应的新 secret
* 启动新的 MTG
* 输出新的代理链接

同样，**旧链接会失效**，请使用新输出的链接。

---

## Telegram 手动添加

如果不能直接点击链接，也可以手动添加：

* Type: `MTProto`
* Server: `脚本输出的公网 IP`
* Port: `443`
* Secret: `脚本输出的 Secret`

---

## 示例输出

```text
Fake host : www.microsoft.com
Public IP : 35.212.204.79
Secret    : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

tg://proxy?server=35.212.204.79&port=443&secret=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
https://t.me/proxy?server=35.212.204.79&port=443&secret=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 常用命令

查看容器状态：

```bash
sudo docker ps
```

查看 MTG 日志：

```bash
sudo docker logs -f mtg
```

查看 443 端口监听：

```bash
sudo ss -lntp | grep ':443'
```

删除 MTG 容器：

```bash
sudo docker rm -f mtg
```

---

## 注意事项

* 每次重新运行脚本，都会生成新的 secret。
* secret 变更后，旧的 Telegram 代理链接会失效。
* 如果更换了伪装域名，代理链接也会变化。
* 请确保 GCP 防火墙已放行 TCP `443`。
* 请确保实例有公网 IP。

---

## 推荐伪装域名

不同网络环境下效果可能不同，可以自行测试：

* `www.microsoft.com`
* `bing.com`
* `www.cloudflare.com`
* `baidu.com`

---

## License

MIT

```
