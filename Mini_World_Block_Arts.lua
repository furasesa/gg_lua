-- apk_version = 0.50.0; 0.51.0
-- gg_version = 101
-- script_version = 0.0.1
-- AUTHOR = Furasesa

-- DEFAULT KEY
local def_XOR_KEY = 945804460 -- Your OWN if different
local def_key_addr = nil -- If you are developer

-- changelog:
-- version 0.0.2 :
--  - Tested APK version 0.51.0
--  - Moved some function: cannot start if key address not defined.
--  - Durability max value on setting. [purpose] : precise slider
--  - You can set XOR, ADDRESS in setting
--  - Transformation: Iron Ore, Soil, custom
--  - Add Default Values.
--  - Fix Resume Function
--  - Fix Choice Hierarki
--  - Grade Change: Before is Upgrade. [purpose] you can downgrade or revert changes
-- version 0.0.1 :
-- Feature :
--  - Key Address Finder : To Find Item #8 address as key
--  - Soil Edit : Change Soil Sprite to Another only in Item#8
--  - Iron Ore Edit : Change Iron Ore to such as Gold, Kyanite, Malachite, etc Ore or blocks
--  - Upgrade : Tools or Equipment. tool = 0-4 : wood-diamond, while equipment 0-3 : wood/leather, stone, iron
--  - Durability
--  - Enchantment : enchant tool/equips.
--  - Stack Edit : Inc/Dec


local debug = false
local resume = {['state']= 0}

local key = {['xor'] = def_XOR_KEY, ['address']=def_key_addr}
local item_address = {}
item_address[8] = {} -- Use for key address

local setting = {
    ['durability'] = 5000,
}

local help = {['main']= '1. Define Your Own XOR KEY by opening this script or set in Setting\n'..
                        '2. Set Your Item 8 to stackable items like soil, rock, etc which more than 1\n'..
                        '3. Start \'Find Key Address\'\n'..
                        '4. The Higher the number of stack the better the result\n'..
                        '5. If the result is more than 1, refine value will be requires\n'..
                        '6. Change your stack size. e.g 15 to 20, back to Find Key Address, refine (not 15)\n'..
                        '7. Once Done you can go Item Modifier\n'..
                        '8. If you are developer, you can copy address value to def_key_addr\n'..
                        '9. Place 64 pcs of Stack on your Item 8 to speed up finding the Key',
            ['itemtype'] =  'Tools : Mod your Tools e.g. Axe, Shovel, \n'..
                            '        Pickaxe, Hoe\n'..
                            'Equipment : Mod your Equipment e.g. Bow,\n'..
                            '            Sword, Spear, Armors\n'..
                            'Stackable : Change Your current Stack. \n'..
                            '            1-64 it mean you can decease it\n'..
                            'Transformation : Transform item sprite. like ore,\n'..
                            '                 tool, weapon. more help see there',
            ['modtype'] =   'Upgrade : Up/Down grade your tool/ equip. range\n'..
                            '          between tool and weapon are diffent.\n'..
                            '          e.g. wooden axe in your items. it mean \n'..
                            '               0 is wooden grade.\n'..
                            '          wooden = 0 -> +1 (stone grade) ->+2 (iron grade)\n'..
                            '          if your item is diamond axe, then\n'..
                            '          diamond = 0 -> -1 (gold grade) ->-2 (iron grade).\n'..
                            '          if you break the rules, like decreasing wooden grade,\n'..
                            '          or upgrading diamond grade, it may become lava, \n'..
                            '          unknown block, unused block, unsupported sprite, \n'..
                            '          etc, sometimes force close. originaly the code\n'..
                            '          comes from Transformation. You can try to\n'..
                            '          transform any block with your own risk\n'..
                            'Durability : Change your Equipment Durability.\n'..
                            'Enchant : Add Enchantment to your tools, weapons, and equips\n',
            ['trans'] = 'Change Ore to Another Ore or Block\n'
            }

resume.bookmark = 0

-- local Edit_Table = {'Soil', 'Iron Ore', 'Leather Helmet', 'Wooden Pickaxe'}

