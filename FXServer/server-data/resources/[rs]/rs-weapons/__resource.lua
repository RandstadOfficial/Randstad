resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'RS:Weapons'

server_scripts {
    "config.lua",
    "server/main.lua",
}

client_scripts {
    "config.lua",
    "client/recoil.lua",
	"client/main.lua",
}

files {
    -- 'weaponsnspistol.meta',
    'weapons.meta',
    -- 'weaponvintagepistol.meta',
}

-- data_file 'WEAPONINFO_FILE_PATCH' 'weaponsnspistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons.meta'
-- data_file 'WEAPONINFO_FILE_PATCH' 'weaponvintagepistol.meta'