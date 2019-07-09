--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 02-02-2019
-- Time: 19:14
-- Made for CiviliansNetwork
--

local cfg = {}

cfg.doors = {
    -- Centrum PD
    [1] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 1557126584, coords={450.27975463867,-986.43347167969,30.689682006836}},
    [2] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 749848321,coords={453.09655761719,-982.54162597656,30.689683914185}},
    [3] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Ledelses Kontor", hash=-1320876379, coords={447.2998046875,-980.09771728516,30.68967628479}},
    [4] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash=185711165, coords={444.06491088867,-989.43817138672,30.689668655396}, pairs = 5},
    [5] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash=185711165, coords={445.28582763672,-989.43853759766,30.689668655396}, pairs = 4},
    [6] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-340230128,coords={464.33865356445,-984.03485107422,43.69785690307}},
    -- Centrum PD Ekstra rum
    [7] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash=-131296141, coords={465.62509155273,-989.38299560547,24.915143966675}, pairs = 8},
    [8] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash=-131296141, coords={465.67004394531,-990.69390869141,24.914762496948}, pairs = 7, close = 9},
    -- Celler
    [9] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=631614199,coords={463.52172851563,-992.72259521484,24.914764404297}, close = 10},
    [10] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=631614199,coords={461.74038696289,-993.36505126953,24.914741516113}, close = 9},

    [11] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-131296141,coords={443.00955200195,-992.56573486328,30.689678192139}, pairs = 12},
    [12] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-131296141,coords={442.91644287109,-994.00378417969,30.689680099487}, pairs = 11},
    -- Centrum PD fordøre
    [13] = {locked = false, key = "key_lspd", permission="police.pc", name = "Politistation",hash=320433149,coords={434.77639770508,-982.43109130859,30.709680557251}, pairs = 14},
    [14] = {locked = false, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1215222675,coords={434.7995300293,-981.20196533203,30.689680099487}, pairs = 13},

    [15] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-131296141,coords={467.98858642578,-992.63336181641,24.914764404297}},
    [16] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-131296141,coords={470.45223999023,-994.37847900391,24.914749145508}},
    [17] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-131296141,coords={470.13507080078,-987.19909667969,24.914764404297}},
    [18] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-131296141,coords={477.74633789063,-987.29876708984,24.914762496948}},

    [19] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=631614199,coords={461.91241455078,-998.66625976563,24.914739608765}},
    [20] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=631614199,coords={461.69604492188,-1002.3547363281,24.914739608765}},

    [20] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1033001619,coords={464.19165039063,-1003.5250244141,24.914739608765}},

    [21] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={467.9358215332,-1014.4254150391,26.386516571045}, pairs = 22},
    [22] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={469.21606445313,-1014.3658447266,26.386516571045}, pairs = 21},

    -- Hospital
    [23] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=1653893025,coords={333.23461914063,-588.10583496094,28.791460037231}},
    [24] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=1653893025,coords={337.45065307617,-583.46667480469,28.79146194458}},

    [25] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-1920147247,coords={319.21368408203,-560.8642578125,28.776344299316}, pairs = 26},
    [26] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-1920147247,coords={320.57766723633,-560.04522705078,28.743457794189}, pairs = 25},

    [27] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=580361003,coords={255.83605957031,-1347.6665039063,24.537809371948}, pairs = 28},
    [28] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=1415151278,coords={256.8034362793,-1348.4171142578,24.537809371948}, pairs = 27},

    [29] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=580361003,coords={266.18991088867,-1345.4222412109,24.537809371948}, pairs = 30},
    [30] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=1415151278,coords={266.95770263672,-1344.4282226563,24.537809371948}, pairs = 29},

    [31] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=580361003,coords={282.36529541016,-1342.3530273438,24.537809371948}, pairs = 32},
    [32] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=1415151278,coords={283.21685791016,-1341.3330078125,24.537788391113}, pairs = 31},

    [33] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=580361003,coords={286.8014831543,-1344.5416259766,24.537784576416}, pairs = 34},
    [34] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=1415151278,coords={285.94778442383,-1345.5451660156,24.537784576416}, pairs = 33},

    [35] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={252.44418334961,-1366.3106689453,24.537799835205}, pairs = 36},
    [36] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={251.56242370605,-1365.6491699219,24.537799835205}, pairs = 35},

    -- Slagter
    [37] = {locked = true, key = "key_hvidvask", permission="slagter.key", name = "Slagter",hash=1755793225,coords={961.97338867188,-2184.6706542969,30.521013259888}},
    [38] = {locked = true, key = "key_hvidvask", permission="slagter.key", name = "Slagter",hash=-1468417022,coords={962.82513427734,-2105.7329101563,31.49340057373}},

    -- Sandy PD
    [39] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-952356348,coords={1856.9645996094,3711.8986816406,1.0403988361359}},

    [40] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1259801187,coords={1850.5528564453,3710.4116210938,1.0600010156631}, pairs = 41},
    [41] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1563799200,coords={1849.8255615234,3711.3449707031,1.0600010156631}, pairs = 40},

    [42] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={1848.6394042969,3707.5979003906,1.0600003004074}},
    [43] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={1844.8991699219,3704.4294433594,1.0600125789642}},
    [44] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={1846.71484375,3710.1440429688,1.0600000619888}},
    [45] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={1842.8623046875,3707.0393066406,1.0600003004074}},

    [46] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1720238398,coords={1842.2221679688,3704.6821289063,1.0600001811981}},
    [47] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1765048490,coords={1855.0665283203,3683.5229492188,34.266490936279}},

    -- Retssal
    [48] = {locked = true, key = "key_court", permission="court.doors", name = "Retssal",hash=110411286,coords={238.95112609863,-420.45617675781,-118.46504974365}},
    [49] = {locked = true, key = "key_court", permission="court.doors", name = "Retssal",hash=110411286,coords={238.51235961914,-421.61920166016,-118.46504974365}},

    -- Stripklub
    [50] = {locked = true, key = "key_stripklub", permission="stripklubben.doors", name = "Stripklubben",hash=668467214,coords={95.586074829102,-1285.341796875,29.279767990112}},
    [51] = {locked = true, key = "key_stripklub", permission="stripklubben.doors", name = "Stripklubben",hash=-626684119,coords={99.600341796875,-1293.2969970703,29.26876449585}},
    [52] = {locked = true, key = "key_stripklub", permission="stripklubben.doors", name = "Stripklubben",hash=-1116041313,coords={128.51901245117,-1298.2335205078,29.269437789917}},

    -- Sons of anal
    [53] = {locked = true, key = "key_soa", permission="soa.doors", name = "SonsOfAnarchy",hash=190770132,coords={981.60498046875,-102.7546081543,74.845146179199}},
    [54] = {locked = true, key = "key_soa", permission="soa.doors", name = "SonsOfAnarchy",hash=-2125423493,coords={959.97784423828,-140.08976745605,74.486106872559}, range = 5.0},

    -- Civilians Auto
    [55] = {locked = true, key = "key_ca", permission="ca.doors", name = "CiviliansAuto",hash=-427498890,coords={-205.6089630127,-1310.5987548828,31.295957565308},range = 8.0},

    [56] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=631614199,coords={461.87744140625,-1002.3448486328,24.914758682251}},
    [57] = {locked = true, key = "key_yacht", permission="yacht.key", name = "Yacht",hash=330294775,coords={-2081.6567382813,-1024.7894287109,5.8841233253479}},
    [58] = {locked = true, key = "key_yacht", permission="yacht.key", name = "Yacht",hash=330294775,coords={-2071.1906738281,-1016.8517456055,5.8841271400452}},

    -- Ejendomsmægler
    [59] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=220394186,coords={-140.21783447266,-626.10949707031,168.82043457031}, pairs = 60},
    [60] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=220394186,coords={-139.44232788086,-626.13616943359,168.82040405273}, pairs = 59},

    [61] = {locked = true, key = "key_advokat", permission="advokat.duty", name = "Advokat",hash=-1821777087,coords={138.72561645508,-768.16802978516,242.1522064209}},
    [62] = {locked = true, key = "key_advokat", permission="advokat.duty", name = "Advokat",hash=-1821777087,coords={127.40701293945,-764.02618408203,242.15190124512}},
    [63] = {locked = true, key = "key_advokat", permission="advokat.duty", name = "Advokat",hash=-853859998,coords={133.0364074707,-767.99884033203,242.15209960938}},

    -- Lifeinvader
    [64] = {locked = false, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=969847031,coords={-1063.1645507813,-240.16094970703,44.021224975586}},
    [65] = {locked = false, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=969847031,coords={-1057.1466064453,-237.08456420898,44.0212059021}},
    [66] = {locked = false, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=-1821777087,coords={-1048.0180664063,-237.37478637695,44.021160125732}, pairs = 67},
    [67] = {locked = false, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=-1821777087,coords={-1047.4484863281,-238.62573242188,44.021152496338}, pairs = 66},
    -- Fordør
    [68] = {locked = true, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=-1679881977,coords={-1083.0604248047,-260.00723266602,37.787815093994}, pairs = 69},
    [69] = {locked = true, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=-1045015371,coords={-1081.5733642578,-259.30850219727,37.784679412842}, pairs = 68},
    -- Bagdør
    [70] = {locked = true, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=1104171198,coords={-1045.5418701172,-231.27163696289,39.014629364014}, pairs = 71},
    [71] = {locked = true, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=-1425071302,coords={-1046.1961669922,-229.98994445801,39.014659881592}, pairs = 70},
    -- Kælder
    [72] = {locked = true, key = "key_lifeinvader", permission="lifeinvader.key", name = "Lifeinvader",hash=-340230128,coords={-1041.9709472656,-240.35179138184,37.964912414551}},

    -- Politistation Vinewood
    [72] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={621.55993652344,-0.35749739408493,43.964069366455}},
    [73] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={620.34637451172,-3.3018908500671,43.964065551758}},
    [74] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={619.26550292969,-6.1055717468262,43.964431762695}},
    [75] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-642608865,coords={618.17791748047,-8.9684419631958,43.966220855713}},
    --Afhøring Vinewoord Politistation
    [76] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1537395557,coords={610.37384033203,-4.9899325370789,43.964462280273}},
    [77] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1537395557,coords={612.31683349609,0.50248163938522,43.964172363281}},
    --Politistation Vinewood
    [78] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1885457048,coords={617.86431884766,10.699716567993,43.963760375977}, pairs = 79},
    [79] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1885457048,coords={618.67822265625,10.40576171875,43.963733673096}, pairs = 78},
    [80] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1537395557,coords={627.24981689453,6.9189519882202,44.394058227539}},
    [81] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-129553421,coords={633.07360839844,-1.668866276741,44.394912719727}},

    [82] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1283267431,coords={636.19696044922,0.70272958278656,44.394947052002}, pairs = 83},
    [83] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-913076967,coords={635.93609619141,-0.26612675189972,44.419925689697}, pairs = 82},

    --key_kartel huset
    [84] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=-1032171637,coords={1390.5715332031,1131.7316894531,114.33407592773}, pairs = 85},
    [85] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=-52575179,coords={1390.5875244141,1132.6441650391,114.33406829834}, pairs = 84},

    [86] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=-1032171637,coords={1399.9057617188,1128.2419433594,114.33451843262}, pairs = 87},
    [87] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=-52575179,coords={1401.1546630859,1128.2502441406,114.33450317383}, pairs = 86},

    -- Kartellet Fordøre
    [88] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=262671971,coords={1395.7215576172,1141.2496337891,114.64886474609}, pairs = 89},
    [89] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=1504256620,coords={1395.7955322266,1142.2257080078,114.6512298584}, pairs = 88},
