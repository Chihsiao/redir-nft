English | [简体中文](README-zh.md)

# redir-nft

A TCP traffic redirection tool implemented using nftables.

## Features

- TCP Traffic Redirection: Uses nftables' redirect functionality to forward traffic to a specified port
  - (configurable via `REDIR_PORT` environment variable, default 52345)

- Systemd Service Support: Can be managed through systemd
- Simple Config: Requires minimal setup to use

## System Requirements

- bash (provides basic script execution environment)
- iproute2 (provides `ip` command for getting all interface IP addresses and monitoring changes)
- nftables (provides `nft` command for configuring redirect rules)
- systemd (optional, provides system service management)

## Quick Start

1. Clone:
   ```bash
   git clone https://github.com/username/redir-nft.git
   cd redir-nft
   ```

2. Install:
   ```bash
   sudo cp redir.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/redir.sh
   sudo cp redir.service /etc/systemd/system/
   sudo systemctl daemon-reload
   ```

3. Start the service:
   ```bash
   sudo systemctl start redir.service
   ```

4. Enable auto-start on boot (optional):
   ```bash
   sudo systemctl enable redir.service
   ```

## Credit

The nftables rules are from [v2rayA](https://github.com/v2rayA/v2rayA).

## License

This project is licensed under AGPL v3. See the [LICENSE](LICENSE) file for details.
