#!/bin/bash
set -e

DOCKERFILES=$1
IMAGES=$2
SCAN=$3
REWRITE=$4
FAIL_ON_CRITICAL=$5
SEVERITY=$6
SUMMARY=$7

mkdir -p /app/.artifact_scan
echo "::group::🔍 Starting Docker Image Hardener..."

if [[ "$DOCKERFILES" != "" ]]; then
  IFS=',' read -ra FILES <<< "$DOCKERFILES"
  for FILE in "${FILES[@]}"; do
    echo "::group::🔎 Analyzing Dockerfile: $FILE"
    ARGS="$FILE"
    [[ "$SCAN" == "true" ]] && ARGS="$ARGS --scan"
    [[ "$REWRITE" == "true" ]] && ARGS="$ARGS --rewrite"
    [[ "$FAIL_ON_CRITICAL" == "true" ]] && ARGS="$ARGS --fail-on-critical"
    [[ "$SEVERITY" != "" ]] && ARGS="$ARGS --severity $SEVERITY"
    [[ "$SUMMARY" == "true" ]] && ARGS="$ARGS --summary"
    python3 /app/cli/main.py $ARGS
    echo "::endgroup::"
  done
fi

if [[ "$IMAGES" != "" ]]; then
  IFS=',' read -ra IMAGE_LIST <<< "$IMAGES"
  for IMG in "${IMAGE_LIST[@]}"; do
    echo "::group::🛡️ Scanning image: $IMG"
    ARGS="--scan-image $IMG"
    [[ "$FAIL_ON_CRITICAL" == "true" ]] && ARGS="$ARGS --fail-on-critical"
    [[ "$SEVERITY" != "" ]] && ARGS="$ARGS --severity $SEVERITY"
    [[ "$SUMMARY" == "true" ]] && ARGS="$ARGS --summary"
    python3 /app/cli/main.py $ARGS
    echo "::endgroup::"
  done
fi

echo "::endgroup::"

# 🚀 Post PR Comment if summary and running in a PR
if [[ "$SUMMARY" == "true" && "$GITHUB_EVENT_NAME" == "pull_request" ]]; then
  echo "::group::📣 Posting PR comment..."
  python3 /app/cli/post_pr_comment.py
  echo "::endgroup::"
fi