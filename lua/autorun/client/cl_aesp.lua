AESP = AESP or {}
AESP.Config = AESP.Config or {}

-- Enable/disable the ESP
AESP.Config.Enabled     = CreateClientConVar("aesp_enabled", "0" , false, false)
-- Set the max draw distance
AESP.Config.MaxDistance = CreateClientConVar("aesp_maxdistance", "16384", true, false)

-- Set the text offset in the x direction
AESP.Config.TextOffsetX = CreateClientConVar("aesp_offsetx", "0" , true, false)
-- Set the text offset in the y direction
AESP.Config.TextOffsetY = CreateClientConVar("aesp_offsety", "50" , true, false)

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

concommand.Add("aesp_getgamemode", 
    function()
        print(string.lower(gmod.GetGamemode().Name))
    end, 
    nil, 
    [[Use this command to find the name for your custom gamemode.
    This helps if you're trying to add custom (per-gamemode) text.]])

surface.CreateFont("aesp_font", {
   font         = "Arial",
   size         = 15,
   weight       = 50,
   antialias    = true
})

local function DrawText(text, color, x, y)
    draw.SimpleTextOutlined(text, "aesp_font", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
end

local function DrawTextESP(target)
    -- darkrp, terrortown, sandbox, murder, etc
    local gamemodeName = string.lower(gmod.GetGamemode().Name)

    -- Where to draw the text in relation to the target
    local textPosition = (target:GetPos() + Vector(0, 0, AESP.Config.TextOffsetY:GetInt())):ToScreen()
    local nextLineOffset = 0
    local textColor = Color(255, 255, 255, 255)

    if AESP.Config.ShowName:GetBool() then
        DrawText("Name: " .. target:Nick(), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end
    
    if AESP.Config.ShowSteamID:GetBool() then
        DrawText("SteamID: " .. target:SteamID(), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end

    if AESP.Config.ShowPing:GetBool() then
        DrawText("Ping: " .. target:Ping(), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end

    if AESP.Config.ShowHealth:GetBool() then
        DrawText("Health: " .. target:Health(), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end

    if AESP.Config.ShowArmor:GetBool() then
        DrawText("Armor: " .. target:Armor(), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end

    if AESP.Config.ShowGroup:GetBool() then
        DrawText("Usergroup: " .. target:GetNWString("usergroup"), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end

    if AESP.Config.ShowJob:GetBool() and gamemodeName == "darkrp" then
        DrawText("Job: " .. team.GetName(target:Team()), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end

    if AESP.Config.ShowMoney:GetBool() and gamemodeName == "darkrp" then
        DrawText("$" .. target:getDarkRPVar("money"), textColor, textPosition.x, textPosition.y + nextLineOffset)
        nextLineOffset = nextLineOffset + 13
    end

    -- This doesn't work right now, shows Traitors as Innocents
    -- Probably has to do with client-side shit, I'll figure it out later
    if AESP.Config.ShowRole:GetBool() and gamemodeName == "trouble in terrorist town" then
        local roleText = ""
        if target:IsTraitor() then
            roleText = "Traitor"
        elseif target:IsDetective() then
            roleText = "Detective"
        else
            roleText = "Innocent"
        end
        
        DrawText("Role:" .. roleText, textColor, textPosition.x, textPosition.y + nextLineOffset)
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
