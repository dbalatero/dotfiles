# Pipe to tee so we can get the git push output as well
git push --force-with-lease | tee /dev/tty | {
  # Capture the output and process it within a single block
  urls=$(grep -o 'https://git\.corp\.stripe\.com/[^/]*/[^/]*/pull/new/[^"]*' || true)

  # Check if any URLs were found
  if [[ -n "$urls" ]]; then
    # Open each URL found
    echo "$urls" | while IFS= read -r url; do
      if open "$url"; then
        echo "Opened submit URL: $url"
      else
        echo "Failed to open submit URL: $url"
      fi
    done
  else
    echo 'No pull request URL found; skipping submission.'
  fi
}
