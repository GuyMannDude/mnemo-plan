#!/usr/bin/env bash
# bus-pending.sh — Surface unread Sparks Bus messages for CC at session start.
# Prints a summary to stdout so Claude Code picks them up as context. Silent when
# there are no pending messages, so normal sessions stay quiet.
set -euo pipefail

BUS_DB="${BUS_DB:-$HOME/.sparks/bus.sqlite}"
AGENT="${BUS_AGENT:-CC}"

[ -f "$BUS_DB" ] || exit 0

pending=$(sqlite3 "$BUS_DB" "SELECT COUNT(*) FROM messages WHERE to_agent='${AGENT}' AND read=0;" 2>/dev/null || echo 0)
[ "$pending" -gt 0 ] || exit 0

echo ""
echo "=== PENDING BUS MESSAGES FOR ${AGENT} (${pending}) ==="
sqlite3 -separator ' | ' "$BUS_DB" \
  "SELECT '#' || id, 'from ' || from_agent || ':', subject, '(' || COALESCE(tracking_id, 'bus-' || id) || ')', 'created ' || created_at
   FROM messages WHERE to_agent='${AGENT}' AND read=0 ORDER BY created_at ASC;"
echo ""
echo "To read the full payload, call mnemo_recall with the tracking_id. Mark read via UPDATE on ~/.sparks/bus.sqlite or bus_read MCP when available."
echo "=== END PENDING ==="
echo ""
