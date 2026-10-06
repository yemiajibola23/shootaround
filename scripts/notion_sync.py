#!/usr/bin/env python3
"""Sync a merged GitHub PR to the Notion Tasks database.

Runs from .github/workflows/notion-sync.yml when a PR is merged.

PR title:        TASK-NN: Title
PR description:  "Closes TASK-NN" -> Status Done, Done checked, Completed on set, PR link set
                 "Ref TASK-NN"    -> PR link only

Standard library only, so the workflow needs no pip install.
Env: NOTION_TOKEN, NOTION_TASKS_DB_ID, GITHUB_EVENT_PATH (set by GitHub Actions).
"""
import json
import os
import re
import sys
import urllib.error
import urllib.request
from datetime import datetime
from zoneinfo import ZoneInfo

API = "https://api.notion.com/v1"
NOTION_VERSION = "2022-06-28"
LOCAL_TZ = ZoneInfo("America/Chicago")


def notion(method, path, body=None):
    """Call the Notion API and return the parsed JSON response."""
    req = urllib.request.Request(
        f"{API}{path}",
        method=method,
        data=json.dumps(body).encode() if body is not None else None,
        headers={
            "Authorization": f"Bearer {os.environ['NOTION_TOKEN']}",
            "Notion-Version": NOTION_VERSION,
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req) as resp:
            return json.load(resp)
    except urllib.error.HTTPError as err:
        sys.exit(f"Notion API error {err.code} on {method} {path}: {err.read().decode()}")


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
    result = notion(
        "POST",
        f"/databases/{os.environ['NOTION_TASKS_DB_ID']}/query",
        {"filter": {"property": "ID", "unique_id": {"equals": task_number}}},
    )
    if not result["results"]:
        sys.exit(f"No Notion task found with ID {task_number}")
    return result["results"][0]["id"]


def main():
    with open(os.environ["GITHUB_EVENT_PATH"]) as f:
        pr = json.load(f)["pull_request"]

    if not pr.get("merged"):
        print("PR closed without merging; nothing to sync.")
        return

    closes, refs = parse_task_ids(pr["title"], pr["body"])
    if not closes and not refs:
        print("No TASK-NN reference found in title or description; nothing to sync.")
        return

    merged_utc = datetime.fromisoformat(pr["merged_at"].replace("Z", "+00:00"))
    completed_on = merged_utc.astimezone(LOCAL_TZ).date().isoformat()

    for number in sorted(closes | refs):
        page_id = find_task_page(number)
        properties = {"PR": {"url": pr["html_url"]}}
        if number in closes:
            properties["Status"] = {"status": {"name": "Done"}}
            properties["Done"] = {"checkbox": True}
            properties["Completed on"] = {"date": {"start": completed_on}}
        notion("PATCH", f"/pages/{page_id}", {"properties": properties})
        action = "closed" if number in closes else "linked"
        print(f"TASK-{number} {action}: {pr['html_url']}")


if __name__ == "__main__":
    main()
