ESX = exports['es_extended']:getSharedObject()
local RNE = RegisterNetEvent 
local AEH = AddEventHandler
local TE = TriggerEvent
local TSE = TriggerServerEvent 
local CT = CreateThread
local pilot, aircraft, parachute, crate, pickup, blip, soundID
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "cuban800", "s_m_m_pilot_02", "prop_box_wood02a_pu"}
local getCrate = true
local itemObj = {}
local stvorio = false

AEH("onResourceStop", function(res)
	local ped = PlayerPedId()
	if GetCurrentResourceName() == res then
		ESX.Game.DeleteObject(GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, `ex_prop_adv_case_sm`, false, false, false))
		ClearPedTasks(ped)
        StopSound(soundID)
  end
end)


CT(function()
    for k, v in pairs(Config.Drop) do
    RequestModel(GetHashKey('g_m_m_chemwork_01'))
    while not HasModelLoaded(GetHashKey('g_m_m_chemwork_01')) do
    Wait(1)
    end
    PostaviPeda = CreatePed(4, 'g_m_m_chemwork_01', v.coords, v.heading, false, true)
    TaskStartScenarioInPlace(PostaviPeda, 'WORLD_HUMAN_STAND_IMPATIENT', 0, false)
    FreezeEntityPosition(PostaviPeda, true) 
    SetEntityInvincible(PostaviPeda, true)
    SetBlockingOfNonTemporaryEvents(PostaviPeda, true) 
    exports.qtarget:AddBoxZone(k, v.coords, 0.85, 0.75, {
        name=k,
        heading=11.0,
        debugPoly=Config.Debug,
        minZ=v.coords.z -1,
        maxZ=v.coords.z +2,
        }, {
            options = {
                {
                    action = function()
                        provera()
                    end,
                    label = v.targetlabel,
                },
            },
            distance = 3.5
    })
  end 
end) 

RNE("provera22", function()
    TSE("provera2")
end)

RNE("kuvanje:sr", function()
    kuvanje()
end)

function  kuvanje()
if stvorio == true then 
 ESX.ShowNotification(Config.Locale["already"]["message"])
   else
    kuvanjenpc()
    lib.progressCircle({
		duration = Config.Time,
		label = Config.Cook,
		useWhileDead = false,
		canCancel = true,
		disable = {
			move = true,
			car = true,
			combat = true,
		},
    })
    exports.qtarget:RemoveZone('lsd')
    TSE("lsd:lsd")
    stvorio = false
 end
end

function provera2()
    TSE("provera2")
end

function kuvanjenpc()
    for k, v in pairs(Config.Npc) do
        stvorio = true
        RequestModel(GetHashKey('g_m_m_chemwork_01'))
        while not HasModelLoaded(GetHashKey('g_m_m_chemwork_01')) do
        Wait(1)
        end
        npczadatak = CreatePed(4, 'g_m_m_chemwork_01', v.coords, v.heading, false, true)
        TaskStartScenarioInPlace(npczadatak, v.scenario, 0, false)
        FreezeEntityPosition(npczadatak, true) 
        SetEntityInvincible(npczadatak, true)
        SetBlockingOfNonTemporaryEvents(npczadatak, true)
  end
end



function provera()
    TSE("provera")
end


CT(function()
while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RNE("startuj", function(playerServerID, args, rawString)
    local playerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0)
    TriggerEvent("napravidrop", false, 400.0, {["x"] = playerCoords.x, ["y"] = playerCoords.y, ["z"] = playerCoords.z})
    ESX.ShowNotification(Config.Locale["airdrop"]["message"])
end)


RNE("napravidrop")
AEH("napravidrop", function(roofCheck, planeSpawnDistance, dropCoords)
    CT(function()

        if dropCoords.x and dropCoords.y and dropCoords.z and tonumber(dropCoords.x) and tonumber(dropCoords.y) and tonumber(dropCoords.z) then

        else
            dropCoords = {0.0, 0.0, 72.0}
        end

        if roofCheck and roofCheck ~= "false" then 

            local ray = StartShapeTestRay(vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), vector3(dropCoords.x, dropCoords.y, dropCoords.z), -1, -1, 0)
            local _, hit, impactCoords = GetShapeTestResult(ray)

            if hit == 0 or (hit == 1 and #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)) < 10.0) then 

                napravidrop(planeSpawnDistance, dropCoords)
            else
                return
            end
        else
            napravidrop(planeSpawnDistance, dropCoords)
        end

    end)
end)

