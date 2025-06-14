local Bridge = {}
Bridge.__index = Bridge
local isClient = IsDuplicityVersion() == false
local isServer = not isClient

function Bridge.Debug(msg, level)
    if not Config or not Config.Debug then return end
    local prefix = '^3[anox-itservice]^7'
    local levelColors = {
        info = '^7',
        success = '^2',
        warning = '^3',
        error = '^1'
    }
    local color = levelColors[level] or '^7'
    print(prefix .. ' ' .. color .. msg .. '^7')
end

local UIPresets = {
    notify = {
        default = {
            backgroundColor = '#1E1E2F',
            boxShadow = '0 0 12px rgba(96, 165, 250, 0.4)',
            color = '#A0A0FF',
            position = 'center-right',
            duration = 6000,
            icon = 'bell'
        },
        error = {
            backgroundColor = '#2F1E1E',
            boxShadow = '0 0 12px rgba(250, 96, 96, 0.4)',
            color = '#FF5C5C',
            position = 'center-right',
            duration = 6000,
            icon = 'circle-exclamation'
        },
        success = {
            backgroundColor = '#1E2F1E',
            boxShadow = '0 0 12px rgba(132, 250, 96, 0.4)',
            color = '#6CFF7F',
            position = 'center-right',
            duration = 6000,
            icon = 'circle-check'
        },
        info = {
            backgroundColor = '#1E1E2F',
            boxShadow = '0 0 12px rgba(96, 165, 250, 0.4)',
            color = '#58C5FF',
            position = 'center-right',
            duration = 6000,
            icon = 'circle-info'
        },
        warning = {
            backgroundColor = '#2F2A1E',
            boxShadow = '0 0 12px rgba(250, 227, 96, 0.4)',
            color = '#FFD966',
            position = 'center-right',
            duration = 6000,
            icon = 'triangle-exclamation'
        }
    },
    textUI = {
        default = {
            backgroundColor = '#1E1E2F',
            position = 'top-center',
            icon = 'info-circle',
            iconColor = '#A0A0FF'
        },
        computer = {
            backgroundColor = '#112F1E',
            position = 'top-center',
            icon = 'laptop',
            iconColor = '#6CFF7F'
        },
        customer = {
            backgroundColor = '#2A1E2F',
            position = 'top-center',
            icon = 'user',
            iconColor = '#FF8AE2'
        },
        timer = {
            backgroundColor = '#256564',
            position = 'top-center',
            icon = 'clock',
            iconColor = '#FFFFFF'
        },
        purchase = {
            backgroundColor = '#2F1E2A',
            position = 'top-center',
            icon = 'shopping-cart',
            iconColor = '#FF6B6B'
        }
    }
}

