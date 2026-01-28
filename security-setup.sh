#!/bin/bash
#
# Docker 실습 환경 호스트 레벨 보안 설정 스크립트
#
# 이 스크립트는 EC2 인스턴스에서 실행하여 핑 공격, SYN Flood 등을 방어합니다.
#
# 사용법:
#   chmod +x security-setup.sh
#   sudo ./security-setup.sh
#
# 주의: 이 스크립트는 root 권한으로 실행해야 합니다.
#

set -e

echo "======================================"
echo "  Docker 실습 환경 보안 설정 시작"
echo "======================================"

# Root 권한 확인
if [ "$EUID" -ne 0 ]; then
    echo "Error: 이 스크립트는 root 권한으로 실행해야 합니다."
    echo "sudo $0"
    exit 1
fi

# 현재 iptables 규칙 백업
echo "[1/5] 현재 iptables 규칙 백업..."
iptables-save > /root/iptables-backup-$(date +%Y%m%d-%H%M%S).rules
echo "  백업 완료: /root/iptables-backup-*.rules"

# ICMP (핑) 제한 - 초당 1개, burst 4개
echo "[2/5] ICMP (핑) Rate Limiting 설정..."
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 4 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
echo "  ICMP 제한: 초당 1개, burst 4개"

# SYN Flood 방어
echo "[3/5] SYN Flood 방어 설정..."
iptables -A INPUT -p tcp --syn -m limit --limit 10/s --limit-burst 20 -j ACCEPT
iptables -A INPUT -p tcp --syn -j DROP
echo "  SYN 제한: 초당 10개, burst 20개"

# 잘못된 패킷 차단
echo "[4/5] 잘못된 패킷 차단 설정..."
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
echo "  INVALID 상태 및 비정상 TCP 플래그 차단"

# 설정 저장 (재부팅 후에도 유지)
echo "[5/5] 설정 저장..."
if command -v netfilter-persistent &> /dev/null; then
    netfilter-persistent save
    echo "  netfilter-persistent로 저장 완료"
elif command -v iptables-save &> /dev/null; then
    # Amazon Linux / CentOS
    if [ -f /etc/sysconfig/iptables ]; then
        iptables-save > /etc/sysconfig/iptables
        echo "  /etc/sysconfig/iptables로 저장 완료"
    # Ubuntu / Debian
    elif [ -d /etc/iptables ]; then
        iptables-save > /etc/iptables/rules.v4
        echo "  /etc/iptables/rules.v4로 저장 완료"
    else
        echo "  경고: 저장 경로를 찾을 수 없습니다. 수동으로 저장하세요."
    fi
fi

echo ""
echo "======================================"
echo "  보안 설정 완료!"
echo "======================================"
echo ""
echo "적용된 보안 규칙:"
echo "  - ICMP (핑): 초당 1개, burst 4개 허용"
echo "  - SYN 패킷: 초당 10개, burst 20개 허용"
echo "  - INVALID 패킷: 모두 차단"
echo "  - 비정상 TCP 플래그: 모두 차단"
echo ""
echo "현재 iptables 규칙 확인:"
iptables -L -n --line-numbers | head -30
echo ""
echo "복원 방법: iptables-restore < /root/iptables-backup-*.rules"
