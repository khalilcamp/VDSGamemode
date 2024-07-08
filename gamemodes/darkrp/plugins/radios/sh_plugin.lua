
PLUGIN.name = "Radios"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds radio"
PLUGIN.schema = "Any"
PLUGIN.version = 1.0
PLUGIN.songs = {
    [''] = "Stop",
    ["ranz/delivery-lethal-company.mp3"] = "Entregas",
    ["vehicles_radio/galaxy_news_radio/fox_boogie.mp3"] = "Boogie",
    ["vehicles_radio/galaxy_news_radio/jazzy_interlude.mp33"] = "Jazzy",
    ["vehicles_radio/galaxy_news_radio/rhythm_for_you.mp3"] = "Rhythm For You",
    ["vehicles_radio/galaxy_news_radio/jolly_days.mp3"] = "Jolly",
    ["vehicles_radio/galaxy_news_radio/happy_times.mp3"] = "Happy Times",
    ["vehicles_radio/galaxy_news_radio/i_dont_want_to_set_the_world_on_fire.mp3"] = "I Dont..",
    ["vehicles_radio/galaxy_news_radio/anything_goes.mp3"] = "Anything Goes",
    ["vehicles_radio/galaxy_news_radio/lets_go_sunning.mp3"] = "Lets Go Sunning",
    ["vehicles_radio/galaxy_news_radio/boogie_man.mp3"] = "Boogie Man",
    ["vehicles_radio/galaxy_news_radio/im_tickled_pink.mp3"] = "Im Tickled Pink",
    ["music/fallout_new_vegas_mojave_radio_station_parte_1_teste1.mp3"] = "Radio Mojave",
}

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")