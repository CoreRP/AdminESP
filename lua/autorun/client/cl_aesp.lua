--[[
Config area. No need for 2 files if they're both small.
]]
AESP = AESP or {}
AESP.Config = AESP.Config or {
  ShowPing  = true,
  ShowHealth  = true,
  ShowArmor = true,
  ShowGroup = true,
  ShowJob   = true,
  ShowMoney = true -- Only set to true if using DarkRP
}

--[[
  Do NOT touch below this line.
]]

print("Admin ESP loaded, type esp_help for information on how to use this script.")

local function esphelpcommand()
	print("This is a simple ESP that was created by Subject_Alpha (STEAM_0:0:41620517), to use type in the console admin_esp 1, to turn off type in admin_esp 0")
end

concommand.Add("esp_help", esphelpcommand)

surface.CreateFont("aesp_font", {
   font = "Arial",
   size = 15,
   weight = 50,
   antialias = true
})

local ESP = CreateClientConVar("admin_esp", "0" , true, false)
local ESP_d = CreateClientConVar("esp_d", "999999", true, false)

local function DrawText(strText, oCol, iXPos, iYPos)
	draw.SimpleTextOutlined(strText, "aesp_font", iXPos, iYPos, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
end

local function DrawAdminESP()
  if(!LocalPlayer():IsSuperAdmin()) then return; end
  if(ESP:GetInt() < 1) then return; end

  for k, v in pairs(player.GetAll()) do
		if( v == LocalPlayer() ||
		!v:Alive() ||
		v:Team() == TEAM_SPECTATOR ||
		v:GetMoveType() == MOVETYPE_OBSERVER ) then
			continue;
		end
      
    if(LocalPlayer():GetPos():Distance(v:GetPos()) < ESP_d:GetInt()) then
      local Pos = (v:GetPos() + Vector(0, 0, 50)):ToScreen()
            DrawText("Name: "..v:Nick(),             team.GetColor(v:Team()),   Pos.x, Pos.y + 13 * 0)
            DrawText("SteamID: "..v:SteamID(),       Color(255, 255, 255, 255), Pos.x, Pos.y + 13 * 1)
            if AESP.Config["ShowPing"] then
              DrawText("Ping: "..v:Ping(),             Color(255, 255, 255, 255), Pos.x, Pos.y + 13 * 2)
            end
            if AESP.Config["ShowHealth"] then
              DrawText("Health: "..v:Health(),         Color(255, 255, 255, 255), Pos.x, Pos.y + 13 * 3)
            end
            if AESP.Config["ShowArmor"] then
              DrawText("Armor: "..v:Armor(),           Color(255, 255, 255, 255), Pos.x, Pos.y + 13 * 4)
            end
            if AESP.Config["ShowGroup"] then
              DrawText("Usergroup: "..v:GetNWString("usergroup"), Color(255, 255, 255, 255), Pos.x, Pos.y + 13 * 5)
            end
            if AESP.Config["ShowJob"] then
              DrawText("Job: "..team.GetName(v:Team()), Color(255, 255, 255, 255), Pos.x, Pos.y + 13 * 6)
            end
            if AESP.Config["ShowMoney"] then
              DrawText("$"..v:getDarkRPVar("money"), Color(255, 255, 255, 255), Pos.x, Pos.y + 13 * 7)
            end
      end
    end
end
hook.Add("HUDPaint", "DrawAdminESP", DrawAdminESP)
