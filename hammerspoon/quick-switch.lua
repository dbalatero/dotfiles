hyperKey
  :bind("1")
  :toApplication("/Applications/1Password 7.app")
  :bind("a")
  :toApplication("/Applications/Slack.app")
  :bind("c")
  :toApplication("/Applications/Google Chrome.app")
  :bind("l")
  :toApplication(
    os.getenv("HOME")
      .. "/Applications/Chrome Apps.localized/Google Calendar.app"
  )
  :bind("s")
  :toApplication("/Applications/Spotify.app")
  :bind("t")
  :toApplication("/Applications/Ghostty.app")
