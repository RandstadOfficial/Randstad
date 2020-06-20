resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

this_is_a_map 'yes'

files {
    'gabz_timecycle_mods_1.xml', 
    'interiorproxies.meta',
}
data_file 'TIMECYCLEMOD_FILE' 'gabz_timecycle_mods_1.xml'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

client_script {
    "main.lua"
}
