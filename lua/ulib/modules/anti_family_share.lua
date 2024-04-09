if SERVER then

        if not ULib then return end

        print('Anti family share carregado')

        local function isBanned(ownerid)
                local banned = false

                if not ULib.bans[ownerid] then return banned end

                return true, ULib.bans[ownerid]
        end

        -- TODO: implementar sistema de desbanimento nas alts caso a principal seja desbanida?
        local function banAlt(baninfo, steamid, ownerid)
                local newban = {}
                newban.unban = baninfo.unban
                newban.time = baninfo.time
                newban.reason = 'Conta secundária de (' .. ownerid .. '); ' .. baninfo.reason
                newban.admin = baninfo.admin
                ULib.bans[steamid] = newban

                ULib.fileWrite( ULib.BANS_FILE, ULib.makeKeyValues( ULib.bans ) )
                return newban.reason
        end

        hook.Add("PlayerAuthed", "AFS_PlayerConnectListener", function( ply, steamid, uniqueid )
                print('Verificando se o jogador ' .. ply:Nick() .. '(' .. ply:SteamID() .. ') está banido em outra conta...')
                local ownerid64, steamid64 = ply:OwnerSteamID64(), ply:SteamID64()
                if ownerid64 == steamid64 then 
                        print('Esta conta não é secundária.')
                        return end
                local ownerid, steamid = util.SteamIDFrom64(ownerid64), util.SteamIDFrom64(steamid64)
                local banned, baninfo = isBanned(ownerid)
                if not banned then
                        print('Não há banimento para a conta em posse do jogo.')
                        return end
                print('Jogador ' .. ply:Nick() .. ' está banido em outra conta (' .. ownerid .. ')')
                local banreason = banAlt(baninfo, steamid, ownerid)

                RunConsoleCommand('ulx', 'kick', ply:Nick(), banreason)
        end)
end