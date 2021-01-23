--apk_version = 0.50.0
--gg_version = 101
--script_version = 0.0.1

--AUTHOR = Furasesa

-- local key.xor = 945804460 --Define your own
local def_XOR_KEY = 945804460
local def_key_addr = 506115623932

local debug = true
local resume_state = {['func']= 0, ['bookmark']=0}

local key = {['xor'] = def_XOR_KEY, ['address']=def_key_addr}
local item_address = {} -- t{[1]=t{}, [2]=t{}, etc}
item_address[8] = {}
-- local msg_prepare_1 = 'Catch Key Address from your item which is stackable'
local msg_prepare_1 = 'Set Item 8 to stackable item. and select how many it is.'
local msg_prepare_2 = 'Now change the value by increasing or decreasing in 5s'

local str_info

local item_type = ({'Tools', 'Equipment', 'Stackable'})

local Edit_Table = {'Soil', 'Iron Ore', 'Leather Helmet', 'Wooden Pickaxe'}

local soil_edit = {
    [0] = "Soil",
    [3] = "Stone",
    [4] = "Moss Stone",
    [8] = "Sandy Soil",
    [11] = "Black Crystal",
    [12] = "Floating Ice",
    [13] = "Lime Sand Soil",
    [14] = "Snow",
    [15] = "Horas Rock",
    [21] = "Snow Block",
    [23] = "Sulfur Rock",
    [24] = "Hot Sand",
    [25] = "Magic Rock",
    [26] = "Sponge",
    [27] = "Red Sand",
}

local iron_ore_edit = {
    [-1] = "Gold Ore",
    [0] = "Iron Ore",
    [1] = "Coal Ore",
    [2] = "Kyanite Ore",
    [3] = "Diamond Ore",
    [4] = "Lithium Ore",
    [5] = "Malachite Ore",
    [6] = "Silica Ore",
    [7] = "Diamond Block",
    [8] = "Malachite Block",
    [9] = "Gold Block",
    [10] = "Iron Block",
    [11] = "Silica Block",
    [12] = "Patterned Silica Block",
    [13] = "Vertical Silica Block",
    [14] = "Lithium Block",
    [15] = "Lump Coal",
    [16] = "Kyanite Block",
}

local leather_helmet_edit = {
    [-3] = "Red Fortune Bag",
    [-1] = "Purple Fortune Bag",
    [0] = "Leather Helmet",
    [1] = "Leather Armor",
    [2] = "Leather Greave",
    [3] = "Leather Boot",
    [4] = "Leather Cloak",
    [5] = "Gold Embroidered Cloak",
    [6] = "Diamond Cloak",
    [7] = "Kyanite Cloak",
    [8] = "Iron Encusted Cloak",
    [9] = "Lava Cloak",
}

local wooden_pickaxe_edit ={ [2]='Gold Pickaxe'  }

local stone_spear_edit = {[1]='Iron Sword'}

local enchant_tool_table = {
    [15] = "Durability",
    [25] = "Speed",
    [24] = "Precise Collection",
    [26] = "Lucky Digging",
}

local enchant_weapon_table = {
    [5] = "Launch Strike (V Knockback)",
    [6] = "Sharp (Melee Dmg)",
    [7] = "Human Hunter",
    [8] = "Animal Hunter",
    [9] = "Demon Hunter",
    [10] = "Ignite (Burn)",
    [11] = "KnockBack (H Knockback)",
    [12] = "Lucky Hunting",
    [13] = "Powerful Shoot (Bow)",
    [14] = "Unlimited Shoot (Bow)",
    [27] = "Blast Shoot (Bow) [1]",
    [15] = "Durability"
}


local enchant_amor_table = {
    [15] = "Durability",
    [16] = "Melee Protection",
    [17] = "Long-Range Protection",
    [18] = "Blast Protection",
    [19] = "Burning Protection",
    [20] = "Poison Protection",
    [21] = "Chaos Protection",
    [22] = "CounterStrike (Reflect Dmg)",
    [23] = "KnockBack Resistance",
    [24] = "Dragon Slow Falling (Cloak)",
    [30] = "Speedy Falling (Greave)",
    [31] = "Spider Climb (Boot)",
}