function napravidrop(planeSpawnDistance, dropCoords)
   CT(function()

        for i = 1, #requiredModels do
            RequestModel(GetHashKey(requiredModels[i]))
            while not HasModelLoaded(GetHashKey(requiredModels[i])) do
                Wait(0)
            end
        end

        RequestWeaponAsset(GetHashKey("weapon_flare")) 
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end

        local rHeading = math.random(0, 360) + 0.0
        local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0 
        local theta = (rHeading / 180.0) * 3.14
        local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0) 

        local dx = dropCoords.x - rPlaneSpawn.x
        local dy = dropCoords.y - rPlaneSpawn.y
        local heading = GetHeadingFromVector_2d(dx, dy) 

        aircraft = CreateVehicle(GetHashKey("cuban800"), rPlaneSpawn, heading, true, true)
        SetEntityHeading(aircraft, heading)
        SetVehicleDoorsLocked(aircraft, 2) 
        SetEntityDynamic(aircraft, true)
        ActivatePhysics(aircraft)
        SetVehicleForwardSpeed(aircraft, 60.0)
        SetHeliBladesFullSpeed(aircraft) 
        SetVehicleEngineOn(aircraft, true, true, false)
        ControlLandingGear(aircraft, 3) 
        OpenBombBayDoors(aircraft) 
        SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

        pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
        SetBlockingOfNonTemporaryEvents(pilot, true) 
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        SetPlaneMinHeightAboveTerrain(aircraft, 50) 

        TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), 60.0, 0, GetHashKey("cuban800"), 262144, 15.0, -1.0) 

        local droparea = vector2(dropCoords.x, dropCoords.y)
        local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
        while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do 
            Wait(100)
            planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y) 
        end

        if IsEntityDead(pilot) then 
            print("PILOT: dead")
            do return end
        end

        TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey("cuban800"), 262144, -1.0, -1.0) 
        SetEntityAsNoLongerNeeded(pilot) 
        SetEntityAsNoLongerNeeded(aircraft)

        local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0) 

        crate = CreateObject(GetHashKey("prop_box_wood02a_pu"), crateSpawn, true, true, true) 
        SetEntityLodDist(crate, 1000) 
        ActivatePhysics(crate)
        SetDamping(crate, 2, 0.1) 
        SetEntityVelocity(crate, 0.0, 0.0, -0.2) 

        parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, true, true, true) 
        SetEntityLodDist(parachute, 1000)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)


        soundID = GetSoundId() 
        PlaySoundFromEntity(soundID, "Crate_Beeps", crate, "MP_CRATE_DROP_SOUNDS", true, 0) 

        blip = AddBlipForEntity(crate)
        SetBlipSprite(blip, 408)
        SetBlipNameFromTextFile(blip, "AMD_BLIPN")
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        SetBlipAlpha(blip, 120)


        AttachEntityToEntity(parachute, crate, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

        while HasObjectBeenBroken(crate) == false do
            Wait(0)
        end
		
		
        local parachuteCoords = vector3(GetEntityCoords(parachute))
        ShootSingleBulletBetweenCoords(parachuteCoords, parachuteCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0) 
        DetachEntity(parachute, true, true)

        DeleteEntity(parachute)
        DetachEntity(crate)
        SetBlipAlpha(blip, 255)


       local  obj = CreateObject(`ex_prop_adv_case_sm`, parachuteCoords, false, true)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			table.insert(itemObj, obj)


		
        while getCrate do 
			Wait(0)
			
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(PlayerPedId())
			local nearbyObject, nearbyID
			
			for i=1, #itemObj, 1 do
				if GetDistanceBetweenCoords(coords, GetEntityCoords(itemObj[i]), false) < 2 then
					nearbyObject, nearbyID = itemObj[i], i
				end
			end
			
            if nearbyObject and IsPedOnFoot(playerPed) then
				
                lib.showTextUI(Config.Ui)
				if IsControlJustPressed(1, 38) then
                    dajitem()
                    table2()
					ESX.Game.DeleteObject(nearbyObject)
					getCrate = false
                    lib.hideTextUI()
				end       
			end
        end

        while DoesObjectOfTypeExistAtCoords(parachuteCoords, 10.0, GetHashKey("w_am_flare"), true) do
            Wait(0)
            local prop = GetClosestObjectOfType(parachuteCoords, 10.0, GetHashKey("w_am_flare"), false, false, false)
            RemoveParticleFxFromEntity(prop)
            SetEntityAsMissionEntity(prop, true, true)
            DeleteObject(prop)
        end

        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end

        StopSound(soundID)
        ReleaseSoundId(soundID)

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
		getCrate = true
    end)
end

function filmskascena2(cut, coords)
    while not HasThisCutsceneLoaded(cut) do 
        RequestCutscene(cut, 8)
        Wait(0) 
    end
    napraviscenu2(false, coords)
    gotovo2(coords)
    RemoveCutscene()
    DoScreenFadeIn(500)
end

