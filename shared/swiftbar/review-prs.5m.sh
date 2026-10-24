#!/bin/bash
# <xbar.title>Review requests</xbar.title>
# <xbar.desc>Open PRs where my review is requested (directly, not via a team).</xbar.desc>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
#
# SwiftBar plugin (filename sets the 5-minute refresh). Replaces Trailer, whose
# menu won't open on an external display (trailer#506) — useless in clamshell.
# Auth is gh's own token; the query matches Trailer's old setup: review
# requested from me personally, my own PRs excluded by definition.
export PATH="/etc/profiles/per-user/johanhanses/bin:/run/current-system/sw/bin:/usr/bin:/bin"

json=$(gh api -X GET search/issues \
  -f q='is:pr is:open archived:false user-review-requested:@me' \
  -f per_page=50 \
  --jq '{n: .total_count, items: [.items[] | {t: .title, u: .html_url, r: (.repository_url | sub(".*/repos/"; "")), num: .number, by: .user.login}]}' 2>/dev/null)

if [ -z "$json" ]; then
  echo "! | sfimage=arrow.triangle.pull"
  echo "---"
  echo "gh request failed — run gh auth status"
  echo "Refresh | refresh=true"
  exit 0
fi

n=$(jq -r .n <<<"$json")
if [ "$n" -eq 0 ]; then
  echo "| sfimage=arrow.triangle.pull"
else
  echo "$n | sfimage=arrow.triangle.pull"
fi
echo "---"
if [ "$n" -eq 0 ]; then
  echo "No reviews requested"
else
  jq -r '.items[] | "\(.r)#\(.num) \(.t) | href=\(.u) length=70\n-- by \(.by) | href=\(.u)"' <<<"$json"
fi
echo "---"
echo "All review requests | href=https://github.com/pulls/review-requested"
echo "Refresh | refresh=true"
