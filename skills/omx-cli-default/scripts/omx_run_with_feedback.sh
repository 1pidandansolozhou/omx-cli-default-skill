#!/bin/bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  New mode (recommended):
    omx_run_with_feedback.sh --goal "<goal>" [--cluster auto|tiny|standard|complex] \
      [--omx "<omx command>"] [--report "<report_json>"] [--force-close-loop] \
      [--prefer-standard]

  Legacy mode (compatible):
    omx_run_with_feedback.sh "<omx_cmd>" "<report_json>" "<goal>"
EOF
}

detect_cluster() {
  local text
  local words
  text="$(printf "%s %s" "$1" "$2" | tr '[:upper:]' '[:lower:]')"
  words="$(printf "%s" "$text" | wc -w | awk '{print $1}')"

  if [[ "$text" =~ (debug|refactor|review|regression|parallel|team|integrat|验证|排查|重构|并行|联调|修复|多步|架构|workflow|pipeline|lint|test|typecheck) ]]; then
    echo "complex"
    return
  fi

  if [[ "$text" =~ (quick|tiny|one[-[:space:]]step|lookup|check|date|time|简单|快速|查一下|单步|看一眼) ]]; then
    # Be conservative: only classify as tiny when there are no edit/debug signals.
    if [[ ! "$text" =~ (edit|modify|implement|create|write|fix|optimi|refactor|debug|review|verify|test|commit|push|上传|部署|闭环|loop|修改|实现|新增|修复|优化|重构|验证|测试|提交|上线) ]] \
      && [ "$words" -le 18 ]; then
      echo "tiny"
      return
    fi
  fi

  echo "standard"
}

cluster_rank() {
  case "$1" in
    tiny) echo 0 ;;
    standard) echo 1 ;;
    complex) echo 2 ;;
    *) echo -1 ;;
  esac
}

apply_cluster_floor() {
  local current="$1"
  local floor="$2"
  local c_rank
  local f_rank
  c_rank="$(cluster_rank "$current")"
  f_rank="$(cluster_rank "$floor")"
  if [ "$c_rank" -lt 0 ] || [ "$f_rank" -lt 0 ]; then
    echo "$current"
    return
  fi
  if [ "$c_rank" -lt "$f_rank" ]; then
    echo "$floor"
  else
    echo "$current"
  fi
}

is_fresh_artifact() {
  local file="$1"
  local stamp="$2"
  [ -f "$file" ] && [ -s "$file" ] && [ "$file" -nt "$stamp" ]
}

make_blocker_feedback() {
  local target="$1"
  local reason="$2"
  python3 - "$target" "$reason" <<'PY'
import datetime as dt
import json
import os
import sys

out_path = os.path.abspath(os.path.expanduser(sys.argv[1]))
reason = sys.argv[2]
payload = {
    "timestamp": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
    "overall_score": 0.0,
    "grade": "N/A",
    "metrics": {
        "module_coverage": 0.0,
        "yield_ratio": 0.0,
        "reliability": 0.0,
        "freshness_penalty": 0.0,
        "noise_penalty": 0.0,
    },
    "recommendations": [reason, "补齐可评估报告路径后重跑一次闭环。"],
}
os.makedirs(os.path.dirname(out_path), exist_ok=True)
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(payload, f, ensure_ascii=False, indent=2)
print(out_path)
PY
}

OMX_CMD=""
REPORT_JSON=""
GOAL=""
CLUSTER="auto"
FORCE_CLOSE_LOOP="0"
PREFER_STANDARD="0"
OMX_EXEC_STATUS="0"
OMX_EXEC_ERROR=""

if [ "$#" -eq 3 ] && [[ "${1:-}" != --* ]]; then
  OMX_CMD="$1"
  REPORT_JSON="$2"
  GOAL="$3"
else
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --goal)
        GOAL="${2:-}"
        shift 2
        ;;
      --omx)
        OMX_CMD="${2:-}"
        shift 2
        ;;
      --report)
        REPORT_JSON="${2:-}"
        shift 2
        ;;
      --cluster)
        CLUSTER="${2:-}"
        shift 2
        ;;
      --force-close-loop)
        FORCE_CLOSE_LOOP="1"
        shift
        ;;
      --prefer-standard)
        PREFER_STANDARD="1"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown arg: $1" >&2
        usage
        exit 2
        ;;
    esac
  done