local soil_table = {
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

local ore_table = {
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

local enchant_table = {
    [5] = {['name'] = 'Launch Strike', ['lvl']=5},
    [6] = {['name'] = "Sharp", ['lvl']=5},
    [7] = {['name'] = "Human Hunter", ['lvl']=5},
    [8] = {['name'] = "Animal Hunter", ['lvl']=5},
    [9] = {['name'] = "Demon Hunter", ['lvl']=5},
    [10] = {['name'] = "Ignite", ['lvl']=5},
    [11] = {['name'] = "KnockBack", ['lvl']=5},
    [12] = {['name'] = "Lucky Hunting", ['lvl']=5},
    [13] = {['name'] = "Powerful Shoot", ['lvl']=5},
    [14] = {['name'] = "Unlimited Shoot", ['lvl']=5},
    [15] = {['name'] = "Durability", ['lvl']=5},
    [16] = {['name'] = "Melee Protection", ['lvl']=5},
    [17] = {['name'] = "Long-Range Protection", ['lvl']=5},
    [18] = {['name'] = "Blast Protection", ['lvl']=5},
    [19] = {['name'] = "Burning Protection", ['lvl']=5},
    [20] = {['name'] = "Poison Protection", ['lvl']=5},
    [21] = {['name'] = "Chaos Protection", ['lvl']=5},
    [22] = {['name'] = "Counter Strike", ['lvl']=5},
    [23] = {['name'] = "KnockBack Resistance", ['lvl']=5},
    [24] = {['name'] = "Precise Collection", ['lvl']=1},
    [25] = {['name'] = "Speed", ['lvl']=5},
    [26] = {['name'] = "Lucky Digging", ['lvl']=3},
    [27] = {['name'] = "Blast Shoot", ['lvl']=1},
    [28] = {['name'] = "Dragon Slow Falling", ['lvl']=1},
    [29] = {['name'] = "Savage Hunter", ['lvl']=5},
    [30] = {['name'] = "Speedy Falling", ['lvl']=5},
    [31] = {['name'] = "Spider Climbing", ['lvl']=5},
}

local enc_tool_table = {15,24,25,26,6,7,8,9,29}
local enc_weapon_table = {5,11,10,6,13,14,27,7,8,9,12,15}
local enc_armor_table = {15,16,17,18,19,20,21,22,23,28,30,31 }
local enc_all = {5,11,10,6,13,14,27,7,8,9,12,15,16,17,18,19,20,21,22,23,28,30,31,24,25,26,29}

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
            if resume.state == 1 then Key_Address_Finder()
            elseif resume.state == 2 then Start()
            elseif resume.state == 3 then Item_Modifier()
            elseif resume.state == 4 then Experimental()
            elseif resume.state == 5 then Sprite_Changer()
            elseif resume.state == 6 then Prototype_Sprite()

            else
                Main()
            end
        end
    gg.sleep(100)
    end
end
function Main()
    local main
    resume.state = 0
    if key.address == nil or key.address == 0 then
        main = gg.choice({'Find Key Address', 'Help', 'Setting'})
        if main == nil then Hide()
        else
            if main == 1 then Key_Address_Finder() end
            if main == 2 then Main_Help() end
            if main == 3 then Setting() end
        end
    else
        main = gg.choice({'Item Modifier', 'Help', 'Setting'})
        if main == nil then Hide()
        else
            if main == 1 then Start() end
            if main == 2 then Main_Help() end
            if main == 3 then Setting() end
        end
    end
    
end

function Get_Address_Value (addr) --return table temp. temp[1]
    local temp = {}
    temp[1] = {}
    temp[1].address = addr
    temp[1].flags = 4
    temp = gg.getValues(temp)
    if debug then print('get value :',temp) end
    return temp
end

function Set_Address_Value (addr, val, freeze_st, encrypted)
    local temp = {}
    temp[1] = {}
    temp[1].address = addr
    temp[1].flags = 4
    if encrypted then temp[1].value = tonumber(val)~key.xor
    else temp[1].value = tonumber(val) end
    temp[1].freeze = freeze_st
    if debug then print('set value :',temp) end
    gg.setValues(temp)
end

function Get_Item_Choice (choices, debug_str)
    local ch = gg.choice(choices)
    if debug then print(debug_str, ch) end
    if ch == nil then Hide()
    else return ch end
end

function Get_Item_Prompt (prompt_table, def_table, type_table, debug_str)
    local prmp = gg.prompt(prompt_table, def_table, type_table)
    if debug then print(debug_str, tostring(prmp)) end
    if prmp == nil then Hide()
    else return prmp end
end

function Key_Address_Finder()
    resume.state = 1
    local set_item_stack = function()
        local stack_num = gg.prompt({'How Many your item 8? [1; 64]'}, {'1'}, {'number'})
        if stack_num == nil then Main()
        else key.stack_size = stack_num[1] end
    end
    local search_address = function ()
        -- local search_str = XOR(current_item, key.xor) --23 is ..804,483 must be ..804,475
        if key.stack_size == 0 then set_item_stack() end
        gg.clearResults()
        key.search_str = key.stack_size ~ key.xor
        gg.searchNumber(key.search_str, gg.TYPE_DWORD, false)
        key.result_count = gg.getResultsCount()
        if key.result_count == 1 then
            local res = gg.getResults(10)
            key.address = res[1].address
        end
        if key.result_count == 0 then
            key.stack_size = nil
        end
        if debug then print('result count :', key.result_count) end
    end

    local refine_address = function ()
        local ch = gg.choice({'refine (not '..key.stack_size..')', 'reset size'})
        if ch == nil then Hide()
        else
            if ch == 1 then
                gg.refineNumber(key.search_str, gg.TYPE_DWORD, false, gg.SIGN_NOT_EQUAL)
                if debug then print('refine number ~=', key.search_str) end
                key.result_count = gg.getResultsCount()
                if key.result_count == 1 then 
                    local res = gg.getResults(10)
                    key.address = res[1].address end
            elseif ch == 2 then
                set_item_stack()
                search_address()
            end
        end
    end

    local finish = function ()
        local alstr = string.format('your key address : %s', key.address)
        gg.alert(alstr)
        local ch = gg.choice({'Item Modifier', 'Redefine' , 'Main Menu'})
        if ch == nil then Hide()
        else
            if ch == 1 then Start() end
            if ch == 2 then
                key.stack_size = nil
                key.result_count = nil
                key.address = nil
                Key_Address_Finder()
            end 
            if ch == 3 then Main() end
        end
    end

    local redefine = function ()
        if key.address == nil or key.address == 0 then
            if key.stack_size == nil then set_item_stack() end
            if key.result_count == nil or key.result_count == 0 then search_address() end
            if key.result_count > 1 then refine_address() end
            if key.result_count == 1 then finish() end
        else finish()
        end
    end
    redefine()
    Main()
end
--resume num = 2
function Start()
    -- resume.bookmark = 1
    if debug then  print('---------start------------') end
    Key_Address_Validator()
    resume.state = 2
    local offset = 0x48
    local addr = item_address[8].address
    for i=0, 7 do
        item_address[8-i] = {}
        item_address[8-i].address = addr - i*offset
        item_address[8-i].flags = 4
    end
    item_address = gg.getValues(item_address)
    if debug then print('item address : ', item_address) end
    Item_Modifier()
end

local itemmod = {['choice']=nil}
local custom_trans = {
    ['prompt'] = '0',
    ['address_t']=nil,
    ['commit']=nil
}
--resume num = 3
function Item_Modifier()
    local item_list = {[0]='Back',[1]='item 1',[2]='item 2',[3]='item 3',[4]='item 4',[5]='item 5',[6]='item 6',[7]='item 7',[8]='item 8'}
    local item_type = {[0]='Back',[1]='Tools', [2]='Equipment', [3]='Stackable', [4]='Transformation', [100]='Help'}
    local item_mod_type = {[0]='Back',[1]='Grade Change', [2]='Durability', [3]='Enchant', [100]='Help'}
    resume.state = 3

    -- grade changes
    local change_grade = function(range_table)
        local offset = 0x24
        local addr = item_address[itemmod.choice].address + offset
        local addr_tbl = Get_Address_Value(addr) --table
        local change_lvl = Get_Item_Prompt(range_table, {'0'}, {'number'}, 'change grade') --val is lvl_c[1]
        local value = addr_tbl[1].value +change_lvl[1]*768
        Set_Address_Value(addr, value, false, false)
        if debug then print('change value to :', value) end
        gg.alert(string.format('set to value : %d\nmove your item to refresh', value))
    end
    -- end grade change

    local durability = function ()
        local offset = 4
        local addr = item_address[itemmod.choice].address + offset
        local addr_tbl = Get_Address_Value(addr) --table
        local cur_value = addr_tbl[1].value
        local new_value = Get_Item_Prompt({'Durability [1;'..setting.durability..']'},{cur_value}, {'number'}, 'Durability')
        Set_Address_Value(addr, new_value[1], false, false)
        gg.alert(string.format('your durability is now : %d',new_value[1]))
    end

    --enchant functions
    local gen_enchant_table = function (v_table)
        local res = {}
        res.id = v_table
        res.name = {}
        res.lvl = {}
        for _, v in ipairs(v_table) do
            res.name[#res.name+1] = enchant_table[v].name
            res.lvl[#res.lvl+1] = enchant_table[v].lvl
        end
        return res
    end
    local gen_lvl_prompt = function (selected_enchant, gen_tbl)
        local res = {}
        res.name = {}
        res.default = {}
        res.type = {}
        for i,v in pairs(selected_enchant) do
            if v then
                res.name[#res.name+1] = gen_tbl.name[i]..'[1;'..gen_tbl.lvl[i]..']'
                res.default[#res.default+1] = gen_tbl.lvl[i]
                res.type[#res.type+1] = 'number'
            end
        end
        return res
    end

    local gen_enchant_value = function (selected_enchant, lvl_value, gen_table_reference)
        local res = {}
        local seltmp ={}
        for i, v in pairs(selected_enchant) do
            if v then seltmp[#seltmp+1] = gen_table_reference.id[i] end
        end
        for i, v in ipairs(lvl_value) do res[#res+1] = seltmp[i]..'0'..lvl_value[i] end
        return res
    end

    local do_enchant = function (address, tbl_enc)
        if debug then print('-----Enchantment-----') end
        local offset_enc_act = 0x8
        local offset_ench = 0x4
        local temp = {}
    
        for i in ipairs(tbl_enc) do
            temp[i] = {}
            temp[i].address = address + offset_enc_act + i*offset_ench
            temp[i].flags = 4
            temp[i].value = tbl_enc[i]
        end
    
        local num_activated = #temp
        if debug then print('num enchant:', num_activated) end
    
        temp[num_activated+1] = {}
        temp[num_activated+1].address = address + offset_enc_act
        temp[num_activated+1].flags = 4
        temp[num_activated+1].value = num_activated
    
        if debug then print('Table : ', temp) end
        gg.setValues(temp)
        gg.alert('Enchant Done')
    end
    --end enchant fn

    local stack_edit = function ()
        if debug then print('-----stack edit-----') end
        local item_table = Get_Address_Value(item_address[itemmod.choice].address)
        local current_value = item_table[1].value~key.xor
        local current_freeze_state = item_table[1].freeze
        if debug then print(string.format('value : %d, freeze: %s', current_value, current_freeze_state)) end

        local prompt = gg.prompt({'Stack Size [1;64]', 'Freeze'},{current_value, current_freeze_state},{'number', 'checkbox'})
        if prompt == nil then Hide()
        else
            if debug then print(string.format('send value: %d, freeze?%s', prompt[1], prompt[2])) end
            Set_Address_Value(item_address[itemmod.choice].address, prompt[1], prompt[2], true)
        end
        itemmod.type = nil
    end

    -- listed known transformation
    local listed_transform = function (known_trans_table, debug_str)
        if debug then print('-----'..debug_str..'-----') end
        local offset = 0x24
        local ch_to = Get_Item_Choice(known_trans_table, debug_str..tostring(known_trans_table)..'choice :')
        local addr = item_address[itemmod.choice].address + offset
        local addr_tbl = Get_Address_Value(addr)
        local cur_value = addr_tbl[1].value
        if debug then print('current value : ', cur_value) end
        local new_value = cur_value + ch_to * 768
        if debug then print('new value : ', new_value) end
        Set_Address_Value(addr, new_value, false, false)
        gg.alert('move to refresh')
        if debug then print('-----end-----') end
    end
    -- end listed known transformation

    -- custom transformation
    local custom_transformation = function ()
        if debug then print('----Custom Transformation-----') end
        local offset = 0x24
        if debug then print('prompt value :', custom_trans.prompt) end
        if custom_trans.prompt == '0' then
            local prompt = Get_Item_Prompt({'Transform [-50;50]'},{custom_trans.prompt},{'number'}, 'Custom Transform : ')
            custom_trans.prompt = prompt[1]
            if debug then print('prompt value changes to:', custom_trans.prompt) end
        end
        local addr = item_address[itemmod.choice].address + offset
        if debug then print('address_t :', custom_trans.address_t) end
        if custom_trans.address_t == nil then
            local addr_table = Get_Address_Value(addr)
            custom_trans.address_t = addr_table[1]
            if debug then print('address_t changes:', custom_trans.address_t) end
        end
        local current_value = custom_trans.address_t.value
        local new_value = current_value + custom_trans.prompt * 768
        if debug then print('current value', current_value) end
        if debug then print('new value', new_value) end
        if debug then print('Testing Value :', new_value) end
        Set_Address_Value(addr, new_value, false, false)
        custom_trans.commit = gg.choice({[1]='Commit Change', [2]='Redo'})
        if custom_trans.commit == nil then Hide()
        else
            if custom_trans.commit == 1 then itemmod.trans = nil end
            if custom_trans.commit == 2 then -- redo
                if debug then print('Redo Change : ', custom_trans.address_t.value) end
                Set_Address_Value(addr,custom_trans.address_t.value, false, false)
                itemmod.trans = nil
            end
            custom_trans.prompt = '0'
            custom_trans.address_t = nil
            custom_trans.commit = nil
        end
    end
    -- end custom transformation

    local tool_mod = function ()
        itemmod.tool = Get_Item_Choice(item_mod_type, 'itemmod.tool') --'Grade Change', 'Durability', 'Enchant'
        if itemmod.tool == 0 then
            if debug then print('Back to item type') end
            itemmod.type = nil
            itemmod.tool = nil
        else
            if itemmod.tool == 1 then --Grade Change
                itemmod.tool = nil
                change_grade({'Change Grade [-4;4]'})
            end
            if itemmod.tool == 2 then --Durability
                itemmod.tool = nil
                durability()
            end
            if itemmod.tool == 3 then --Enchant
                itemmod.tool = nil
                local _ch = Get_Item_Choice({'Tool', 'All List'}, 'Tool::Enchant::Tool/All List')
                local ch_wa = {}
                if _ch == 1 then ch_wa = enc_tool_table end
                if _ch == 2 then ch_wa = enc_all end

                local gen_tbl = gen_enchant_table(ch_wa)
                if debug then print('gen tbl', gen_tbl) end

                local sel_enchant = gg.multiChoice(gen_tbl.name)
                if debug then print('selected enchant', sel_enchant) end

                -- gen level
                local lvl_prmp = gen_lvl_prompt(sel_enchant, gen_tbl)
                if debug then print('level prompt :', lvl_prmp) end

                local lvl_val = gg.prompt(lvl_prmp.name, lvl_prmp.default, lvl_prmp.type)
                if debug then print('promp result', lvl_val) end

                local enc_val = gen_enchant_value(sel_enchant, lvl_val, gen_tbl)
                if debug then print('enchant value :', enc_val)end

                do_enchant(item_address[itemmod.choice].address, enc_val)
            end
            if itemmod.tool == 100 then gg.alert(help.modtype) end

        end
    end

    local eq_mod = function()
        itemmod.equip = Get_Item_Choice(item_mod_type, 'itemmod.equip') --'Grade Change', 'Durability', 'Enchant'
        if itemmod.equip == 0 then
            if debug then print('Back to item type') end
            itemmod.type = nil
            itemmod.equip = nil
        else
            if itemmod.equip == 1 then --upgrade
                itemmod.equip = nil
                change_grade({'Change Grade [-3;3]'})
            end
            if itemmod.equip == 2 then --durability
                itemmod.equip = nil
                durability()
            end
            if itemmod.equip == 3 then --enchant
                itemmod.equip = nil
                local _ch = Get_Item_Choice({'Weapon', 'Armor', 'All List'}, 'Equip::Enchant::Weapon/Armor/All List')
                local ch_wa = {}
                if _ch == 1 then ch_wa = enc_weapon_table end
                if _ch == 2 then ch_wa = enc_armor_table end
                if _ch == 3 then ch_wa = enc_all end

                local gen_tbl = gen_enchant_table(ch_wa)
                if debug then print('gen tbl', gen_tbl) end

                local sel_enchant = gg.multiChoice(gen_tbl.name)
                if debug then print('selected enchant', sel_enchant) end

                -- gen level
                local lvl_prmp = gen_lvl_prompt(sel_enchant, gen_tbl)
                if debug then print('level prompt :', lvl_prmp) end

                local lvl_val = gg.prompt(lvl_prmp.name, lvl_prmp.default, lvl_prmp.type)
                if debug then print('promp result', lvl_val) end

                local enc_val = gen_enchant_value(sel_enchant, lvl_val, gen_tbl)
                if debug then print('enchant value :', enc_val)end

                do_enchant(item_address[itemmod.choice].address, enc_val)
            end
            if itemmod.equip == 100 then gg.alert(help.modtype) end

        end
    end

    local transformation_items = function (addr)
        if itemmod.trans == nil then
            local trans_list = {[0]='Back',[1]='Iron Ore', [2]='Soil', [3]='Custom', [100]='Help'}
            itemmod.trans = Get_Item_Choice(trans_list, 'Ore Trans')
        end

        if itemmod.trans == 0 then
            itemmod.type = nil
            itemmod.trans = nil
        else
            if itemmod.trans == 1 then
                itemmod.trans = nil
                listed_transform(ore_table, 'Ore Trans') end
            if itemmod.trans == 2 then
                itemmod.trans = nil
                listed_transform(soil_table, 'Soil Trans') end
            if itemmod.trans == 3 then
                custom_transformation() end
            if itemmod.trans == 100 then gg.alert(help.trans) end
        end
    end

    if itemmod.choice == nil then itemmod.choice = Get_Item_Choice(item_list, 'itemmod.choice') end
    if itemmod.choice == 0 then itemmod.choice = nil Main() end

    if itemmod.type == nil then itemmod.type = Get_Item_Choice(item_type, 'itemmod.type') end
    if itemmod.type == 0 then
        print('Back to item choice')
        itemmod.choice = nil
        itemmod.type = nil
    else
        if itemmod.type == 1 then tool_mod() end --Tool
        if itemmod.type == 2 then eq_mod() end --Equipment
        if itemmod.type == 3 then stack_edit() end --Stackable
        if itemmod.type == 4 then transformation_items() end -- Transformation
        if itemmod.type == 100 then itemmod.type = nil gg.alert(help.itemtype) end -- Help.
    end
    if debug then print('Restart Item Modifier') end
    Item_Modifier()

end

function Main_Help() gg.alert(help.main) Main() end

function Setting()
    if debug then  print('-----Settting-----')end
    local setting_table = {'XOR KEY', 'KEY ADDRESS', 'Durability Value'}
    local setting_default = {def_XOR_KEY, def_key_addr or key.address, 5000}
    local setting_type = {'number', 'number', 'number'}
    local set = Get_Item_Prompt(setting_table, setting_default , setting_type, 'Setting :')
    if set[1] then key.xor = set[1] end
    if set[2] then key.address = set[2] end
    if set[3] then setting.durability = set[3] end
    -- local ln = #key.address
    if debug then print('key.xor : ', key.xor)end
    if debug then print('key address : ', key.address)end
    -- print('type of key_addr :', type(key.address))
    Main()
end

Main()