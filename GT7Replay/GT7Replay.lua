local fontMedium = 'gt7-MyFont Medium'
local fontFolder = 'fonts/'

-- local gtColorRed = rgbm(0.85, 0.1, 0.1, 1)

local function drawTrackInfo(w, h)
  local sim = ac.getSim()
  local trackName = ac.getTrackName()
  local layout = ac.getTrackLayout()

  if layout and layout ~= "" then
    trackName = trackName .. ": " .. layout
  end

  local eventName = ac.getSessionName(sim.currentSessionIndex)
  if not eventName or eventName == "" then
    eventName = "Replay"
  end

  local scale = math.max(0.6, math.min(2, math.min(w, h) / 1080))
  local marginBottom = 50 * scale
  local blockHeight = 100 * scale
  local blockBottom = h - marginBottom
  local blockTop = blockBottom - blockHeight

  local startX = 80 * scale
  local gap = 16 * scale
  local currentX = startX

  local uiFolder = ac.getFolder(ac.FolderID.CurrentTrackLayoutUI)
  local outlinePath = uiFolder .. '/outline.png'
  local hasOutline = io.fileExists(outlinePath)

  if hasOutline then
    local size = blockHeight
    ui.drawImage(outlinePath, vec2(currentX, blockTop), vec2(currentX + size, blockBottom), rgbm.colors.white)
    currentX = currentX + size + gap
  end

  ui.pushDWriteFont(fontFolder .. fontMedium .. '.ttf')
  local textTop = blockTop + 8 * scale
  local lineGap = 6 * scale
  ui.setCursor(vec2(currentX, textTop))
  ui.dwriteText(trackName, 18 * scale, rgbm(0.8, 0.8, 0.8, 1))
  ui.setCursor(vec2(currentX, textTop + 18 * scale + lineGap))
  ui.dwriteText(eventName, 32 * scale, rgbm.colors.white)
  ui.popDWriteFont()
end

local function drawReplayUI()
  ui.forceSimplifiedComposition(true)

  local uiState = ac.getUI()
  local w = uiState.windowSize.x
  local h = uiState.windowSize.y
  drawTrackInfo(w, h)
  -- drawGradient()

  --[[
  local barMargin = 100
  local barHeight = h - 100
  local barWidth = w - (barMargin * 2)

  local totalFrames = sim.replayFrames
  local currentFrame = sim.replayCurrentFrame
  local progress = 0
  if totalFrames > 0 then
    progress = currentFrame / totalFrames
  end
  ui.drawLine(vec2(barMargin, barHeight), vec2(w - barMargin, barHeight), rgbm(1, 1, 1, 0.3), 4)

  local currentX = barMargin + (barWidth * progress)
  ui.drawLine(vec2(barMargin, barHeight), vec2(currentX, barHeight), rgbm.colors.white, 4)
  ui.drawCircleFilled(vec2(currentX, barHeight), 6, gtColorRed)
  ]]
end

ui.onExclusiveHUD(function(mode)
  if mode ~= 'replay' then
    return
  end
  drawReplayUI()
  return 'apps'
end)

function script.update(dt)
end

function script.windowMain(dt)
end
