#!/usr/bin/env python3
"""
Grab the claude.ai sessionKey cookie from Firefox (or a Chromium browser)
and update ~/.claude/statusline-config.sh.

Supports: Firefox, Chrome, Arc, Brave, Edge (macOS only)

Usage:
    ~/.claude/refresh-session.py          # update config
    ~/.claude/refresh-session.py --dry-run # just print the cookie
"""

import glob
import hashlib
import os
import re
import shutil
import sqlite3
import subprocess
import sys
import tempfile

CONFIG_FILE = os.path.expanduser("~/.claude/statusline-config.sh")


# --- Firefox ---

def find_firefox_db():
    """Find the Firefox cookies.sqlite for the default profile."""
    profiles_dir = os.path.expanduser("~/Library/Application Support/Firefox/Profiles")
    # Try default-release first, then any profile
    for pattern in ["*.default-release", "*.default", "*"]:
        matches = glob.glob(os.path.join(profiles_dir, pattern, "cookies.sqlite"))
        if matches:
            return matches[0]
    return None


def get_firefox_cookie():
    """Read the sessionKey cookie from Firefox (stored in plaintext)."""
    db_path = find_firefox_db()
    if not db_path:
        return None

    print("Reading cookies from Firefox...")
    tmp_dir, tmp_db = copy_db(db_path)
    try:
        conn = sqlite3.connect(tmp_db)
        row = conn.execute(
            "SELECT value FROM moz_cookies "
            "WHERE host LIKE '%claude.ai' AND name = 'sessionKey'"
        ).fetchone()
        conn.close()
    finally:
        shutil.rmtree(tmp_dir)

    if not row or not row[0]:
        return None
    return row[0]


# --- Chromium browsers (fallback) ---

CHROMIUM_BROWSERS = [
    ("Chrome", "Chrome", "~/Library/Application Support/Google/Chrome"),
    ("Arc", "Arc", "~/Library/Application Support/Arc/User Data"),
    ("Brave", "Brave Browser", "~/Library/Application Support/BraveSoftware/Brave-Browser"),
    ("Edge", "Microsoft Edge", "~/Library/Application Support/Microsoft Edge"),
]

CHROMIUM_COOKIE_PATHS = [
    "Default/Cookies",
    "Default/Network/Cookies",
    "Profile 1/Cookies",
    "Profile 1/Network/Cookies",
]


def find_chromium_db():
    for name, keychain_svc, base_path in CHROMIUM_BROWSERS:
        base = os.path.expanduser(base_path)
        for rel in CHROMIUM_COOKIE_PATHS:
            db_path = os.path.join(base, rel)
            if os.path.exists(db_path):
                return name, keychain_svc, db_path
    return None, None, None


def get_chromium_cookie():
    browser, keychain_svc, db_path = find_chromium_db()
    if not db_path:
        return None

    print(f"Reading cookies from {browser}...")
    tmp_dir, tmp_db = copy_db(db_path)
    try:
        conn = sqlite3.connect(tmp_db)
        row = conn.execute(
            "SELECT encrypted_value FROM cookies "
            "WHERE host_key LIKE '%claude.ai' AND name = 'sessionKey'"
        ).fetchone()
        conn.close()
    finally:
        shutil.rmtree(tmp_dir)

    if not row or not row[0]:
        return None

    # Decrypt
    try:
        pwd = subprocess.check_output(
            ["security", "find-generic-password", "-w", "-s", f"{browser} Safe Storage"],
            stderr=subprocess.DEVNULL,
        ).strip()
    except subprocess.CalledProcessError:
        print(f"Could not read '{browser} Safe Storage' from Keychain.", file=sys.stderr)
        return None

    key = hashlib.pbkdf2_hmac("sha1", pwd, b"saltysalt", 1003, dklen=16)
    encrypted = row[0]

    if not encrypted.startswith(b"v10"):
        return encrypted.decode("utf-8", errors="replace")

    proc = subprocess.run(
        ["openssl", "enc", "-aes-128-cbc", "-d", "-K", key.hex(), "-iv", "0" * 32],
        input=encrypted[3:],
        capture_output=True,
    )
    if proc.returncode != 0:
        return None
    return proc.stdout.decode("utf-8")


# --- Shared helpers ---

def copy_db(db_path):
    """Copy the DB (and WAL/SHM) to avoid browser locks."""
    tmp_dir = tempfile.mkdtemp()
    dst = os.path.join(tmp_dir, os.path.basename(db_path))
    shutil.copy2(db_path, dst)
    for suffix in ("-wal", "-shm"):
        src = db_path + suffix
        if os.path.exists(src):
            shutil.copy2(src, dst + suffix)
    return tmp_dir, dst


def update_config(session_key):
    cookie = f"sessionKey={session_key}"

    if not os.path.exists(CONFIG_FILE):
        print(f"Config not found: {CONFIG_FILE}", file=sys.stderr)
        sys.exit(1)

    with open(CONFIG_FILE, "r") as f:
        content = f.read()

    content = re.sub(
        r'CLAUDE_SESSION_COOKIE=".*"',
        f'CLAUDE_SESSION_COOKIE="{cookie}"',
        content,
    )

    with open(CONFIG_FILE, "w") as f:
        f.write(content)

    print(f"Updated {CONFIG_FILE}")


def main():
    dry_run = "--dry-run" in sys.argv

    # Try Firefox first, then Chromium browsers
    session_key = get_firefox_cookie()
    if not session_key:
        session_key = get_chromium_cookie()
    if not session_key:
        print("No sessionKey cookie found for claude.ai in any browser.", file=sys.stderr)
        print("Make sure you're logged into claude.ai.", file=sys.stderr)
        sys.exit(1)

    if dry_run:
        print(f"\nsessionKey={session_key}")
    else:
        update_config(session_key)
        print("Done! Usage data should appear on the next statusline refresh.")


if __name__ == "__main__":
    main()
