--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 19-11-2018
-- Time: 16:16
-- Made for CiviliansNetwork
--

vRPanim = {}
Tunnel.bindInterface("cn-animation",vRPanim)
vRP = Proxy.getInterface("vRP")

local animations = {
    ['kaffe'] = {dict = "amb@world_human_aa_coffee@idle_a", anim = "idle_b", locked = false, prop = {propn = "p_amb_coffeecup_01", bindex = 28422}, options = {12.0, -1, -1, 50, 1}, useInCar=true,keepplaying=true,upper=true},
    ['mobil'] = {dict = "cellphone@", anim = "cellphone_text_in", locked = false, prop = {propn = "prop_amb_phone", bindex = 28422}, options = {3.0, -1, -1, 50, 0}, useInCar=true,blocked=true,keepplaying=true},
    ['ringer'] = {dict = "cellphone@", anim = "cellphone_call_in", locked = false, prop = {propn = "prop_amb_phone", bindex = 28422}, options = {12.0, -1, -1, 50, 1}, useInCar=true,blocked=true,keepplaying=true},
    ['pift'] = {dict = "rcmnigel1c", anim = "hailing_whistle_waive_a", locked = false, options = {8.0,-8.0,-1,50,1}, reset = 2300},
    ['skid'] = {dict = "missfbi3ig_0", anim = "shit_loop_trev", locked = true, options = {8.0,-8.0,-1,0,0}, particle = {dict = "scr_amb_chop", name = "ent_anim_dog_poo", bone = 11816, zOffset =-0.8, xRot = 0.0, stop = 3500}},
    ['læn'] = {dict = "amb@world_human_leaning@male@wall@back@legs_crossed@base", anim = "base", locked = true, options = {1.0, 1.0, -1, 9, -1}},
    ['wank'] = {dict = "mp_player_int_upperwank", anim = "mp_player_int_wank_01", locked = false, options = {12.0, -1, -1, 1, 1}},
    ['fuck'] = {dict = "anim@mp_player_intincarfingerstd@ds@", anim = "idle_a", locked = false, options = {1.0, 1.0, -1, 50, -1}, useInCar=true},
    ['highfive'] = {dict = "mp_ped_interaction", anim = "highfive_guy_a", locked = false, options = {1.0, 1.0, -1, 50, -1}},
    --['kram'] = {dict = "mp_ped_interaction", anim = "hugs_guy_b", locked = true, options = {12.0, -1, -1, 50, 1}},
    --['kram2'] = {dict = "anim@mp_player_intcelebrationpaired@f_f_bro_hug", anim = "bro_hug_left", locked = true, options = {12.0, -1, -1, 50, 1}},
    ['armbøjninger'] = {
        multiple={
            [2] = {dict = "amb@world_human_push_ups@male@enter", anim = "enter", locked = false, options = {8.0, 1.0, -1, 0, 0},time=3500},
            [1] = {dict = "amb@world_human_push_ups@male@base", anim = "base", locked = false, options = {8.0, 1.0, -1, 1, 0}}
        },
    },
    ['mavebøjninger'] = {
        multiple={
            [2] = {dict = "amb@world_human_sit_ups@male@enter", anim = "enter", locked = false, options = {8.0, 1.0, -1, 0, 0},time=3500},
            [1] = {dict = "amb@world_human_sit_ups@male@base", anim = "base", locked = false, options = {8.0, 1.0, -1, 1, 0}}
        },
    },
    ['breakopentrunk'] = {dict = "veh@break_in@0h@p_m_one@", anim = "low_force_entry_ds", locked = true, options = {12.0, -1, -1, 1, 1},reset=2200, blocked=true},
    ['krydsarme'] =
    {
        male = {dict = "amb@world_human_hang_out_street@male_c@base", anim = "base", locked = false, options = {-1, -1, -1, 50, 0},keepplaying=true},
        female = {dict = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base", locked = false, options = {-1, -1, -1, 50, 0},keepplaying=true}
    },

    ['bange'] = {dict = "amb@code_human_cower@female@idle_a", anim = "idle_a", locked = false, options = {1.0, 1.0, -1, 9, -1}},
    ['tommel'] = {dict = "random@hitch_lift", anim = "idle_f", locked = false, options = {1.0, 1.0, -1, 50, -1}},
    ['damn'] = {dict = "misscommon@response", anim = "damn", locked = false, options = {1.0, 1.0, -1, 50, -1}},
    ['kors'] = {dict = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base", locked = false, options = {1.0, 1.0, -1, 50, -1}, useInCar=true,keepplaying=true},
    ['pause'] = {dict = "misscommon@response", anim = "give_me_a_break", locked = false, options = {1.0, 1.0, -1, 50, -1}},
    ['gift'] = {dict = "random@peyote@eat", anim = "eat_peyote_plantpot", locked = false, options = {1.0, 1.0, -1, 8, -1}},

    ['dril'] = {dict = "anim@mp_player_intcelebrationmale@thumb_on_ears", anim = "thumb_on_ears", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['luftguitar'] = {dict = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['vinder'] = {dict = "anim@mp_player_intcelebrationmale@air_shagging", anim = "air_shagging", locked = false, options = {1.0, 1.0, -1, 8, -1}},

    ['dans2'] = {dict = "anim@mp_player_intcelebrationmale@air_synth", anim = "air_synth", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans3'] = {dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^6", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans4'] = {dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "med_center_up", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans5'] = {dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "med_right_up", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans6'] = {dict = "timetable@tracy@ig_5@idle_b", anim = "idle_e", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans7'] = {dict = "mini@strip_club@idles@dj@idle_04", anim = "idle_04", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans8'] = {dict = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans9'] = {dict = "anim@amb@nightclub@dancers@black_madonna_entourage@", anim = "hi_dance_facedj_09_v2_male^5", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans10'] = {dict = "anim@mp_player_intcelebrationfemale@uncle_disco", anim = "uncle_disco", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans11'] = {dict = "anim@mp_player_intcelebrationfemale@raise_the_roof", anim = "raise_the_roof", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['dans12'] = {dict = "anim@mp_player_intcelebrationmale@cats_cradle", anim = "cats_cradle", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename

    ['lesterdans'] = {dict = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao", locked = false, options = {1.0, 1.0, -1, 8, -1}}, -- rename
    ['luftkys'] = {dict = "anim@mp_player_intcelebrationmale@blow_kiss", anim = "blow_kiss", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['brolove'] = {dict = "anim@mp_player_intcelebrationmale@bro_love", anim = "bro_love", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['dj'] = {dict = "anim@mp_player_intcelebrationmale@dj", anim = "dj", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['idiot'] = {dict = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['kylling'] = {dict = "anim@mp_player_intcelebrationmale@chicken_taunt", anim = "chicken_taunt", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['fingerkys'] = {dict = "anim@mp_player_intcelebrationmale@finger_kiss", anim = "finger_kiss", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['loco'] = {dict = "anim@mp_player_intcelebrationmale@you_loco", anim = "you_loco", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['hyggefinger'] = {dict = "anim@mp_player_intcelebrationmale@dock", anim = "dock", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['flipud'] = {dict = "anim@mp_player_intcelebrationmale@freakout", anim = "freakout", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['fingerknæk'] = {dict = "anim@mp_player_intcelebrationmale@knuckle_crunch", anim = "knuckle_crunch", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['pilnæse'] = {dict = "anim@mp_player_intcelebrationmale@nose_pick", anim = "nose_pick", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['noway'] = {dict = "anim@mp_player_intcelebrationmale@no_way", anim = "no_way", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['peace'] = {dict = "anim@mp_player_intcelebrationmale@peace", anim = "peace", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['tys'] = {dict = "anim@mp_player_intcelebrationmale@shush", anim = "shush", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['langsomklap'] = {dict = "anim@mp_player_intcelebrationmale@slow_clap", anim = "slow_clap", locked = false, options = {1.0, 1.0, -1, 8, -1}},
    ['tigger'] = {dict = "amb@world_human_bum_freeway@male@base", anim = "base", prop = {propn = "prop_beggers_sign_03", bindex = 0x6f06}, locked = false, options = {8.0, 1.0, -1, 50, 0}},

    ['gørsigklar'] = {dict = "anim@amb@clubhouse@mini@arm_wrestling@", anim = "stand_idle_a", locked = false, options = {8.0, 1.0, -1, 1, 0}, useInCar=true},

    ['knækfinger'] = {dict = "anim@mp_player_intupperknuckle_crunch", anim = "enter", locked = false, options = {12.0, -1, -1, 50, 1}, reset = 2200},
    ['sarkastisk'] = {dict = "anim@mp_player_intcelebrationpaired@m_m_sarcastic", anim = "sarcastic_left", locked = false, options = {12.0, -1, -1, 50, 1}, reset = 7800},

    -- 18+
    ['vehbjgetter'] = {dict = "oddjobs@towing", anim = "m_blow_job_loop", locked = false, options = {12.0, -1, -1, 50, 1}, useInCar=true, mature=true},
    ['vehbjgiver'] = {dict = "oddjobs@towing", anim = "f_blow_job_loop", locked = false, options = {12.0, -1, -1, 50, 1}, useInCar=true, mature=true},
    ['klør'] = {dict = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", locked = false, options = {12.0, -1, -1, 50, 1}, mature=true},
    ['charme'] = {dict = "mini@strip_club@idles@stripper", anim = "stripper_idle_02", locked = false, options = {1.0, 1.0, -1, 8, -1}, mature=true},
    ['flash'] = {dict = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b", locked = false, options = {1.0, 1.0, -1, 8, -1}, mature=true},
    ['strip'] = {dict = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f", locked = false, options = {1.0, 1.0, -1, 8, -1}, mature=true},
    ['strip2'] = {dict = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2", locked = false, options = {1.0, 1.0, -1, 8, -1}, mature=true},
    ['strip3'] = {dict = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3", locked = false, options = {1.0, 1.0, -1, 8, -1}, mature=true},
    ['analgetter'] = {dict = "rcmpaparazzo_2", anim = "shag_loop_poppy", locked = false, options = {1.0, 1.0, -1, 8, -1}, mature=true},
    ['analgiver'] = {dict = "rcmpaparazzo_2", anim = "shag_loop_a", locked = false, options = {1.0, 1.0, -1, 8, -1}, mature=true},
    ['bjgetter'] = {dict = "misscarsteal2pimpsex", anim = "pimpsex_punter", locked = false, options = {1.0, 1.0, -1, 8, -1}, reset = 37000, mature=true},
    ['bjgiver'] = {dict = "misscarsteal2pimpsex", anim = "pimpsex_hooker", locked = false, options = {1.0, 1.0, -1, 8, -1}, reset = 37000, mature=true},
    ['vehsexgetter'] = {dict = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player", locked = false, options = {1.0, 1.0, -1, 50, -1}, useInCar=true, mature=true},
    ['vehsexgiver'] = {dict = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female", locked = false, options = {8.0, -8.0, -1, 0, 0}, useInCar=true, mature=true},

    ['farm'] = {anim = "PROP_HUMAN_PARKING_METER"},
    ['bor'] = {anim = "WORLD_HUMAN_CONST_DRILL"},
    ['plant'] = {anim = "WORLD_HUMAN_GARDENER_PLANT"},
    ['yoga'] = {anim = "WORLD_HUMAN_YOGA"},
    ['sidned'] = {anim = "WORLD_HUMAN_PICNIC"},
    ['sid'] = {anim = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", locs = true},
    ['vodka'] = {anim = "WORLD_HUMAN_DRINKING"},
    ['trip'] = {anim = "WORLD_HUMAN_JOG_STANDING"},
    ['vagt'] = {anim = "WORLD_HUMAN_GUARD_STAND"},
    ['politi'] = {anim = "WORLD_HUMAN_COP_IDLES"},
    ['hammer'] = {anim = "WORLD_HUMAN_HAMMERING"},
    ['chinups'] = {anim = "PROP_HUMAN_MUSCLE_CHIN_UPS"},
    ['vask'] = {anim = "WORLD_HUMAN_MAID_CLEAN"},
    ['ligpåryggen'] = {anim = "WORLD_HUMAN_SUNBATHE_BACK"},
    ['ligpåsiden'] = {anim = "WORLD_HUMAN_BUM_SLUMPED"},
    ['ligpåmaven'] = {anim = "WORLD_HUMAN_SUNBATHE"},
    ['kost'] = {anim = "WORLD_HUMAN_JANITOR"},
    ['luder'] = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"},
    ['luder2'] = {anim = "WORLD_HUMAN_PROSTITUTE_LOW_CLASS"},
    ['luder3'] = {dict = "amb@world_human_prostitute@hooker@base", anim = "base", locked = false, options = {8.0, 1.0, -1, 1, 0}, useInCar=true},
    ['lænforover'] = {anim = "PROP_HUMAN_BUM_SHOPPING_CART"},
    ['dans'] = {dict = "rcmnigel1bnmt_1b", anim = "dance_intro_tyler", locked = false, options = {8.0, 1.0, -1, 0, 0}, afteranim = {anim = "dance_loop_tyler", time = 6000}},
    ['salute'] = {dict = "mp_player_int_uppersalute", anim = "mp_player_int_salute", locked = false, options = {1.0, 1.0, -1, 50, -1}},
    ['satans'] = {dict = "gestures@f@standing@casual", anim = "gesture_damn", locked = false, options = {1.0, 1.0, -1, 50, -1}},
    ['flex'] = {dict = "rcmnigel1bnmt_1b", anim = "that_had_to_be_tyler", locked = false, options = {12.0, -1, -1, 50, 1}},
    ['bål'] = {dict = "amb@world_human_stand_fire@male@base", anim = "base", locked = false, options = {1.0, 1.0, -1, 1, -1}},
    ['vinke'] = { dict = "anim@mp_player_intupperwave", anim = "idle_a", locked = false, options = {8.0, 8.0, -1, 49, 0}, useInCar=true},
    ['handsup'] = {dict = "missminuteman_1ig_2", anim = "handsup_enter", locked = false, options = {5.0, 1.0, -1, 50, -1}},
    -- ['peg'] = {dict = "random@car_thief@victimpoints_ig_3", anim = "pointing", locked = false, options = {1.0, 1.0, -1, 50, -1}},
    ['hep'] =
    {
        male = {dict = "amb@world_human_cheering@male_b", anim = "base", locked = false, options = {1.0, 1.0, -1, 8, -1}},
        female = {dict = "amb@world_human_cheering@female_a", anim = "base", locked = false, options = {1.0, 1.0, -1, 8, -1}}
    },
    ['udklipsholder'] = {dict = "amb@world_human_clipboard@male@base", anim = "base", locked = false, prop = {propn = "p_cs_clipboard", bindex = 0xeb95}, options = {8.0, 1.0, -1, 49, 0},keepplaying=true},
    ['notesblok'] = {dict = "amb@medic@standing@timeofdeath@base", anim = "base", locked = false, prop = {propn = "p_notepad_01_s", bindex = 0xeb95}, options = {8.0, 1.0, -1, 49, 0},keepplaying=true},
    ['bitchno'] = {dict = "anim@mp_player_intcelebrationfemale@no_way", anim = "no_way", locked = false, options = {8.0, 1.0, -1, 0, 0}},
    ['trafik'] = {dict = "amb@world_human_car_park_attendant@male@idle_a", anim = "idle_c", prop = {propn = "prop_parking_wand_01", bindex = 0x6f06}, locked = false, options = {8.0, 1.0, -1, 49, 0},keepplaying=true},
    ['vægt'] = {anim = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS"},

    -- BLOCKED ANIMATIONS CAN'T BE USED WITH COMMAND
    ['paraply'] = {dict = "amb@code_human_wander_drinking@male@base", anim = "static", blockcontrols = true, locked = false, prop = {propn = "p_amb_brolly_01_s", bindex = 28422}, options = {1.0, 1.0, -1, 50, -1}, blocked = true,keepplaying=true},
    ['pizza'] = {dict = "anim@heists@box_carry@", anim = "idle", blockcontrols = true, locked = false, prop = {propn = "prop_pizza_box_01", bindex = 28422, loc = {0.0, -0.35, -0.2, 0.0, 0.0, 0.0}}, options = {1.0, 1.0, -1, 50, -1}, blocked = true,keepplaying=true},
    ['stok'] = {dict = "missheist_jewelleadinout", anim = "lester_1st_suitless_entrance_negative_b", blockcontrols = true, locked = false, prop = {propn = "prop_cs_walking_stick", bindex = 28422}, options = {1.0, 1.0, -1, 50, -1}, blocked = true,keepplaying=true},
    ['kuffert'] = {blockcontrols = true, locked = false, prop = {propn = "prop_ld_case_01", bindex = 28422, loc = {0.10, 0.0, 0.0, -60.0, -80.0, 0.0}, rot = 2}, options = {1.0, 1.0, -1, 50, -1}, blocked = true,keepplaying=true},
    ['drillbank'] = {dict = "anim@heists@fleeca_bank@drilling", anim = "drill_straight_idle", blockcontrols = true, locked = false, prop = {propn = "hei_prop_heist_drill", bindex = 28422, loc = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}, rot = 2}, options = {1.0, 1.0, -1, 9, -1}, blocked = true},
    ['boxlift'] = {dict = "anim@heists@box_carry@", anim = "idle", blockcontrols = true, locked = false, prop = {propn = "prop_cs_cardbox_01", bindex = 28422, loc = {0.0, -0.01, 0.0, 0.0, 0.0, 0.0}, rot = 2}, options = {1.0, 1.0, -1, 50, -1}, blocked = true,keepplaying=true},
    ['unicorn'] = {dict = "anim@amb@nightclub@lazlow@hi_dancefloor@", anim = "dancecrowd_li_15_handup_laz", locked = false, prop = {propn = "ba_prop_battle_hobby_horse", bindex = 28422}, options = {8.0, 1.0, -1, 49, 0},keepplaying=true, blocked = true},
    --['healthbox'] = {dict = "anim@heists@box_carry@", anim = "idle", locked = false, prop = {propn = "prop_ld_health_pack", bindex = 28422, loc = {0.0, -0.01, 0.0, 0.0, 0.0, 0.0}, rot = 2}, options = {0.8, 1.0, -1, 50, -1}},

    -- Animationer der ikke skal kunne bruges ved /emote
    -- VRP
    ['drik'] = {dict = "mp_player_intdrink", anim = "loop_bottle", locked = false, prop = {propn = "prop_ld_flow_bottle", bindex = 18905, loc = {0.09, -0.05, 0.03, -100.0, 0.0, -20.0}}, options = {0.8, 1.0, -1, 49, -1}, reset = 5000, blocked = true},
    ['spis'] = {dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", locked = false, prop = {propn = "prop_cs_burger_01", bindex = 18905, loc = {0.13, 0.05, 0.031, 10.0, 175.0, 0.0}}, options = {0.8, 1.0, -1, 49, -1}, reset = 5000, blocked = true},

    ['carkeys'] = {dict = "anim@mp_player_intmenu@key_fob@", anim = "fob_click_fp", locked = false, prop = {propn = "p_car_keys_01", bindex = 0x6F06, loc = {-0.025, -0.025, 0.0, 0.0, 0.0, 60.0}}, options = {8.0, 1.0, -1, 49, 0}, reset = 900, blocked = true},
    ['repair'] = {dict = "amb@world_human_vehicle_mechanic@male@idle_a", anim = "idle_b", locked = false, options = {8.0, 1.0, -1, 0, 0}, afteranim = {dict="amb@world_human_vehicle_mechanic@male@exit",anim = "exit", time = 26000}, blocked = true},

    ['mobil3'] = {dict = "cellphone@", anim = "cellphone_call_to_text", locked = false, prop = {propn = "prop_amb_phone", bindex = 28422}, options = {12.0, -1, -1, 50, 1}, blocked = true, useInCar=true},
    ['mobil4'] = {dict = "cellphone@", anim = "cellphone_text_out", locked = false, prop = {propn = "prop_amb_phone", bindex = 28422}, options = {12.0, -1, -1, 50, 1}, blocked = true, useInCar=true},
    ['mobil5'] = {dict = "cellphone@", anim = "cellphone_call_listen_base", locked = false, prop = {propn = "prop_amb_phone", bindex = 28422}, options = {12.0, -1, -1, 50, 1}, blocked = true, useInCar=true},

    -- FUNCTIONS
    ["giveop"] = {func = "giveop"},
    ["suicide"] = {func = "suicide" },
    ['tis'] = {func = "Pee"},
    ['makeitrain'] = {func = "CashRain"},

    -- Hunde emotes til politiet lorte hunde - Udover Arthur, han er sød nok
    ['hund1'] = {anim = "WORLD_DOG_SITTING_RETRIEVER", blocked = true},
    ['hund2'] = {anim = "WORLD_DOG_BARKING_RETRIEVER", blocked = true},
}

local holdingcash = false
local cashmodel = "prop_anim_cash_pile_01"
local cash_net = nil
function CashRain()
    if holdingcash == false then
        local player = GetPlayerPed(-1)
        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local cashmodel = CreateObject(GetHashKey(cashmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        local netid = ObjToNet(cashmodel)
        local ad = "anim@mp_player_intupperraining_cash"
        local pd = "scr_xs_celebration"
        local pn = "scr_xs_money_rain"
        local isRaining = false
        loadAnimDict(ad)
        loadParticleDict(pd)
        RequestModel(GetHashKey(cashmodel))
        TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 51, 0, 0, 0, 0 )
        AttachEntityToEntity(cashmodel,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309),0.0,0.0,0.01,180.0,360.0,70.0,1,1,0,1,0,1)
        cash_net = netid
        holdingcash = true

        while holdingcash do
            Wait(0)
            if isRaining == false then
                DisplayHelpText("Tryk ~INPUT_PICKUP~ at være sej")
                if IsControlJustPressed(0, 38) then
                    isRaining = true
                    Wait(500)
                    RequestNamedPtfxAsset(pd)
                    HasNamedPtfxAssetLoaded(pd)
                    UseParticleFxAssetNextCall(pd)
                    TriggerServerEvent("cn-emotes:particles",cash_net,pd,pn,{default={0.0, 0.0, -0.09, -80.0, 0.0, 0.0, 1.0}},"entity",15000)
                    Wait(16000)
                    isRaining = false
                end
            end
        end
    end
end
function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local usedprop = ""
local isPlayingAnim = false
local currentlist = ""
local started = false
function playAnim(anim, notNotify)
    local ped = GetPlayerPed(-1)
    if not DoesEntityExist(ped) then
        return false
    end
    local list = ""
    local sex = "male"
    if(GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
        sex = 'female'
    end
    if animations[anim].male ~= nil then
        if sex == "male" then list = animations[anim].male else list = animations[anim].female end
    else
        list = animations[anim]
    end
    if (not IsPedInAnyVehicle(ped, false) or list.useInCar ~= nil) then
        if not IsPedSwimming(ped) then
            if vRP.isHandcuffed() == false then
                local playerHealth = GetEntityHealth(ped) - 100
                if playerHealth >= 1 then
                    if isPlayingAnim then
                        if list.upper == true then
                            if usedprop ~= "" then delProps(ped) end
                        else
                            delProps(ped,1)
                        end
                    end
                    started = false
                    isPlayingAnim = anim
                    currentlist = list
                    if notNotify == nil then
                        TriggerEvent("pNotify:SendNotification",{
                            text = "Bruger emote: <b style='color:#64A664'>"..anim.."</b>",
                            type = "success",
                            timeout = 3000,
                            layout = "centerRight",
                            queue = "global",
                            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                        })
                    end
                    if list.func ~= nil then
                        _G[list.func]()
                        return true
                    end
                    if list.dict ~= nil then
                        loadAnimDict(list.dict)
                    end
                    if list.particle ~= nil then
                        loadParticleDict(list.particle.dict)
                    end
                    if list.blockcontrols == true then
                        BlockControls = true
                    end
                    if list.dict ~= nil and list.advanced == nil then
                        local speed,speedm,duration,flag,play = table.unpack(list.options)
                        TaskPlayAnim(ped, list.dict, list.anim, speed,speedm,duration, flag,play,list.locked,list.locked,list.locked)
                    elseif list.multiple ~= nil then
                        for k,v in pairs(list.multiple) do
                            loadAnimDict(v.dict)
                            local speed,speedm,duration,flag,play = table.unpack(v.options)
                            TaskPlayAnim(ped, v.dict, v.anim, speed,speedm,duration, flag,play,v.locked,v.locked,v.locked)
                            if v.time ~= nil then
                                Wait(v.time)
                            end
                        end
                    elseif list.advanced ~= nil then
                        local speed,speedm,duration,flag,play = table.unpack(list.options)
                        local heading = GetEntityHeading(ped)
                        local x,y,z = table.unpack(GetEntityCoords(ped, true))
                        TaskPlayAnimAdvanced(ped, list.dict, list.anim,x+list.advanced.x,y+list.advanced.y,z+list.advanced.z, 0, 0, heading, speed, speedm, duration, flag, 1, 0,0)
                    else
                        if list.locs == nil then
                            TaskStartScenarioInPlace(ped, list.anim, 0, true)
                        else
                            local heading = GetEntityHeading(ped)
                            local x,y,z = table.unpack(GetEntityCoords(ped, true))
                            TaskStartScenarioAtPosition(ped, list.anim, x, y, z-1, heading, 0, 0, false)
                        end
                    end
                    if list.prop ~= nil then
                        local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -4.0)
                        local propspawned = CreateObject(GetHashKey(list.prop.propn), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
                        Citizen.Wait(10)
                        usedprop = propspawned
                        if list.prop.loc ~= nil then
                            local ox,oy,oz,o1,o2,o3 = table.unpack(list.prop.loc)
                            local rot = 0
                            if list.prop.rot then rot = list.prop.rot end
                            AttachEntityToEntity(propspawned, ped, GetPedBoneIndex(ped, list.prop.bindex), ox,oy,oz,o1,o2,o3, 0, 0, 0, 0, rot, 1)
                        else
                            AttachEntityToEntity(propspawned, ped, GetPedBoneIndex(ped, list.prop.bindex), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 1)
                        end
                    end
                    -- INSERT PARTICLES
                    if list.particle ~= nil then
                        local bone = GetPedBoneIndex(ped, list.particle.bone)
                        SetPtfxAssetNextCall(list.particle.dict)
                        local effect = StartParticleFxLoopedOnPedBone(list.particle.name, ped, 0.0, 0.0, list.particle.zOffset, list.particle.xRot, 0.0, 20.0, bone, 2.0, false, false, false)
                        Citizen.Wait(list.particle.stop)
                        StopParticleFxLooped(effect, 0)
                    end
                    if anim == "tis" or anim == "skid" then
                        local splay = true
                        if sex == "male" and anim == "tis" then splay = false end
                        Citizen.Wait(500)
                        if isPlayingAnim == anim and splay then
                            local speed,speedm,duration,flag,play = table.unpack(list.options)
                            TaskPlayAnim(ped, list.dict, "shit_react_trev", speed,speedm,duration,flag,play,list.locked,list.locked,list.locked)
                        end
                    end
                    if list.afteranim ~= nil then
                        local speed,speedm,duration,flag,play = table.unpack(list.options)
                        Wait(list.afteranim.time)
                        local adict = list.dict
                        if list.afteranim.dict ~= nil then
                            adict = list.afteranim.dict
                            loadAnimDict(adict)
                        end
                        TaskPlayAnim(ped, adict, list.afteranim.anim, speed,speedm,duration,flag,play,list.locked,list.locked,list.locked)
                    end
                    if list.reset ~= nil then
                        Wait(list.reset)
                        if isPlayingAnim == anim then
                            delProps(ped)
                            StopAnimTask(ped, list.dict, list.anim, 1.0)
                        end
                    end
                    started = true
                else
                    if notNotify == nil then
                        TriggerEvent("pNotify:SendNotification", {text = config.animWhileDead, type = "error", timeout = 2000, layout = "centerRight"})
                    end
                end
            else
                if notNotify == nil then
                    TriggerEvent("pNotify:SendNotification", {text = config.animWhileHandcuffed, type = "error", timeout = 2000, layout = "centerRight"})
                end
            end
        else
            if notNotify == nil then
                TriggerEvent("pNotify:SendNotification", {text = config.animInWater, type = "error", timeout = 2000, layout = "centerRight"})
            end
        end
    else
        if notNotify == nil then
            TriggerEvent("pNotify:SendNotification", {text = config.animInVeh, type = "error", timeout = 2000, layout = "centerRight"})
        end
        --[[if list.onlyInCar ~= nil then
            TriggerEvent("pNotify:SendNotification", {text = "Du skal sidde i en bil!", type = "error", timeout = 2000, layout = "centerRight"})
        else
            TriggerEvent("pNotify:SendNotification", {text = config.animInVeh, type = "error", timeout = 2000, layout = "centerRight"})
        end]]
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(1, 246) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedUsingScenario(GetPlayerPed(-1), "WORLD_HUMAN_SUNBATHE_BACK") then
            if isPlayingAnim ~= "hund" then
              if IsPedModel(GetPlayerPed(-1),1126154828) then
                local r = math.random(1,2)
                  playAnim("hund" .. r,true)
              else
                  stopAnim()
              end
            end
        end
        if IsControlJustPressed(1, 323) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedUsingScenario(GetPlayerPed(-1), "WORLD_HUMAN_SUNBATHE_BACK") then
            if isPlayingAnim ~= "handsup" then
                playAnim("handsup",true)
            else
                stopAnim()
            end
        end
        -- if IsControlJustPressed(1, 29) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedUsingScenario(GetPlayerPed(-1), "WORLD_HUMAN_SUNBATHE_BACK") then
        --     if isPlayingAnim ~= "peg" then
        --         playAnim("peg")
        --     else
        --         stopAnim()
        --     end
        -- end
        if IsControlJustPressed(1, 113) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedUsingScenario(GetPlayerPed(-1), "WORLD_HUMAN_SUNBATHE_BACK") then
            if isPlayingAnim ~= "vinke" then
                playAnim("vinke",true)
            else
                stopAnim()
            end
        end
        if IsControlJustPressed(1, 121) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedUsingScenario(GetPlayerPed(-1), "WORLD_HUMAN_SUNBATHE_BACK") then -- INSERT
            if isPlayingAnim ~= "krydsarme" then
                playAnim("krydsarme",true)
            else
                stopAnim()
            end
        end
    end
end)


Citizen.CreateThread( function()
    while true do
        Citizen.Wait(500)
        if isPlayingAnim ~= false then
            local ped = GetPlayerPed(-1)
            if currentlist ~= "" then
                if currentlist.keepplaying ~= nil then
                    if started then
                        if currentlist.dict ~= nil and not IsEntityPlayingAnim(ped, currentlist.dict, currentlist.anim, 3) then
                            if currentlist.reset ~= nil or currentlist.afteranim ~= nil then
                                delProps(ped)
                            else
                                playAnim(isPlayingAnim, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

function vRPanim.getCurrentAnim()
    return isPlayingAnim
end

RegisterNetEvent('cn-emotes:startparticles')
AddEventHandler('cn-emotes:startparticles', function(entity,dict,parname,settings,type,stoptime)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(1)
    end
    SetPtfxAssetNextCall(dict)
    local effect = ""
    if type == "ped" then
        local ped = NetToPed(entity)
        local xoff,yoff,zoff,xrot,yrot,zrot,bone = ""
        if settings.female ~= nil and GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
            xoff,yoff,zoff,xrot,yrot,zrot,bone = table.unpack(settings.female)
        else
            xoff,yoff,zoff,xrot,yrot,zrot,bone = table.unpack(settings.default)
        end
        bone = GetPedBoneIndex(ped, bone)
        effect = StartParticleFxLoopedOnPedBone(parname, ped, xoff,yoff,zoff,xrot,yrot,zrot,bone, 2.0, false, false, false)
    elseif type == "entity" then
        local entity = NetToObj(entity)
        local xoff,yoff,zoff,xrot,yrot,zrot,whatever = table.unpack(settings.default)
        effect = StartParticleFxLoopedOnEntity(parname, entity, xoff,yoff,zoff,xrot,yrot,zrot,whatever, false, false, false)
    end
    Citizen.Wait(stoptime)
    StopParticleFxLooped(effect, 0)
end)

function Pee()
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        return false
    end
    local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))

    local animDictionary = 'missbigscore1switch_trevor_piss'
    local animName = 'piss_loop'

    local sex = "male"
    if(GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
        sex = 'female'
    end

    RequestAnimDict(animDictionary)

    while not HasAnimDictLoaded(animDictionary) do
        Citizen.Wait(1)
    end
    if sex == 'male' then
        local heading = GetEntityPhysicsHeading(PlayerPed)
        TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)
    elseif sex == 'female' then
        RequestAnimDict('missfbi3ig_0')
        while not HasAnimDictLoaded('missfbi3ig_0') do
            Citizen.Wait(1)
        end
        local heading = GetEntityPhysicsHeading(PlayerPed)
        TaskPlayAnim(PlayerPed, 'missfbi3ig_0', 'shit_loop_trev', 8.0, -8.0, -1, 0, 0, false, false, false)
    end

    TriggerServerEvent("cn-emotes:particles",PedToNet(PlayerPed),"core","ent_amb_peeing",{default={0.0, 0.0, -0.1, -90.0, 0.0, 20.0,11816},female={0.0, 0.0, -0.55, 0.0, 0.0, 20.0,11816}},"ped",5000)
    Citizen.Wait(5500)
    TriggerServerEvent("cn-emotes:updatepiss")
end

function delProps(ped, full)
    if full ~= nil then
        ClearPedTasks(ped)
        BlockControls = false
        --ClearPedSecondaryTask(ped)
    end
    if usedprop ~= "" then
        DeleteObject(usedprop)
        usedprop = ""
    end
    currentlist = ""
    started = false
    isPlayingAnim = false
end

function loadParticleDict(dict)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(5)
    end
end

function loadAnimDict( dict )
    RequestAnimDict( dict )
    while not HasAnimDictLoaded(dict)  do
        Citizen.Wait( 5 )
    end
end

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(0)
        if IsDisabledControlJustReleased( 0, 20 ) then
            stopAnim()
        end
    end
end)

function stopAnim(instant)
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) and not instant then
        if not IsPedJumping(ped) then
            isPlayingAnim = false
            if IsEntityPlayingAnim(ped, "cellphone@", "cellphone_call_in", 3) then
                TaskPlayAnim(ped, "cellphone@", "cellphone_call_to_text", 12.0, -1, -1, 50, 1, false, false, false)
                Citizen.Wait(600)
                TaskPlayAnim(ped, "cellphone@", "cellphone_horizontal_exit", 12.0, -1, -1, 50, 1, false, false, false)
                Citizen.Wait(1000)
                delProps(ped, 1)
            elseif IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_in", 3) then
                TaskPlayAnim(ped, "cellphone@", "cellphone_text_out", 3.0, -1, -1, 50, 0, false, false, false)
                Citizen.Wait(1000)
                delProps(ped, 1)
            elseif IsEntityPlayingAnim(ped, "cellphone@", "cellphone_call_to_text", 3) then
                TaskPlayAnim(ped, "cellphone@", "cellphone_horizontal_exit", 12.0, -1, -1, 50, 1, false, false, false)
                Citizen.Wait(1000)
                delProps(ped, 1)
            elseif IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then
                delProps(ped, 1)
            elseif IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle_a", 3) then
                Citizen.Wait(100)
                delProps(ped, 1)
            elseif IsEntityPlayingAnim(ped, "", "", 3) then
                Citizen.Wait(100)
                delProps(ped, 1)
            else
                delProps(ped, 1)
            end
        end
    elseif instant then
        print("qweqwe")
        delProps(ped, 1)
    end
    if holdingcash then
        DetachEntity(NetToObj(cash_net), 1, 1)
        DeleteEntity(NetToObj(cash_net))
        Wait(750)
        ClearPedSecondaryTask(GetPlayerPed(-1))
        cash_net = nil
        holdingcash = false
        StopParticleFxLooped("scr_xs_money_rain",0)
    end
end

RegisterNetEvent("cn-animation:startWithoutNotify")
AddEventHandler("cn-animation:startWithoutNotify", function(anim)
    if animations[anim] ~= nil then
        playAnim(anim, 1)
    end
end)

RegisterNetEvent("cn-animation:start")
AddEventHandler("cn-animation:start", function(anim)
    if animations[anim] ~= nil and animations[anim].blocked == nil then
      if not IsPedUsingScenario(GetPlayerPed(-1), "WORLD_HUMAN_SUNBATHE_BACK") then
        playAnim(anim)
      else
        TriggerEvent("pNotify:SendNotification",{text = "Du kan ikke bruge emotes i en seng!",type = "error",timeout = 3000,layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    else
        TriggerEvent("pNotify:SendNotification",{text = "Den emote findes ikke!",type = "error",timeout = 3000,layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)

RegisterNetEvent("cn-animation:startWithItem")
AddEventHandler("cn-animation:startWithItem", function(anim)
  if not IsPedUsingScenario(GetPlayerPed(-1), "WORLD_HUMAN_SUNBATHE_BACK") then
    playAnim(anim)
  else
    TriggerEvent("pNotify:SendNotification",{text = "Du kan ikke bruge emotes i en seng!",type = "error",timeout = 3000,layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterNetEvent("cn-animation:stopAnimInstant")
AddEventHandler("cn-animation:stopAnimInstant", function()
    stopAnim(true)
end)

RegisterNetEvent("cn-animation:stopAnim")
AddEventHandler("cn-animation:stopAnim", function()
    stopAnim()
end)

local lemotes = ""
RegisterNetEvent("cn-animation:showEmotes")
AddEventHandler("cn-animation:showEmotes", function()
    getEmotes()
    TriggerEvent("chatMessage","",{255, 0, 0}, "^3^*[EMOTES] ^1^rDer er følgende: ")
    TriggerEvent("chatMessage","",{255, 0, 0}, "^0"..lemotes)
    TriggerEvent("chatMessage","",{255, 0, 0}, "^3For 18+ emotes skriv /18")
end)

RegisterNetEvent("cn-animation:showEmotes18")
AddEventHandler("cn-animation:showEmotes18", function()
    getEmotes(true)
    TriggerEvent("chatMessage","",{255, 0, 0}, "^3^*[18+ EMOTES] ^1^rDer er følgende: ")
    TriggerEvent("chatMessage","",{255, 0, 0}, "^0"..lemotes)
end)

function getEmotes(mature)
    local emotes = ""
    for k,v in pairs(animations) do
        if v.blocked == nil and (mature == nil and v.mature == nil or mature == true and v.mature == true) then
            if emotes == "" then
                emotes = "^*"..k
            else
                emotes = emotes.." ^3^*| ^7^r^*"..k
            end
        end
    end
    lemotes = emotes
end

-------------------------------------------------------------------------------------------------
--                                     ↓ FACE ! - /ansigt ↓                                    --
-------------------------------------------------------------------------------------------------

local faces = {
    ["sur"] = "mood_drivefast_1",
    ["glad"] = "mood_happy_1",
    ["overrasket"] = "shocked_1",
    ["normal"] = "mood_normal_1",
    ["fuld"] = "mood_drunk_1",
    ["gab"] = "coughing_1"
}
local isPlayingFace = false
function playFace(face)
    TriggerEvent("pNotify:SendNotification",{
        text = "Ansigt: <b style='color:#64A664'>"..face.."</b>",
        type = "success",
        timeout = 3000,
        layout = "centerRight",
        queue = "global",
        animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
    })
    isPlayingFace = face
    SetFacialIdleAnimOverride(GetPlayerPed(-1), faces[face])
    if face == "gab" then
        Wait(1500)
        if isPlayingFace == face then SetFacialIdleAnimOverride(GetPlayerPed(-1), "mood_normal_1") end
    end
end

RegisterNetEvent("cn-animation:face")
AddEventHandler("cn-animation:face", function(face)
    if faces[face] ~= nil then
        playFace(face)
    else
        TriggerEvent("pNotify:SendNotification",{text = "Det ansigt findes ikke!",type = "error",timeout = 3000,layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)

local lfaces = ""
RegisterNetEvent("cn-animation:showFaces")
AddEventHandler("cn-animation:showFaces", function()
    getFaces()
    TriggerEvent("chatMessage","",{255, 0, 0}, "^3^*[HUMØR] ^1^rDer er følgende: ")
    TriggerEvent("chatMessage","",{255, 0, 0}, "^0"..lfaces)
end)

function getFaces()
    local efaces = ""
    for k,v in pairs(faces) do
        if efaces == "" then
            efaces = "^*"..k
        else
            efaces = efaces.." ^3^*| ^7^r^*"..k
        end
    end
    lfaces = efaces
end

-------------------------------------------------------------------------------------------------
--                                     ↓ Overgiv dig! - /k ↓                                   --
-------------------------------------------------------------------------------------------------


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 100 )
    end
end

local suicideweapons = {
    "WEAPON_SNSPISTOL",
    "WEAPON_PISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_PISTOL50",
}

function suicide()
    local ped = GetPlayerPed( -1 )
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
        local gun = GetSelectedPedWeapon(ped)
        print(gun)
        if has_value(suicideweapons, gun) then
            SetCurrentPedWeapon(ped, gun, true)
            loadAnimDict("mp_suicide")
            TaskPlayAnim(GetPlayerPed(-1), "mp_suicide", "pistol", 8.0, 1.0, -1, 0, 1, 1, 0, 0 )
            Wait(800)
            SetEntityHealth(GetPlayerPed(-1), 100)
        else
            TriggerEvent("pNotify:SendNotification",{text = "Du skal have en pistol i hånden!",type = "error",timeout = 3000,layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end
end

function giveop()
    local player = GetPlayerPed( -1 )
    if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
        loadAnimDict( "random@arrests" )
        loadAnimDict( "random@arrests@busted" )
        if ( IsEntityPlayingAnim( player, "random@arrests@busted", "idle_a", 3 ) ) then
            if isPlayingAnim == "giveop" then TaskPlayAnim( player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) end
            Wait (3000)
            if isPlayingAnim == "giveop" then TaskPlayAnim( player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 ) end
        else
            if isPlayingAnim == "giveop" then TaskPlayAnim( player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) end
            Wait (4000)
            if isPlayingAnim == "giveop" then TaskPlayAnim( player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) end
            Wait (500)
            if isPlayingAnim == "giveop" then TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) end
            Wait (1000)
            if isPlayingAnim == "giveop" then TaskPlayAnim( player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 ) end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if BlockControls == true then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
            DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
        end
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(animations) do
        if v.blocked == nil then
            TriggerEvent('chat:addSuggestion', '/e '..k, 'Animation')
        end
    end
    for k,v in pairs(faces) do
        TriggerEvent('chat:addSuggestion', '/humør '..k, 'Ansigts udtryk')
    end
    TriggerEvent('chat:addSuggestion', '/rul', 'Rul de første vinduer ned!')
    TriggerEvent('chat:addSuggestion', '/rulbag', 'Rul de bageste vinduer ned!')
    TriggerEvent('chat:addSuggestion', '/pis eller /tis', 'Skal bruges når du skal pisse, ellers pisser du i bukserne!')
    TriggerEvent('chat:addSuggestion', '/pis eller /tis', 'Skal bruges når du skal pisse, ellers pisser du i bukserne!')
    TriggerEvent('chat:addSuggestion', '/me eller /mig', 'Denne funktion bruges til at skrive f.eks en tanke. (/mig Tænker: Nøj jeg kunne godt en pizza.)')
    TriggerEvent('chat:addSuggestion', '/humør', 'Brug denne funktion for at skifte dit ansigtsudtryk.')
    TriggerEvent('chat:addSuggestion', '/e', 'Brug denne funktion for at lave en handling.')
    TriggerEvent('chat:addSuggestion', '/k', 'Overgivelse ved at ligge på knæ med hænderne over hovedet.')
    TriggerEvent('chat:addSuggestion', '/tshirt', 'Tager din tshirt af/på.')
    TriggerEvent('chat:addSuggestion', '/jakke', 'Tager dine jakke af/på.')
    TriggerEvent('chat:addSuggestion', '/hat', 'Tager din hat af/på.')
    TriggerEvent('chat:addSuggestion', '/hjelm', 'Tager din hjelm af/på.')
    TriggerEvent('chat:addSuggestion', '/maske', 'Tager din maske af/på.')
    TriggerEvent('chat:addSuggestion', '/briller', 'Tager dine briller af/på.')
    TriggerEvent('chat:addSuggestion', '/bukser', 'Tager din bukser af/på.')
    TriggerEvent('chat:addSuggestion', '/sko', 'Tager din sko af/på.')
    TriggerEvent('chat:addSuggestion', '/slips', 'Tager dit slips af/på.')
    TriggerEvent('chat:addSuggestion', '/skift', 'Sætter dig i føresædet.')
end)

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if GetHashKey(value) == val then
            return true
        end
    end
    return false
end