function Key_Address_Validator()
    if debug then print('-----Key_Address_Validator-----') end
    if key.address == nil or key.address == 0 then
        if debug then print('key_address is nil') end
        if def_key_addr ~= 0 then key.address = def_key_addr Key_Address_Validator() end
        gg.alert('You can use Find Key Address or set it directly in Setting')
        Main()
    else
        if debug then print('type of key_address :', type(key.address)) end
        item_address[8].address = key.address
        item_address[8].flags = 4
    end
end

function Hide()
    gg.showUiButton()
    while true do
        if gg.isClickedUiButton() then
            if resume_state.func == 1 then Key_Address_Finder()
            elseif resume_state.func == 2 then Start()
            elseif resume_state.func == 3 then Item_Manipulator()
            elseif resume_state.func == 4 then Experimental()
            elseif resume_state.func == 5 then Sprite_Changer()
            elseif resume_state.func == 6 then Prototype_Sprite()

            else
                Main()
            end
        end
    gg.sleep(100)
    end
end
function Main()
    resume_state.func = 0
    local main = gg.choice({'Find Key Address', 'Start', 'Experimental', 'Info', 'Setting'})
    if main == 1 then Key_Address_Finder()
    elseif main == 2 then Start()
    elseif main == 3 then Experimental()
    elseif main == 4 then Home_Info()
    elseif main == 5 then Setting()
    else Hide()
    end
end
--resume num = 1
function Key_Address_Finder()
    resume_state.func = 1
    while key.address == nil do
        gg.alert(msg_prepare_1)
        local current_item
 
        local it_pr = gg.prompt({'How Many? [1; 64]'}, {'1'}, {'number'})
        if it_pr == nil then Hide()
        else current_item = it_pr[1]
        end

        -- local search_str = XOR(current_item, key.xor) --23 is ..804,483 must be ..804,475
        local search_str = current_item ~ key.xor
        if debug then print('search string : ', search_str) end
        gg.clearResults()
        gg.searchNumber(search_str, gg.TYPE_DWORD, false)
        local res = gg.getResults(100)
        local cnt = gg.getResultsCount()
        if debug then print('result count :', cnt) end
        if cnt == 0 then Key_Address_Finder() end
        gg.toast(msg_prepare_2)
        gg.sleep(5000)
        while cnt > 1 do
            if debug then print('refine number ~=', search_str) end
            gg.sleep(200)
            gg.refineNumber(search_str, gg.TYPE_DWORD, false, gg.SIGN_NOT_EQUAL)
            cnt = gg.getResultsCount()
            res = gg.getResults(100)
            print('finding changes value :', cnt)
        end
        if cnt == 0 then Key_Address_Finder() end
        key.address = res[1].address
        
        -- os.exit()
    end
    gg.alert('Key Address was found, now you Choose Start')
    local prep_msg = gg.choice({'Start', 'Back', 'Redefine key_address'})
    if prep_msg == 1 then Start()
    elseif prep_msg == 2 then Main()
    elseif prep_msg ==3 then key.address=nil Key_Address_Finder()
    end
    Home_Info()
end
--resume num = 2
function Start()
    resume_state.func = 2
    if debug then  print('---------start------------') end
    Key_Address_Validator()
    local offset = 0x48
    local addr = item_address[8].address
    for i=0, 8 do
        item_address[8-i] = {}
        item_address[8-i].address = addr - i*offset
        item_address[8-i].flags = 4
    end
    item_address = gg.getValues(item_address)
    if debug then print('item address : ', item_address) end
    Item_Manipulator()
    
