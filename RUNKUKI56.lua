-- ================================================================
-- KFC ANTI-STEAL v11 "OBSIDIAN SPIRAL"
-- Owner: LOLASSR5
-- Drop-in .lua — loadstring(readfile("kfc_antisteal_v11.lua"))()
-- ================================================================

local OWNER_NAME = "LOLASSR5"

-- ── OWNER CHECK ─────────────────────────────────────────────────
local Players        = game:GetService("Players")
local LocalPlayer    = Players.LocalPlayer
local RunService     = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function isOwner()
    return LocalPlayer and string.lower(LocalPlayer.Name) == string.lower(OWNER_NAME)
end

-- ── CONSTANTS ───────────────────────────────────────────────────
local HEX  = "0123456789ABCDEF"
local ZWS  = "\226\128\139"
local ZWNJ = "\226\128\140"
local ZWJ  = "\226\128\141"
local WJ   = "\226\129\160"
local BOM  = "\239\187\191"
local NBSP = "\194\160"
local SHY  = "\194\173"

local ADMIN_SHIELD = "lloyd_adm_shield=1&owner=" .. OWNER_NAME
local SCRIPT_TAG   = "lloyd_usr_v11=1"

-- ── HELPERS ──────────────────────────────────────────────────────
local function spaceFractured(s)
    local out = {}
    for i = 1, #s do
        local b  = string.byte(s, i)
        local hi = math.floor(b / 16) + 1
        local lo = (b % 16) + 1
        local h1 = string.sub(HEX, hi, hi)
        local h2 = string.sub(HEX, lo, lo)
        local spA = string.rep(" ", math.random(0, 2))
        local spB = string.rep(" ", math.random(1, 2))
        local spC = string.rep(" ", math.random(0, 2))
        if math.random(1, 5) == 1 and b >= 48 and b <= 57 then
            table.insert(out, " " .. string.char(b) .. " ")
        else
            table.insert(out, spA .. "%" .. spB .. h1 .. spC .. h2)
        end
    end
    return table.concat(out)
end

local function polyValue(idStr, force)
    local z = string.rep("0", math.random(1, 5))
    if force or math.random(1, 3) ~= 1 then
        return spaceFractured(z) .. spaceFractured(idStr)
    end
    return "%30%30" .. spaceFractured(idStr)
end

-- ── BAIT POOL ───────────────────────────────────────────────────
local BAIT = {
    "1848354536","1837879082","9043887091","1845756489","9048375035",
    "1836842899","1843404009","7029024726","5410086218","1846458016",
    "1839841807","1841647093","9046863253","9047050075","1837474337",
    "1842802203","1845554017","1838673350","9045766377","1840684529",
    "1836009206","1847853099","9039767824","9042666762","1835337424",
    "1841998846","1839246711","9044565954","1846088038","1837070127",
    "1843324953","9041985263","1838457617","1845092181","9038554128",
    "1836358814","1842241530","1847319562","9045120934","1839981240",
    "1841093482","1837762915","9040881726","1844219085","1835891042",
    "1846892310","9043118902","1838129045","1842910482","9039112048",
    "1836712094","1845310928","1839510294","9046102938","1840291847",
    "1837310928","1843819204","9041502938","1838910294","1846201928",
    "1835610294","1841402918","9044901284","1839019284","1844710294",
    "129138368026497","1847102938","1835201928","9047819203","1840918273",
    "1836291847","9038192837","1844102938","1839718293","9042819203",
}

