[English](README.md) | 简体中文

# redir-nft

一个使用 nftables 实现的 TCP 流量重定向工具。

## 功能特性

- TCP 流量重定向：使用 nftables 的重定向功能将流量转发到指定端口
  - 默认为 52345，可通过环境变量 `REDIR_PORT` 配置

- Systemd 支持：可以通过 systemd 进行管理
- 简单配置：使用时只需最少的设置

## 系统要求

- bash（提供基本的脚本执行环境）
- iproute2（提供 `ip` 命令用于获取所有接口 IP 地址和监控变化）
- nftables（提供 `nft` 命令用于配置重定向规则）
- systemd（可选，提供系统服务管理）

## 快速开始

1. 克隆：
   ```bash
   git clone https://github.com/username/redir-nft.git
   cd redir-nft
   ```

2. 安装：
   ```bash
   sudo cp redir.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/redir.sh
   sudo cp redir.service /etc/systemd/system/
   sudo systemctl daemon-reload
   ```

3. 启动服务：
   ```bash
   sudo systemctl start redir.service
   ```

4. 开机自启（可选）：
   ```bash
   sudo systemctl enable redir.service
   ```

## 致谢

nftables 规则来自 [v2rayA](https://github.com/v2rayA/v2rayA)。

## 许可证

本项目采用 AGPL v3 许可证。详见 [LICENSE](LICENSE) 文件。