--Kartellet
    -- SOA Coke salg
    [90] = {locked = true, key = "key_camorra_salg", permission="camorra.doors", name = "Camorra",hash=-1230442770,coords={241.80499267578,360.41781616211,105.61915588379}},

    -- Bilforhandleren
    -- Indgang 1
    [91] = {locked = false, key = "key_bilforhandler_unused", permission="bilforhandler.doors.unused", name = "Bilforhandler",hash=2059227086,coords={-38.636848449707,-1108.3608398438,26.468864440918}, pairs = 92},
    [92] = {locked = false, key = "key_bilforhandler_unused", permission="bilforhandler.doors.unused", name = "Bilforhandler",hash=1417577297,coords={-37.818347930908,-1108.7191162109,26.468883514404}, pairs = 91},
    -- Kontor
    [93] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=-2051651622,coords={-34.122013092041,-1108.2292480469,26.422351837158}},
    [94] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=-2051651622,coords={-31.903076171875,-1102.4223632813,26.422357559204}},
     -- Indgang 2
    [95] = {locked = false, key = "key_bilforhandler_unused", permission="bilforhandler.doors.unused", name = "Bilforhandler",hash=2059227086,coords={-60.018104553223,-1093.4749755859,26.67373085022}, pairs = 96},
    [96] = {locked = false, key = "key_bilforhandler_unused", permission="bilforhandler.doors.unused", name = "Bilforhandler",hash=1417577297,coords={-60.425937652588,-1094.2043457031,26.673414230347}, pairs = 95},

    [97] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=1286535678,coords={-12.702404022217,-1088.6901855469,26.672050476074}, range = 10.0},


    -- Ejendomsmægler Boliger s
    [98] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=1939954886,coords={-131.4874420166,-637.57611083984,168.82037353516}, pairs = 99},
    [99] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=1939954886,coords={-133.8650970459,-631.32440185547,168.82046508789}, pairs = 98},

    -- Bolig 1
    [100] = {locked = true, key = "key_bolig1", permission="realestate.key", name = "Bolig",hash=-1918480350,coords={-825.41851806641,-32.705406188965,38.633014678955}},
    [101] = {locked = true, key = "key_bolig1", permission="realestate.key", name = "Bolig",hash=-349730013,coords={-826.47338867188,-30.352327346802,38.658115386963}},

    -- Ejendom 2
    [102] = {locked = false, key = "key_ejendom2", permission="realestate.key", name = "Bolig",hash=-1230442770,coords={111242.00746154785,360.81338500977,105.73811340332}},

    -- Bolig 7
    [103] = {locked = true, key = "key_bolig7", permission="realestate.key", name = "Bolig",hash=-1249591818,coords={-1800.9001464844,474.28771972656,133.68882751465}, pairs = 104},
    [104] = {locked = true, key = "key_bolig7", permission="realestate.key", name = "Bolig",hash=546378757,coords={-1799.7318115234,472.01876831055,133.69081115723}, pairs = 103},

    -- Grove st.
    [105] = {locked = true, key = "key_ltf3", permission="", name = "LTF",hash=-1436200562,coords={22.844955444336,-1897.0880126953,22.965364456177}}, -- Hus 1

    [106] = {locked = true, key = "key_grove", permission="", name = "GROVE",hash=1286535678,coords={-47.93770980835,-1828.5533447266,26.469179153442}, range = 10.0}, -- Gate
    [107] = {locked = true, key = "key_ejendom3", permission="", name = "Bolig",hash=1683288312,coords={-1589.4794921875,-3229.7475585938,26.335493087769}, pairs = 110},
    [108] = {locked = true, key = "key_ejendom3", permission="", name = "Bolig",hash=-99214212,coords={-1588.3715820313,-3230.46484375,26.331552505493}, pairs = 109},
    --[109] = {locked = true, key = "key_bolig13", permission="", name = "Bolig",hash=132154435,coords={1973.3223876953,3815.7580566406,33.510265350342}},
    [109] = {locked = true, key = "key_grove", permission="", name = "GROVE",hash=1436076651,coords={-0.26303127408028,-1823.9610595703,29.545501708984}}, -- Salgsted
    [110] = {locked = true, key = "key_grove", permission="", name = "GROVE",hash=1436076651,coords={86.198669433594,-1959.8801269531,21.121259689331}}, -- Klubhus
    [111] = {locked = true, key = "key_grove3", permission="", name = "GROVE",hash=-1436200562,coords={114.42317199707,-1961.4368896484,21.352180480957}}, -- Hus 3
    [112] = {locked = true, key = "key_grove2", permission="", name = "GROVE",hash=-1436200562,coords={46.391143798828,-1863.6202392578,23.280796051025}}, -- Hus 2
    [113] = {locked = true, key = "key_bolig6", permission="", name = "Bolig",hash=-1249591818,coords={-2557.2717285156,1914.5399169922,168.89500427246}, pairs = 117},
    [114] = {locked = true, key = "key_bolig6", permission="", name = "Bolig",hash=546378757,coords={-2558.548828125,1912.0297851563,168.86601257324}, pairs = 116},

    [115] = {locked = true, key = "key_bolig34", permission="", name = "Trailerpark",hash=668467214,coords={92.262031555176,3744.7619628906,40.704486846924}},
    [116] = {locked = true, key = "key_bolig34", permission="", name = "Trailerpark",hash=668467214,coords={94.243362426758,3750.4816894531,40.766716003418}},

    --Outlaw
     [117] = {locked = true, key = "key_outlaw", permission="", name = "Outlaw",hash=486670049,coords={-107.32997131348,-8.3928689956665,70.524604797363}},
     [118] = {locked = true, key = "key_outlaw", permission="", name = "Outlaw",hash=733542368,coords={-547.11871337891,304.48382568359,83.026016235352}},
     [119] = {locked = true, key = "key_outlaw", permission="", name = "Outlaw",hash=993120320,coords={-561.97485351563,293.63177490234,87.628341674805}},
     [120] = {locked = true, key = "key_outlaw", permission="", name = "Outlaw",hash=733542368,coords={-542.8671875,327.38961791992,83.030395507813}},
     [121] = {locked = true, key = "key_outlaw", permission="", name = "Outlaw",hash=-626684119,coords={-560.35723876953,292.21209716797,82.17618560791}},
	 [122] = {locked = true, key = "key_outlaw", permission="", name = "Outlaw",hash=993120320,coords={-564.39190673828,276.47872924805,83.135040283203}},

    -- Kartellet
    [123] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=-26664553,coords={2332.2573242188,2575.5356445313,46.681259155273}, pairs = 124},
    [124] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=914592203,coords={2330.6984863281,2576.2448730469,46.678100585938}, pairs = 123},
    [132] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=3552507031,coords={1317.7819824219,1188.7006835938,106.90690612793   }, pairs = 133},
    [133] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=1107349801,coords={1317.8514404297,1187.2886962891,106.85741424561}, pairs = 132},
    [134] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=3552507031,coords={1316.3784179688,1106.6414794922,105.85131072998}, pairs = 135},
    [135] = {locked = true, key = "key_kartel", permission="", name = "Kartellet",hash=1107349801,coords={1316.7541503906,1105.373046875,105.85801696777}, pairs = 134},

    -- Yellow Jack
    [125] = {locked = true, key = "key_yj", permission="", name = "YellowJack",hash=-287662406,coords={1990.5233154297,3053.4594726563,47.21533203125}},
    [126] = {locked = true, key = "key_yj", permission="", name = "YellowJack",hash=-768731720,coords={1978.0362548828,3037.6960449219,47.056339263916}},
    [127] = {locked = true, key = "key_yj", permission="", name = "YellowJack",hash=1817008884,coords={1984.5753173828,3059.8110351563,47.21085357666}},

    -- Politi Skydebane
    [128] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Skydebane", hash=3875290964, coords={-1184.5869140625,-1770.1104736328,3.9084672927856}},
    [129] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Skydebane", hash=3875290964, coords={-1215.7121582031,-1785.4688720703,3.9084675312042}},
    [130] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Skydebane", hash=3875290964, coords={-1182.1441650391,-1806.1534423828,3.9085311889648}},
    [131] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Skydebane", hash=3875290964, coords={-1175.2947998047,-1783.7905273438,3.908465385437}},

        -- PD Paleto
        [132] = {locked = true, key = "key_lspd", permission="police.pc", name = "Paleto PD", hash=2793810241, coords={-443.67907714844,6016.8061523438,31.712211608887}, pairs = 133},
        [133] = {locked = true, key = "key_lspd", permission="police.pc", name = "Paleto PD", hash=2793810241, coords={-442.93734741211,6016.236328125,31.712211608887}, pairs = 132},
        [134] = {locked = true, key = "key_lspd", permission="police.pc", name = "Paleto PD", hash=1286535678, coords={-454.3698425293,6029.6538085938,31.340547561646}, range = 10.0},

        -- Centrum PD bagport
        [137] = {locked = true, key = "key_lspd", permission="police.pc", name = "Centrum PD", hash=-1603817716, coords={488.91033935547,-1017.6137695313,28.212596893311}, range = 10.0},

        -- Fængsles Porte
        [135] = {locked = true, key = "key_lspd", permission="police.pc", name = "Fængsel", hash=741314661, coords={1845.0898,2609.6157,45.6005}, range = 10.0},
        [136] = {locked = true, key = "key_lspd", permission="police.pc", name = "Fængsel", hash=741314661, coords={1818.6126,2609.7465,45.6065}, range = 10.0},

        -- Bahmas Mamas
        [138] = {locked = true, key = "key_bahmas", permission="", name = "Bahmas Mamas", hash=4163671155, coords={-1389.25, -587.9828, 30.49132}, pairs = 139},
        [139] = {locked = true, key = "key_bahmas", permission="", name = "Bahmas Mamas", hash=4163671155, coords={-1387.077, -586.5358, 30.49563}, pairs = 138},
}
return cfg
