local firstSpawn = true

----------------------------------------------------------------
-- YARDIMCI: TELEPORT
----------------------------------------------------------------
local function Teleport(coords)
    local ped = PlayerPedId()

    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)

    if coords.w then
        SetEntityHeading(ped, coords.w)
    end

    -- Küçük fade efekti istersen:
    -- DoScreenFadeOut(500)
    -- Wait(500)
    -- SetEntityCoords ...
    -- DoScreenFadeIn(500)
end

----------------------------------------------------------------
-- MULTICHAR / PLAYER LOADED
----------------------------------------------------------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('qbx-motel:server:FirstSpawn')
end)


CreateThread(function()
    for _, m in pairs(Config.Motels) do
        local blip = AddBlipForCoord(m.coords.x, m.coords.y, m.coords.z)
        SetBlipSprite(blip, 475)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(m.label)
        EndTextCommandSetBlipName(blip)
    end
end)


----------------------------------------------------------------
-- SERVER → CLIENT EVENTLER
----------------------------------------------------------------

-- İlk spawn veya enter event’lerinde çağrılabilir
RegisterNetEvent('qbx-motel:client:TeleportInside', function()
    Teleport(Config.Motel.exit)
end)

RegisterNetEvent('qbx-motel:client:Enter', function()
    Teleport(Config.Motel.exit)
end)

RegisterNetEvent('qbx-motel:client:Exit', function()
    Teleport(Config.Motel.enter)
end)

-- Stash
RegisterNetEvent('qbx-motel:client:OpenStash', function(stashId)
    if not stashId then return end
    exports.ox_inventory:openInventory('stash', stashId)
end)

----------------------------------------------------------------
-- TARGET BÖLGELERİ
----------------------------------------------------------------

CreateThread(function()
    -- GİRİŞ (dış kapı)
    exports.ox_target:addBoxZone({
        coords   = Config.Motel.enter,
        size     = vec3(1.5, 1.5, 2.0),
        rotation = 0.0,
        debug    = false,
        options  = {
            {
                name  = 'motel_enter',
                icon  = 'fa-solid fa-door-open',
                label = 'Motelden İçeri Gir',
                onSelect = function()
                    TriggerServerEvent('qbx-motel:server:Enter')
                end
            }
        }
    })

    -- ÇIKIŞ (iç kapı)
    exports.ox_target:addBoxZone({
        coords   = vec3(Config.Motel.exit.x, Config.Motel.exit.y, Config.Motel.exit.z),
        size     = vec3(1.2, 1.2, 2.0),
        rotation = 0.0,
        debug    = false,
        options  = {
            {
                name  = 'motel_exit',
                icon  = 'fa-solid fa-door-closed',
                label = 'Dışarı Çık',
                onSelect = function()
                    TriggerServerEvent('qbx-motel:server:Exit')
                end
            }
        }
    })

    -- CLOTHING
    exports.ox_target:addSphereZone({
        coords  = Config.Motel.clothing,
        radius  = 0.8,
        debug   = false,
        options = {
            {
                icon  = 'fa-solid fa-shirt',
                label = 'Kıyafet Dolabı',
                onSelect = function()
                    -- Kendi giyinme sistemine göre değiştir
                    TriggerEvent('illenium-appearance:client:openOutfitMenu')
                end
            }
        }
    })

    -- STASH
    exports.ox_target:addSphereZone({
        coords  = Config.Motel.stash,
        radius  = 1.0,
        debug   = false,
        options = {
            {
                icon  = 'fa-solid fa-box',
                label = 'Oda Deposu',
                onSelect = function()
                    TriggerServerEvent('qbx-motel:server:RequestStash')
                end
            }
        }
    })

    -- LOGOUT / KARAKTER DEĞİŞTİR
    --[[ exports.ox_target:addSphereZone({
        coords  = Config.Motel.logout,
        radius  = 0.8,
        debug   = false,
        options = {
            {
                icon  = 'fa-solid fa-bed',
                label = 'Karakter Değiştir',
                onSelect = function()
                    TriggerEvent('qbx_multicharacter:client:chooseChar')
                end
            }
        }
    }) ]]
end)
