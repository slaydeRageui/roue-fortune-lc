
isRoll = false
amount = 50000
isOccuper = false

RegisterServerEvent('roueFortune:isOccuper')
AddEventHandler('roueFortune:isOccuper', function()
    isOccuper = true
end)

--function Notif(msg) SetNotificationTextEntry('STRING') AddTextComponentSubstringPlayerName(msg) DrawNotification(false, true) end

RegisterServerEvent('roueFortune:getLucky')
AddEventHandler('roueFortune:getLucky', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isRoll then
        if xPlayer ~= nil then
            if 1 < 2 then
                isRoll = true
                -- local _priceIndex = math.random(1, 20)
                local _randomPrice = math.random(1, 100)
                if _randomPrice == 1 then
                    -- une voiture
                    local _subRan = math.random(1,1000)
                    if _subRan <= 1 then
                        _priceIndex = 19
                    else
                        _priceIndex = 3
                    end
                elseif _randomPrice > 1 and _randomPrice <= 6 then
                    -- une arme
                    _priceIndex = 12
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 12
                    else
                        _priceIndex = 7
                    end
                elseif _randomPrice > 6 and _randomPrice <= 15 then
                    -- argent sale
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 4
                    elseif _sRan == 2 then
                        _priceIndex = 8
                    elseif _sRan == 3 then
                        _priceIndex = 11
                    else
                        _priceIndex = 16
                    end
                elseif _randomPrice > 15 and _randomPrice <= 25 then
                    -- argent
                    -- _priceIndex = 5
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 5
                    else
                        _priceIndex = 20
                    end
                elseif _randomPrice > 25 and _randomPrice <= 40 then
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 1
                    elseif _sRan == 2 then
                        _priceIndex = 9
                    elseif _sRan == 3 then
                        _priceIndex = 13
                    else
                        _priceIndex = 17
                    end
                elseif _randomPrice > 40 and _randomPrice <= 60 then
                    local _itemList = {}
                    _itemList[1] = 2
                    _itemList[2] = 6
                    _itemList[3] = 10
                    _itemList[4] = 14
                    _itemList[5] = 18
                    _priceIndex = _itemList[math.random(1, 5)]
                elseif _randomPrice > 60 and _randomPrice <= 100 then
                    local _itemList = {}
                    _itemList[1] = 3
                    _itemList[2] = 7
                    _itemList[3] = 15
                    _itemList[4] = 20
                    _priceIndex = _itemList[math.random(1, 4)]
                end

                SetTimeout(5000, function()
                    isRoll = false
                    -- Prix a gagner
                    if _priceIndex == 1 or _priceIndex == 9 or _priceIndex == 13 or _priceIndex == 17 then
                        --print("armure")
                        TriggerClientEvent('okokNotify:Alert', _source, "Roue de la fortune", "Vous n\'avez rien gagné, retentez votre chance dans 24H !", 5000, 'info')
                    elseif _priceIndex == 2 or _priceIndex == 6 or _priceIndex == 10 or _priceIndex == 14 or _priceIndex == 18 then
                        --print("pain eau")
                        xPlayer.addInventoryItem("bread", 10)
                        xPlayer.addInventoryItem("water", 24)
                        TriggerClientEvent('okokNotify:Alert', _source, "Roue de la fortune", "Bravo vous avez gagné du pain et de l\'eau !", 5000, 'success')
                    elseif _priceIndex == 3 or _priceIndex == 7 or _priceIndex == 15 or _priceIndex == 20 then
                        --print("argent")
                        local _money = 0
                        if _priceIndex == 3 then
                            _money = 1000
                        elseif _priceIndex == 7 then
                            _money = 2000
                        elseif _priceIndex == 15 then
                            _money = 3000
                        elseif _priceIndex == 20 then
                            _money = 4000
                        end
                        xPlayer.addAccountMoney("bank", _money)
                        TriggerClientEvent('okokNotify:Alert', _source, "Roue de la fortune", "Bravo vous avez gagné ".. ESX.Math.GroupDigits(_money) .."$", 5000, 'success')
                    elseif _priceIndex == 4 or _priceIndex == 8 or _priceIndex == 11 or _priceIndex == 16 or _priceIndex == 12 then
                        --print("argent sale x2")
                        TriggerClientEvent('okokNotify:Alert', _source, "Roue de la fortune", "Vous n\'avez rien gagné, retentez votre chance dans 24H !", 5000, 'info')
                    elseif _priceIndex == 5 then
                        --print("300 000$")
                        xPlayer.addAccountMoney('black_money', 20000)
                        TriggerClientEvent('okokNotify:Alert', _source, "Roue de la fortune", "Bravo vous avez gagné 20 000$ d\'argent sale !", 5000, 'success')
                    elseif _priceIndex == 19 then
                        --print("voiture")
                        TriggerClientEvent("roueFortune:voiture", _source)
                        TriggerClientEvent('okokNotify:Alert', _source, "Roue de la fortune", "Félicitation ! Vous avez gagné la voiture !", 5000, 'success')
                    end
                    TriggerClientEvent("roueFortune:rollFinished", _source)
                    isOccuper = false
                end)
                TriggerClientEvent("roueFortune:doRoll", _source, _priceIndex)
            else
                TriggerClientEvent("roueFortune:rollFinished", _source)    
            end
        end
    end
end)


RegisterNetEvent("setup")
AddEventHandler("setup", function(playerNameee)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if isOccuper == true then
        TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Roue de la fortune", "Une personne toune déjà la roue, merci de patientez.", 5000, 'error')
    elseif isOccuper == false then
        MySQL.Async.fetchAll("SELECT * FROM rouefortune WHERE name = @a", {["@a"] = xPlayer.identifier},
        function(result)
            if result[1] then
                if tostring(result[1].args) == os.date("%d/%m/%Y") then
                    --meme jour
                    TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Roue de la fortune", 'Vous avez déjà tourner la roue aujourd\'hui. <br>(' .. tostring(result[1].args) .. ')', 5000, 'error')
                else
                    --c'est bon
                    TriggerClientEvent("roueFortune:good", xPlayer.source) 
                    MySQL.Async.execute("UPDATE rouefortune SET args = @a WHERE name = @b",     
                    {["@b"] = xPlayer.identifier, ["@a"] = os.date("%d/%m/%Y")},function () end)
                end
                --local date = tostring(result[1].args) 
                --print(date)
            else
                TriggerClientEvent("roueFortune:good", xPlayer.source) 
                MySQL.Async.execute("INSERT INTO rouefortune (name, args) VALUES (@name, @args)",     
                {["@name"] = xPlayer.identifier, ["@args"] = os.date("%d/%m/%Y")},function () end)
            end
        end)  
    else
        TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Roue de la fortune", 'Un problème est survenue, merci de patientez.', 5000, 'error')
    end
end)
