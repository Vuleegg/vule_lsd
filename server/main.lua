ESX = exports['es_extended']:getSharedObject()
local RSE = RegisterServerEvent 
local AEH = AddEventHandler
local TE = TriggerEvent
local TCE = TriggerClientEvent 
local CT = CreateThread


CreateThread(function()
  print("[^1"..GetCurrentResourceName().."^7] Skripta ucitana | verzija 1.0.0")
end)


RSE("lsd:dajeitem", function()
 local igrac = ESX.GetPlayerFromId(source)
    igrac.addInventoryItem("lizerginska_kiselina", 3)
    igrac.addInventoryItem("antibiotici", 5)
    igrac.addInventoryItem("pouches", 17)
end)

RSE("provera2", function()
  local igrac = ESX.GetPlayerFromId(source) 
  if igrac.getInventoryItem("lizerginska_kiselina").count >= 3 and  igrac.getInventoryItem("antibiotici").count >= 5 and igrac.getInventoryItem("pouches").count >= 17 then
   TCE("kuvanje:sr", source)
  else 
    TriggerClientEvent("esx:showNotification", source, Config.Locale["missing"].message)
  end
end)

RSE("lsd:lsd", function()
  local igrac = ESX.GetPlayerFromId(source) 
   igrac.addInventoryItem("tableta_lsd", 5)
   igrac.removeInventoryItem("lizerginska_kiselina", 3)
   igrac.removeInventoryItem("antibiotici", 5)
   igrac.removeInventoryItem("pouches", 17)
end)

RSE("provera", function()
  local igrac = ESX.GetPlayerFromId(source)

  if igrac.getAccount("black_money").money >= 4500 then
    TCE("startuj", source)
    igrac.removeAccountMoney("black_money", 4500)
  else 
    TriggerClientEvent("esx:showNotification", source, Config.Locale["noblack"].message)
  end
end)

RSE("gg:sell", function()
  local igrac = ESX.GetPlayerFromId(source)
  for k, v in pairs(Config.Sell) do
  local lsd = igrac.getInventoryItem('tableta_lsd').count 
  local distanca = #(GetEntityCoords(GetPlayerPed(source)) - v.coords)
  local isplata = 0 
  isplata = 150 * lsd



  if distanca < 3.5 then
      if lsd >= 1 then

          TCE("gg:moviescene", source)
          igrac.removeInventoryItem('tableta_lsd', lsd)
          igrac.addAccountMoney("black_money", isplata)
          TriggerClientEvent("esx:showNotification", source, Config.Locale["selled"].message)
          LogsLSD("Logs » LSD SELL", GetPlayerName(igrac.source) .. " was sell LSD for : " ..isplata)
      else
        TriggerClientEvent("esx:showNotification", source, Config.Locale["notenough"].message)
      end    
  else
      DropPlayer(source, 'Cheating is rude')
    end
  end
end)

function LogsLSD(name, message)
  local poruka = {
      {
          ["color"] = 2061822,
          ["title"] = "**".. name .."**",
          ["description"] = message,
          ["footer"] = {
      ["text"] = os.date'%d/%m/%Y [%X]',
          },
      }
    }
  PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Server » Logovi", embeds = poruka, avatar_url = ""}), { ['Content-Type'] = 'application/json' })
end