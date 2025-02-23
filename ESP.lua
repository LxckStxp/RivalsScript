-- ESP.lua
-- ESP functionality for Rivals

local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/RivalsScript/main/Utils.lua"))()
local ESP = {}
ESP.__index = ESP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function ESP.new()
    local self = setmetatable({}, ESP)
    self.Enabled = false
    self.TeamCheck = true
    self.ESPObjects = {}
    self.Connection = nil
    return self
end

function ESP:Enable()
    if self.Enabled then return end
    self.Enabled = true
    
    self.Connection = RunService.RenderStepped:Connect(function()
        self:Update()
    end)
end

function ESP:Disable()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    for _, obj in pairs(self.ESPObjects) do
        obj:Remove()
    end
    self.ESPObjects = {}
end

function ESP:SetTeamCheck(state)
    self.TeamCheck = state
    self:Update()
end

function ESP:Update()
    local localPlayer = Players.LocalPlayer
    for _, obj in pairs(self.ESPObjects) do
        obj:Remove()
    end
    self.ESPObjects = {}
    
    if not self.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not self.TeamCheck or player.Team ~= localPlayer.Team then
                local rootPart = player.Character.HumanoidRootPart
                local espBox = Utils.CreateESPBox(rootPart)
                table.insert(self.ESPObjects, espBox)
            end
        end
    end
end

function ESP:Destroy()
    self:Disable()
end

return ESP
