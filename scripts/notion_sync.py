#!/usr/bin/env python3
"""Sync a merged GitHub PR to the Notion Tasks database.

Local use (after merging):   python3 scripts/notion_sync.py --pr 12
GitHub Actions use:          reads the PR from $GITHUB_EVENT_PATH (no flag needed)

PR title:        TASK-NN: Title
PR description:  "Closes TASK-NN" -> Status Done, Done checked, Completed on set, PR link set
                 "Ref TASK-NN"    -> PR link only

Token: $NOTION_TOKEN, or the macOS Keychain item "notion-sync".
Local mode needs the GitHub CLI (`gh`) signed in. Standard library only.
"""
import argparse
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from datetime import datetime
from zoneinfo import ZoneInfo

API = "https://api.notion.com/v1"
NOTION_VERSION = "2022-06-28"
LOCAL_TZ = ZoneInfo("America/Chicago")
DEFAULT_DB_ID = "26413914-6cd2-4c4f-9e7f-33a7a935173e"  # Second Brain 2.0 / Databases / Tasks


def get_token():
    """Return the Notion token from the environment, else the macOS Keychain."""
    token = os.environ.get("NOTION_TOKEN")
    if token:
        return token
    try:
        result = subprocess.run(
            ["security", "find-generic-password", "-s", "notion-sync", "-w"],
            capture_output=True, text=True, check=True,
        )
    except (FileNotFoundError, subprocess.CalledProcessError):
        sys.exit(
            "No Notion token found. Set NOTION_TOKEN, or store it once with:\n"
            "  security add-generic-password -a \"$USER\" -s notion-sync -w"
        )
    return result.stdout.strip()


def notion(method, path, body=None):
    """Call the Notion API and return the parsed JSON response."""
    req = urllib.request.Request(
        f"{API}{path}",
        method=method,
        data=json.dumps(body).encode() if body is not None else None,
        headers={
            "Authorization": f"Bearer {get_token()}",
            "Notion-Version": NOTION_VERSION,
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req) as resp:
            return json.load(resp)
    except urllib.error.HTTPError as err:
        sys.exit(f"Notion API error {err.code} on {method} {path}: {err.read().decode()}")


def load_pr(pr_number):
    """Return the PR as {merged, title, body, merged_at, url}.

    Uses `gh` when a PR number is given, otherwise the GitHub Actions event file.
    """
    if pr_number is not None:
        result = subprocess.run(
            ["gh", "pr", "view", str(pr_number),
             "--json", "title,body,state,mergedAt,url"],
            capture_output=True, text=True,
        )
        if result.returncode != 0:
            sys.exit(f"gh could not read PR {pr_number}: {result.stderr.strip()}")
        data = json.loads(result.stdout)
        return {
            "merged": data["state"] == "MERGED",
            "title": data["title"],
            "body": data["body"],
            "merged_at": data["mergedAt"],
            "url": data["url"],
        }

    event_path = os.environ.get("GITHUB_EVENT_PATH")
    if not event_path:
        sys.exit("Pass --pr <number>, or run inside GitHub Actions.")
    with open(event_path) as f:
        pr = json.load(f)["pull_request"]
    return {
        "merged": bool(pr.get("merged")),
        "title": pr["title"],
        "body": pr["body"],
        "merged_at": pr.get("merged_at"),
        "url": pr["html_url"],
    }


def parse_task_ids(title, body):
    """Return (closes, refs): sets of task numbers named in the PR."""
    body = body or ""
    closes = {int(n) for n in re.findall(r"\bCloses\s+TASK-(\d+)\b", body, re.I)}
    refs = {int(n) for n in re.findall(r"\bRef\s+TASK-(\d+)\b", body, re.I)}
    if not closes and not refs:
        # Fall back to the title and treat it as link-only, the safe choice.
        match = re.match(r"\s*TASK-(\d+)\b", title or "", re.I)
        if match:
            refs.add(int(match.group(1)))
    return closes, refs - closes


def find_task_page(task_number):
    """Look up the Tasks row whose auto ID equals task_number."""
    db_id = os.environ.get("NOTION_TASKS_DB_ID", DEFAULT_DB_ID)
    result = notion(
        "POST",
        f"/databases/{db_id}/query",
        {"filter": {"property": "ID", "unique_id": {"equals": task_number}}},
    )
    if not result["results"]:
        sys.exit(f"No Notion task found with ID {task_number}")
    return result["results"][0]["id"]


def main():
    parser = argparse.ArgumentParser(description="Sync a merged PR to Notion.")
    parser.add_argument("--pr", type=int, help="PR number (local mode, uses gh)")
    args = parser.parse_args()

    pr = load_pr(args.pr)
    if not pr["merged"]:
        print("PR is not merged; nothing to sync.")
        return

    closes, refs = parse_task_ids(pr["title"], pr["body"])
    if not closes and not refs:
        print("No TASK-NN reference found in title or description; nothing to sync.")
        return

    merged_utc = datetime.fromisoformat(pr["merged_at"].replace("Z", "+00:00"))
    completed_on = merged_utc.astimezone(LOCAL_TZ).date().isoformat()

    for number in sorted(closes | refs):
        page_id = find_task_page(number)
        properties = {"PR": {"url": pr["url"]}}
        if number in closes:
            properties["Status"] = {"status": {"name": "Done"}}
            properties["Done"] = {"checkbox": True}
            properties["Completed on"] = {"date": {"start": completed_on}}
        notion("PATCH", f"/pages/{page_id}", {"properties": properties})
        action = "closed" if number in closes else "linked"
        print(f"TASK-{number} {action}: {pr['url']}")


if __name__ == "__main__":
    main()
