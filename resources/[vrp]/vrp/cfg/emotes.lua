
-- define emotes
-- use the custom emotes admin action to test emotes on-the-fly
-- animation list: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local cfg = {}

-- map of emote_name => {upper,seq,looping}
-- seq can also be a task definition, check the examples below
cfg.emotes = {
--  ["Hammer"] = {false, {task="WORLD_HUMAN_HAMMERING"}, false},
--  ["Hangout"] = {false, {task="WORLD_HUMAN_HANG_OUT_STREET"}, false},
-- ["Hiker"] = {false, {task="WORLD_HUMAN_HIKER_STANDING"}, false},
--  ["Cop"] = {false, {task="WORLD_HUMAN_COP_IDLES"}, false},
--  ["Film"] = {false, {task="WORLD_HUMAN_MOBILE_FILM_SHOCKING"}, false},
--  ["Plant"] = {false, {task="WORLD_HUMAN_GARDENER_PLANT"}, false},
--  ["Fish"] = {false, {task="WORLD_HUMAN_STAND_FISHING"}, false},
--  ["Impatient"] = {false, {task="WORLD_HUMAN_STAND_IMPATIENT"}, false},
--  ["Weld"] = {false, {task="WORLD_HUMAN_WELDING"}, false},
--  ["Kneel"] = {false, {task="CODE_HUMAN_MEDIC_KNEEL"}, false},
--  ["Crowdcontrol"] = {false, {task="CODE_HUMAN_POLICE_CROWD_CONTROL"}, false},
--  ["Investigate"] = {false, {task="CODE_HUMAN_POLICE_INVESTIGATE"}, false},
--  ["Ouvir Coração"] = {false,{{"mini@safe_cracking","hailing_whistle_waive_a"}},false},
--  ["Cagar"] = {false,{{"switch@trevor@on_toilet", "idle_base"}},false},
--  ["Churrasco"] = {false, {task="PROP_HUMAN_BBQ"}, false},
--  ["Mãos para cima"] = { -- handsup state, use clear to lower hands
--    true,
--    { -- sequence, list of {dict,name,loops}
--      {"random@mugging3", "handsup_standing_base", 1}
--    },
--    true
--  },
}
cfg.emotes_sports = {
  ["Tai Chi"] = {false, {{"switch@trevor@rand_temple","tai_chi_trevor",1}}, false},
  ["Alongar Pernas"] = {false, {{"mini@triathlon","idle_e",1}}, false},
  ["Flexões"] = {false, {task="WORLD_HUMAN_PUSH_UPS"}, false},
  ["Abdominais"] = {false, {task="WORLD_HUMAN_SIT_UPS"}, false},
  ["Cansadissimo"] = {false, {{"rcmbarry","idle_d",1}}, true},
  ["Yoga"] = {false, {task="WORLD_HUMAN_YOGA"}, false},
  ["Flex"] = {false, {task="WORLD_HUMAN_MUSCLE_FLEX"}, false},
  ["Jog"] = {false, {task="WORLD_HUMAN_JOG_STANDING"}, false},
}
cfg.emotes_gestos = {
  ["Assobiar"] = {true,{{"rcmnigel1c","hailing_whistle_waive_a"}},false},
  ["Não"] = {
    true, {{"gestures@f@standing@casual","gesture_head_no",1}}, false
  },
  ["Droga"] = {
    true, {{"gestures@f@standing@casual","gesture_damn",1}}, false
  },

  ["Miss Brasil"] = {false, {{"anim@mp_player_intupperwave","idle_a",1}}, true},
  ["Legal"] = {true, {{"anim@mp_player_intupperthumbs_up","idle_a",1}}, false},
  ["Oh!"] = {true, {{"anim@mp_player_intselfieblow_kiss","idle_a",1}}, false},
  ["Tirar Meleca"] = {true, {{"anim@mp_player_intuppernose_pick","idle_a",1}}, false},
  ["Chororo"] = {true, {{"anim@mp_player_intupperjazz_hands","idle_a",1}}, false},
  ["Cruzar Braços"] = {true, {{"amb@world_human_hang_out_street@female_arms_crossed@idle_a","idle_a",1}}, true},
  ["Coçar Bunda"] = {false, {{"anim@heists@team_respawn@respawn_01","heist_spawn_01_ped_d",1}}, false},
  ["Vem Rápido"] = {false, {{"missfam4","say_hurry_up_a_trevor",1}}, false},
  ["Tirar Sujeira Terno"] = {false, {{"missfbi3_camcrew","final_loop_guy",1}}, false},
  ["Imitar Galinha"] = {false, {{"random@peyote@chicken","wakeup",1}}, false},
  ["Peidar"] = {false, {{"rcm_barry2","clown_idle_2",1}}, false},
  ["Abraçar 01"] = {false, {{"mp_ped_interaction","kisses_guy_a",1}}, false},
  ["Abraçar 02"] = {false, {{"mp_ped_interaction","hugs_guy_a",1}}, false},
  ["Abraçar 03"] = {false, {{"mp_ped_interaction","kisses_guy_b",1}}, false},

  ["Mandar Beijinho"] = {false, {{"mini@hookers_sp","idle_a",1}}, false},
  ["Ficar de Guarda"] = {false, {task="WORLD_HUMAN_GUARD_STAND"}, false},
  ["Statua"] = {false, {task="WORLD_HUMAN_HUMAN_STATUE"}, false},
  ["Fail"] = {false, {{"anim@mp_freemode_return@f@fail","fail_a",1}}, false},
  ["Unhas"] = {false, {{"friends@fra@ig_1","base_idle",1}}, false},
  ["Rejeitar"] = {false, {{"mini@hookers_sp","idle_reject",1}}, false},
  ["Salute"] = {true,{{"mp_player_int_uppersalute","mp_player_int_salute",1}},false},
  ["Ler"] = {false, {task="WORLD_HUMAN_LEANING"}, false},
  ["Celular 01"] = {false, {task="WORLD_HUMAN_STAND_MOBILE"}, false},
  ["Celular 02"] = {false,{{"anim@heists@prison_heistunfinished_biztarget_idle","target_idle"}},true},
  ["Mijar"] = {false, {{"misscarsteal2peeing","peeing_intro",1},{"misscarsteal2peeing","peeing_loop",1},{"misscarsteal2peeing","peeing_outro",1}}, false},
  ["Sentir Frio"] = {false, {{"misschinese1leadinoutchi_1_mcs_4","chi_1_mcs_4_translator_idle_2",1}}, true},
  ["Céu"] = {true, {{"rcmepsilonism8","worship_base",1}}, true},
  ["Nervoso"] = {false, {{"rcmme_tracey1","nervous_loop",1}}, false},
  ["Pedir Esmola"] = {false, {task="WORLD_HUMAN_BUM_FREEWAY"}, false},
  ["Sentar na Cadeira"] = {false, {task="PROP_HUMAN_SEAT_CHAIR_MP_PLAYER"}, false},
  ["Dor no Chão 01"] = {false, {{"misstrevor3_beatup","guard_beatup_exit_dockworker",1}}, true},
  ["Dor no Chão 02"] = {false, {{"combat@damage@writheidle_c","writhe_idle_g",1}}, true},
  ["Cavar"] = {false, {{"missmic1leadinoutmic_1_mcs_2","_leadin_trevor",1}}, true},
  ["Mão na Cintura"] = {false, {{"amb@world_human_hang_out_street@female_arm_side@idle_a","idle_a",1}}, false},
  ["Sentar no Chão"] = {false, {{"anim@heists@fleeca_bank@ig_7_jetski_owner","owner_idle",1}}, true},
  ["Camera"] = {false, {task="WORLD_HUMAN_PAPARAZZI"}, false},
  ["Sentar"] = {false, {task="WORLD_HUMAN_PICNIC"}, false},
  ["Binoculos"] = {false, {task="WORLD_HUMAN_BINOCULARS"}, false},
  ["Banho de Sol"] = {false, {task="WORLD_HUMAN_SUNBATHE_BACK"}, false},
  ["Banho de Sol 2"] = {false, {task="WORLD_HUMAN_SUNBATHE"}, false},
  ["Vergonha Alheia"] = {
    true, {
      {"anim@mp_player_intupperface_palm","enter_fp",1},
      {"anim@mp_player_intupperface_palm","idle_a_fp",1},
      {"anim@mp_player_intupperface_palm","exit_fp",1}
    }, false
  },
  ["Estralar Dedos"] = {true, {{"anim@mp_player_intupperknuckle_crunch","idle_a",1}}, false},
  ["Prancheta"] = {true, {task="WORLD_HUMAN_CLIPBOARD"}, false},
  ["Digitar"] = {true, {{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop",1}}, true}

}
cfg.emotes_trabalhos = {
}

cfg.emotes_festivo = {
  ["Tocar Solo"] = {true, {{"anim@mp_player_intupperair_guitar","idle_a",1}}, true},
  ["Diggit"] = {false, {task="WORLD_HUMAN_STRIP_WATCH_STAND"}, false},
  ["Dança 01"] = {
    false, {
      {"rcmnigel1bnmt_1b","dance_intro_tyler",1},
      {"rcmnigel1bnmt_1b","dance_loop_tyler",1}
    }, false
  },
  ["Dança 03"] = {false, {{"misschinese2_crystalmazemcs1_cs","dance_loop_tao",1}}, true},
  ["Dança 04"] = {false, {{"special_ped@mountain_dancer@monologue_2@monologue_2a","mnt_dnc_angel",1}}, true},
  ["Dança 05"] = {false, {{"special_ped@mountain_dancer@monologue_3@monologue_3a","mnt_dnc_buttwag",1}}, true},

  ["Dança Maluca"] = {false, {{"rcm_barry2","clown_idle_4",1}}, false},
  ["Dança Maluca 02"] = {true, {{"misschinese1crazydance","crazy_dance_3",1}}, false},
  ["Dança FBI"] = {false, {{"missfbi3_sniping","dance_m_default",1}}, true},

  ["DJ 01"] = {false, {{"anim@mp_player_intcelebrationmale@dj","dj",1}}, true},
  ["DJ 02"] = {false, {{"mini@strip_club@idles@dj@base","base",1}}, true},
  ["Rock"] = {true,{{"mp_player_introck","mp_player_int_rock",1}},false},
  ["Celebrar"] = {false, {{"anim@mp_celebration@idles@female","celebration_idle_f_a",1}}, true},
  ["Beber"] = {false, {task="WORLD_HUMAN_DRINKING"}, false},
  ["Fumar"] = {false, {task="WORLD_HUMAN_SMOKING"}, false},
  ["Cheer"] = {false, {task="WORLD_HUMAN_CHEERING"}, false},
  ["Fotografia"] = {true, {{"anim@mp_player_intincarphotographystd@rds@","idle_a",1}}, false},
  ["YES!"] = {false, {{"rcmfanatic1celebrate","celebrate",1}}, false},
  ["Empolgado"] = {false, {{"random@street_race","_streetracer_accepted",1}}, false},
}

cfg.emotes_porns = {
  ["M Blowjob"] = {false, {{"oddjobs@towing","m_blow_job_loop",1}}, false},
  ["F Blowjob"] = {false, {{"oddjobs@towing","f_blow_job_loop",1}}, false},
  ["Car Sex Loop Player"] = {false, {{"mini@prostitutes@sexlow_veh","low_car_sex_loop_player",1}}, false},
  ["Car Sex Loop Female"] = {false, {{"mini@prostitutes@sexlow_veh","low_car_sex_loop_female",1}}, false},
  ["Uppergrab Crotch"] = {false, {{"mp_player_int_uppergrab_crotch","mp_player_int_grab_crotch",1}}, false},
  ["Stripper 02"] = {false, {{"mini@strip_club@idles@stripper","stripper_idle_02",1}}, false},
  ["Stripper High Class"] = {false, {task="WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}, false},
  ["Stripper Low Class"] = {false, {task="WORLD_HUMAN_PROSTITUTE_LOW_CLASS"}, false},
  ["Stripper Backroom"] = {false, {{"mini@strip_club@backroom@","stripper_b_backroom_idle_b",1}}, false},
  ["Girl Song"] = {false, {{"mini@strip_club@lap_dance@ld_girl_a_song_a_p1","ld_girl_a_song_a_p1_f",1}}, false},
  ["Priv Dance 01"] = {false, {{"mini@strip_club@private_dance@idle","priv_dance_idle",1}}, false},
  ["Priv Dance 02"] = {false, {{"mini@strip_club@private_dance@part1","priv_dance_p1",1}}, false},
  ["Priv Dance 03"] = {false, {{"mini@strip_club@private_dance@part2","priv_dance_p2",1}}, false},
  ["Cartman Dance"] = {false, {{"mini@strip_club@private_dance@part3","priv_dance_p3",1}}, false},
  ["Apalpar Seios"] = {false, {{"amb@code_human_in_car_mp_actions@tit_squeeze@bodhi@rps@base","idle_a",1}}, false},
  ["Man Moviments"] = {false, {{"misslamar1leadinout","denise_idle",1}}, false},
  ["Woman Moviments"] = {false, {{"missmic4premiere","prem_actress_star_a",1}}, false},
  ["Crotch"] = {false, {{"mp_player_int_upperwank","mp_player_int_wank_01",1}}, false},
  ["Give Ass"] = {false, {{"rcmpaparazzo_2","shag_loop_poppy",1}}, true},
  ["Eat Ass"] = {false, {{"rcmpaparazzo_2","shag_loop_a",1}}, true},
  ["Stripper Dance 01"] = {
    false, {
      {"mp_am_stripper","lap_dance_girl",1},
      {"mp_am_stripper","lap_dance_player",1}
    }, false
  },
  ["Dedo Anel"] = {false, {{"anim@mp_player_intupperdock","idle_a",1}}, true},
}

return cfg
