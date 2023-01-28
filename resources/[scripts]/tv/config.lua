Config = {}

Config['URL'] = 'https://www.youtube.com/embed/%s?autoplay=1&controls=1&disablekb=1&fs=0&rel=0&showinfo=0&iv_load_policy=3&start=%s'
Config['API'] = {
    ['URL'] = 'https://www.googleapis.com/youtube/v3/videos?id=%s&part=contentDetails&key=%s',
    ['Key'] = ''
}
Config['DurationCheck'] = false 

Config['Objects'] = {
    {
        ['Object'] =  "vw_prop_vw_cinema_tv_01",
        ['Scale'] = 0.08,
        ['Offset'] = vec3(-1.5, -0.1, 0.70),
        ['Distance'] = 20.5,
    },
    {
        ['Object'] = 'hei_heist_str_avunitl_03',
        ['Scale'] = 0.05,
        ['Offset'] = vec3(-1.0, -0.4, 1.95), 
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'v_ilev_cin_screen',
        ['Scale'] = 0.2,
        ['Offset'] = vec3(-3.5, 0.13, 1.90),
        ['Distance'] = 40.5,
    },
    
    {
        ['Object'] = 'prop_cs_tv_stand',
        ['Scale'] = 0.03,
        ['Offset'] = vec3(-0.57, -0.1, 1.60),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'v_ilev_mm_screen',
        ['Scale'] = 0.0485,
        ['Offset'] = vec3(-1.0, 0.10, -0.30),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_01',
        ['Scale'] = 0.05,
        ['Offset'] = vec3(-0.925, -0.055, 1.0),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'ex_prop_ex_tv_flat_01',
        ['Scale'] = 0.05,
        ['Offset'] = vec3(-0.925, -0.055, 1.0),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'apa_mp_h_str_avunitl_04',
        ['Scale'] = 0.05,
        ['Offset'] = vec3(-0.2, -0.45, 2.0),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_michael',
        ['Scale'] = 0.035,
        ['Offset'] = vec3(-0.675, -0.055, 0.4),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_trev_tv_01',
        ['Scale'] = 0.012,
        ['Offset'] = vec3(-0.225, -0.01, 0.26),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03b',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.062, 0.18),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.01, 0.4),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02b',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 7.5,
    },
}