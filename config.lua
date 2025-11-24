Config = {}

Config.Motel = {
    enter   = vec3(-969.48, -1431.22, 6.76),                    -- motel kapısı
    exit    = vec4(346.76, -1011.52, -99.2, 358.57),           -- içeri spawn
    clothing= vec3(350.84, -993.90, -99.20),
    stash   = vec3(351.98, -998.80, -99.20),
    logout  = vec3(349.24, -995.09, -99.20),
}

Config.Motels = {
    { label = "Motel", coords = vec3(-969.48, -1431.22, 6.76) },
}

-- İlk spawn’da da buraya göndereceğiz
Config.SpawnInMotelOnFirstLoad = true

-- Bucket başlangıç ID (oyuncular çakışmasın diye)
Config.BucketStart = 7000

-- Stash ayarları
Config.StashSlots  = 50
Config.StashWeight = 50000  -- 50kg

-- Multichar / karakter menüsü event’i (qbx_multichar + qbx_core ortak qb event)
Config.PlayerLoadedEvent = 'QBCore:Client:OnPlayerLoaded'  -- qbx_core bunu trigliyor :contentReference[oaicite:1]{index=1}
Config.PlayerUnloadEvent = 'QBCore:Client:OnPlayerUnload'
