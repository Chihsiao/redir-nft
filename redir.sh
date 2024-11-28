#!/usr/bin/env bash

nft -f - << EOF
table inet redir {
    set whitelist {
        type ipv4_addr
        flags interval
        auto-merge
        elements = {
            0.0.0.0/32,
            10.0.0.0/8,
            100.64.0.0/10,
            127.0.0.0/8,
            169.254.0.0/16,
            172.16.0.0/12,
            192.0.0.0/24,
            192.0.2.0/24,
            192.88.99.0/24,
            192.168.0.0/16,
            198.51.100.0/24,
            203.0.113.0/24,
            224.0.0.0/4,
            240.0.0.0/4
        }
    }

    set whitelist6 {
        type ipv6_addr
        flags interval
        auto-merge
        elements = {
            ::/128,
            ::1/128,
            64:ff9b::/96,
            100::/64,
            2001::/32,
            2001:20::/28,
            fe80::/10,
            ff00::/8
        }
    }

    set interface {
        type ipv4_addr
        flags interval
        auto-merge
    }

    set interface6 {
        type ipv6_addr
        flags interval
        auto-merge
    }

    chain tp_rule {
        ip daddr @whitelist return
        ip daddr @interface return
        ip6 daddr @whitelist6 return
        ip6 daddr @interface6 return
        meta mark & 0x80 == 0x80 return
        meta l4proto tcp redirect to :${REDIR_PORT:-52345}
    }

    chain tp_pre {
        type nat hook prerouting priority dstnat - 5
        meta nfproto { ipv4, ipv6 } meta l4proto tcp jump tp_rule
    }

    chain tp_out {
        type nat hook output priority -105
        meta nfproto { ipv4, ipv6 } meta l4proto tcp jump tp_rule
    }
}
EOF

trap 'nft delete table inet redir' EXIT

_whitelist() {
  local inet_addr inet_type
  inet_addr="$(printf '%s\n' "$2" | awk '{ print $2 }')"
  inet_type="$(printf '%s\n' "$2" | awk '{ sub(/^inet/, "interface"); print $1 }')"
  nft "$1" element inet redir "$inet_type" '{' \
    "$inet_addr" \
  '}'
}

ip address \
  | grep -Eo '\binet6?\s[a-z0-9\.:]+/[0-9]+\b' \
  | while read -r inet; do _whitelist add "$inet"; done

ip monitor address | \
  while IFS=$'\n' read -r line; do
    (printf '%s\n' "$line" | grep -q '^\s') && continue || true
    (printf '%s\n' "$line" | grep -q '^Deleted') && action=delete || action=add
    inet="$(printf '%s\n' "$line" | grep -Eo '\binet6?\s[a-z0-9\.:]+/[0-9]+\b')"
    _whitelist "$action" "$inet"
  done