end
--resume num = 3
function Item_Manipulator()
    resume_state.func = 3
    local item_ch = gg.choice({'item 1','item 2','item 3','item 4','item 5','item 6','item 7','item 8','Back'})
    if item_ch == nil then Hide() end
    if item_ch == 9 then Main() end
    local item_tp_ch = gg.choice(item_type) --tools, Equipment, stackable
    if item_tp_ch == nil then Item_Manipulator() end

    --get address selected
    -- local temp= {}
    -- temp[1]={}
    -- temp[1].address = item_address[item_ch].address
    -- temp[1].flags = 4

    if item_tp_ch == 1 then
        --tools
        local tool_ch = gg.choice({'Back','Upgrade', 'Durability', 'Enchant'})
        if tool_ch == 1 then Item_Manipulator()
        elseif tool_ch == 2 then --Upgrade
            local up_level = gg.prompt({'Upgrade Level [0;4]'}, {'0'}, {'number'})
            if up_level == nil then Item_Manipulator()
            else
                Equipment_Upgrade(item_address[item_ch].address, up_level[1])
            end
        elseif tool_ch == 3 then --Durability
            Durability_Editor(item_address[item_ch].address)
        elseif tool_ch == 4 then
            gg.alert('comming soon')
            Item_Manipulator()
        else Hide()
        end
    elseif item_tp_ch == 2 then
        --equipment
        local eq_ch = gg.choice({'Back','Upgrade', 'Durability', 'Enchant'})
        if eq_ch == 1 then Item_Manipulator()
        elseif eq_ch == 2 then --Upgrade
            local up_level = gg.prompt({'Upgrade Level [0;3]'}, {'0'}, {'number'})
            if up_level == nil then Item_Manipulator()
            else
                Equipment_Upgrade(item_address[item_ch].address, up_level[1])
            end
        elseif eq_ch == 3 then --Durability
            Durability_Editor(item_address[item_ch].address)
        elseif eq_ch == 4 then
            gg.alert('comming soon')
            Item_Manipulator()
        else Hide()
        end
    elseif item_tp_ch == 3 then
        --stackable
        local stack_size = gg.prompt({'Stack Size [1;64]'},{'1'},{'number'})
        if stack_size == nil then Item_Manipulator()
        else
            Stack_Editor(item_address[item_ch].address, stack_size[1])
        end
    else
        Hide()
    end
    Item_Manipulator()
end
--resume num = 4
function Experimental()
    resume_state.func = 4
    if debug then print('----Experimental-----') end
    Key_Address_Validator()
    local opt = gg.choice({'Soil Edit', 'Iron Ore Edit', 'Leather Helmet Edit', 'Instruction', 'Prototype'})
    if opt == 1 then Soil_Cast()
    elseif opt == 2 then Iron_Ore_Cast()
    elseif opt == 3 then Leather_Helmet_Cast()
    elseif opt == 4 then Instruction_Info()
    elseif opt == 5 then Prototype_Sprite()
    else Hide()
    end
end
--resume num = 5
function Sprite_Changer(id_inc)
    resume_state.func = 5
    if debug then  print('-----SPRITE CHANGER-----') end
    local tmp_addr = {}
    tmp_addr[1] = {}
    local sprite_offset = 0x24
    if debug then  print('type of item_address[8]', type(item_address[8].address))end
    if debug then  print('item_address[8]', item_address[8].address) end

    tmp_addr[1].address = item_address[8].address+sprite_offset
    tmp_addr[1].flags = 4 --DWORD
    tmp_addr = gg.getValues(tmp_addr)

    local native_value = tmp_addr[1].value
    local cast_value = native_value + id_inc*768
    tmp_addr[1].value = cast_value

    if debug then print('native_value : ', native_value) end
    if debug then print('cast_value :', cast_value) end
    if debug then print('tmp addr',tmp_addr) end

    --commit changes
    gg.setValues(tmp_addr)
end
--resume num = 6
function Prototype_Sprite()
    resume_state.func = 6
    if debug then print('-----Find New Sprite Change----') end
    local ch = gg.choice({'Ready', 'Exit'})
    if debug then print('choice', ch) end
    if ch == 2 then Main() end
    
    local temp = {}
    temp[1] = {}
    temp[1].address = item_address[8].address+0x24
    temp[1].flags = 4
    temp = gg.getValues(temp)

    local native_value = temp[1].value
    
    local offset_multiplier = gg.prompt({'test value [-15;15]'},{'0'},{'number'})
    if offset_multiplier == nil then Prototype_Sprite()
    else
        if offset_multiplier[1] then 
            local sprt_val = tonumber(offset_multiplier[1])
            Sprite_Changer(sprt_val)
        end
    end
    gg.sleep(8000)

    local exit_prompt = gg.choice({'Again', 'Save & Exit'})
    if exit_prompt == 1 then 
        gg.alert('back to native item')
        if debug then print('back to native item') end
        temp[1].value = native_value
        gg.setValues(temp)
        Prototype_Sprite()
    elseif exit_prompt == 2 then
        gg.alert('save changes item')
        Main()
    else
        Hide()
    end
    if debug then print('back to native item') end
    temp[1].value = native_value
    gg.setValues(temp)
    Prototype_Sprite()
