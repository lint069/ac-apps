local colors = require 'colors'

--#region Drawing Functions

local function drawBackground()
    ui.drawRectFilled(vec2(0, 0), ui.windowSize(), colors.background)
end

local laststring = ''
local laststatus = ''
local allstr = ''
local function drawDebugText()
    local windowSize = ui.windowSize()
    local loadingStatus ---@type ui.ExtraCanvas

    if not loadingStatus or loadingStatus:size().x ~= windowSize.x then
        loadingStatus = ui.ExtraCanvas(vec2(windowSize.x, windowSize.y))
    end

    loadingStatus:clear(rgbm.colors.transparent):update(function()
        local status = loading.status()
        local details = loading.details()

        if status and status ~= laststatus and status ~= '' and
           details and details ~= laststring and details ~= ''
        then
			if status and status ~= '' and status ~= laststatus then
				if laststatus ~= nil then
					allstr = allstr .. '\n'
				end

				laststatus = status
			end

            if details and details ~= laststring and details ~= '' then
                laststring = details
                if string.len(laststatus) > 12 then
                    allstr = allstr .. status .. '\n\t' .. details .. '\n'
                else
                    allstr = allstr .. status .. '\t' .. details .. '\n'
                end
            else
                allstr = allstr .. status .. '\n'
            end
        else
            if details and details ~= laststring and details ~= '' then
                laststring = details
                allstr = allstr .. '\t' .. details .. '\n'
            end
        end
    end)

	local spinnerPos = 20
    local spinnerSize = 34
	ui.drawLoadingSpinner(spinnerPos, spinnerPos + spinnerSize)

	ui.offsetCursorY(20)
	ui.offsetCursorX(100)
	ui.dwriteText(loading.status(), 22, colors.statusText)

	ui.setCursorX(100)
	ui.dwriteText(allstr, 14, colors.detailsText)

	if ui.getCursorY() > windowSize.y - 32 then
		allstr = string.sub(allstr, string.find(allstr, '\n') + 1)
	end

    ui.drawImage(loadingStatus, vec2(0, 0), loadingStatus:size())
end

local function drawProgressBar()
    -- ui.beginTextureShade('splashscreen::background')
    local windowSize = ui.windowSize()
    ui.drawRectFilled(vec2(0, 0), vec2(windowSize.x * loading.progress(), windowSize.y), colors.progressBarForeground)
    -- ui.endTextureShade(vec2(0, 0), ui.windowSize())
end

--#endregion

--#region Main

function script.update()
    drawBackground()
    drawProgressBar()
    drawDebugText()
end

--#endregion