function Bridge.Notify(source, title, description, type, duration)
    local success, err = pcall(function()
        local notifyType = type or 'info'
        local notifyStyle = UIPresets.notify[notifyType] or UIPresets.notify.default
        local msgTitle = title or 'Notification'
        local msgDesc = tostring(description or '')
        local notifyDuration = duration or notifyStyle.duration or 6000
        local style = {
            backgroundColor = notifyStyle.backgroundColor or '#000000',
            color = notifyStyle.color or '#FFD700',
            borderRadius = 14,
            fontSize = '16px',
            fontWeight = 'bold',
            textAlign = 'left',
            padding = '14px 20px',
            border = '1px solid ' .. (notifyStyle.color or '#FFD700'),
            letterSpacing = '0.5px'
        }
        if not source then
            style.boxShadow = notifyStyle.boxShadow
        end
        if Config.UISystem.Notify == 'ox' then
            local notifyData = {
                title = msgTitle,
                description = msgDesc,
                type = notifyType,
                icon = notifyStyle.icon,
                style = style,
                position = notifyStyle.position or 'top-right',
                duration = notifyDuration
            }
            if source then
                TriggerClientEvent('ox_lib:notify', source, notifyData)
            else
                lib.notify(notifyData)
            end
        else
            if isClient and not source then
                BeginTextCommandThefeedPost('STRING')
                AddTextComponentSubstringPlayerName(msgTitle .. '\n' .. msgDesc)
                EndTextCommandThefeedPostTicker(false, false)
            else
                Bridge.Debug('NOTIFY: ' .. msgTitle .. ' - ' .. msgDesc, 'info')
            end
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.Notify: ' .. tostring(err), 'error')
    end
end

function Bridge.ShowTextUI(text, options)
    if not isClient then return end
    local success, err = pcall(function()
        options = options or {}
        local styleKey = options.style or 'default'
        local textUIStyle = UIPresets.textUI[styleKey] or UIPresets.textUI.default
        if Config.UISystem.TextUI == 'ox' then
            lib.showTextUI(text, {
                position = textUIStyle.position or 'top-center',
                icon = options.icon or textUIStyle.icon,
                iconColor = options.iconColor or textUIStyle.iconColor or '#ffffff',
                iconAnimation = options.iconAnimation or 'spin',
                style = {
                    backgroundColor = textUIStyle.backgroundColor or '#000000',
                    color = textUIStyle.iconColor or '#ffffff',
                    borderRadius = 6,
                    border = '1px solid ' .. (textUIStyle.iconColor or '#ffffff'),
                    fontSize = '15px',
                    fontWeight = '600',
                    padding = '8px 16px',
                    letterSpacing = '0.5px',
                }
            })
        else
            Bridge.Debug('TextUI: ' .. text, 'info')
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.ShowTextUI: ' .. tostring(err), 'error')
    end
end

function Bridge.HideTextUI()
    if not isClient then return end
    local success, err = pcall(function()
        if Config.UISystem.TextUI == 'ox' then
            lib.hideTextUI()
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.HideTextUI: ' .. tostring(err), 'error')
    end
end

function Bridge.ProgressBar(options)
    if not isClient then return true end
    local success, result = pcall(function()
        if Config.UISystem.ProgressBar == 'ox' then
            return lib.progressBar(options)
        else
            if options.duration then
                Wait(options.duration)
            end
            return true
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.ProgressBar: ' .. tostring(result), 'error')
        return false
    end
    return result or false
end

function Bridge.ProgressCircle(options)
    if not isClient then return true end
    local success, result = pcall(function()
        if Config.UISystem.ProgressBar == 'ox' then
            return lib.progressCircle(options)
        else
            if options.duration then
                Wait(options.duration)
            end
            return true
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.ProgressCircle: ' .. tostring(result), 'error')
        return false
    end
    return result or false
end

function Bridge.AlertDialog(options)
    if not isClient then return 'confirm' end
    local success, result = pcall(function()
        options = options or {}
        if Config.UISystem.AlertDialog == 'ox' then
            return lib.alertDialog({
                header = options.header or 'Alert',
                content = options.content or '',
                centered = options.centered ~= nil and options.centered or true,
                cancel = options.cancel ~= nil and options.cancel or true,
                labels = options.labels or {
                    confirm = 'Confirm',
                    cancel = 'Cancel'
                }
            })
        else
            Bridge.Debug('AlertDialog: ' .. (options.header or 'Alert'), 'info')
            return 'confirm'
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.AlertDialog: ' .. tostring(result), 'error')
    end
    return result or 'confirm'
end

function Bridge.SkillCheck(difficulty, inputs)
    if not isClient then return true end
    local success, result = pcall(function()
        if Config.UISystem.SkillCheck == 'ox' then
            return lib.skillCheck(difficulty, inputs)
        else
            local successChance = 100
            if type(difficulty) == 'table' then
                local total = 0
                for _, diff in ipairs(difficulty) do
                    if type(diff) == 'string' then
                        if diff == 'easy' then total = total + 80
                        elseif diff == 'medium' then total = total + 60
                        elseif diff == 'hard' then total = total + 40
                        else total = total + 50 end
                    else
                        total = total + (diff or 50)
                    end
                end
                successChance = total / #difficulty
            elseif type(difficulty) == 'string' then
                if difficulty == 'easy' then successChance = 80
                elseif difficulty == 'medium' then successChance = 60
                elseif difficulty == 'hard' then successChance = 40
                else successChance = 50 end
            end
            return math.random(100) <= successChance
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.SkillCheck: ' .. tostring(result), 'error')
        return false
    end
    return result or false
end

function Bridge.RegisterContext(data)
    if not isClient then return end
    local success, err = pcall(function()
        if Config.UISystem.ContextMenu == 'ox' then
            lib.registerContext(data)
        else
            Bridge.Debug('Context Menu not supported without ox_lib', 'warning')
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.RegisterContext: ' .. tostring(err), 'error')
    end
end

function Bridge.ShowContext(id)
    if not isClient then return end
    local success, err = pcall(function()
        if Config.UISystem.ContextMenu == 'ox' then
            lib.showContext(id)
        else
            Bridge.Debug('Context Menu not supported without ox_lib', 'warning')
        end
    end)
    
    if not success then
        Bridge.Debug('Error in Bridge.ShowContext: ' .. tostring(err), 'error')
    end
end

function Bridge.HideContext(onExit)
    if not isClient then return end
    local success, err = pcall(function()
        if Config.UISystem.ContextMenu == 'ox' then
            lib.hideContext(onExit)
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.HideContext: ' .. tostring(err), 'error')
    end
end

function Bridge.InputDialog(heading, rows)
    if not isClient then return nil end
    local success, result = pcall(function()
        if Config.UISystem.InputDialog == 'ox' then
            return lib.inputDialog(heading, rows)
        else
            Bridge.Debug('Input Dialog not supported without ox_lib', 'warning')
            return nil
        end
    end)
    if not success then
        Bridge.Debug('Error in Bridge.InputDialog: ' .. tostring(result), 'error')
        return nil
    end
    return result
end

Bridge.Target = {
    AddLocalEntity = function(entity, options)
        if not isClient then return end
        local success, err = pcall(function()
            if Config.Target == 'ox' then
                exports['ox_target']:addLocalEntity(entity, options)
            elseif Config.Target == 'qb' then
                local qbOptions = {}
                for _, opt in ipairs(options) do
                    local qbOption = {
                        type = opt.type or 'client',
                        icon = opt.icon,
                        label = opt.label,
                        canInteract = opt.canInteract,
                        job = opt.job
                    }
                    if opt.event then
                        qbOption.event = opt.event
                    elseif opt.onSelect then
                        qbOption.action = function()
                            opt.onSelect()
                        end
                    elseif opt.serverEvent then
                        qbOption.type = 'server'
                        qbOption.event = opt.serverEvent
                    end
                    table.insert(qbOptions, qbOption)
                end
                exports['qb-target']:AddTargetEntity(entity, {
                    options = qbOptions,
                    distance = 2.5
                })
            else
                Bridge.Debug('Target system not supported: ' .. tostring(Config.Target), 'warning')
            end
        end)
        if not success then
            Bridge.Debug('Error in Bridge.Target.AddLocalEntity: ' .. tostring(err), 'error')
        end
    end,
    RemoveLocalEntity = function(entity, names)
        if not isClient then return end
        local success, err = pcall(function()
            if Config.Target == 'ox' then
                exports['ox_target']:removeLocalEntity(entity, names)
            elseif Config.Target == 'qb' then
                exports['qb-target']:RemoveTargetEntity(entity, names)
            end
        end)
        if not success then
            Bridge.Debug('Error in Bridge.Target.RemoveLocalEntity: ' .. tostring(err), 'error')
        end
    end,
    AddSphereZone = function(data)
        if not isClient then return end
        local success, err = pcall(function()
            if Config.Target == 'ox' then
                exports['ox_target']:addSphereZone(data)
            elseif Config.Target == 'qb' then
                local qbOptions = {}
                if data.options then
                    for _, opt in ipairs(data.options) do
                        local qbOption = {
                            type = opt.type or 'client',
                            icon = opt.icon,
                            label = opt.label,
                            canInteract = opt.canInteract,
                            job = opt.job
                        }
                        if opt.event then
                            qbOption.event = opt.event
                        elseif opt.onSelect then
                            qbOption.action = function()
                                opt.onSelect()
                            end
                        elseif opt.serverEvent then
                            qbOption.type = 'server'
                            qbOption.event = opt.serverEvent
                        end
                        table.insert(qbOptions, qbOption)
                    end
                end
                exports['qb-target']:AddCircleZone(data.name, data.coords, data.radius, {
                    name = data.name,
                    debugPoly = data.debug,
                    useZ = true,
                }, {
                    options = qbOptions,
                    distance = data.radius or 2.5
                })
            end
        end)
        
        if not success then
            Bridge.Debug('Error in Bridge.Target.AddSphereZone: ' .. tostring(err), 'error')
        end
    end,
    RemoveZone = function(name)
        if not isClient then return end
        local success, err = pcall(function()
            if Config.Target == 'ox' then
                exports['ox_target']:removeZone(name)
            elseif Config.Target == 'qb' then
                exports['qb-target']:RemoveZone(name)
            end
        end)
        if not success then
            Bridge.Debug('Error in Bridge.Target.RemoveZone: ' .. tostring(err), 'error')
        end
    end
}

function Bridge.Load()
    if not Config then
        Bridge.Debug('Config not found', 'error')
        return nil
    end
    local framework = nil
    local frameworkMap = {
        ['esx'] = 'esx',
        ['qb'] = 'qb', 
        ['qbx'] = 'qbx'
    }
    if Config.Framework and Config.Framework ~= 'auto' and Config.Framework ~= 'autodetect' then
        framework = frameworkMap[string.lower(Config.Framework)]
        if not framework then
            Bridge.Debug('Unknown framework specified: ' .. Config.Framework, 'error')
            return nil
        end
    else
        if GetResourceState('es_extended') == 'started' then
            framework = 'esx'
        elseif GetResourceState('qb-core') == 'started' then
            framework = 'qb'
        elseif GetResourceState('qbx_core') == 'started' then
            framework = 'qbx'
        else
            Bridge.Debug('No supported framework detected', 'error')
            return nil
        end
    end
    local context = isClient and 'client' or 'server'
    local bridgePath = ('bridge/%s/%s'):format(context, framework)
    local success, frameworkBridge = pcall(require, bridgePath)
    if not success or not frameworkBridge then
        Bridge.Debug('Failed to load bridge module: ' .. bridgePath, 'error')
        return nil
    end
    if frameworkBridge.Init and type(frameworkBridge.Init) == 'function' then
        if not frameworkBridge:Init() then
            Bridge.Debug('Failed to initialize ' .. framework .. ' bridge', 'error')
            return nil
        end
        Bridge.Debug('Successfully initialized ' .. framework .. ' bridge', 'success')
        if frameworkBridge.RegisterEvents and type(frameworkBridge.RegisterEvents) == 'function' then
            frameworkBridge:RegisterEvents()
        end
    else
        Bridge.Debug('Loaded ' .. framework .. ' bridge', 'success')
    end
    return setmetatable({
        Notify = Bridge.Notify,
        ShowTextUI = Bridge.ShowTextUI,
        HideTextUI = Bridge.HideTextUI,
        ProgressBar = Bridge.ProgressBar,
        ProgressCircle = Bridge.ProgressCircle,
        AlertDialog = Bridge.AlertDialog,
        SkillCheck = Bridge.SkillCheck,
        RegisterContext = Bridge.RegisterContext,
        ShowContext = Bridge.ShowContext,
        HideContext = Bridge.HideContext,
        InputDialog = Bridge.InputDialog,
        Target = Bridge.Target,
        Debug = Bridge.Debug,
        Framework = framework,
        IsClient = isClient,
        IsServer = isServer
    }, {
        __index = function(t, k)
            return frameworkBridge[k] or Bridge[k]
        end
    })
end

return Bridge