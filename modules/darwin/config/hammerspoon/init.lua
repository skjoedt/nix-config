local hyper = { "cmd", "alt", "ctrl" }
local hyperDown = false
local aerospace = "/Users/skjoedt/.nix-profile/bin/aerospace"

local f18 = 79
local arrows = {
  [123] = "left",
  [124] = "right",
  [126] = "up",
  [125] = "down",
}

local mappedKeys = {
  [29] = true,
  [18] = true,
  [19] = true,
  [20] = true,
  [21] = true,
  [23] = true,
  [22] = true,
  [26] = true,
  [28] = true,
  [25] = true,

  [0] = true,
  [11] = true,
  [14] = true,
  [3] = true,
  [5] = true,
  [38] = true,
  [37] = true,
  [46] = true,
  [45] = true,
  [15] = true,
  [1] = true,
  [17] = true,
  [13] = true,

  [123] = true,
  [124] = true,
  [126] = true,
  [125] = true,

  [36] = true,
  [49] = true,
  [48] = true,
  [50] = true,
  [27] = true,
  [24] = true,
  [41] = true,
  [44] = true,
}

local function hasHyper(flags)
  return flags.cmd and flags.alt and flags.ctrl
end

local function runAerospace(args)
  hs.task.new(aerospace, nil, args):start()
end

local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(event)
  local keyCode = event:getKeyCode()
  local eventType = event:getType()
  local isDown = eventType == hs.eventtap.event.types.keyDown

  if keyCode == f18 then
    hyperDown = isDown
    return true
  end

  local flags = event:getFlags()
  local arrow = arrows[keyCode]
  -- AeroSpace doesn't reliably receive mutated arrow events, so invoke it directly.
  if hyperDown and arrow then
    if isDown then
      if flags.shift then
        runAerospace({ "move", arrow })
      else
        runAerospace({ "focus", arrow })
      end
    end
    return true
  end

  if hyperDown and mappedKeys[keyCode] and not hasHyper(flags) then
    event:setFlags({
      cmd = true,
      alt = true,
      ctrl = true,
      shift = flags.shift,
    })
    return false
  end

  return false
end)

tap:start()