fi

if [ -z "$GOAL" ]; then
  echo "Missing --goal (or legacy <goal>)" >&2
  usage
  exit 2
fi

if [ "$CLUSTER" = "auto" ]; then
  CLUSTER="$(detect_cluster "$GOAL" "$OMX_CMD")"
fi

if [[ "$CLUSTER" != "tiny" && "$CLUSTER" != "standard" && "$CLUSTER" != "complex" ]]; then
  echo "Invalid cluster: $CLUSTER (expected tiny|standard|complex|auto)" >&2
  exit 2
fi

if [ "$PREFER_STANDARD" = "1" ]; then
  CLUSTER="$(apply_cluster_floor "$CLUSTER" "standard")"
fi
if [ -n "${OMX_MIN_CLUSTER:-}" ]; then
  CLUSTER="$(apply_cluster_floor "$CLUSTER" "${OMX_MIN_CLUSTER}")"
fi

if [[ "$CLUSTER" != "tiny" && "$CLUSTER" != "standard" && "$CLUSTER" != "complex" ]]; then
  echo "Invalid effective cluster after floor: $CLUSTER (OMX_MIN_CLUSTER=${OMX_MIN_CLUSTER:-})" >&2
  exit 2
fi

mkdir -p .omx/state/skill-feedback .omx/plans
STAMP_FILE="$(mktemp "${TMPDIR:-/tmp}/omx-loop-stamp.XXXXXX")"
trap 'rm -f "$STAMP_FILE"' EXIT
touch "$STAMP_FILE"

if [ -n "$OMX_CMD" ]; then
  set +e
  bash -lc "$OMX_CMD"
  OMX_EXEC_STATUS="$?"
  set -e
  if [ "$OMX_EXEC_STATUS" -ne 0 ]; then
    OMX_EXEC_ERROR="OMX command failed (exit=${OMX_EXEC_STATUS}): ${OMX_CMD}"
  fi
fi

FEEDBACK_FILE=".omx/state/skill-feedback/latest-feedback.json"
BRIEF_FILE=".omx/plans/omx-next-run-brief.md"
OMX_OWNED_LOOP="0"

if [ "$FORCE_CLOSE_LOOP" != "1" ] \
  && is_fresh_artifact "$FEEDBACK_FILE" "$STAMP_FILE" \
  && is_fresh_artifact "$BRIEF_FILE" "$STAMP_FILE"; then
  OMX_OWNED_LOOP="1"
fi

if [ "$CLUSTER" = "tiny" ] \
  && [ "$OMX_OWNED_LOOP" != "1" ] \
  && [ "$FORCE_CLOSE_LOOP" != "1" ] \
  && [ "$OMX_EXEC_STATUS" -eq 0 ]; then
  echo "cluster=tiny loop_owner=codex action=skip_close_loop omx_status=${OMX_EXEC_STATUS} omx_cmd=\"${OMX_CMD}\""
  exit 0
fi

if [ "$OMX_OWNED_LOOP" = "1" ]; then
  echo "cluster=$CLUSTER loop_owner=omx action=reuse_existing_close_loop omx_status=${OMX_EXEC_STATUS} omx_cmd=\"${OMX_CMD}\""
  exit 0
fi

if [ -n "$REPORT_JSON" ] && [ -f "$REPORT_JSON" ]; then
  python3 "$HOME/.codex/skills/omx-cli-default/scripts/omx_feedback_eval.py" \
    --report "$REPORT_JSON" \
    --out "$FEEDBACK_FILE"
else
  if [ "$OMX_EXEC_STATUS" -ne 0 ]; then
    make_blocker_feedback "$FEEDBACK_FILE" "${OMX_EXEC_ERROR}；未检测到本轮可评估报告，已由 Codex 生成阻塞反馈占位。"
  else
    make_blocker_feedback "$FEEDBACK_FILE" "未检测到本轮可评估报告，已由 Codex 生成阻塞反馈占位。"
  fi
fi

python3 "$HOME/.codex/skills/omx-cli-default/scripts/omx_close_loop.py" \
  --feedback "$FEEDBACK_FILE" \
  --goal "$GOAL"

echo "cluster=$CLUSTER loop_owner=codex action=close_loop_completed omx_status=${OMX_EXEC_STATUS} omx_cmd=\"${OMX_CMD}\""
