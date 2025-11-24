local CreatedStashes = {}         -- stashId -> true
local PlayerBuckets  = {}         -- src -> bucketId
local BucketCounter  = Config.BucketStart or 7000

----------------------------------------------------------------
-- YARDIMCI FONKSİYONLAR
----------------------------------------------------------------

local function GetCitizenId(src)
    -- qbx_core'dan Player almayı dene
    local Player = exports.qbx_core:GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.citizenid then
        return Player.PlayerData.citizenid
    end

    -- Fallback: rockstar license
    local identifiers = GetPlayerIdentifiers(src)
    return identifiers[1] or ("cid_" .. tostring(src))
end

local function PutPlayerInNewBucket(src)
    BucketCounter += 1
    local bucket = BucketCounter

    PlayerBuckets[src] = bucket
    exports.qbx_core:SetPlayerBucket(src, bucket)  -- qbx_core bucket export'u :contentReference[oaicite:2]{index=2}
end

local function RemovePlayerBucket(src)
    if not PlayerBuckets[src] then return end
    exports.qbx_core:SetPlayerBucket(src, 0)
    PlayerBuckets[src] = nil
end

local function EnsureMotelStash(src)
    local citizenid = GetCitizenId(src)
    local stashId   = ('motelstash_%s'):format(citizenid)

    if not CreatedStashes[stashId] then
        exports.ox_inventory:RegisterStash(
            stashId,
            'Motel Deposu',
            Config.StashSlots,
            Config.StashWeight,
            citizenid -- owner identifier
        )
        CreatedStashes[stashId] = true
    end

    return stashId
end

----------------------------------------------------------------
-- İLK SPAWN / MULTICHAR SONRASI MOTEL’E ATMA
----------------------------------------------------------------

RegisterNetEvent('qbx-motel:server:FirstSpawn', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    -- LAST LOCATION kontrolü
    local pos = Player.PlayerData.position
    if pos and pos.x ~= 0 then
        -- Oyuncunun last location'ı var → motele teleport ETME
        print("[MOTEL] Last location bulundu, motel spawn atlanıyor:", src)
        return
    end

    -- İlk kez giriyorsa motele spawn et
    print("[MOTEL] İlk giriş → motel spawn:", src)

    PutPlayerInNewBucket(src)
    local stashId = EnsureMotelStash(src)

    TriggerClientEvent('qbx-motel:client:TeleportInside', src)
    TriggerClientEvent("illenium-appearance:client:openOutfitMenu", src)
end)


----------------------------------------------------------------
-- MANUEL MOTEL GİRİŞ / ÇIKIŞ (kapıdan gir-çık)
----------------------------------------------------------------

RegisterNetEvent('qbx-motel:server:Enter', function()
    local src = source
    PutPlayerInNewBucket(src)
    TriggerClientEvent('qbx-motel:client:Enter', src)
end)

RegisterNetEvent('qbx-motel:server:Exit', function()
    local src = source
    RemovePlayerBucket(src)
    TriggerClientEvent('qbx-motel:client:Exit', src)
end)

----------------------------------------------------------------
-- STASH
----------------------------------------------------------------

RegisterNetEvent('qbx-motel:server:RequestStash', function()
    local src = source

    local stashId = EnsureMotelStash(src)
    -- Sadece stash aç, teleport yok
    TriggerClientEvent('qbx-motel:client:OpenStash', src, stashId)
end)

----------------------------------------------------------------
-- OYUNCU ÇIKARKEN TEMİZLEME (opsiyonel)
----------------------------------------------------------------

AddEventHandler('playerDropped', function()
    local src = source
    RemovePlayerBucket(src)
end)
