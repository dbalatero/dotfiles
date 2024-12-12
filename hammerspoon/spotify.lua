local function openRemoteSpotify()
  hs.timer.doAfter(0, function()
    local cmd = "/usr/bin/ssh sorny.local 'open -a Spotify'"

    hs.execute(cmd)
    hs.alert('Opened Spotify on desktop')
  end)
end

hyperKey:bind('6'):toFunction('Open Spotify on desktop', openRemoteSpotify)

-- Spotify next/prev/play/pause
hyperKey:bind('←', 'left'):toFunction('Previous song', hs.spotify.previous)
hyperKey:bind('→', 'right'):toFunction('Next song', hs.spotify.next)
hyperKey:bind('_', 'space'):toFunction('Play/pause', hs.spotify.playpause)
