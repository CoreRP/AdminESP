-- Localizing this stuff makes it go fast!
local math      = math
local string    = string
local cam       = cam
local table     = table

AESP = AESP or {}
AESP.Config = AESP.Config or {}

-- Enable/disable the ESP
AESP.Config.Enabled     = CreateClientConVar("aesp_enabled", "0" , false, false)
-- Set the max draw distance
AESP.Config.MaxDistance = CreateClientConVar("aesp_maxdistance", "8192", true, false)

-- Set the text offset in the y direction
AESP.Config.TextOffsetY = CreateClientConVar("aesp_offsety", "85" , true, false)

-- Draw the target's model, visible through the world
AESP.Config.ShowModel   = CreateClientConVar("aesp_drawmodel", "0", true, false)

-- Draw the target's name
AESP.Config.ShowName    = CreateClientConVar("aesp_drawname", "1", true, false)
-- Draw the target's Steam ID
AESP.Config.ShowSteamID = CreateClientConVar("aesp_drawsteamid", "1", true, false)
-- Draw the target's ping
AESP.Config.ShowPing    = CreateClientConVar("aesp_drawping", "0", true, false)
-- Draw the target's health
AESP.Config.ShowHealth  = CreateClientConVar("aesp_drawhealth", "0", true, false)
-- Draw the target's armor
AESP.Config.ShowArmor   = CreateClientConVar("aesp_drawarmor", "0", true, false)
-- Draw the target's group (i.e. ULX)
AESP.Config.ShowGroup   = CreateClientConVar("aesp_drawgroup", "0", true, false)
-- DarkRP Only
-- Draw the target's job
AESP.Config.ShowJob     = CreateClientConVar("aesp_darkrp_drawjob", "0", true, false)
-- Draw the target's money
AESP.Config.ShowMoney   = CreateClientConVar("aesp_darkrp_drawmoney", "0", true, false)
-- TTT only
-- Draw the target's role (i.e. Traitor, Innocent, Detective)
AESP.Config.ShowRole    = CreateClientConVar("aesp_ttt_drawrole", "0", true, false)

-- Use this command to get the name of your custom gamemode if you want to add more
-- text drawing methods specific to that gamemode.
concommand.Add("aesp_getgamemode", 
    function()
        print(string.lower(gmod.GetGamemode().Name))
    end
)

surface.CreateFont("aesp_font", {
   font         = "Arial",
   size         = 15,
   weight       = 50,
   antialias    = true
})

