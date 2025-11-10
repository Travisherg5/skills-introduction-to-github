#!/usr/bin/env bash
set -euo pipefail

DEFAULT_CACHE_DIR="/Users/haze/Library/Caches"

dry_run=false
cache_dir="$DEFAULT_CACHE_DIR"

print_usage() {
  cat <<'USAGE'
Usage: clear_cache.sh [options]

Options:
  -p, --path DIR   Cache directory to clean (defaults to /Users/haze/Library/Caches)
  -n, --dry-run    Show what would be deleted without removing anything
  -h, --help       Display this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--path)
      if [[ $# -lt 2 ]]; then
        echo "Error: --path requires a directory argument" >&2
        exit 1
      fi
      cache_dir="$2"
      shift 2
      ;;
    -n|--dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option $1" >&2
      print_usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "$cache_dir" ]]; then
  echo "Error: Cache directory '$cache_dir' does not exist" >&2
  exit 1
fi

if [[ "$cache_dir" == "/" ]]; then
  echo "Error: Refusing to operate on the root directory" >&2
  exit 1
fi

if [[ "$dry_run" == true ]]; then
  echo "[dry-run] The following items would be removed from $cache_dir:"
  find "$cache_dir" -mindepth 1 -maxdepth 1
  exit 0
fi

find "$cache_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

echo "Cleared cache contents in '$cache_dir'."
