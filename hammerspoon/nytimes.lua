local function afterClipboardUpdate(lastCount, fn)
  local clipboardHasUpdated = function()
    return lastCount ~= hs.pasteboard.changeCount()
  end

  hs.timer.waitUntil(clipboardHasUpdated, fn, 10 / 1000)
end

local function refreshNytimesSubscription()
  local googleEmail = "dbalatero@gmail.com"
  local lastCount = hs.pasteboard.changeCount()

  -- copy the current article URL
  hs.eventtap.keyStroke({ "cmd" }, "l", 0)
  hs.eventtap.keyStroke({ "cmd" }, "c", 0)

  afterClipboardUpdate(lastCount, function()
    local articleUrl = hs.pasteboard.getContents()

    hs.alert.show("Signing you into " .. articleUrl)

    hs.application.launchOrFocus("Google Chrome")
    hs.eventtap.keyStroke({ "cmd" }, "t", 0)

    hs.timer.doAfter(1, function()
      hs.eventtap.keyStroke({ "cmd" }, "l", 0)
      hs.eventtap.keyStrokes(
        "https://nytimes.com/subscription/promotions/lp3FURL.html?campaignId=7LYRX&gift_code=0fb2197f29d62eee"
      )
      hs.eventtap.keyStroke({}, "return", 0)

      hs.timer.doAfter(1, function()
        -- open dev tools
        hs.eventtap.keyStroke({}, "f12", 0)

        hs.timer.doAfter(1, function()
          -- press the Redeem button
          hs.eventtap.keyStrokes(
            "document.querySelector('.giftRedeem__submitButton').click();"
          )
          hs.eventtap.keyStroke({}, "return", 0)

          hs.timer.doAfter(1, function()
            hs.eventtap.keyStrokes(
              "document.querySelector('[data-testid=google-sso-button]').click();"
            )
            hs.eventtap.keyStroke({}, "return", 0)

            hs.timer.doAfter(3, function()
              hs.eventtap.keyStroke({}, "f12", 0)
              hs.timer.doAfter(2, function()
                hs.eventtap.keyStrokes(
                  "document.querySelector('[role=link][data-identifier=\""
                    .. googleEmail
                    .. "\"').click();"
                )
                hs.eventtap.keyStroke({}, "return", 0)

                hs.alert.show("Returning to article in 5 seconds...")

                hs.timer.doAfter(5, function()
                  hs.eventtap.keyStroke({ "cmd" }, "l", 0)
                  hs.eventtap.keyStrokes(articleUrl)
                  hs.eventtap.keyStroke({}, "return", 0)
                end)
              end)
            end)
          end)
        end)
      end)
    end)
  end)
end

-- hyperKey:bind('n'):toFunction("NYTimes sub", refreshNytimesSubscription)
