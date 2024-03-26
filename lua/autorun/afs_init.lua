if SERVER then

        local function isBanned(steamid64)
                local duration = 0
                local banned = false

                // do something

                if not banned then return banned end

                return true, duration
        end

        hook.Add('PlayerInitialSpawn', 'AFS_PlayerConnectListener', function(ply, transition) 
                banned, duration = isBanned(ply:OwnerSteamID64())
                if not banned then return end

                RunConsoleCommand('ulx ban', ply:Nick(), duration)
        end)
end