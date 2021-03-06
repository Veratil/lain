
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2013, Luke Bonham                     
                                                  
--]]

local helpers      = require("lain.helpers")
local wibox        = require("wibox")
local io           = { open = io.open }
local tonumber     = tonumber
local setmetatable = setmetatable

-- coretemp
-- lain.widgets.temp
local temp = helpers.make_widget_textbox()

local function worker(args)
    local args     = args or {}
    local timeout  = args.timeout or 2
    local tempfile = args.tempfile or "/sys/class/thermal/thermal_zone0/temp"
    local settings = args.settings or function() end

    function update()
        local f = io.open(tempfile)
        if f then
            coretemp_now = tonumber(f:read("*all")) / 1000
            f:close()
        else
            coretemp_now = "N/A"
        end

        widget = temp.widget
        settings()
    end

    helpers.newtimer("coretemp", timeout, update)

    return temp
end

return setmetatable(temp, { __call = function(_, ...) return worker(...) end })
