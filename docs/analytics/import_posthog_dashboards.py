#!/usr/bin/env python3
"""Creates the PostHog dashboards of posthog_dashboards.json, skipping existing names.
See docs/analytics/README.md for the API key scopes and the usage."""

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path

DEFINITION = Path(__file__).with_name("posthog_dashboards.json")


def request(method, url, key, body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {key}")
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read() or b"{}")
    except urllib.error.HTTPError as error:
        sys.exit(f"{method} {url} failed ({error.code}): {error.read().decode()}")


def existing_dashboards(base, key):
    names, url = set(), f"{base}/dashboards/?limit=200"
    while url:
        page = request("GET", url, key)
        names.update(d["name"] for d in page.get("results", []) if not d.get("deleted"))
        url = page.get("next")
    return names


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--project", required=True, help="PostHog project id (Settings > Project)")
    parser.add_argument("--host", default="https://eu.posthog.com", help="App host, not the ingestion host")
    parser.add_argument("--dry-run", action="store_true", help="Print what would be created")
    args = parser.parse_args()

    key = os.environ.get("POSTHOG_PERSONAL_API_KEY")
    if not key and not args.dry_run:
        sys.exit("Set POSTHOG_PERSONAL_API_KEY first.")

    definition = json.loads(DEFINITION.read_text(encoding="utf-8"))
    base = f"{args.host.rstrip('/')}/api/projects/{args.project}"
    already = set() if args.dry_run else existing_dashboards(base, key)

    for dashboard in definition["dashboards"]:
        if dashboard["name"] in already:
            print(f"= {dashboard['name']} (exists, skipped)")
            continue
        print(f"+ {dashboard['name']}")
        if args.dry_run:
            for insight in dashboard["insights"]:
                print(f"    - {insight['name']}")
            continue

        created = request("POST", f"{base}/dashboards/", key, {
            "name": dashboard["name"],
            "description": dashboard["description"],
            "tags": ["nanimo"],
        })
        for insight in dashboard["insights"]:
            request("POST", f"{base}/insights/", key, {
                "name": insight["name"],
                "description": insight["description"],
                "query": insight["query"],
                "dashboards": [created["id"]],
            })
            print(f"    - {insight['name']}")

    print("Done.")


if __name__ == "__main__":
    main()
