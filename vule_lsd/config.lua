Config = {}
Config.Debug = false
Config.Time = 60000 -- time for cooking
Config.Blip = true -- if you dont want a blip on map change to false
Config.Ui = '[E] - pretrazi drop' -- text when drop land
Config.ProgressLabel = 'Pretrazujete drop'
Config.Search = 10000 -- search time
Config.Cook = "Hemicari kuvaju sada"-- cook time
Config.Webhook = "WEBHOOK"

Config.Drop = {
    drop = {
      coords = vector3(-202.44, 6301.2, 30.48),
      label = "Air Drop",
      targetlabel = "Koristi air drop",
      id = 90,
      color = 6,
      heading = 322.28,
    },
}

Config.Sell = {
    sell = {
        coords = vector3(149.08, 6362.84, 30.52),
        targetlabel = "Prodaj LSD",
        camera = vector3(148.6, 6357.76, 30.52), -- camera position for selling
        heading = 131.64,
    },
}

Config.Table = {
    table = {
        targetlabel = "Kuvaj LSD",
        coords = vector3(2431.79, 4968.49, 42.35),
    },
}

Config.Npc = {
    npc1 = {
        coords = vector3(2432.04, 4967.52, 41.36),
        scenario = "CODE_HUMAN_MEDIC_TIME_OF_DEATH", -- animation for npc must me scenario or change code on client side
        heading = 322.12,
    },
    npc2 = {
        coords = vector3(2431.52, 4969.16, 41.36),
        scenario = "WORLD_HUMAN_GUARD_STAND",
        heading = 200.88,
    },
    npc3 = {
        coords = vector3(2432.72, 4970.36, 41.36),
        scenario = "WORLD_HUMAN_WELDING",
        heading = 224.32,
    },
}

Config.Locale = { -- notification
    ["airdrop"] = {
        message = 'Air drop je zapoceo,sacekajte momenat da stigne.',
    },
    ["noblack"] = {
        message = 'Nemate dovoljno prljavog novca.',
    },
    ["missing"] = {
        message = 'Nesto vam fali!',
    },
    ["already"] = {
        message = 'Neko vec kuva,sacekajte dok zavrsi.',
    },
    ["selled"] = {
        message = 'Prodali ste iteme dileru.',
    },
    ["notenough"] = {
        message = 'Nemate dovoljno LSD-a za prodaju!',
    },
}