#!/usr/bin/bash
# Regenerates verify-iso-sig.pot from the CLI and GUI scripts' own
# gettext()/eval_gettext() calls plus verify-iso-sig.desktop.in's own
# Name=/Comment=/Keywords= fields, then merges any new/changed strings
# into every existing per-language .po (msgmerge preserves already-
# translated entries, marking changed ones "fuzzy" for review - never
# overwrites a translation outright).
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR/.."

# --keyword=safe_eval_gettext is required, not optional: xgettext's Shell
# backend only recognizes a fixed built-in list of extraction keywords
# (gettext/ngettext/eval_gettext/eval_ngettext) by default
xgettext --language=Shell --from-code=UTF-8 --add-comments=TRANSLATORS: \
    --keyword=safe_eval_gettext \
    --package-name=verify-iso-sig \
    -o po/verify-iso-sig.pot verify-iso-sig-gui.sh verify-iso-sig


xgettext --join-existing --language=Desktop \
    -o po/verify-iso-sig.pot verify-iso-sig.desktop.in

for po in po/*.po; do
    [ -e "$po" ] || continue
    msgmerge --update --backup=off "$po" po/verify-iso-sig.pot
done