function napraviscenu2(change, coords)
    local ped = PlayerPedId()
        
    local clone = ClonePedEx(ped, 0.0, false, true, 1)
    local clone2 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone3 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone4 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone5 = ClonePedEx(ped, 0.0, false, true, 1)

    SetBlockingOfNonTemporaryEvents(clone, true)
    SetEntityVisible(clone, false, false)
    SetEntityInvincible(clone, true)
    SetEntityCollision(clone, false, false)
    FreezeEntityPosition(clone, true)
    SetPedHelmet(clone, false)
    RemovePedHelmet(clone, true)
    
    if change then
        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_2', 0, GetEntityModel(ped), 64)
        
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_1', 0, GetEntityModel(clone2), 64)
    else
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_1', 0, GetEntityModel(ped), 64)

        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_2', 0, GetEntityModel(clone2), 64)
    end

    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(clone3, 'MP_3', 0, GetEntityModel(clone3), 64)
    
    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(clone4, 'MP_4', 0, GetEntityModel(clone4), 64)
    
    SetCutsceneEntityStreamingFlags('MP_5', 0, 1)
    RegisterEntityForCutscene(clone5, 'MP_5', 0, GetEntityModel(clone5), 64)
    
    Wait(10)
    if coords then
        StartCutsceneAtCoords(coords, 0)
    else
        StartCutscene(0)
    end
    Wait(10)
    ClonePedToTarget(clone, ped)
    Wait(10)
    DeleteEntity(clone)
    DeleteEntity(clone2)
    DeleteEntity(clone3)
    DeleteEntity(clone4)
    DeleteEntity(clone5)
    Wait(50)
    DoScreenFadeIn(250)
end

function gotovo2(coords)
    if coords then
        local tripped = false
        repeat
            Wait(0)
            if (timer and (GetCutsceneTime() > timer))then
                DoScreenFadeOut(250)
                tripped = true
            end
            if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
            DoScreenFadeOut(250)
            tripped = true
            end
        until not IsCutscenePlaying()
        if (not tripped) then
            DoScreenFadeOut(100)
            Wait(150)
        end
        return
    else
        Wait(18500)
        StopCutsceneImmediately()
    end
end




function dajitem()
    lib.progressCircle({
		duration = Config.Search,
		label = Config.ProgressLabel,
		useWhileDead = false,
		canCancel = true,
		disable = {
			move = true,
			car = true,
			combat = true,
		},
	anim = { 
        dict = 'anim@gangops@facility@servers@bodysearch@', 
        clip = 'player_search' 
    },
}) 
	TSE('lsd:dajeitem')
end

function  table2()
    for k, v in pairs(Config.Table) do
    exports.qtarget:AddBoxZone("lsd", v.coords, 0.85, 0.75, {
        name="lsd",
        heading=11.0,
        debugPoly=Config.Debug,
        minZ=v.coords.z -1,
        maxZ=v.coords.z +2,
        }, {
            options = {
                {
                    action = function()
                        kuvanje()
                    end,
                    label = v.targetlabel,
                },
            },
            distance = 3.5
    })
  end
end

CT(function()
    for k, v in pairs(Config.Sell) do
        RequestModel(GetHashKey('cs_lazlow'))
        while not HasModelLoaded(GetHashKey('cs_lazlow')) do
        Wait(1)
        end
        PostaviPeda = CreatePed(4, 'cs_lazlow', v.coords, v.heading, false, true)
        TaskStartScenarioInPlace(PostaviPeda, 'WORLD_HUMAN_JANITOR', 0, false)
        FreezeEntityPosition(PostaviPeda, true) 
        SetEntityInvincible(PostaviPeda, true)
        SetBlockingOfNonTemporaryEvents(PostaviPeda, true) 
    exports.qtarget:AddBoxZone("sell", v.coords, 0.85, 0.75, {
        name="sell",
        heading=11.0,
        debugPoly=Config.Debug,
        minZ=v.coords.z -1,
        maxZ=v.coords.z +2,
        }, {
            options = {
                {
                    action = function()
                        sell()
                    end,
                    label = v.targetlabel,
                },
            },
            distance = 3.5
    })
  end
end)

function sell()
    TSE("gg:sell")
end

RNE("gg:moviescene", function()
for k, v in pairs(Config.Sell) do
 filmskascena2('hs3f_all_drp3', v.camera)
    end
end)

CT(function()
for k, v in pairs(Config.Drop) do 
 if Config.Blip == true then
    Config.Blip = AddBlipForCoord(v.coords)
   SetBlipSprite(Config.Blip, v.id)
   SetBlipDisplay(Config.Blip, 4)
   SetBlipScale(Config.Blip, 0.8)
   SetBlipColour(Config.Blip, v.color)
   SetBlipAsShortRange(Config.Blip, true)
   BeginTextCommandSetBlipName("STRING")
   AddTextComponentString(v.label)
   EndTextCommandSetBlipName(Config.Blip)
    end
  end
end)