local function nearClone(base)
    local c = {}
    for i = 1, #base do c[i] = string.sub(base, i, i) end
    local n = math.random(2, math.min(4, #c - 1))
    for _ = 1, n do
        local p  = math.random(2, #c)
        local d  = tonumber(c[p]) or 5
        c[p] = tostring((d + math.random(1, 8)) % 10)
    end
    return table.concat(c)
end

local function garbageNum(excl, round)
    local salt = ((round or 1) * 137) % 899 + 100
    local mode = math.random(1, 12)
    local c
    if     mode == 1  then c = tostring(math.random(18300,18499))..tostring(math.random(10000,99999))
    elseif mode == 2  then c = tostring(math.random(90380,90489))..tostring(math.random(10000,99999))
    elseif mode == 3  then c = tostring(math.random(1100,9899))..tostring(math.random(1000,9999))..tostring(math.random(1000,9999))
    elseif mode == 4  then c = tostring(math.random(10500,13999))..tostring(math.random(10000,99999))..tostring(math.random(10000,99999))
    elseif mode == 5  then c = tostring(math.random(1000,9999))..tostring(math.random(10000,99999))..tostring(math.random(10000,99999))
    elseif mode == 6  then c = tostring(math.random(110,989))..tostring(math.random(100000,999999))
    elseif mode == 7  then c = tostring(math.random(1200,9899))..tostring(math.random(1000,9999))
    elseif mode == 8  then c = nearClone(excl or "1848354536")
    elseif mode == 9  then c = nearClone(BAIT[math.random(1,#BAIT)])
    elseif mode == 10 then
        local clk = math.floor((os.clock()*10000) % 89999) + 10000
        c = tostring(salt)..tostring(clk)..tostring(math.random(10,99))
    elseif mode == 11 then c = tostring(math.random(500,899))..tostring(math.random(10000,99999))..tostring(math.random(10000,99999))
    else                   c = tostring(math.random(1000,8999))..tostring(math.random(1000,9999))..tostring(math.random(1000,9999))..tostring(math.random(1000,9999))
    end
    if c == tostring(excl) then c = c .. tostring(math.random(1,9)) end
    return c
end

_G._kfcUsed = _G._kfcUsed or {}
local function uniqueBait(excl, round, seen)
    for _ = 1, 20 do
        local pick
        if math.random(1,10) <= 7 then
            pick = garbageNum(excl, round)
        else
            pick = BAIT[math.random(1,#BAIT)]
            if seen and seen[pick] then pick = nearClone(pick) end
        end
        if pick ~= tostring(excl)
            and not (seen and seen[pick])
            and not _G._kfcUsed[pick]
        then
            if seen then seen[pick] = true end
            if math.random(1,3) == 1 then _G._kfcUsed[pick] = true end
            return pick
        end
    end
    return garbageNum(excl, round) .. tostring(math.random(10,99))
end

-- ── KEY TABLES ──────────────────────────────────────────────────
local VALID_KEYS = {
    "& % 6 9 % 6 4 = ",
    "&  % 6 9  % 6 4  =  ",
    "&   % 6 9   d   =   ",
    "&  i   % 6 4   =  ",
    "& % 6 9  d =  ",
    "&  i  % 6 4 = ",
    "&   i   d   =   ",
}

local POISON_KEYS = {
    "& \t% 6 9 % 6 4 = ","& \r% 6 9 % 6 4 = ","& \n% 6 9 % 6 4 = ",
    "& % 6 9 \t% 6 4 = ","& % 6 9 % 6 4 \t= ","& % 2 0 % 6 9 % 6 4 = ",
    "& % 6 9 % 0 0 % 6 4 = ","& % 0 0 % 6 9 % 6 4 = ","& % 6 9 % 6 4 % 0 0 = ",
    "& % 6 9 % 0 1 % 6 4 = ","& % 6 9 % 0 7 F % 6 4 = ",
    "&"..ZWS.."% 6 9 % 6 4 = ","& % 6 9 "..ZWS.."% 6 4 = ",
    "&"..ZWNJ.."% 6 9 % 6 4 = ","&"..ZWJ.."% 6 9 % 6 4 = ",
    "& % 6 9 "..WJ.."% 6 4 = ","&"..BOM.."% 6 9 % 6 4 = ",
    "&"..NBSP.."% 6 9 % 6 4 = ","&"..SHY.."% 6 9 % 6 4 = ",
    "& % 6 9 % C 2 % A 0 % 6 4 = ",
    "& % 6 9 % E 2 % 8 0 % 8 B % 6 4 = ",
    "& % 2 6 % 6 9 % 6 4 % 3 D ",
    "& % 6 9 % 6 4 % 3 D ",
}

local GARBAGE_KEYS = {
    "real_id","true_id","actual_id","play_id","main_id","raw_id",
    "clean_id","source_id","id_real","id_true","id_main","id_play",
    "id_0","id_1","id_2","id_3","id0","id1","id2","id_master",
    "id_stream","id_override","id_final","id_target","id_active",
    "id_primary","id_sound","id_asset","id_audio","id_music",
    "id_track","id_raw","sound_id","asset_id","audio_id","music_id",
    "track_id","stream_id","rbxassetid","rbx_sound","clip_id",
    "media_id","voice_id","song_id","tune_id","melody_id","beat_id",
    "record_id","channel_id","buffer_id","sample_id","wave_id",
    "ogg_id","vorbis_id","fmod_id","fmod_bank","dsp_node","bank_id",
    "node_id","guid_id","hash_id","crc_id","pcm_offset","opus_frame",
}

local function encGarbageKey(k)
    local pos    = math.random(1, #k)
    local marker = math.random(1,2)==1 and "% 0 0 " or ZWS
    local out    = {}
    for i = 1, #k do
        if i == pos then table.insert(out, marker) end
        local b  = string.byte(k, i)
        local hi = math.floor(b/16)+1
        local lo = (b%16)+1
        if i==1 or math.random(1,2)==1 then
            table.insert(out, "% "..string.sub(HEX,hi,hi).." "..string.sub(HEX,lo,lo).." ")
        else
            table.insert(out, string.sub(k,i,i)..string.rep(" ",math.random(0,1)))
        end
    end
    return table.concat(out)
end

local function fakeKeySeg(id, round, seen)
    local k = GARBAGE_KEYS[math.random(1,#GARBAGE_KEYS)]
    local b = uniqueBait(id, round, seen)
    return "& "..encGarbageKey(k).."= "..polyValue(b,false).."&%00"
end

local function poisonSeg(id, round, seen, forced)
    local b   = forced or uniqueBait(id, round, seen)
    local pfx = POISON_KEYS[math.random(1,#POISON_KEYS)]
    return pfx..polyValue(b,false).."&%00"
end

local function validSeg(id, round, seen, forced)
    local b = forced or uniqueBait(id, round, seen)
    local k = VALID_KEYS[math.random(1,#VALID_KEYS)]
    return k..polyValue(b,false).."&%00"
end

-- ── CORE BUILDER ─────────────────────────────────────────────────
local function buildPayload(rawId)
    local cleanId = tostring(rawId):match("%d+") or tostring(rawId)
    _G._kfcRound  = (_G._kfcRound or 0) + 1
    local round   = _G._kfcRound
    local seen    = { [cleanId] = true }

    -- chameleon mode (rotate real-ID placement zone every call)
    local last    = _G._kfcLastMode or 0
    local mode    = ((round + math.random(1,3)) % 4) + 1
    if mode == last then mode = (mode % 4) + 1 end
    _G._kfcLastMode = mode

    local total   = math.random(115,135) + math.min((round-1)*14, 130)

    local realIdx
    if     mode == 1 then realIdx = math.random(math.floor(total*.18), math.floor(total*.32))
    elseif mode == 2 then realIdx = math.random(math.floor(total*.72), math.floor(total*.86))
    elseif mode == 3 then realIdx = math.random(math.floor(total*.35), math.floor(total*.65))
    else               realIdx = math.random(math.floor(total*.42), math.floor(total*.58))
    end

    local lines = {}
    table.insert(lines, "120232514292241&lloyd_auth=1&owner="..OWNER_NAME)
    table.insert(lines, string.format(
        "; OBSIDIAN_SPIRAL_v11_%04d_SALT_%s_%s_OWNER_%s",
        round, garbageNum(cleanId,round), garbageNum(cleanId,round+7), OWNER_NAME
    ))

    -- duplicate cluster (frequency-analysis bait)
    local dupPool = {"120232514292241"}
    for _ = 1, math.random(8,14) do
        table.insert(dupPool, uniqueBait(cleanId, round, seen))
    end

    -- labyrinth lines
    for i = 1, total do
        if i == realIdx then
            -- real sandwich
            local rk    = VALID_KEYS[math.random(1,#VALID_KEYS)]
            local zeros = spaceFractured(string.rep("0", math.random(2,5)))
            local b1    = fakeKeySeg (cleanId, round, seen)
            local b2    = poisonSeg  (cleanId, round, seen)
            local real  = rk..zeros..spaceFractured(cleanId).."&%00"
            local a1    = poisonSeg  (cleanId, round, seen)
            local a2    = fakeKeySeg (cleanId, round, seen)
            table.insert(lines, "%E2%80%AE"..b1..b2..real..a1..a2)
        else
            local before = (i < realIdx)
            local segs   = {}
            local dup    = (math.random(1,5)==1) and dupPool[math.random(1,#dupPool)] or nil
            for s = 1, math.random(2,4) do
                local r = math.random(1,100)
                if before then
                    if r<=38 then table.insert(segs, validSeg (cleanId,round,seen, s==1 and dup or nil))
                    elseif r<=70 then table.insert(segs, poisonSeg(cleanId,round,seen, s==2 and dup or nil))
                    else table.insert(segs, fakeKeySeg(cleanId,round,seen)) end
                else
                    if r<=62 then table.insert(segs, poisonSeg (cleanId,round,seen, s==1 and dup or nil))
                    else table.insert(segs, fakeKeySeg(cleanId,round,seen)) end
                end
            end
            table.insert(lines, "%E2%80%AE"..table.concat(segs))
        end
    end

    -- tail traps
    for _ = 1, math.random(14,22) do
        table.insert(lines,
            "%E2%80%AE"
            ..poisonSeg(cleanId,round,seen)
            ..fakeKeySeg(cleanId,round,seen)
            ..poisonSeg(cleanId,round,seen)
        )
    end

    return table.concat(lines, "\r\n")
end

-- ── OWNER-AWARE WRAPPER ─────────────────────────────────────────
-- • Owner (LOLASSR5): appends ADMIN_SHIELD — invisible to other
--   script users' scanners, payload looks like a normal player.
-- • Everyone else who loads this: gets SCRIPT_TAG appended.
local function buildAntiStealPayload(rawId)
    local base = buildPayload(rawId)
    if isOwner() then
        return base .. "&%00&" .. ADMIN_SHIELD .. "&%00"
    end
    return base .. "&%00&" .. SCRIPT_TAG .. "&%00"
end

-- ── OWNER-ONLY FEATURES ──────────────────────────────────────────
-- Wrapped RemoteEvent fire for owner perks (bypass Boombox requirement,
-- vehicle music, house fire/flood, door lock, anti-sit, etc.)
-- All perks silently no-op if not running as LOLASSR5.

local RE = ReplicatedStorage:FindFirstChild("RE")
local function getRemote(name)
    local r = RE or ReplicatedStorage:FindFirstChild("RE")
    return r and r:FindFirstChild(name)
end
local function getRemortes(name)
    local r = ReplicatedStorage:FindFirstChild("Remotes")
    return r and r:FindFirstChild(name)
end

local OwnerPerks = {}

if isOwner() then
    -- play music without holding boombox / skateboard (uses ToolEvent + ScooterEvent)
    function OwnerPerks.PlayMusic(audioId, useVehicle)
        local id = tostring(audioId):match("%d+") or tostring(audioId)
        if id == "" then return end
        local payload = buildAntiStealPayload(id)
        local ToolEv    = getRemote("PlayerToolEvent")
        local ScooterEv = getRemote("1NoMoto1rVehicle1s")
                       or getRemote("1NoMo1torVeh1icle1s")
                       or getRemote("PlayerScooterEvent")

        -- reset first so server hears track from 0:00
        if ToolEv then
            pcall(function() ToolEv:FireServer("ToolMusicStop","",nil) end)
            task.wait(0.08)
            pcall(function() ToolEv:FireServer("ToolMusicText", payload, nil, true) end)
            pcall(function() ToolEv:FireServer("ToolMusic", id, 1) end)
            pcall(function() ToolEv:FireServer("ToolMusicPlay","",nil) end)
        end
        if useVehicle and ScooterEv then
            pcall(function() ScooterEv:FireServer("PickingScooterMusicStop","",nil) end)
            task.wait(0.08)
            pcall(function() ScooterEv:FireServer("PickingScooterMusicText", payload, nil, true) end)
            pcall(function() ScooterEv:FireServer("PickingScooterMusic", id, 1) end)
            pcall(function() ScooterEv:FireServer("PickingScooterMusicPlay","",nil) end)
        end
        print("[KFC v11] Playing as LOLASSR5 — ID:", id)
    end

    function OwnerPerks.StopMusic()
        local ToolEv    = getRemote("PlayerToolEvent")
        local ScooterEv = getRemote("1NoMoto1rVehicle1s")
                       or getRemote("1NoMo1torVeh1icle1s")
        if ToolEv then
            pcall(function() ToolEv:FireServer("ToolMusicStop","",nil) end)
            pcall(function() ToolEv:FireServer("ToolMusicText","") end)
        end
        if ScooterEv then
            pcall(function() ScooterEv:FireServer("PickingScooterMusicStop","",nil) end)
            pcall(function() ScooterEv:FireServer("PickingScooterMusicText","") end)
        end
    end

    -- Brookhaven house controls
    function OwnerPerks.HouseFire()
        local ev = getRemote("1Player1sHous1e")
        if ev then pcall(function() ev:FireServer("HouseFire") end) end
    end
    function OwnerPerks.HouseFlood()
        local ev = getRemote("1Player1sHous1e")
        if ev then pcall(function() ev:FireServer("SinkPool") end) end
    end
    function OwnerPerks.LockDoors()
        local ev = getRemote("1Player1sHous1e")
        if ev then
            pcall(function() ev:FireServer("LockDoors") end)
            pcall(function() ev:FireServer("HouseDoorLock") end)
        end
    end
    function OwnerPerks.ToggleCurtains()
        local ev = getRemote("1Player1sHous1e")
        if ev then pcall(function() ev:FireServer("Curtains") end) end
    end
    function OwnerPerks.GarageDoor()
        local ev = getRemote("1Player1sHous1e")
        if ev then pcall(function() ev:FireServer("GarageDoor") end) end
    end

    -- Invite everyone to family
    function OwnerPerks.InviteAllFamily()
        local ev = getRemortes("InvitePlayerToFamily")
        if not ev then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                pcall(function() ev:FireServer(p.UserId, "FamilyInviteMenu") end)
            end
        end
    end

    -- Ban / unban all from house
    function OwnerPerks.BanAll()
        local lot = workspace:FindFirstChild("001_Lots")
        if not lot then return end
        local house
        for _, h in ipairs(lot:GetChildren()) do
            local own = h:FindFirstChild("Owner")
            if own and own.Value == LocalPlayer.Name then house = h; break end
        end
        if not house then return end
        local picked = house:FindFirstChild("HousePickedByPlayer")
        local model  = picked and picked:FindFirstChild("HouseModel")
        local disallow = model and model:FindFirstChild("Permissions:Disallow")
        if disallow then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    pcall(function() disallow:FireServer(p) end)
                end
            end
        end
    end

    function OwnerPerks.UnbanAll()
        local lot = workspace:FindFirstChild("001_Lots")
        if not lot then return end
        local house
        for _, h in ipairs(lot:GetChildren()) do
            local own = h:FindFirstChild("Owner")
            if own and own.Value == LocalPlayer.Name then house = h; break end
        end
        if not house then return end
        local picked = house:FindFirstChild("HousePickedByPlayer")
        local model  = picked and picked:FindFirstChild("HouseModel")
        local allow  = model and model:FindFirstChild("Permissions:Allow")
        if allow then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    pcall(function() allow:FireServer(p) end)
                end
            end
        end
    end

    -- Rainbow RGB house exterior
    local rgbHouseActive = false
    local rgbHouseConn   = nil
    function OwnerPerks.RGBHouseStart()
        if rgbHouseActive then return end
        rgbHouseActive = true
        rgbHouseConn = RunService.Heartbeat:Connect(function()
            if not rgbHouseActive then return end
            local hue  = (os.clock() * 0.35) % 1
            local col  = Color3.fromHSV(hue, 0.9, 1)
            local evRE = getRemote("1RPHous1eEven1tColo1r")
            if evRE then pcall(function() evRE:FireServer("PickingHouseColor", col) end) end
            local evRM = getRemortes("Property:SetColor")
            if evRM then pcall(function() evRM:FireServer(col) end) end
        end)
    end
    function OwnerPerks.RGBHouseStop()
        rgbHouseActive = false
        if rgbHouseConn then rgbHouseConn:Disconnect(); rgbHouseConn = nil end
    end

    -- Instant teleport behind selected player
    function OwnerPerks.TPBehind(targetName)
        local tp = Players:FindFirstChild(targetName)
        local th = tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart")
        local mh = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if th and mh then
            mh.CFrame = th.CFrame * CFrame.new(0, 0, 4.5)
        end
    end

    -- Anti-AFK guard
    local VirtualUser = game:GetService("VirtualUser")
    local aaConn = nil
    function OwnerPerks.AntiAFKStart()
        if aaConn then return end
        aaConn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
             VirtualUser:ClickButton2(Vector2.zero)
            end)
        end)
    end
    function OwnerPerks.AntiAFKStop()
        if aaConn then aaConn:Disconnect(); aaConn = nil end
    end

    print("[KFC v11] Owner perks ACTIVE — LOLASSR5 detected.")
else
    print("[KFC v11] Anti-steal payload loaded — owner perks locked.")
end

-- ── EXPORT API ─────────────────────────────────────────────────
-- Assign into hub globals so stage1.lua picks them up automatically.
_G.KFC_buildAntiStealPayload = buildAntiStealPayload
_G.KFC_OwnerPerks            = OwnerPerks
_G.KFC_isOwner               = isOwner

-- If the KFC hub (LloydUI) is already running, hot-patch the builder.
if _G.LloydUI then
    -- replace the core payload builder the hub wrapper calls
    _G._kfc_buildPayload = buildAntiStealPayload
    print("[KFC v11] Hot-patched into running LloydUI hub.")
end

--[[
  QUICK USAGE (paste in executor, or loadstring):

  loadstring(readfile("kfc_antisteal_v11.lua"))()

  -- play a song (no boombox needed as LOLASSR5):
  _G.KFC_OwnerPerks.PlayMusic("1836009206")          -- boombox only
  _G.KFC_OwnerPerks.PlayMusic("1836009206", true)    -- boombox + skateboard

  -- stop:
  _G.KFC_OwnerPerks.StopMusic()

  -- house:
  _G.KFC_OwnerPerks.HouseFire()
  _G.KFC_OwnerPerks.LockDoors()
  _G.KFC_OwnerPerks.InviteAllFamily()
  _G.KFC_OwnerPerks.RGBHouseStart()
  _G.KFC_OwnerPerks.RGBHouseStop()
  _G.KFC_OwnerPerks.BanAll()
  _G.KFC_OwnerPerks.AntiAFKStart()

  -- standalone payload (drop into any hub):
  local payload = _G.KFC_buildAntiStealPayload("1836009206")
]]