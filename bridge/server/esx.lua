local ESXBridge = {}
ESXBridge.__index = ESXBridge
local ESX = nil

function ESXBridge:Init()
    ESX = exports['es_extended']:getSharedObject()
    if not ESX then
        return false
    end
    return true
end

function ESXBridge:GetPlayer(playerId)
    return ESX.GetPlayerFromId(playerId)
end

function ESXBridge:GetPlayerFromIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function ESXBridge:AddMoney(playerId, amount, moneyType)
    local xPlayer = self:GetPlayer(playerId)
    if not xPlayer then return false end
    moneyType = moneyType or 'cash'
    if moneyType == 'cash' then
        xPlayer.addMoney(amount)
    elseif moneyType == 'bank' then
        xPlayer.addAccountMoney('bank', amount)
    end
    return true
end

function ESXBridge:RemoveMoney(playerId, amount, moneyType)
    local xPlayer = self:GetPlayer(playerId)
    if not xPlayer then return false end
    moneyType = moneyType or 'cash'
    if moneyType == 'cash' then
        xPlayer.removeMoney(amount)
    elseif moneyType == 'bank' then
        xPlayer.removeAccountMoney('bank', amount)
    end
    return true
end

function ESXBridge:GetMoney(playerId, moneyType)
    local xPlayer = self:GetPlayer(playerId)
    if not xPlayer then return 0 end
    moneyType = moneyType or 'cash'
    if moneyType == 'cash' then
        return xPlayer.getMoney()
    elseif moneyType == 'bank' then
        return xPlayer.getAccount('bank').money
    end
    return 0
end

function ESXBridge:HasMoney(playerId, amount, moneyType)
    return self:GetMoney(playerId, moneyType) >= amount
end

function ESXBridge:GetPlayerJob(playerId)
    local xPlayer = self:GetPlayer(playerId)
    if not xPlayer then return nil end
    return xPlayer.job
end

function ESXBridge:GetPlayerIdentifier(playerId)
    local xPlayer = self:GetPlayer(playerId)
    if not xPlayer then return nil end
    return xPlayer.identifier
end

function ESXBridge:GetPlayerName(playerId)
    local xPlayer = self:GetPlayer(playerId)
    if not xPlayer then return "Unknown" end
    return xPlayer.getName()
end

function ESXBridge:GetFramework()
    return ESX
end

return ESXBridge