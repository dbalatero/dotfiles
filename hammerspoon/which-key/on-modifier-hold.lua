local function onModifierHold(modifiers, timeoutMs, onHold, onRelease)
  local state = {
    held = false,
    holdTimer = nil,
    onHold = onHold,
    onRelease = onRelease,
    tap = nil,
  }

  local cancelTimer = function()
    if not state.holdTimer then
      return
    end

    state.holdTimer:stop()
    state.holdTimer = nil
  end

  -- This event fires whenever the modifier keys changed.
  -- In eventtap's world, modifiers are called "flags", because each
  -- key (cmd, alt, etc) gets a flag bit set to 0 or 1 depending if
  -- it is held or not.
  state.tap = hs.eventtap.new(
    { hs.eventtap.event.types.flagsChanged },
    -- Whenever the modifier keys change, this function will be fired
    -- by the event tap.
    function(event)
      local containsFlags = event:getFlags():containExactly(modifiers)

      if state.held then
        -- The `modifiers` are currently being held, so we're just waiting for
        -- the user to release them.
        --
        -- If the modifiers are not held any more, then we want to set `held`
        -- to `false` and fire `onRelease()`.
        if not containsFlags then
          state.held = false
          onRelease()
          cancelTimer()
        end
      elseif state.holdTimer then
        -- We are waiting for the timeout timer to fire, so we're somewhere
        -- between 0ms and `timeoutMs`.
        if not containsFlags then
          -- If the modifiers aren't held down anymore, we can go ahead and
          -- cancel our timer.
          cancelTimer()
        end
      elseif containsFlags then
        -- If you're in this block, the user *just* held down the modifier keys.
        -- However, the clock is at 0ms at this point.
        --
        -- We need to wait for `timeoutMs` before actually firing `onHold()`.
        --
        -- To achieve this, we can schedule a timer to fire a
        -- callback in `timeoutMs`. Once that time is hit, we'll flip `held`
        -- to `true` and fire `onHold()`.
        state.holdTimer = hs.timer.doAfter(timeoutMs / 1000, function()
          state.held = true
          onHold()
        end)
      end

      -- By returning `false` in this tap, you're making sure that key presses
      -- are still allowed to pass through to programs.
      --
      -- If you *don't* return true the keyboard will just stop working haha...
      return false
    end
  )

  -- You need to start the event tap or it won't work :)
  state.tap:start()

  return state.tap
end

return onModifierHold
