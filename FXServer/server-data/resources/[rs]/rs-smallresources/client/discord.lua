Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(716768880311402498)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('randstad-logo')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('https://discord.gg/2DRbeFy')
        
        --Here you will have to put the image name for the "small" icon.
        --SetDiscordRichPresenceAssetSmall('logo-mk3')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('https://discord.gg/2DRbeFy')

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)