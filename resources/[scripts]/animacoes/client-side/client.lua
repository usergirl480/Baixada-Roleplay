-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local fov_min = 5.0
local fov_max = 70.0
local cameras = false
local binoculos = false
local tratamento = false
local fov = (fov_max + fov_min) * 0.5
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local beds = {
	{ 1631638868,0.0,0.0 },
	{ 2117668672,0.0,0.0 },
	{ -1498379115,1.0,90.0 },
	{ -1519439119,1.0,0.0 },
	{ -289946279,1.0,0.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLEDANCES
-----------------------------------------------------------------------------------------------------------------------------------------
local poleDances = {
	{ 108.98,-1289.45,29.25,252.29 },
	{ 102.40,-1290.06,29.25,320.32 },
	{ 104.95,-1294.35,29.25,323.15 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMA????ES
-----------------------------------------------------------------------------------------------------------------------------------------
local animacoes = {
	["macaco"] = { dict = "" , anim = "" , prop = "changer_monkey" , andar = true , loop = true , flag = 49 , mao = 24817 , pos1 = 0.41 , pos2 = -0.13 , pos3 = -0.155 , pos4 = -182.0 , pos5 = -80.0 , pos6 = 0.0 },
	["pneu"] = { dict = "anim@heists@box_carry@", anim = "idle", prop = "imp_prop_impexp_tyre_01a", flag = 49, mao = 28422, altura = -0.02, pos1 = -0.1, pos2 = 0.2, pos3 = 10.0, pos4 = 0.0, pos5 = 0.0 },
	["bong"] = { dict = "anim@safehouse@bong", anim = "bong_stage1", prop = "prop_bong_01", flag = 49, mao = 18905, altura = 0.10, pos1 = -0.25, pos2 = 0.0, pos3 = 95.0, pos4 = 190.0, pos5 = 180.0 },
	["mic"] = { dict = "missfra1", anim = "mcs2_crew_idle_m_boom", prop = "prop_v_bmike_01", flag = 50, mao = 28422, altura = -0.08, pos1 = 0.0, pos2 = 0.0, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["mic2"] = { dict = "missmic4premiere", anim = "interview_short_lazlow", prop = "p_ing_microphonel_01", flag = 50, mao = 28422 },
	["mic3"] = { dict = "anim@random@shop_clothes@watches", anim = "base", prop = "p_ing_microphonel_01", flag = 49, mao = 60309, altura = 0.10, pos1 = 0.04, pos2 = 0.012, pos3 = -60.0, pos4 = 60.0, pos5 = -30.0 },
	["megaphone"] = { dict = "anim@random@shop_clothes@watches", anim = "base", prop = "prop_megaphone_01", flag = 49, mao = 60309, altura = 0.10, pos1 = 0.04, pos2 = 0.012, pos3 = -60.0, pos4 = 100.0, pos5 = -30.0 },
	["livro"] = { dict = "cellphone@", anim = "cellphone_text_read_base", prop = "prop_novel_01", flag = 49, mao = 6286, altura = 0.15, pos1 = 0.03, pos2 = -0.065, pos3 = 0.0, pos4 = 180.0, pos5 = 90.0 },
	["radio2"] = { prop = "prop_boombox_01", flag = 50, mao = 57005, altura = 0.30, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["bolsa"] = { prop = "prop_ld_case_01", flag = 50, mao = 57005, altura = 0.16, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["bolsa2"] = { prop = "prop_ld_case_01_s", flag = 50, mao = 57005, altura = 0.16, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["bolsa3"] = { prop = "prop_security_case_01", flag = 50, mao = 57005, altura = 0.16, pos1 = 0, pos2 = -0.01, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["bolsa4"] = { prop = "w_am_case", flag = 50, mao = 57005, altura = 0.08, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["caixa2"] = { prop = "prop_tool_box_04", flag = 50, mao = 57005, altura = 0.45, pos1 = 0, pos2 = 0.05, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["lixo"] = { prop = "prop_cs_rub_binbag_01", flag = 50, mao = 57005, altura = 0.11, pos1 = 0, pos2 = 0.0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["prebeber"] = { dict = "amb@code_human_wander_drinking@beer@male@base", anim = "static", prop = "p_amb_coffeecup_01", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["prebeber2"] = { dict = "amb@code_human_wander_drinking@beer@male@base", anim = "static", prop = "prop_ld_flow_bottle", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["prebeber3"] = { dict = "amb@code_human_wander_drinking@beer@male@base", anim = "static", prop = "prop_cs_bs_cup", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.10, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["prebeber4"] = { dict = "anim@heists@humane_labs@finale@keycards", anim = "ped_a_enter_loop", prop = "prop_drink_champlocal animacoes" },
	["pneu"] = { dict = "anim@heists@box_carry@", anim = "idle", prop = "imp_prop_impexp_tyre_01a", flag = 49, mao = 28422, altura = -0.02, pos1 = -0.1, pos2 = 0.2, pos3 = 10.0, pos4 = 0.0, pos5 = 0.0 },
	["bong"] = { dict = "anim@safehouse@bong", anim = "bong_stage1", prop = "prop_bong_01", flag = 49, mao = 18905, altura = 0.10, pos1 = -0.25, pos2 = 0.0, pos3 = 95.0, pos4 = 190.0, pos5 = 180.0 },
	["mic"] = { dict = "missfra1", anim = "mcs2_crew_idle_m_boom", prop = "prop_v_bmike_01", flag = 50, mao = 28422, altura = -0.08, pos1 = 0.0, pos2 = 0.0, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["mic2"] = { dict = "missmic4premiere", anim = "interview_short_lazlow", prop = "p_ing_microphonel_01", flag = 50, mao = 28422 },
	["mic3"] = { dict = "anim@random@shop_clothes@watches", anim = "base", prop = "p_ing_microphonel_01", flag = 49, mao = 60309, altura = 0.10, pos1 = 0.04, pos2 = 0.012, pos3 = -60.0, pos4 = 60.0, pos5 = -30.0 },
	["livro"] = { dict = "cellphone@", anim = "cellphone_text_read_base", prop = "prop_novel_01", flag = 49, mao = 6286, altura = 0.15, pos1 = 0.03, pos2 = -0.065, pos3 = 0.0, pos4 = 180.0, pos5 = 90.0 },
	["radio2"] = { prop = "prop_boombox_01", flag = 50, mao = 57005, altura = 0.30, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["spiderman"] = { dict = "missexile3" , anim = "ex03_train_roof_idle" , andar = false , loop = true },
	["bolsa"] = { prop = "prop_ld_case_01", flag = 50, mao = 57005, altura = 0.16, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["bolsa2"] = { prop = "prop_ld_case_01_s", flag = 50, mao = 57005, altura = 0.16, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["bolsa3"] = { prop = "prop_security_case_01", flag = 50, mao = 57005, altura = 0.16, pos1 = 0, pos2 = -0.01, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["bolsa4"] = { prop = "w_am_case", flag = 50, mao = 57005, altura = 0.08, pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["caixa2"] = { prop = "prop_tool_box_04", flag = 50, mao = 57005, altura = 0.45, pos1 = 0, pos2 = 0.05, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["lixo"] = { prop = "prop_cs_rub_binbag_01", flag = 50, mao = 57005, altura = 0.11, pos1 = 0, pos2 = 0.0, pos3 = 0, pos4 = 260.0, pos5 = 60.0 },
	["prebeber"] = { dict = "amb@code_human_wander_drinking@beer@male@base", anim = "static", prop = "p_amb_coffeecup_01", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["prebeber2"] = { dict = "amb@code_human_wander_drinking@beer@male@base", anim = "static", prop = "prop_ld_flow_bottle", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["prebeber3"] = { dict = "amb@code_human_wander_drinking@beer@male@base", anim = "static", prop = "prop_cs_bs_cup", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.10, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["prebeber4"] = { dict = "anim@heists@humane_labs@finale@keycards", anim = "ped_a_enter_loop", prop = "prop_drink_champ", flag = 49, mao = 18905, altura = 0.10, pos1 = -0.05, pos2 = 0.03, pos3 = -100.0, pos4 = 0.0, pos5 = -10.0 },
	["verificar"] = { dict = "amb@medic@standing@tendtodead@idle_a", anim = "idle_a", andar = false, loop = true },
	["mexer"] = { dict = "amb@prop_human_parking_meter@female@idle_a", anim = "idle_a_female", andar = true, loop = true },
	["cuidar"] = { dict = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", andar = true, loop = true },
	["cuidar2"] = { dict = "mini@cpr@char_a@cpr_str", anim = "cpr_kol", andar = true, loop = true },
	["cuidar3"] = { dict = "mini@cpr@char_a@cpr_str", anim = "cpr_kol_idle", andar = true, loop = true },
	["cansado"] = { dict = "rcmbarry", anim = "idle_d", andar = false, loop = true },
	["meleca"] = { dict = "anim@mp_player_intuppernose_pick" , anim = "idle_a" , andar = true , loop = true },
	["meleca2"] = { dict = "anim@mp_player_intcelebrationfemale@nose_pick" , anim = "nose_pick" , andar = false , loop = false },
	["meleca3"] = { dict = "move_p_m_two_idles@generic" , anim = "fidget_sniff_fingers" , andar = true , loop = false },
	["bora"] = { dict = "missfam4", anim = "say_hurry_up_a_trevor", andar = true, loop = false },
	["limpar"] = { dict = "missfbi3_camcrew", anim = "final_loop_guy", andar = true, loop = false },
	["galinha"] = { dict = "random@peyote@chicken", anim = "wakeup", andar = true, loop = true },
	["amem"] = { dict = "rcmepsilonism8", anim = "worship_base", andar = true, loop = true },
	["nervoso"] = { dict = "rcmme_tracey1", anim = "nervous_loop", andar = true, loop = true },
	["ajoelhar"] = { dict = "amb@medic@standing@kneel@idle_a", anim = "idle_a", andar = false, loop = true },
	["sinalizar"] = { dict = "amb@world_human_car_park_attendant@male@base", anim = "base", prop = "prop_parking_wand_01", flag = 49, mao = 28422 },
	["placa"] = { dict = "amb@world_human_bum_freeway@male@base", anim = "base", prop = "prop_beggers_sign_01", flag = 49, mao = 28422 },
	["placa2"] = { dict = "amb@world_human_bum_freeway@male@base", anim = "base", prop = "prop_beggers_sign_03", flag = 49, mao = 28422 },
	["placa3"] = { dict = "amb@world_human_bum_freeway@male@base", anim = "base", prop = "prop_beggers_sign_04", flag = 49, mao = 28422 },
	["abanar"] = { dict = "timetable@amanda@facemask@base", anim = "base", andar = true, loop = true },
	["cocada"] = { dict = "mp_player_int_upperarse_pick", anim = "mp_player_int_arse_pick", andar = true, loop = true },
	["cocada2"] = { dict = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", andar = true, loop = true },
	["lero"] = { dict = "anim@mp_player_intselfiejazz_hands", anim = "idle_a", andar = true, loop = false },
	["dj2"] = { dict = "anim@mp_player_intupperair_synth", anim = "idle_a_fp", andar = false, loop = true },
	["beijo"] = { dict = "anim@mp_player_intselfieblow_kiss", anim = "exit", andar = true, loop = false },
	["malicia"] = { dict = "anim@mp_player_intupperdock", anim = "idle_a", andar = true, loop = false },
	["ligar"] = { dict = "cellphone@", anim = "cellphone_call_in", prop = "prop_npc_phone_02", flag = 50, mao = 28422 },
	["radio"] = { dict = "cellphone@", anim = "cellphone_call_in", prop = "prop_cs_hand_radio", flag = 50, mao = 28422 },
	["cafe"] = { dict = "amb@world_human_aa_coffee@base", anim = "base", prop = "p_amb_coffeecup_01", flag = 50, mao = 28422 },
	["cafe2"] = { dict = "amb@world_human_aa_coffee@idle_a", anim = "idle_a", prop = "p_amb_coffeecup_01", flag = 49, mao = 28422 },
	["cafe3"] = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", prop = "p_amb_coffeecup_01", flag = 49, mao = 28422 },
	["caixa"] = { dict = "anim@heists@box_carry@", anim = "idle", prop = "hei_prop_heist_box", flag = 50, mao = 28422 },
	["chuva"] = { dict = "amb@world_human_drinking@coffee@male@base", anim = "base", prop = "p_amb_brolly_01", flag = 50, mao = 28422 },
	["chuva2"] = { dict = "amb@world_human_drinking@coffee@male@base", anim = "base", prop = "p_amb_brolly_01_s", flag = 50, mao = 28422 },
	["comer"] = { dict = "amb@code_human_wander_eating_donut@male@idle_a", anim = "idle_c", prop = "prop_cs_burger_01", flag = 49, mao = 28422 },
	["comer2"] = { dict = "amb@code_human_wander_eating_donut@male@idle_a", anim = "idle_c", prop = "prop_cs_hotdog_01", flag = 49, mao = 28422 },
	["comer3"] = { dict = "amb@code_human_wander_eating_donut@male@idle_a", anim = "idle_c", prop = "prop_amb_donut", flag = 49, mao = 28422 },
	["comer4"] = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", prop = "prop_choc_ego", flag = 49, mao = 60309 },
	["comer5"] = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", prop = "prop_sandwich_01", flag = 49, mao = 18905, altura = 0.13, pos1 = 0.05, pos2 = 0.02, pos3 = -50.0, pos4 = 16.0, pos5 = 60.0 },
	["comer6"] = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", prop = "prop_taco_01", flag = 49, mao = 18905, altura = 0.16, pos1 = 0.06, pos2 = 0.02, pos3 = -50.0, pos4 = 220.0, pos5 = 60.0 },
	["comer7"] = { dict = "mp_player_inteat@burger", anim = "mp_player_int_eat_burger", prop = "prop_food_bs_chips", flag = 49, mao = 18905, altura = 0.10, pos1 = 0.0, pos2 = 0.08, pos3 = 150.0, pos4 = 320.0, pos5 = 160.0 },
	["beber"] = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_a", prop = "p_cs_bottle_01", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = 0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber2"] = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_a", prop = "prop_energy_drink", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = 0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber3"] = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_a", prop = "prop_amb_beer_bottle", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = 0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber4"] = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_a", prop = "p_whiskey_notop", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = 0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber5"] = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_a", prop = "prop_beer_logopen", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.10, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber6"] = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_a", prop = "prop_beer_blr", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = -0.10, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber7"] = { dict = "amb@world_human_drinking@beer@male@idle_a", anim = "idle_a", prop = "prop_ld_flow_bottle", flag = 49, mao = 28422, altura = 0.0, pos1 = 0.0, pos2 = 0.05, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber8"] = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", prop = "prop_plastic_cup_02", flag = 49, mao = 28422 },
	["beber9"] = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", prop = "prop_food_bs_juice01", flag = 49, mao = 28422, altura = 0.0, pos1 = -0.01, pos2 = -0.15, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["beber10"] = { dict = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", prop = "ng_proc_sodacan_01b", flag = 49, mao = 28422, altura = 0.0, pos1 = -0.01, pos2 = -0.08, pos3 = 0.0, pos4 = 0.0, pos5 = 0.0 },
	["digitar"] = { dict = "anim@heists@prison_heistig1_p1_guard_checks_bus", anim = "loop", andar = false, loop = true },
	["continencia"] = { dict = "mp_player_int_uppersalute", anim = "mp_player_int_salute", andar = true, loop = true },
	["atm"] = { dict = "amb@prop_human_atm@male@idle_a", anim = "idle_a", andar = false, loop = false },
	["nao"] = { dict = "mp_player_int_upper_nod", anim = "mp_player_int_nod_no", andar = true, loop = true },
	
	["palmas"] = { dict = "anim@mp_player_intcelebrationfemale@slow_clap" , anim = "slow_clap" , andar = true , loop = false },
	["palmas2"] = { dict = "amb@world_human_cheering@male_b" , anim = "base" , andar = true , loop = true },
	["palmas3"] = { dict = "amb@world_human_cheering@male_d" , anim = "base" , andar = true , loop = true },
	["palmas4"] = { dict = "amb@world_human_cheering@male_e" , anim = "base" , andar = true , loop = true },
	["palmas5"] = { dict = "anim@arena@celeb@flat@solo@no_props@" , anim = "angry_clap_a_player_a" , andar = true , loop = false },
	["palmas6"] = { dict = "anim@mp_player_intupperslow_clap" , anim = "idle_a" , andar = true , loop = true },

	["postura"] = { dict = "anim@heists@prison_heiststation@cop_reactions", anim = "cop_a_idle", andar = true, loop = true },
	["postura2"] = { dict = "amb@world_human_cop_idles@female@base", anim = "base", andar = true, loop = true },
	["varrer"] = { dict = "amb@world_human_janitor@male@idle_a", anim = "idle_a", prop = "prop_tool_broom", flag = 49, mao = 28422 },
	["musica"] = { dict = "amb@world_human_musician@guitar@male@base", anim = "base", prop = "prop_el_guitar_01", flag = 49, mao = 60309 },
	["musica2"] = { dict = "amb@world_human_musician@guitar@male@base", anim = "base", prop = "prop_el_guitar_02", flag = 49, mao = 60309 },
	["musica3"] = { dict = "amb@world_human_musician@guitar@male@base", anim = "base", prop = "prop_el_guitar_03", flag = 49, mao = 60309 },
	["musica4"] = { dict = "amb@world_human_musician@guitar@male@base", anim = "base", prop = "prop_acc_guitar_01", flag = 49, mao = 60309 },
	["musica5"] = { dict = "switch@trevor@guitar_beatdown", anim = "001370_02_trvs_8_guitar_beatdown_idle_busker", prop = "prop_acc_guitar_01", flag = 49, mao = 24818, altura = -0.05, pos1 = 0.31, pos2 = 0.1, pos3 = 0.0, pos4 = 20.0, pos5 = 150.0 },
	["camera"] = { dict = "missfinale_c2mcs_1", anim = "fin_c2_mcs_1_camman", prop = "prop_v_cam_01", flag = 49, mao = 28422 },
	["prancheta"] = { dict = "amb@world_human_clipboard@male@base", anim = "base", prop = "p_amb_clipboard_01", flag = 50, mao = 60309 },
	["mapa"] = { dict = "amb@world_human_clipboard@male@base", anim = "base", prop = "prop_tourist_map_01", flag = 50, mao = 60309 },
	["anotar"] = { dict = "amb@medic@standing@timeofdeath@base", anim = "base", prop = "prop_notepad_01", flag = 49, mao = 60309 },
	["paz"] = { dict = "mp_player_int_upperpeace_sign", anim = "mp_player_int_peace_sign", andar = true, loop = true },
	["deitar"] = { dict = "anim@gangops@morgue@table@", anim = "body_search", andar = false, loop = true },
	["deitar2"] = { dict = "amb@world_human_sunbathe@female@front@idle_a" , anim = "idle_a" , andar = false , loop = true },
	["deitar3"] = { dict = "amb@world_human_sunbathe@male@back@idle_a" , anim = "idle_a" , andar = false , loop = true },
	["deitar4"] = { dict = "amb@world_human_sunbathe@male@front@idle_a" , anim = "idle_a" , andar = false , loop = true },
	["deitar5"] = { dict = "mini@cpr@char_b@cpr_str" , anim = "cpr_kol_idle" , andar = false , loop = true },
	["deitar6"] = { dict = "switch@trevor@scares_tramp" , anim = "trev_scares_tramp_idle_tramp" , andar = false , loop = true },
	["deitar7"] = { dict = "switch@trevor@annoys_sunbathers" , anim = "trev_annoys_sunbathers_loop_girl" , andar = false , loop = true },		
	["deitar8"] = { dict = "switch@trevor@annoys_sunbathers" , anim = "trev_annoys_sunbathers_loop_guy" , andar = false , loop = true },
	["debrucar"] = { dict = "amb@prop_human_bum_shopping_cart@male@base" , anim = "base" , andar = false , loop = true },
	["debrucar2"] = { dict = "anim@amb@casino@valet_scenario@pose_b@" , anim = "base_a_m_y_vinewood_01" , andar = false , loop = true },
	["debrucar3"] = { dict = "anim@amb@casino@valet_scenario@pose_a@" , anim = "base_a_m_y_vinewood_01" , andar = false , loop = true },
	["debrucar4"] = { dict = "anim@amb@casino@out_of_money@ped_female@02a@base" , anim = "base" , andar = false , loop = true },
	["debrucar5"] = { dict = "anim@mini@yacht@bar@drink@four" , anim = "four_bartender" , andar = false , loop = true },
	["dancar"] = { dict = "rcmnigel1bnmt_1b" , anim = "dance_loop_tyler" , andar = false , loop = true },
	["dancar2"] = { dict = "mp_safehouse" , anim = "lap_dance_girl" , andar = false , loop = true },
	["dancar3"] = { dict = "misschinese2_crystalmazemcs1_cs" , anim = "dance_loop_tao" , andar = false , loop = true },
	["dancar4"] = { dict = "mini@strip_club@private_dance@part1" , anim = "priv_dance_p1" , andar = false , loop = true },
	["dancar5"] = { dict = "mini@strip_club@private_dance@part2" , anim = "priv_dance_p2" , andar = false , loop = true },
	["dancar6"] = { dict = "mini@strip_club@private_dance@part3" , anim = "priv_dance_p3" , andar = false , loop = true },
	["dancar7"] = { dict = "special_ped@mountain_dancer@monologue_2@monologue_2a" , anim = "mnt_dnc_angel" , andar = false , loop = true },
	["dancar8"] = { dict = "special_ped@mountain_dancer@monologue_3@monologue_3a" , anim = "mnt_dnc_buttwag" , andar = false , loop = true },
	["dancar9"] = { dict = "missfbi3_sniping" , anim = "dance_m_default" , andar = false , loop = true },
	["dancar10"] = { dict = "anim@amb@nightclub@dancers@black_madonna_entourage@" , anim = "hi_dance_facedj_09_v2_male^5" , andar = false , loop = true },
	["dancar11"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^1" , andar = false , loop = true },
	["dancar12"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^2" , andar = false , loop = true },
	["dancar13"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^3" , andar = false , loop = true },
	["dancar14"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^4" , andar = false , loop = true },
	["dancar15"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^5" , andar = false , loop = true },
	["dancar16"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^6" , andar = false , loop = true },
	["dancar17"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^1" , andar = false , loop = true },
	["dancar18"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^2" , andar = false , loop = true },
	["dancar19"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^3" , andar = false , loop = true },
	["dancar20"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^4" , andar = false , loop = true },
	["dancar21"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^5" , andar = false , loop = true },
	["dancar22"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^6" , andar = false , loop = true },
	["dancar23"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^1" , andar = false , loop = true },
	["dancar24"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^2" , andar = false , loop = true },
	["dancar25"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^3" , andar = false , loop = true },
	["dancar26"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^4" , andar = false , loop = true },
	["dancar27"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^5" , andar = false , loop = true },
	["dancar28"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^6" , andar = false , loop = true },
	["dancar29"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^1" , andar = false , loop = true },
	["dancar30"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^2" , andar = false , loop = true },
	["dancar31"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^3" , andar = false , loop = true },
	["dancar32"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^4" , andar = false , loop = true },
	["dancar33"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^5" , andar = false , loop = true },
	["dancar34"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^6" , andar = false , loop = true },
	["dancar35"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^1" , andar = false , loop = true },
	["dancar36"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^2" , andar = false , loop = true },
	["dancar37"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^3" , andar = false , loop = true },
	["dancar38"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^4" , andar = false , loop = true },
	["dancar39"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^5" , andar = false , loop = true },
	["dancar40"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^6" , andar = false , loop = true },
	["dancar41"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^1" , andar = false , loop = true },
	["dancar42"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^2" , andar = false , loop = true },
	["dancar43"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^3" , andar = false , loop = true },
	["dancar44"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^4" , andar = false , loop = true },
	["dancar45"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^5" , andar = false , loop = true },
	["dancar46"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^6" , andar = false , loop = true },
	["dancar47"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^1" , andar = false , loop = true },
	["dancar48"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^2" , andar = false , loop = true },
	["dancar49"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^3" , andar = false , loop = true },
	["dancar50"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^4" , andar = false , loop = true },
	["dancar51"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^5" , andar = false , loop = true },
	["dancar52"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^6" , andar = false , loop = true },
	["dancar53"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^1" , andar = false , loop = true },
	["dancar54"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^2" , andar = false , loop = true },
	["dancar55"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^3" , andar = false , loop = true },
	["dancar56"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^4" , andar = false , loop = true },
	["dancar57"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^5" , andar = false , loop = true },
	["dancar58"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^6" , andar = false , loop = true },
	["dancar59"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^1" , andar = false , loop = true },
	["dancar60"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^2" , andar = false , loop = true },
	["dancar61"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^3" , andar = false , loop = true },
	["dancar62"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^4" , andar = false , loop = true },
	["dancar63"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^5" , andar = false , loop = true },
	["dancar64"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^6" , andar = false , loop = true },
	["dancar65"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^1" , andar = false , loop = true },
	["dancar66"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^2" , andar = false , loop = true },
	["dancar67"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^3" , andar = false , loop = true },
	["dancar68"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^4" , andar = false , loop = true },
	["dancar69"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^5" , andar = false , loop = true },
	["dancar70"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^6" , andar = false , loop = true },
	["dancar71"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^1" , andar = false , loop = true },
	["dancar72"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^2" , andar = false , loop = true },
	["dancar73"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^3" , andar = false , loop = true },
	["dancar74"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^4" , andar = false , loop = true },
	["dancar75"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^5" , andar = false , loop = true },
	["dancar76"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^6" , andar = false , loop = true },
	["dancar77"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^1" , andar = false , loop = true },
	["dancar78"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^2" , andar = false , loop = true },
	["dancar79"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^3" , andar = false , loop = true },
	["dancar80"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^4" , andar = false , loop = true },
	["dancar81"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^5" , andar = false , loop = true },
	["dancar82"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^6" , andar = false , loop = true },
	["dancar83"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^1" , andar = false , loop = true },
	["dancar84"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^2" , andar = false , loop = true },
	["dancar85"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^3" , andar = false , loop = true },
	["dancar86"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^4" , andar = false , loop = true },
	["dancar87"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^5" , andar = false , loop = true },
	["dancar88"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^6" , andar = false , loop = true },
	["dancar89"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^1" , andar = false , loop = true },
	["dancar90"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^2" , andar = false , loop = true },
	["dancar91"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^3" , andar = false , loop = true },
	["dancar92"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^4" , andar = false , loop = true },
	["dancar93"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^5" , andar = false , loop = true },
	["dancar94"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^6" , andar = false , loop = true },
	["dancar95"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^1" , andar = false , loop = true },
	["dancar96"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^2" , andar = false , loop = true },
	["dancar97"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^3" , andar = false , loop = true },
	["dancar98"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^4" , andar = false , loop = true },
	["dancar99"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^5" , andar = false , loop = true },
	["dancar100"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^6" , andar = false , loop = true },
	["dancar101"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^1" , andar = false , loop = true },
	["dancar102"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^2" , andar = false , loop = true },
	["dancar103"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^3" , andar = false , loop = true },
	["dancar104"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^4" , andar = false , loop = true },
	["dancar105"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^5" , andar = false , loop = true },
	["dancar106"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^6" , andar = false , loop = true },
	["dancar107"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^1" , andar = false , loop = true },
	["dancar108"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^2" , andar = false , loop = true },
	["dancar109"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^3" , andar = false , loop = true },
	["dancar110"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^4" , andar = false , loop = true },
	["dancar111"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^5" , andar = false , loop = true },
	["dancar112"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^6" , andar = false , loop = true },
	["dancar113"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^1" , andar = false , loop = true },
	["dancar114"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^2" , andar = false , loop = true },
	["dancar115"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^3" , andar = false , loop = true },
	["dancar116"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^4" , andar = false , loop = true },
	["dancar117"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^5" , andar = false , loop = true },
	["dancar118"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^6" , andar = false , loop = true },
	["dancar119"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^1" , andar = false , loop = true },
	["dancar120"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^2" , andar = false , loop = true },
	["dancar121"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^3" , andar = false , loop = true },
	["dancar122"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^4" , andar = false , loop = true },
	["dancar123"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^5" , andar = false , loop = true },
	["dancar124"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^6" , andar = false , loop = true },
	["dancar125"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^1" , andar = false , loop = true },
	["dancar126"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^2" , andar = false , loop = true },
	["dancar127"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^3" , andar = false , loop = true },
	["dancar128"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^4" , andar = false , loop = true },
	["dancar129"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^5" , andar = false , loop = true },
	["dancar130"] = { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^6" , andar = false , loop = true },
	["dancar131"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^1" , andar = false , loop = true },
	["dancar132"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^2" , andar = false , loop = true },
	["dancar133"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^3" , andar = false , loop = true },
	["dancar134"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^4" , andar = false , loop = true },
	["dancar135"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^5" , andar = false , loop = true },
	["dancar136"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^6" , andar = false , loop = true },
	["dancar137"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^1" , andar = false , loop = true },
	["dancar138"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^2" , andar = false , loop = true },
	["dancar139"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^3" , andar = false , loop = true },
	["dancar140"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^4" , andar = false , loop = true },
	["dancar141"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^5" , andar = false , loop = true },
	["dancar142"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^6" , andar = false , loop = true },
	["dancar143"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^1" , andar = false , loop = true },
	["dancar144"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^2" , andar = false , loop = true },
	["dancar145"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^3" , andar = false , loop = true },
	["dancar146"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^4" , andar = false , loop = true },
	["dancar147"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^5" , andar = false , loop = true },
	["dancar148"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^6" , andar = false , loop = true },
	["dancar149"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^1" , andar = false , loop = true },
	["dancar150"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^2" , andar = false , loop = true },
	["dancar151"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^3" , andar = false , loop = true },
	["dancar152"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^4" , andar = false , loop = true },
	["dancar153"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^5" , andar = false , loop = true },
	["dancar154"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^6" , andar = false , loop = true },
	["dancar155"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^1" , andar = false , loop = true },
	["dancar156"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^2" , andar = false , loop = true },
	["dancar157"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^3" , andar = false , loop = true },
	["dancar158"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^4" , andar = false , loop = true },
	["dancar159"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^5" , andar = false , loop = true },
	["dancar160"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^6" , andar = false , loop = true },
	["dancar161"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^1" , andar = false , loop = true },
	["dancar162"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^2" , andar = false , loop = true },
	["dancar163"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^3" , andar = false , loop = true },
	["dancar164"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^4" , andar = false , loop = true },
	["dancar165"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^5" , andar = false , loop = true },
	["dancar166"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^6" , andar = false , loop = true },
	["dancar167"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^1" , andar = false , loop = true },
	["dancar168"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^2" , andar = false , loop = true },
	["dancar169"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^3" , andar = false , loop = true },
	["dancar170"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^4" , andar = false , loop = true },
	["dancar171"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^5" , andar = false , loop = true },
	["dancar172"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^6" , andar = false , loop = true },
	["dancar173"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^1" , andar = false , loop = true },
	["dancar174"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^2" , andar = false , loop = true },
	["dancar175"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^3" , andar = false , loop = true },
	["dancar176"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^4" , andar = false , loop = true },
	["dancar177"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^5" , andar = false , loop = true },
	["dancar178"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^6" , andar = false , loop = true },
	["dancar179"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^1" , andar = false , loop = true },
	["dancar180"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^2" , andar = false , loop = true },
	["dancar181"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^3" , andar = false , loop = true },
	["dancar182"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^4" , andar = false , loop = true },
	["dancar183"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^5" , andar = false , loop = true },
	["dancar184"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^6" , andar = false , loop = true },
	["dancar185"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^1" , andar = false , loop = true },
	["dancar186"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^2" , andar = false , loop = true },
	["dancar187"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^3" , andar = false , loop = true },
	["dancar188"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^4" , andar = false , loop = true },
	["dancar189"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^5" , andar = false , loop = true },
	["dancar190"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^6" , andar = false , loop = true },
	["dancar191"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^1" , andar = false , loop = true },
	["dancar192"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^2" , andar = false , loop = true },
	["dancar193"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^3" , andar = false , loop = true },
	["dancar194"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^4" , andar = false , loop = true },
	["dancar195"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^5" , andar = false , loop = true },
	["dancar196"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^6" , andar = false , loop = true },
	["dancar197"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^1" , andar = false , loop = true },
	["dancar198"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^2" , andar = false , loop = true },
	["dancar199"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^3" , andar = false , loop = true },
	["dancar200"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^4" , andar = false , loop = true },
	["dancar201"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^5" , andar = false , loop = true },
	["dancar202"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^6" , andar = false , loop = true },
	["dancar203"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^1" , andar = false , loop = true },
	["dancar204"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^2" , andar = false , loop = true },
	["dancar205"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^3" , andar = false , loop = true },
	["dancar206"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^4" , andar = false , loop = true },
	["dancar207"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^5" , andar = false , loop = true },
	["dancar208"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^6" , andar = false , loop = true },
	["dancar209"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^1" , andar = false , loop = true },
	["dancar210"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^2" , andar = false , loop = true },
	["dancar211"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^3" , andar = false , loop = true },
	["dancar212"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^4" , andar = false , loop = true },
	["dancar213"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^5" , andar = false , loop = true },
	["dancar214"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^6" , andar = false , loop = true },
	["dancar215"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^1" , andar = false , loop = true },
	["dancar216"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^2" , andar = false , loop = true },
	["dancar217"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^3" , andar = false , loop = true },
	["dancar218"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^4" , andar = false , loop = true },
	["dancar219"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^5" , andar = false , loop = true },
	["dancar220"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^6" , andar = false , loop = true },
	["dancar221"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^1" , andar = false , loop = true },
	["dancar222"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^2" , andar = false , loop = true },
	["dancar223"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^3" , andar = false , loop = true },
	["dancar224"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^4" , andar = false , loop = true },
	["dancar225"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^5" , andar = false , loop = true },
	["dancar226"] = { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^6" , andar = false , loop = true },
	["dancar227"] = { dict = "anim@amb@nightclub@lazlow@hi_podium@" , anim = "danceidle_hi_11_buttwiggle_b_laz" , andar = false , loop = true },
	["dancar228"] = { dict = "timetable@tracy@ig_5@idle_a" , anim = "idle_a" , andar = false , loop = true },
	["dancar229"] = { dict = "anim@mp_player_intupperfind_the_fish" , anim = "idle_a" , andar = true , loop = true },
	["dancar230"] = { dict = "anim@amb@nightclub@dancers@podium_dancers@" , anim = "hi_dance_facedj_17_v2_male^5" , andar = false , loop = true },
	["dancar231"] = { dict = "anim@amb@nightclub@dancers@solomun_entourage@" , anim = "mi_dance_facedj_17_v1_female^1" , andar = false , loop = true },
	["dancar232"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center" , andar = false , loop = true },
	["dancar233"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center_down" , andar = false , loop = true },
	["dancar234"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	["dancar235"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_left" , andar = false , loop = true },
	["dancar236"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_left_down" , andar = false , loop = true },
	["dancar237"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_left_up" , andar = false , loop = true },
	["dancar238"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_right" , andar = false , loop = true },
	["dancar239"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_right_down" , andar = false , loop = true },
	["dancar240"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_right_up" , andar = false , loop = true },
	["dancar241"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_center" , andar = false , loop = true },
	["dancar242"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_center_down" , andar = false , loop = true },
	["dancar243"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_center_up" , andar = false , loop = true },
	["dancar244"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_left" , andar = false , loop = true },
	["dancar245"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_left_down" , andar = false , loop = true },
	["dancar246"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_left_up" , andar = false , loop = true },
	["dancar247"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_right" , andar = false , loop = true },
	["dancar248"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_right_down" , andar = false , loop = true },
	["dancar249"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_right_up" , andar = false , loop = true },
	["dancar250"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_center" , andar = false , loop = true },
	["dancar251"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_center_down" , andar = false , loop = true },
	["dancar252"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_center_up" , andar = false , loop = true },
	["dancar253"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_left" , andar = false , loop = true },
	["dancar254"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_left_down" , andar = false , loop = true },
	["dancar255"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_left_up" , andar = false , loop = true },
	["dancar256"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_right" , andar = false , loop = true },
	["dancar257"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_right_down" , andar = false , loop = true },
	["dancar258"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_right_up" , andar = false , loop = true },
	["dancar259"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_center" , andar = false , loop = true },
	["dancar260"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_center_down" , andar = false , loop = true },
	["dancar261"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_center_up" , andar = false , loop = true },
	["dancar262"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_left" , andar = false , loop = true },
	["dancar263"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_left_down" , andar = false , loop = true },
	["dancar264"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_left_up" , andar = false , loop = true },
	["dancar265"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_right" , andar = false , loop = true },
	["dancar266"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_right_down" , andar = false , loop = true },
	["dancar267"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_right_up" , andar = false , loop = true },
	["dancar268"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_center" , andar = false , loop = true },
	["dancar269"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_center_down" , andar = false , loop = true },
	["dancar270"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_center_up" , andar = false , loop = true },
	["dancar271"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_left" , andar = false , loop = true },
	["dancar272"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_left_down" , andar = false , loop = true },
	["dancar273"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_left_up" , andar = false , loop = true },
	["dancar274"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_right" , andar = false , loop = true },
	["dancar275"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_right_down" , andar = false , loop = true },
	["dancar276"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_right_up" , andar = false , loop = true },
	["dancar277"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_center" , andar = false , loop = true },
	["dancar278"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_center_down" , andar = false , loop = true },
	["dancar279"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_center_up" , andar = false , loop = true },
	["dancar280"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_left" , andar = false , loop = true },
	["dancar281"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_left_down" , andar = false , loop = true },
	["dancar282"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_left_up" , andar = false , loop = true },
	["dancar283"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_right" , andar = false , loop = true },
	["dancar284"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_right_down" , andar = false , loop = true },
	["dancar285"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_right_up" , andar = false , loop = true },
	["dancar286"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center" , andar = false , loop = true },
	["dancar287"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center_down" , andar = false , loop = true },
	["dancar288"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	["dancar289"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_left" , andar = false , loop = true },
	["dancar290"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_left_down" , andar = false , loop = true },
	["dancar291"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_left_up" , andar = false , loop = true },
	["dancar292"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_right" , andar = false , loop = true },
	["dancar293"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_right_down" , andar = false , loop = true },
	["dancar294"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_right_up" , andar = false , loop = true },
	["dancar295"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center" , andar = false , loop = true },
	["dancar296"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center_down" , andar = false , loop = true },
	["dancar297"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center_up" , andar = false , loop = true },
	["dancar298"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_left" , andar = false , loop = true },
	["dancar299"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_left_down" , andar = false , loop = true },
	["dancar300"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_left_up" , andar = false , loop = true },
	["dancar301"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_right" , andar = false , loop = true },
	["dancar302"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_right_down" , andar = false , loop = true },
	["dancar303"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_right_up" , andar = false , loop = true },
	["dancar304"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_center" , andar = false , loop = true },
	["dancar305"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_center_down" , andar = false , loop = true },
	["dancar306"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_center_up" , andar = false , loop = true },
	["dancar307"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_left" , andar = false , loop = true },
	["dancar308"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_left_down" , andar = false , loop = true },
	["dancar309"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_left_up" , andar = false , loop = true },
	["dancar310"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_right" , andar = false , loop = true },
	["dancar311"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_right_down" , andar = false , loop = true },
	["dancar312"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_right_up" , andar = false , loop = true },
	["dancar313"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center" , andar = false , loop = true },
	["dancar314"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_down" , andar = false , loop = true },
	["dancar315"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_up" , andar = false , loop = true },
	["dancar316"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_left" , andar = false , loop = true },
	["dancar317"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_left_down" , andar = false , loop = true },
	["dancar318"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_left_up" , andar = false , loop = true },
	["dancar319"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_right" , andar = false , loop = true },
	["dancar320"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_right_down" , andar = false , loop = true },
	["dancar321"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_right_up" , andar = false , loop = true },
	["dancar322"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center" , andar = false , loop = true },
	["dancar323"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center_down" , andar = false , loop = true },
	["dancar324"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center_up" , andar = false , loop = true },
	["dancar325"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_left" , andar = false , loop = true },
	["dancar326"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_left_down" , andar = false , loop = true },
	["dancar327"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_left_up" , andar = false , loop = true },
	["dancar328"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_right" , andar = false , loop = true },
	["dancar329"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_right_down" , andar = false , loop = true },
	["dancar330"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_right_up" , andar = false , loop = true },
	["dancar331"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_center" , andar = false , loop = true },
	["dancar332"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_center_down" , andar = false , loop = true },
	["dancar333"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_center_up" , andar = false , loop = true },
	["dancar334"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_left" , andar = false , loop = true },
	["dancar335"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_left_down" , andar = false , loop = true },
	["dancar336"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_left_up" , andar = false , loop = true },
	["dancar337"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_right" , andar = false , loop = true },
	["dancar338"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_right_down" , andar = false , loop = true },
	["dancar339"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_right_up" , andar = false , loop = true },
	["dancar340"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_center" , andar = false , loop = true },
	["dancar341"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_center_down" , andar = false , loop = true },
	["dancar342"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	["dancar343"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_left" , andar = false , loop = true },
	["dancar344"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_left_down" , andar = false , loop = true },
	["dancar345"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_left_up" , andar = false , loop = true },
	["dancar346"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_right" , andar = false , loop = true },
	["dancar347"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_right_down" , andar = false , loop = true },
	["dancar348"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_right_up" , andar = false , loop = true },
	["dancar349"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_center" , andar = false , loop = true },
	["dancar350"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_center_down" , andar = false , loop = true },
	["dancar351"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_center_up" , andar = false , loop = true },
	["dancar352"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_left" , andar = false , loop = true },
	["dancar353"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_left_down" , andar = false , loop = true },
	["dancar354"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_left_up" , andar = false , loop = true },
	["dancar355"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_right" , andar = false , loop = true },
	["dancar356"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_right_down" , andar = false , loop = true },
	["dancar357"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_right_up" , andar = false , loop = true },
	["dancar358"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_center" , andar = false , loop = true },
	["dancar359"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_center_down" , andar = false , loop = true },
	["dancar360"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_center_up" , andar = false , loop = true },
	["dancar361"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_left" , andar = false , loop = true },
	["dancar362"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_left_down" , andar = false , loop = true },
	["dancar363"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_left_up" , andar = false , loop = true },
	["dancar364"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_right" , andar = false , loop = true },
	["dancar365"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_right_down" , andar = false , loop = true },
	["dancar366"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_right_up" , andar = false , loop = true },
	["dancar367"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center" , andar = false , loop = true },	
	["dancar368"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center_down" , andar = false , loop = true },	
	["dancar369"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center_up" , andar = false , loop = true },	
	["dancar370"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_left" , andar = false , loop = true },	
	["dancar371"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_left_down" , andar = false , loop = true },	
	["dancar372"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_left_up" , andar = false , loop = true },	
	["dancar373"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_right" , andar = false , loop = true },	
	["dancar374"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_right_down" , andar = false , loop = true },	
	["dancar375"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_right_up" , andar = false , loop = true },	
	["dancar376"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_center" , andar = false , loop = true },	
	["dancar377"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_center_down" , andar = false , loop = true },	
	["dancar378"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_center_up" , andar = false , loop = true },	
	["dancar379"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_left" , andar = false , loop = true },	
	["dancar380"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_left_down" , andar = false , loop = true },	
	["dancar381"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_left_up" , andar = false , loop = true },	
	["dancar382"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_right" , andar = false , loop = true },	
	["dancar383"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_right_down" , andar = false , loop = true },	
	["dancar384"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_right_up" , andar = false , loop = true },	
	["dancar385"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_center" , andar = false , loop = true },	
	["dancar386"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_center_down" , andar = false , loop = true },	
	["dancar387"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_center_up" , andar = false , loop = true },	
	["dancar388"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_left" , andar = false , loop = true },	
	["dancar389"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_left_down" , andar = false , loop = true },	
	["dancar390"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_left_up" , andar = false , loop = true },	
	["dancar391"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_right" , andar = false , loop = true },	
	["dancar392"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_right_down" , andar = false , loop = true },	
	["dancar393"] = { dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_right_up" , andar = false , loop = true },
	["dancar394"] = { dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_left_up" , andar = false , loop = true },    
    ["dancar395"] = { dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_f@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    ["dancar396"] = { dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_f@" , anim = "ped_b_dance_idle" , andar = false , loop = true },    
    ["dancar397"] = { dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_h@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    ["dancar398"] = { dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_h@" , anim = "ped_b_dance_idle" , andar = false , loop = true },    
    ["dancar399"] = { dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_j@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    ["dancar400"] = { dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_m@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    ["dancar401"] = { dict = "anim@amb@nightclub_island@dancers@club@" , anim = "hi_idle_a_f02" , andar = false , loop = true },    
    ["dancar402"] = { dict = "anim@amb@nightclub_island@dancers@club@" , anim = "mi_idle_b_f02" , andar = false , loop = true },    
    ["dancar403"] = { dict = "anim@mp_player_intcelebrationfemale@crowd_invitation" , anim = "crowd_invitation" , andar = false , loop = true },    
    ["dancar404"] = { dict = "anim@mp_player_intcelebrationfemale@driver" , anim = "driver" , andar = false , loop = true },    
    ["dancar405"] = { dict = "anim@mp_player_intcelebrationfemale@shooting" , anim = "shooting" , andar = false , loop = true },    
    ["dancar406"] = { dict = "anim@mp_player_intcelebrationmale@shooting" , anim = "shooting" , andar = false , loop = true },    
    ["dancar407"] = { dict = "anim@mp_player_intcelebrationmale@suck_it" , anim = "suck_it" , andar = false , loop = true },    
    ["dancar408"] = { dict = "anim@mp_player_intuppercrowd_invitation" , anim = "idle_a" , andar = false , loop = true },    
    ["dancar409"] = { dict = "anim@mp_player_intuppershooting" , anim = "idle_a" , andar = false , loop = true },    
    ["dancar410"] = { dict = "anim@mp_player_intuppersuck_it" , anim = "idle_a" , andar = false , loop = true },

	["argumentar"] = { dict = "misscarsteal4@actor", anim = "actor_berating_loop", andar = true, loop = true },
	["passaro"] = { dict = "random@peyote@bird", anim = "wakeup", andar = true, loop = true },
	["mandarbeijo"] = { dict = "anim@mp_player_intcelebrationfemale@blow_kiss", anim = "blow_kiss", andar = true, loop = true },
	["vempracima"] = { dict = "misscommon@response", anim = "bring_it_on", andar = true, loop = false },
	["relaxar"] = { dict = "switch@trevor@scares_tramp", anim = "trev_scares_tramp_idle_tramp", andar = false, loop = true },
	["caidentro"] = { dict = "mini@triathlon", anim = "want_some_of_this", andar = true, loop = true },
	["rastejar"] = { dict = "move_injured_ground", anim = "front_loop", andar = false, loop = true },
	["mortal"] = { dict = "anim@arena@celeb@flat@solo@no_props@", anim = "cap_a_player_a", andar = false, loop = false },
	["mortal2"] = { dict = "anim@arena@celeb@flat@solo@no_props@", anim = "flip_a_player_a", andar = false, loop = false },
	["meditar"] = { dict = "rcmcollect_paperleadinout@", anim = "meditiate_idle", andar = false, loop = true },
	["paz2"] = { dict = "anim@mp_player_intupperpeace", anim = "idle_a", andar = true, loop = true },
	["brucos"] = { dict = "missfbi3_sniping", anim = "prone_dave", andar = false, loop = true },
	["inspecionar"] = { dict = "random@train_tracks", anim = "idle_e", andar = false, loop = false },
	["cadeira"] = { dict = "timetable@ron@ig_5_p3", anim = "ig_5_p3_base", andar = false, loop = true },
	["cadeira2"] = { dict = "timetable@reunited@ig_10", anim = "base_amanda", andar = false, loop = true },
	["cadeira3"] = { dict = "timetable@ron@ig_3_couch", anim = "base", andar = false, loop = true },
	["cadeira4"] = { dict = "timetable@jimmy@mics3_ig_15@", anim = "mics3_15_base_tracy", andar = false, loop = true },
	["cadeira5"] = { dict = "timetable@maid@couch@", anim = "base", andar = false, loop = true },
	["superheroi"] = { dict = "rcmbarry", anim = "base", andar = true, loop = true },
	["escrever"] = { dict = "anim@heists@prison_heiststation@cop_reactions", anim = "cop_b_idle", andar = true, loop = true },
	["yeah"] = { dict = "anim@mp_player_intupperair_shagging", anim = "idle_a", andar = true, loop = true },
	["sexo"] = { dict = "rcmpaparazzo_2" , anim = "shag_loop_poppy" , andar = false , loop = true },
	["sexo2"] = { dict = "rcmpaparazzo_2" , anim = "shag_loop_a" , andar = false , loop = true },
	["sexo3"] = { dict = "anim@mp_player_intcelebrationfemale@air_shagging" , anim = "air_shagging" , andar = false , loop = true },
	["sexo4"] = { dict = "oddjobs@towing" , anim = "m_blow_job_loop" , andar = false , loop = true , cars = true },
	["sexo5"] = { dict = "oddjobs@towing" , anim = "f_blow_job_loop" , andar = false , loop = true , cars = true },
	["sexo6"] = { dict = "mini@prostitutes@sexlow_veh" , anim = "low_car_sex_loop_female" , andar = false , loop = true , cars = true },
	["sexo7"] = { dict = "timetable@trevor@skull_loving_bear" , anim = "skull_loving_bear" , andar = false , loop = true },
	["sentar"] = { dict = "timetable@ron@ig_3_couch" , anim = "base" , andar = false , loop = true },
	["sentar2"] = { dict = "amb@world_human_picnic@male@base" , anim = "base" , andar = false , loop = true },
	["sentar3"] = { dict = "anim@heists@fleeca_bank@ig_7_jetski_owner" , anim = "owner_idle" , andar = false , loop = true },
	["sentar4"] = { dict = "amb@world_human_picnic@female@base" , anim = "base" , andar = false , loop = true },
	["sentar5"] = { dict = "anim@amb@nightclub@lazlow@lo_alone@" , anim = "lowalone_base_laz" , andar = false , loop = true },
	["sentar6"] = { dict = "rcm_barry3" , anim = "barry_3_sit_loop" , andar = false , loop = true },
	["sentar7"] = { dict = "amb@world_human_picnic@male@idle_a" , anim = "idle_a" , andar = false , loop = true },
	["sentar8"] = { dict = "amb@world_human_picnic@female@idle_a" , anim = "idle_a" , andar = false , loop = true },
	["sentar9"] = { dict = "timetable@jimmy@mics3_ig_15@" , anim = "idle_a_jimmy" , andar = false , loop = true },
	["sentar10"] = { dict = "amb@world_human_stupor@male@idle_a" , anim = "idle_a" , andar = false , loop = true },
	["sentar11"] = { dict = "timetable@tracy@ig_14@" , anim = "ig_14_base_tracy" , andar = false , loop = true },
	["sentar12"] = { dict = "anim@heists@ornate_bank@hostages@hit" , anim = "hit_loop_ped_b" , andar = false , loop = true },
	["sentar13"] = { dict = "timetable@ron@ig_5_p3" , anim = "ig_5_p3_base" , andar = false , loop = true },
	["sentar14"] = { dict = "timetable@reunited@ig_10" , anim = "base_amanda" , andar = false , loop = true },
	["sentar15"] = { dict = "timetable@ron@ig_3_couch" , anim = "base" , andar = false , loop = true },
	["sentar16"] = { dict = "timetable@jimmy@mics3_ig_15@" , anim = "mics3_15_base_tracy" , andar = false , loop = true },
	["sentar17"] = { dict = "timetable@maid@couch@" , anim = "base" , andar = false , loop = true },
    ["sentar18"] = { dict = "missdrfriedlanderdrf_idles" , anim = "drf_idle_drf" , andar = false , loop = true },
	["sentar19"] = { dict = "missfbi2@leadinout" , anim = "fbi_2_int_leadinout_loop_steve" , andar = false , loop = true },
	["sentar20"] = { dict = "missfbi2@leadinout" , anim = "fbi_2_int_leadinout_loop_andreas" , andar = false , loop = true },
	["sentar21"] = { dict = "missfbi2@leadinout" , anim = "fbi_2_int_leadinout_loop_daven" , andar = false , loop = true },
	["sentar22"] = { dict = "missfbi2@leadinoutfbi_2_mcs_1" , anim = "_leadin_loop_franklin" , andar = false , loop = true },
    ["sentar23"] = { dict = "missfbi3_party" , anim = "snort_coke_b_female" , andar = false , loop = true },
	["sentar24"] = { dict = "missfbi3_party" , anim = "snort_coke_a_female" , andar = false , loop = true },
	["sentar25"] = { dict = "missfbi4leadinoutfbi_4_mcs_3" , anim = "_leadin_loop_michael" , andar = false , loop = true },
	["sentar26"] = { dict = "misshair_shop@hair_dressers" , anim = "base_female" , andar = false , loop = true },
	["sentar27"] = { dict = "missheist_agency2aig_4" , anim = "look_plan_base_worker2" , andar = false , loop = true },
	["sentar28"] = { dict = "missheist_agency2aig_8" , anim = "start_loop_foreman" , andar = false , loop = true },
	["sentar29"] = { dict = "missheist_agency2aig_8" , anim = "end_loop_foreman" , andar = false , loop = true },
	["sentar30"] = { dict = "missheistdocks2bleadinoutlsdh_2b_int" , anim = "sitting_loop_wade" , andar = false , loop = true },
	["sentar31"] = { dict = "missmic1leadinoutmic_1_int" , anim = "_leadin_michael" , andar = false , loop = true },
	["sentar32"] = { dict = "misstattoo_parlour@shop_ig_4" , anim = "customer_loop" , andar = false , loop = true },
	["sentar33"] = { dict = "mp_cop_miss" , anim = "dazed" , andar = false , loop = true },
	["sentar34"] = { dict = "rcmjosh3" , anim = "sit_stairs_idle" , andar = false , loop = true },
	["sentar35"] = { dict = "safe@franklin@ig_14" , anim = "base" , andar = false , loop = true },
	["sentar36"] = { dict = "switch@franklin@bed" , anim = "bed_reading_loop" , andar = false , loop = true },
	["sentar37"] = { dict = "switch@franklin@bye_taxi" , anim = "001938_01_fras_v2_7_bye_taxi_idle_girl" , andar = false , loop = true },
	["sentar38"] = { dict = "switch@michael@tv_w_kids" , anim = "001520_02_mics3_14_tv_w_kids_exit_trc" , andar = false , loop = true },
	["sentar39"] = { dict = "switch@trevor@mocks_lapdance" , anim = "001443_01_trvs_28_idle_man" , andar = false , loop = true },
	["sentar40"] = { dict = "switch@trevor@scares_tramp" , anim = "trev_scares_tramp_idle_tramp" , andar = false , loop = true },
	["sentar41"] = { dict = "timetable@amanda@ig_12" , anim = "amanda_base" , andar = false , loop = true },
	["sentar42"] = { dict = "timetable@reunited@ig_10" , anim = "base_tracy" , andar = false , loop = true },
	["sentar43"] = { dict = "timetable@tracy@ig_2@base" , anim = "base" , andar = false , loop = true },
	["sentar44"] = { dict = "missheist_jewelleadinout" , anim = "jh_int_outro_loop_a" , andar = false , loop = true },
	["sentar45"] = { dict = "anim@amb@clubhouse@boardroom@crew@female@var_c@base_r@" , anim = "base" , andar = false , loop = true },
	["sentar46"] = { dict = "anim@amb@clubhouse@boardroom@crew@female@var_c@base@" , anim = "base" , andar = false , loop = true },
	["sentar47"] = { dict = "anim@amb@office@seating@male@var_d@base@" , anim = "base" , andar = false , loop = true },
	["sentar48"] = { dict = "anim@amb@office@seating@female@var_b@base@" , anim = "base" , andar = false , loop = true },
	["sentar49"] = { dict = "anim@amb@office@seating@female@var_c@base@" , anim = "base" , andar = false , loop = true },
	
	["inspec"] = { dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_b" , andar = false , loop = true },
	["inspec2"] = { dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_c" , andar = false , loop = false },
	["inspec3"] = { dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_d" , andar = false , loop = false },
	["inspec4"] = { dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_e" , andar = false , loop = false },
	["inspec5"] = { dict = "mp_deathmatch_intros@1hmale" , anim = "intro_male_1h_a_michael" , andar = false , loop = false },
	["inspec6"] = { dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_a" , andar = false , loop = false },
	["inspec7"] = { dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_b" , andar = false , loop = false },
	["inspec8"] = { dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_c" , andar = false , loop = false },
	["inspec9"] = { dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_d" , andar = false , loop = false },
	["inspec10"] = { dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_e" , andar = false , loop = false },
	["inspec11"] = { dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_a" , andar = false , loop = false },
	["inspec12"] = { dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_b" , andar = false , loop = false },
	["inspec13"] = { dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_c" , andar = false , loop = false },
	["inspec14"] = { dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_d" , andar = false , loop = false },
	["inspec15"] = { dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_e" , andar = false , loop = false },
	["inspec16"] = { dict = "anim@deathmatch_intros@1hmale" , anim = "intro_male_1h_d_michael" , andar = true , loop = false },

	["swat"] = { dict = "swat" , anim = "come" , andar = true , loop = false },
	["swat2"] = { dict = "swat" , anim = "freeze" , andar = true , loop = false },
	["swat3"] = { dict = "swat" , anim = "go_fwd" , andar = true , loop = false },
	["swat4"] = { dict = "swat" , anim = "rally_point" , andar = true , loop = false },
	["swat5"] = { dict = "swat" , anim = "understood" , andar = true , loop = false },
	["swat6"] = { dict = "swat" , anim = "you_back" , andar = true , loop = false },
	["swat7"] = { dict = "swat" , anim = "you_fwd" , andar = true , loop = false },
	["swat8"] = { dict = "swat" , anim = "you_left" , andar = true , loop = false },
	["swat9"] = { dict = "swat" , anim = "you_right" , andar = true , loop = false },

	["beijar"] = { dict = "mp_ped_interaction", anim = "kisses_guy_a", andar = false, loop = false },
	["striper"] = { dict = "mini@strip_club@idles@stripper", anim = "stripper_idle_02", andar = false, loop = true },
	["escutar"] = { dict = "mini@safe_cracking", anim = "idle_base", andar = false, loop = true },

	["alongar"] = { dict = "anim@deathmatch_intros@unarmed" , anim = "intro_male_unarmed_e" , andar = false , loop = true },
	["alongar2"] = { dict = "mini@triathlon" , anim = "idle_e" , andar = false , loop = true },
	["alongar3"] = { dict = "anim@deathmatch_intros@unarmed" , anim = "intro_male_unarmed_c" , andar = false , loop = false },
	["alongar4"] = { dict = "mini@triathlon" , anim = "idle_f" , andar = false , loop = true },
	["alongar5"] = { dict = "mini@triathlon" , anim = "idle_d" , andar = false , loop = true },
	["alongar6"] = { dict = "rcmfanatic1maryann_stretchidle_b" , anim = "idle_e" , andar = false , loop = true },
	["alongar7"] = { dict = "timetable@reunited@ig_2" , anim = "jimmy_getknocked" , andar = false , loop = true },

	["dj"] = { dict = "anim@mp_player_intupperdj" , anim = "idle_a", andar = true , loop = true },
	["dj2"] = { dict = "anim@mp_player_intupperair_synth" , anim = "idle_a_fp" , andar = false , loop = true },
	["dj3"] = { dict = "anim@mp_player_intcelebrationfemale@air_synth" , anim = "air_synth" , andar = false , loop = false },
	["dj4"] = { dict = "anim@amb@nightclub@djs@solomun@" , anim = "sol_idle_ctr_mid_a_sol" , andar = false , loop = true },

	["poledance"] = { dict = "mini@strip_club@pole_dance@pole_dance1", anim = "pd_dance_01", andar = false, loop = true, extra = function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(poleDances) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 1 then
				SetEntityHeading(ped,v[4])
				SetEntityCoords(ped,v[1],v[2],v[3] - 1,1,0,0,0)
				break
			end
		end
	end },
	["poledance2"] = { dict = "mini@strip_club@pole_dance@pole_dance2", anim = "pd_dance_02", andar = false, loop = true, extra = function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(poleDances) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 1 then
				SetEntityHeading(ped,v[4])
				SetEntityCoords(ped,v[1],v[2],v[3] - 1,1,0,0,0)
				break
			end
		end
	end },
	["poledance3"] = { dict = "mini@strip_club@pole_dance@pole_dance3", anim = "pd_dance_03", andar = false, loop = true, extra = function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(poleDances) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 1 then
				SetEntityHeading(ped,v[4])
				SetEntityCoords(ped,v[1],v[2],v[3] - 1,1,0,0,0)
				break
			end
		end
	end },

	["rock"] = { dict = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar", andar = false, loop = true },
	["rock2"] = { dict = "mp_player_introck", anim = "mp_player_int_rock", andar = false, loop = false },
	["rock3"] = { dict = "mp_player_int_upperrock ", anim = "mp_player_int_rock_enter" , andar = false , loop = false },
	["abracar"] = { dict = "mp_ped_interaction", anim = "hugs_guy_a", andar = false, loop = false },
	["abracar2"] = { dict = "mp_ped_interaction", anim = "kisses_guy_b", andar = false, loop = false },
	["peitos"] = { dict = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b", andar = false, loop = false },
	["espernear"] = { dict = "missfam4leadinoutmcs2", anim = "tracy_loop", andar = false, loop = true },
	["arrumar"] = { dict = "anim@amb@business@coc@coc_packing_hi@", anim = "full_cycle_v1_pressoperator", andar = false, loop = true },

	["lanca"] = { dict = "amb@incar@male@smoking@enter", anim = "enter", prop = "mah_lanca" , flag = 49 , mao = 28422},  
	["lancab"] = { dict = "amb@incar@male@smoking@enter", anim = "enter", prop = "mah_lanca_02" , flag = 49 , mao = 28422},

	["bebado"] = { dict = "missfam5_blackout" , anim = "pass_out" , andar = false , loop = false },
	["bebado2"] = { dict = "missheist_agency3astumble_getup" , anim = "stumble_getup" , andar = false , loop = false },
	["bebado3"] = { dict = "missfam5_blackout" , anim = "vomit" , andar = false , loop = false },
	["bebado4"] = { dict = "random@drunk_driver_1" , anim = "drunk_fall_over" , andar = false , loop = false },
	["bebado5"] = { dict = "misscarsteal4@actor" , anim = "stumble" , andar = false , loop = false },
	["bebado6"] = { dict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@drunk" , anim = "outro_fallover" , andar = false , loop = false },
	["bebado7"] = { dict = "switch@trevor@puking_into_fountain" , anim = "trev_fountain_puke_loop" , andar = false , loop = true },
	["bebado8"] = { dict = "switch@trevor@head_in_sink" , anim = "trev_sink_idle" , andar = false , loop = true },

	["bebado2"] = { dict = "missheist_agency3astumble_getup", anim = "stumble_getup", andar = false, loop = false },
	["bebado3"] = { dict = "missfam5_blackout", anim = "vomit", andar = false, loop = false },
	["yoga"] = { dict = "missfam5_yoga", anim = "f_yogapose_a", andar = false, loop = true },
	["yoga2"] = { dict = "amb@world_human_yoga@male@base", anim = "base_a", andar = false, loop = true },
	["abdominal"] = { dict = "amb@world_human_sit_ups@male@base", anim = "base", andar = false, loop = true },
	["bixa"] = { anim = "WORLD_HUMAN_PROSTITUTE_LOW_CLASS" },
	["britadeira"] = { dict = "amb@world_human_const_drill@male@drill@base", anim = "base", prop = "prop_tool_jackham", flag = 15, mao = 28422 },
	["cerveja"] = { anim = "WORLD_HUMAN_PARTYING" },
	["churrasco"] = { anim = "PROP_HUMAN_BBQ" },
	["consertar"] = { anim = "WORLD_HUMAN_WELDING" },
	["bracos"] = { dict = "anim@heists@heist_corona@single_team", anim = "single_team_loop_boss", andar = true, loop = true },
	["postura3"] = { dict = "mini@strip_club@idles@bouncer@base", anim = "base", andar = true, loop = true },
	["dedos"] = { dict = "anim@mp_player_intupperfinger", anim = "idle_a_fp", andar = true, loop = true },
	["dormir"] = { dict = "anim@heists@ornate_bank@hostages@hit", anim = "hit_react_die_loop_ped_a", andar = false, loop = true },
	["dormir2"] = { dict = "anim@heists@ornate_bank@hostages@hit", anim = "hit_react_die_loop_ped_e", andar = false, loop = true },
	["dormir3"] = { dict = "anim@heists@ornate_bank@hostages@hit", anim = "hit_react_die_loop_ped_h", andar = false, loop = true },
	
	["encostar"] = { dict = "amb@lo_res_idles@" , anim = "world_human_lean_male_foot_up_lo_res_base" , andar = false , loop = true },
	["encostar2"] = { dict = "bs_2a_mcs_10-0" , anim = "hc_gunman_dual-0" , andar = false , loop = true },
	["encostar3"] = { dict = "misscarstealfinalecar_5_ig_1" , anim = "waitloop_lamar" , andar = false , loop = true },
	["encostar4"] = { dict = "anim@amb@casino@out_of_money@ped_female@02b@base" , anim = "base" , andar = false , loop = true },
	["encostar5"] = { dict = "anim@amb@casino@hangout@ped_male@stand@03b@base" , anim = "base" , andar = true , loop = true },
	["encostar6"] = { dict = "anim@amb@casino@hangout@ped_female@stand@02b@base" , anim = "base" , andar = false , loop = true },
	["encostar7"] = { dict = "anim@amb@casino@hangout@ped_female@stand@02a@base" , anim = "base" , andar = false , loop = true },
	["encostar8"] = { dict = "anim@amb@casino@hangout@ped_female@stand@01b@base" , anim = "base" , andar = false , loop = true },
	["encostar9"] = { dict = "anim@amb@clubhouse@bar@bartender@" , anim = "base_bartender" , andar = false , loop = true },
	["encostar10"] = { dict = "missclothing" , anim = "idle_a" , andar = false , loop = true },
	["encostar11"] = { dict = "misscarstealfinale" , anim = "packer_idle_1_trevor" , andar = false , loop = true },
	["encostar12"] = { dict = "missarmenian1leadinoutarm_1_ig_14_leadinout" , anim = "leadin_loop" , andar = false , loop = true },

	["estatua"] = { dict = "amb@world_human_statue@base", anim = "base", andar = false, loop = true },
	["flexao"] = { dict = "amb@world_human_push_ups@male@base", anim = "base", andar = false, loop = true },
	["fumar"] = { anim = "WORLD_HUMAN_SMOKING" },
	["fumar2"] = { anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS" },
	["fumar3"] = { anim = "WORLD_HUMAN_AA_SMOKE" },
	["fumar4"] = { anim = "WORLD_HUMAN_SMOKING_POT" },
	["fumar5"] = { dict = "amb@world_human_aa_smoke@male@idle_a", anim = "idle_c", prop = "prop_cs_ciggy_01", flag = 49, mao = 28422 },
	["fumar6"] = { dict = "amb@world_human_aa_smoke@male@idle_a", anim = "idle_b", prop = "prop_cs_ciggy_01", flag = 49, mao = 28422 },
	["fumar7"] = { dict = "amb@world_human_smoking@female@idle_a", anim = "idle_b", prop = "prop_cs_ciggy_01", flag = 49, mao = 28422 },
	["malhar"] = { dict = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base", prop = "prop_curl_bar_01", flag = 49, mao = 28422 },
	["malhar2"] = { dict = "amb@prop_human_muscle_chin_ups@male@base", anim = "base", andar = false, loop = true },
	["martelo"] = { dict = "amb@world_human_hammering@male@base", anim = "base", prop = "prop_tool_hammer", flag = 49, mao = 28422 },
	["pescar"] = { dict = "amb@world_human_stand_fishing@base", anim = "base", prop = "prop_fishing_rod_01", flag = 49, mao = 60309 },
	["pescar2"] = { dict = "amb@world_human_stand_fishing@idle_a", anim = "idle_c", prop = "prop_fishing_rod_01", flag = 49, mao = 60309 },
	["plantar"] = { dict = "amb@world_human_gardener_plant@female@base", anim = "base_female", andar = false, loop = true },
	["plantar2"] = { dict = "amb@world_human_gardener_plant@female@idle_a", anim = "idle_a_female", andar = false, loop = true },
	["procurar"] = { dict = "amb@world_human_bum_wash@male@high@base", anim = "base", andar = false, loop = true },
	["soprador"] = { dict = "amb@code_human_wander_gardener_leaf_blower@base", anim = "static", prop = "prop_leaf_blower_01", flag = 49, mao = 28422 },
	["soprador2"] = { dict = "amb@code_human_wander_gardener_leaf_blower@idle_a", anim = "idle_a", prop = "prop_leaf_blower_01", flag = 49, mao = 28422 },
	["soprador3"] = { dict = "amb@code_human_wander_gardener_leaf_blower@idle_a", anim = "idle_b", prop = "prop_leaf_blower_01", flag = 49, mao = 28422 },
	["trotar"] = { dict = "amb@world_human_jog_standing@male@fitidle_a", anim = "idle_a", andar = false, loop = true },
	["esquentar"] = { anim = "WORLD_HUMAN_STAND_FIRE" },
	["tablet"] = { dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base", anim = "base", prop = "prop_cs_tablet", flag = 50, mao = 28422 },
	["selfie"] = { dict = "cellphone@self", anim = "selfie_in_from_text", prop = "prop_npc_phone_02", flag = 50, mao = 28422 },
	["selfie2"] = { dict = "cellphone@", anim = "cellphone_text_read_base_cover_low", prop = "prop_npc_phone_02", flag = 50, mao = 28422 },
	["mecanico"] = { dict = "amb@world_human_vehicle_mechanic@male@idle_a", anim = "idle_a", andar = false, loop = true },
	["mecanico2"] = { dict = "mini@repair", anim = "fixing_a_player", andar = false, loop = true },
	["mecanico3"] = { dict = "mini@repair", anim = "fixing_a_ped", andar = false, loop = true },
	["mecanico4"] = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", andar = false, loop = true },
	["mecanico5"] = { dict = "amb@prop_human_movie_bulb@base", anim = "base", andar = true, loop = true },
	["mecanico6"] = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", andar = true, loop = true, cars = true },
	["xiu"] = { dict = "anim@mp_player_intincarshushbodhi@ds@", anim = "idle_a_fp", andar = true, loop = true },
	["tapa"] = { dict = "melee@unarmed@streamed_variations", anim = "plyr_takedown_front_slap", andar = false, loop = false },
	["pano2"] = { dict = "timetable@floyd@clean_kitchen@base", anim = "base", prop = "prop_rag_01", flag = 49, mao = 28422, extra = function()
		local vehicle = vRP.nearVehicle(7)
		if vehicle then
			TriggerEvent("Progress",10000)
			SetTimeout(10000,function()
				SetVehicleDirtLevel(vehicle,0.0)
				vRP.removeObjects("one")
			end)
		end
	end },
	["pano"] = { dict = "timetable@maid@cleaning_window@base", anim = "base", prop = "prop_rag_01", flag = 49, mao = 28422, extra = function()
		local vehicle = vRP.nearVehicle(7)
		if vehicle then
			TriggerEvent("Progress",10000)
			SetTimeout(10000,function()
				SetVehicleDirtLevel(vehicle,0.0)
				vRP.removeObjects("one")
			end)
		end
	end },
	["checkinskyz"] = { dict = "anim@gangops@morgue@table@", anim = "body_search", andar = false, loop = true, extra = function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(beds) do
			local object = GetClosestObjectOfType(coords["x"],coords["y"],coords["z"],0.9,v[1],0,0,0)
			if DoesEntityExist(object) then
				local heading = GetEntityHeading(object)
				local objCoords = GetEntityCoords(ped)
				local health = GetEntityHealth(ped)
				local armour = GetPedArmour(ped)

				NetworkResurrectLocalPlayer(objCoords["x"],objCoords["y"],objCoords["z"] + v[2],heading,true,false)
				SetEntityHealth(ped,health)
				SetPedArmour(ped,armour)

				TriggerEvent("resetBleeding")
				TriggerEvent("resetDiagnostic")
				TriggerEvent("cancelando",true)

				SetEntityCoords(ped,objCoords["x"],objCoords["y"],objCoords["z"] + v[2],1,0,0,0)
				SetEntityHeading(ped,heading + v[3] - 180.0)
				tratamento = true
				break
			end
		end
	end },

	["cruzar"] = { dict = "amb@world_human_cop_idles@female@idle_b" , anim = "idle_e" , andar = true , loop = true },
	["cruzar2"] = { dict = "anim@amb@casino@hangout@ped_male@stand@02b@idles" , anim = "idle_a" , andar = true , loop = true },
	["cruzar3"] = { dict = "amb@world_human_hang_out_street@male_c@idle_a" , anim = "idle_b" , andar = true , loop = true },
	["cruzar4"] = { dict = "random@street_race" , anim = "_car_b_lookout" , andar = true , loop = true },
	["cruzar5"] = { dict = "random@shop_gunstore" , anim = "_idle" , andar = true , loop = true },
	["cruzar6"] = { dict = "move_m@hiking" , anim = "idle" , andar = true , loop = true },
	["cruzar7"] = { dict = "anim@amb@casino@valet_scenario@pose_d@" , anim = "base_a_m_y_vinewood_01" , andar = true , loop = true },
	["cruzar8"] = { dict = "anim@amb@casino@shop@ped_female@01a@base" , anim = "base" , andar = true , loop = true },
	["cruzar9"] = { dict = "anim@amb@casino@valet_scenario@pose_c@" , anim = "shuffle_feet_a_m_y_vinewood_01" , andar = true , loop = true },
	["cruzar10"] = { dict = "anim@amb@casino@hangout@ped_male@stand@03a@idles_convo" , anim = "idle_a" , andar = true , loop = true },

	["cintura5"] = { dict = "random@shop_tattoo", anim = "_idle_a", andar = true, loop = true },
	["cintura"] = { dict = "rcmnigel1cnmt_1c", anim = "base", andar = true, loop = true },
	["cintura2"] = { dict = "rcmjosh1", anim = "idle", andar = true, loop = true },
	["cintura3"] = { dict = "timetable@amanda@ig_3", anim = "ig_3_base_tracy", andar = true, loop = true },
	["cintura4"] = { dict = "misshair_shop@hair_dressers", anim = "keeper_base", andar = true, loop = true },
	["estalar"] = { dict = "anim@mp_player_intcelebrationfemale@knuckle_crunch", anim = "knuckle_crunch", andar = true, loop = false },
	["encostar3"] = { dict = "misscarstealfinalecar_5_ig_1", anim = "waitloop_lamar", andar = true, loop = true },
	["nao2"] = { dict = "anim@heists@ornate_bank@chat_manager", anim = "fail", andar = true, loop = false },
	["ok"] = { dict = "anim@mp_player_intselfiedock", anim = "idle_a", andar = true, loop = false },
	["banana"] = { dict = "misscommon@response", anim = "screw_you", andar = true, loop = false },
	["pensar"] = { dict = "misscarsteal4@aliens", anim = "rehearsal_base_idle_director", andar = true, loop = true },
	["pensar2"] = { dict = "missheist_jewelleadinout", anim = "jh_int_outro_loop_a", andar = true, loop = true },
	["pensar3"] = { dict = "timetable@tracy@ig_8@base", anim = "base", andar = true, loop = true },
	["acenar"] = { dict = "random@mugging5", anim = "001445_01_gangintimidation_1_female_idle_b", andar = true, loop = true },
	["acenar2"] = { dict = "friends@fra@ig_1", anim = "over_here_idle_a", andar = true, loop = true },
	["acenar3"] = { dict = "friends@frj@ig_1", anim = "wave_e", andar = true, loop = true },
	["gang"] = { dict = "mp_player_int_uppergang_sign_a", anim = "mp_player_int_gang_sign_a", andar = true, loop = true },
	["gang2"] = { dict = "mp_player_int_uppergang_sign_b", anim = "mp_player_int_gang_sign_b", andar = true, loop = true },
	
	["dedo"] = { dict = "anim@mp_player_intcelebrationfemale@finger" , anim = "finger" , andar = true , loop = false },
	["dedo2"] = { dict = "anim@arena@celeb@podium@no_prop@" , anim = "flip_off_a_1st" , andar = false , loop = false },
	["dedo3"] = { dict = "anim@arena@celeb@podium@no_prop@" , anim = "flip_off_c_1st" , andar = true , loop = false },

	["reverencia"] = { dict = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_1st", andar = true, loop = false },
	["cabecada"] = { dict = "melee@unarmed@streamed_variations", anim = "plyr_takedown_front_headbutt", andar = true, loop = false },
	["naruto"] = { dict = "missfbi1", anim = "ledge_loop", andar = true, loop = true },
	["naruto2"] = { dict = "missfam5_yoga" , anim = "a2_pose" , andar = true , loop = true },
	["rebolar"] = { dict = "switch@trevor@mocks_lapdance" , anim = "001443_01_trvs_28_idle_stripper" , andar = false , loop = true },
	["tossir"] = { dict = "timetable@gardener@smoking_joint", anim = "idle_cough", andar = true, loop = true },
	["controlemental"] = { dict = "rcmbarry", anim = "bar_1_attack_idle_aln", andar = true, loop = true },
	["palhaco"] = { dict = "rcm_barry2", anim = "clown_idle_0", andar = false, loop = true },
	["palhaco2"] = { dict = "rcm_barry2", anim = "clown_idle_1", andar = false, loop = true },
	["palhaco3"] = { dict = "rcm_barry2", anim = "clown_idle_3", andar = false, loop = true },
	["meditar2"] = { dict = "timetable@amanda@ig_4", anim = "ig_4_base", andar = false, loop = true },
	["punheta"] = { dict = "anim@mp_player_intselfiewank", anim = "enter" , andar = true , loop = false },
	
	["karate"] = { dict = "anim@mp_player_intcelebrationfemale@karate_chops" , anim = "karate_chops" , andar = false , loop = false },
	["karate2"] = { dict = "anim@mp_player_intcelebrationmale@karate_chops" , anim = "karate_chops" , andar = false , loop = false },
	["boxe"] = { dict = "anim@mp_player_intcelebrationmale@shadow_boxing" , anim = "shadow_boxing" , andar = false , loop = false },
	["boxe2"] = { dict = "anim@mp_player_intcelebrationfemale@shadow_boxing" , anim = "shadow_boxing" , andar = false , loop = false },
	["boxe3"] = { dict = "rcmextreme2", anim = "loop_punching", andar = true, loop = true },

	["w"] = { dict = "penguin@custom@v2", anim = "penguin_sorry1", andar = false, loop = true },
	["w2"] = { dict = "penguin@custom@v2", anim = "penguin_duo1_m", andar = false, loop = true },
    ["w3"] = { dict = "penguin@custom@v2", anim = "penguin_duo1_f", andar = false, loop = true },
    ["w4"] = { dict = "penguin@custom@v2", anim = "penguin_pose_couple_m_v2", andar = false, loop = true },
    ["w5"] = { dict = "penguin@custom@v2", anim = "penguin_pose_couple_f_v2", andar = false, loop = true },
    ["w6"] = { dict = "penguin@custom@v2", anim = "penguin_japanom", andar = false, loop = true },
    ["w7"] = { dict = "penguin@custom@v2", anim = "penguin_pose1_v2", andar = false, loop = true },
    ["w8"] = { dict = "penguin@custom@v2", anim = "penguin_pose2_v2", andar = false, loop = true },
    ["w9"] = { dict = "penguin@custom@v2", anim = "penguin_pose3_v2", andar = false, loop = true },
    ["w10"] = { dict = "penguin@custom@v2", anim = "penguin_pose4_v2", andar = false, loop = true },
    ["w11"] = { dict = "penguin@custom@v2", anim = "penguin_pose5_v2", andar = false, loop = true },
    ["w12"] = { dict = "penguin@custom@v2", anim = "penguin_pose6_v2", andar = false, loop = true },
    ["w13"] = { dict = "penguin@custom@v2", anim = "penguin_pose7_v2", andar = false, loop = true },
    ["w14"] = { dict = "penguin@custom@v2", anim = "penguin_pose8_v2", andar = false, loop = true },
    ["w15"] = { dict = "penguin@custom@v2", anim = "penguin_pose9_v2", andar = false, loop = true },
    ["w16"] = { dict = "penguin@custom@v2", anim = "penguin_pose10_v2", andar = false, loop = true },
    ["w17"] = { dict = "penguin@custom@v2", anim = "penguin_pose11_v2", andar = false, loop = true },
    ["w18"] = { dict = "penguin@custom@v2", anim = "penguin_pose12_v2", andar = false, loop = true },
	["w19"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose1", andar = false, loop = true },
    ["w20"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose2", andar = false, loop = true },
    ["w21"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose3", andar = false, loop = true },
    ["w22"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose4", andar = false, loop = true },
    ["w23"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose5", andar = false, loop = true },
    ["w24"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose6", andar = false, loop = true },
    ["w25"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose7", andar = false, loop = true },
    ["w26"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose8", prop = "prop_cs_ciggy_01", flag = 49, mao = 28422, altura = 0.09, pos1 = 0.2, pos2 = 0.0, pos3 = 5.0, pos4 = 109.0, pos5 = 10.0 },
    ["w27"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose9", prop = "prop_cs_ciggy_01", flag = 49, mao = 28422, altura = 0.09, pos1 = 0.2, pos2 = 0.0, pos3 = 5.0, pos4 = 109.0, pos5 = 10.0 },
    ["w28"] = { dict = "penguin_mppos@pose_model", anim = "penguin_mppos_pose10", prop = "prop_phone_ing_03", flag = 49, mao = 28422, altura = 0.07, pos1 = 0.03, pos2 = -0.02, pos3 = -127.0, pos4 = -133.0, pos5 = 2.0 },
	["w29"] = { dict = "penguin@custom@v1", anim = "penguinhead", andar = false, loop = true },
    ["w30"] = { dict = "penguin@custom@v1", anim = "penguinlove", andar = false, loop = true },
    ["w31"] = { dict = "penguin@custom@v1", anim = "penguin_standpickpocket", andar = false, loop = true },
    ["w32"] = { dict = "penguin@custom@v1", anim = "penguin_2_fingers_up", andar = false, loop = true },
    ["w33"] = { dict = "penguin@custom@v1", anim = "penguin_pok_cheek", andar = false, loop = true },
    ["w34"] = { dict = "penguin@custom@v1", anim = "penguin_hold_the_cheek", andar = false, loop = true },
    ["w35"] = { dict = "penguin@custom@v1", anim = "penguin_pose", andar = false, loop = true },
    ["w36"] = { dict = "penguin@custom@v1", anim = "penguin_pose2", andar = false, loop = true },
    ["w37"] = { dict = "penguin@custom@v1", anim = "penguin_pose3", andar = false, loop = true },
    ["w38"] = { dict = "penguin@custom@v1", anim = "penguin_pose4", andar = false, loop = true },
    ["w39"] = { dict = "penguin@custom@v1", anim = "penguin_pose5", andar = false, loop = true },
    ["w40"] = { dict = "penguin@custom@v1", anim = "penguin_pose6", andar = false, loop = true },
    ["w41"] = { dict = "penguin@custom@v1", anim = "penguin_pose7", andar = false, loop = true },
    ["w42"] = { dict = "penguin@custom@v1", anim = "penguin_pose8", andar = false, loop = true },
    ["w43"] = { dict = "penguin@custom@v1", anim = "penguin_pose9", andar = false, loop = true },
    ["w44"] = { dict = "penguin@custom@v1", anim = "penguin_pose10", andar = false, loop = true },
    ["w45"] = { dict = "penguin@custom@v1", anim = "penguin_dab", andar = false, loop = true },
	["w46"] = { dict = "anim@mp_player_intcelebrationmale@bang_bang" , anim = "bang_bang" , andar = true , loop = false },
    ["w47"] = { dict = "anim@mp_player_intcelebrationmale@air_drums" , anim = "air_drums" , andar = true , loop = false },
    ["w48"] = { dict = "anim@mp_player_intcelebrationmale@call_me" , anim = "call_me" , andar = true , loop = false },
    ["w49"] = { dict = "anim@mp_player_intcelebrationmale@coin_roll_and_toss" , anim = "coin_roll_and_toss" , andar = true , loop = false },
    ["w50"] = { dict = "anim@mp_player_intcelebrationmale@mind_blown" , anim = "mind_blown" , andar = true , loop = false },
    ["w51"] = { dict = "anim@mp_player_intcelebrationmale@respect" , anim = "respect" , andar = true , loop = false },
    ["w52"] = { dict = "anim@amb@casino@hangout@ped_male@stand@01a@base" , anim = "base" , andar = true , loop = true },
    ["w53"] = { dict = "anim@amb@casino@hangout@ped_male@stand@01b@enter" , anim = "enter" , andar = true , loop = false },
    ["w54"] = { dict = "anim@amb@casino@hangout@ped_male@stand@01b@exit" , anim = "exit" , andar = true , loop = false },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("emotes")
AddEventHandler("emotes",function(nome)
	if (not exports["player"]:blockCommands() and not exports["player"]:handCuff()) or nome == "checkinskyz" then
		local ped = PlayerPedId()

		if animacoes[nome] and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
			if (GetEntityHealth(ped) > 101 or nome == "checkinskyz") and vSERVER.checkInventory() then
				vRP.removeObjects("one")

				if not IsPedInAnyVehicle(ped) and not animacoes[nome]["cars"] then
					if animacoes[nome]["extra"] then
						animacoes[nome].extra()
					end

					if animacoes[nome]["altura"] and animacoes[nome]["anim"] == nil then
						vRP.createObjects("","",animacoes[nome]["prop"],animacoes[nome]["flag"],animacoes[nome]["mao"],animacoes[nome]["altura"],animacoes[nome]["pos1"],animacoes[nome]["pos2"],animacoes[nome]["pos3"],animacoes[nome]["pos4"],animacoes[nome]["pos5"])
					elseif animacoes[nome]["altura"] and animacoes[nome]["anim"] then
						vRP.createObjects(animacoes[nome]["dict"],animacoes[nome]["anim"],animacoes[nome]["prop"],animacoes[nome]["flag"],animacoes[nome]["mao"],animacoes[nome]["altura"],animacoes[nome]["pos1"],animacoes[nome]["pos2"],animacoes[nome]["pos3"],animacoes[nome]["pos4"],animacoes[nome]["pos5"])
					elseif animacoes[nome]["prop"] then
						vRP.createObjects(animacoes[nome]["dict"],animacoes[nome]["anim"],animacoes[nome]["prop"],animacoes[nome]["flag"],animacoes[nome]["mao"])
					elseif animacoes[nome]["dict"] then
						vRP.playAnim(animacoes[nome]["andar"],{animacoes[nome]["dict"],animacoes[nome]["anim"]},animacoes[nome]["loop"])
					else
						vRP.playAnim(false,{ task = animacoes[nome]["anim"] },false)
					end
				else
					if IsPedInAnyVehicle(ped) and animacoes[nome]["cars"] then
						local vehicle = GetVehiclePedIsUsing(ped)

						if (GetPedInVehicleSeat(vehicle,-1) == ped or GetPedInVehicleSeat(vehicle,1) == ped) and nome == "sexo4" then
							vRP.playAnim(animacoes[nome]["andar"],{animacoes[nome]["dict"],animacoes[nome]["anim"]},animacoes[nome]["loop"])
						elseif (GetPedInVehicleSeat(vehicle,0) == ped or GetPedInVehicleSeat(vehicle,2) == ped) and (nome == "sexo5" or nome == "sexo6") then
							vRP.playAnim(animacoes[nome]["andar"],{animacoes[nome]["dict"],animacoes[nome]["anim"]},animacoes[nome]["loop"])
						elseif nome == "hotwired" then
							vRP.playAnim(animacoes[nome]["andar"],{animacoes[nome]["dict"],animacoes[nome]["anim"]},animacoes[nome]["loop"])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if (binoculos or cameras) then
			timeDistance = 1

			local ped = PlayerPedId()
			local scaleform = RequestScaleformMovie("BINOCULARS")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(1)
			end

			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
			AttachCamToEntity(cam,ped,0.0,0.0,1.0,true)
			SetCamRot(cam,0.0,0.0,GetEntityHeading(ped))
			SetCamFov(cam,fov)
			RenderScriptCams(true,false,0,1,0)

			while (binoculos or cameras) and true do
				Citizen.Wait(1)

				local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
				CheckInputRotation(cam,zoomvalue)
				HandleZoom(cam)

				if binoculos then
					DrawScaleformMovieFullscreen(scaleform,255,255,255,255)
				end

				if IsPedArmed(PlayerPedId(),6) then
					TriggerServerEvent("inventory:Cancel")
					binoculos = false
					cameras = false
				end
			end

			fov = (fov_max + fov_min) * 0.5
			RenderScriptCams(false,false,0,1,0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam,false)
			SetNightvision(false)
			SetSeethrough(false)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEBINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("useBinoculos")
AddEventHandler("useBinoculos",function()
	binoculos = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEBINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("useCamera")
AddEventHandler("useCamera",function()
	cameras = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("binoculos")
AddEventHandler("binoculos",function()
	if IsEntityPlayingAnim(PlayerPedId(),"amb@world_human_binoculars@male@enter","enter",3) then
		binoculos = true
	else
		binoculos = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("camera")
AddEventHandler("camera",function()
	if IsEntityPlayingAnim(PlayerPedId(),"amb@world_human_paparazzi@male@base","base",3) then
		cameras = true
	else
		cameras = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINPUTROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckInputRotation(cam,zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * 8.0 * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0,rotation["x"] + rightAxisY * -1.0 * 8.0 * (zoomvalue + 0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEZOOM
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleZoom(cam)
	if IsControlJustPressed(1,241) then
		fov = math.max(fov - 10.0,fov_min)
	end

	if IsControlJustPressed(1,242) then
		fov = math.min(fov + 10.0,fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then
		fov = current_fov
	end

	SetCamFov(cam,current_fov + (fov - current_fov) * 0.05)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTRATAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local treatmentTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= treatmentTimers then
			treatmentTimers = GetGameTimer() + 2000

			if tratamento then
				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)

				if health < 200 then
					SetEntityHealth(ped,health + 1)
				else
					tratamento = false
					ClearPedBloodDamage(ped)
					TriggerEvent("cancelando",false)
					TriggerEvent("player:blockCommands",false)
					TriggerEvent("Notify","sucesso","Tratamento concluido.",3000)
				end
			end
		end

		Citizen.Wait(1000)
	end
end)