end

function Durability_Editor(address)
    local offset = 4
    local temp = {}
    temp[1] = {}
    temp[1].address = address+offset
    temp[1].flags = 4
    temp[1].value = 10000
    gg.setValues(temp)
    gg.alert('Move to any space to refresh')
    Hide()
end

function Stack_Editor(address, val)
    local temp = {}
    temp[1] = {}
    temp[1].address = address
    temp[1].flags = 4

    -- value validation
    if type(val) ~= 'number' then val = tonumber(val) end
    temp[1].value = val~key.xor
    gg.setValues(temp)
    gg.alert(string.format('set to value : %d', val))
    Hide()
    
end

function Equipment_Upgrade(address, val)
    local offset = 0x24
    local temp = {}
    temp[1] = {}
    temp[1].address = address+offset
    temp[1].flags = 4
    local native_value = gg.getValues(temp)

    -- value validation
    if type(val) ~= 'number' then val = tonumber(val) end
    temp[1].value = native_value+val*768
    gg.setValues(temp)
    gg.alert(string.format('set to value : %d', val))
    Hide()
    
end

function Home_Info()
    Key_Address_Validator()
    str_info = string.format("key.xor :%d\nKEY Address :%s", key.xor, key.address) 
    gg.alert(str_info)
    Main()
end

function Setting()
    if debug then  print('-----Settting-----')end
    local set = gg.prompt({'XOR KEY', 'KEY ADDRESS'}, {def_XOR_KEY, def_key_addr}, {'number', 'number'})
    if set == nil then Main()
    else
        if set[1] then key.xor = set[1] end
        if set[2] then key.address = set[2] end
    end
    -- local ln = #key.address
    if debug then print('key.xor : ', key.xor)end
    if debug then print('key address : ', key.address)end
    
    -- print('type of key_addr :', type(key.address))
    Main()
end
function Soil_Cast()
    if debug then print('-----SOIL CAST----') end
    gg.alert('Put Soil to your Item #8')
    local ch = gg.choice({'Ready', 'Not Yet'})
    if debug then print('choice', ch) end
    if ch == 1 then
        local cast_to = gg.choice(soil_edit)
        if debug then print ('cast to : ', cast_to)end
        Sprite_Changer(cast_to)
    elseif ch == 2 then Experimental()
    else Hide()
    end
    Main()
end
function Iron_Ore_Cast()
    gg.alert('Not Ready Yet')
    Experimental()
end

function Leather_Helmet_Cast()
    gg.alert('Not Ready Yet')
    Experimental()
    
end

function Instruction_Info()
    local info = '1. Put Soil/Iron Ore/etc at Item #8\n2. Cast Previous Item to Another'
    gg.alert(info)
end

-- function Find_New()
--     if debug then print('-----Find New Sprite Change----') end
--     local ch = gg.choice({'Ready', 'Not Yet'})
--     if debug then print('choice', ch) end
    
--     local temp = {}
--     temp[1] = {}
--     temp[1].address = item_address[8].address+0x24
--     temp[1].flags = 4
--     temp = gg.getValues(temp)
    
--     if ch == 1 then
--         -- local cast_to = gg.choice(soil_edit)
--         -- if debug then print ('cast to : ', cast_to)end
--         for i=0, 15 do
--             gg.toast(string.format('number :%d', i))
--             Sprite_Changer(i)
--             gg.sleep(10000)
--         end
        
--     elseif ch == 2 then Find_New()
--     else Hide()
--     end

--     gg.setValues(temp)
-- end






Main()