local function DrawText(text, color, x, y)
    local textWidth, _ = draw.SimpleTextOutlined(text, "aesp_font", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
    return textWidth
end

local function CalculateTextHeight()
    local totalHeight = 0
    local gamemodeName = string.lower(gmod.GetGamemode().Name)

    if AESP.Config.ShowName:GetBool() then      totalHeight = totalHeight + 13 end
    if AESP.Config.ShowSteamID:GetBool() then   totalHeight = totalHeight + 13 end
    if AESP.Config.ShowPing:GetBool() then      totalHeight = totalHeight + 13 end
    if AESP.Config.ShowHealth:GetBool() then    totalHeight = totalHeight + 13 end
    if AESP.Config.ShowArmor:GetBool() then     totalHeight = totalHeight + 13 end
    if AESP.Config.ShowGroup:GetBool() then     totalHeight = totalHeight + 13 end
    if gamemodeName == "darkrp" then
        if AESP.Config.ShowJob:GetBool() then   totalHeight = totalHeight + 13 end
        if AESP.Config.ShowMoney:GetBool() then totalHeight = totalHeight + 13 end
    end
    if AESP.Config.ShowRole:GetBool() and gamemodeName == "trouble in terrorist town" then totalHeight = totalHeight + 13 end

    if totalHeight ~= 0 then
        return totalHeight
    else
        return false
    end
end

local function CalculateMaxTextWidth(stringArray)
    surface.SetFont("aesp_font")
    local maxWidth = 0
    
    for _, checkString in pairs(stringArray) do
        w, h = surface.GetTextSize(checkString)
        if w > maxWidth then maxWidth = w end
    end

    -- change 6 to whatever number you want for nice padding
    return maxWidth + 10
end

local function DrawTextESP(target)
    -- Don't do anything if totalheight is false 
    -- (i.e. none of the aesp_draw flags are enabled)
    if not CalculateTextHeight() then return end
    
    -- darkrp, terrortown, sandbox, murder, etc
    local gamemodeName = string.lower(gmod.GetGamemode().Name)

    -- Where to draw the text in relation to the target
    local textPosition = (target:GetPos() + Vector(0, 0, AESP.Config.TextOffsetY:GetInt())):ToScreen()
    -- Calculate the height of all the enabled lines
    local totalHeight = CalculateTextHeight()
    -- line offset is incremented with each enabled flag so text doesn't overlap
    local nextLineOffset = 1
    -- the color of the text
    local textColor = color_white

    -- Create an array of every bit of text we'd like to draw
    local infoArray = {}

    -- insert all our strings into infoArray
    if AESP.Config.ShowName:GetBool() then
        table.insert(infoArray, "Name: " .. target:Nick())
    end
    if AESP.Config.ShowSteamID:GetBool() then
        table.insert(infoArray, "SteamID: " .. target:SteamID())
    end
    if AESP.Config.ShowPing:GetBool() then
        table.insert(infoArray, "Ping: " .. target:Ping())
    end
    if AESP.Config.ShowHealth:GetBool() then
        table.insert(infoArray, "Health: " .. target:Health())
    end
    if AESP.Config.ShowArmor:GetBool() then
        table.insert(infoArray, "Armor: " .. target:Armor())
    end
    if AESP.Config.ShowGroup:GetBool() then
        table.insert(infoArray, "Usergroup: " .. target:GetNWString("usergroup"))
    end
    -- DarkRP-specific draw commands
    if gamemodeName == "darkrp" then
        if AESP.Config.ShowJob:GetBool() then
            table.insert(infoArray, "Job: " .. team.GetName(target:Team()))
        end
        if AESP.Config.ShowMoney:GetBool() then
            table.insert(infoArray, "$" .. target:getDarkRPVar("money"))
        end
    -- TTT-specific draw commands
    elseif gamemodeName == "trouble in terrorst town" then
        if AESP.Config.ShowRole:GetBool() then
            -- Find the name of the team the target's on
            local roleText = ""
            if target:IsTraitor() then
                roleText = "Traitor"
            elseif target:IsDetective() then
                roleText = "Detective"
            else
                roleText = "Innocent"
            end
            -- Insert the value
            table.insert(infoArray, "Role:" .. roleText)
        end
    end

    -- Find the maximum width (i.e. the width our background will be)
    local maxWidth = CalculateMaxTextWidth(infoArray)

    -- Create a background for our text so it doesn't get hard to read
    local bgpanel = draw.RoundedBox(10,     -- Radius of corners
        textPosition.x - (maxWidth / 2),    -- x position of panel
        textPosition.y - totalHeight - 10,  -- y position of panel
        maxWidth,                           -- width of panel
        totalHeight + 10,                   -- height of panel
        Color(76, 76, 76))                  -- panel background color

    -- draw all our text!
    for _, text in pairs(infoArray) do
        DrawText(text, textColor, textPosition.x, textPosition.y - totalHeight + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end
end

local function DrawModelESP(target)
    if not AESP.Config.ShowModel:GetBool() then return end
    
    cam.Start3D(EyePos(), EyeAngles())
        cam.IgnoreZ(true)
        target:DrawModel(STUDIO_NOSHADOWS)
        cam.IgnoreZ(false)
    cam.End3D()
end

local function TargetIsValid(target)
    if target == LocalPlayer()
        or !target:Alive()
        or target:Team() == TEAM_SPECTATOR
        or target:GetMoveType() == MOVETYPE_OBSERVER
        or LocalPlayer():GetPos():Distance(target:GetPos()) > AESP.Config.MaxDistance:GetInt()
    then
        return false
    else
        return true
    end
end

local function CalcESP()
    -- Check if the player can access this
    if not (LocalPlayer():IsSuperAdmin() or LocalPlayer():IsAdmin()) then return end
    -- Check if the player enabled AESP
    if AESP.Config.Enabled:GetInt() < 1 then return end

    for _, target in pairs(player.GetAll()) do
        if not TargetIsValid(target) then continue end

        DrawTextESP(target)
        DrawModelESP(target)
    end
end

hook.Add("HUDPaint", "DrawAdminESP", CalcESP)
