--Shadow of Death Skill Hack
 --gg_version = 101
--apk_version = 1.96.0.0
----------------WARNING------------------------
--THE AUTHOR IS NOT RESPONSIBILE FOR ANY HARM
--IT MAY CAUSE YOUR DATA BE BANNED
--SAVE BEFORE USE
------------------END--------------------------

-------------------NOTE---------------------
--Please use it for adventure, tower and raid. PVP are not tested (may be banned)
--Turn off / reset skill to native while playing PVP.
-- guide:
-- 1.  select character. Wait until all 8 skills loaded. It may take a minute
-- 2.  select skill cooldown or skill damage manipulating
--     cooldown Note:
--     Quinn:  Because same cooldown time, so Death Spike's Address are in Phobos Strike.
--             Choosing Death Spike Only will not work
-- 3.  Touch to outside area to hide
-- 4.  For Skill Damage, select damage multiplier first then pick any skill
--     Skill Damage Note:
--     '1' is native skill damage
--     by default, skill damage multipliers are from 1-100
--     to edit the limit of max damage, find max_dmg_choices
-- 5.  Revert All Changes are not work. I was too lazy to fix that.
--     to Revert Changes:
--     Select Skill Cooldown. leave unchecked, OK
--     Select Skill Damage. Select whatever, leave unchecked, OK
-- 6.  Since Game APK version are same, normaly 1-3 of address are saved, except for max
--     see: Max Saved Address to table
-- 7.  Restart the game if not work. if not try to edit this
--     local skill_start_sc = 0
--     local skill_end_sc = -1
--     it may take a long time, and not accurate.
-------------------NOTE---------------------

gg.setVisible(false)
local char_table = {'Maximus', 'Quinn', 'Mount', 'Lunae', 'Exit'}
local char_selector

local max_dmg_choices = 100

--Max Saved Address to table.
local maximus_saved_addr = 6
local quinn_saved_addr = 4
local mount_saved_addr = 4
local lunae_saved_addr = 4

local maximus_skill_table = {
	"1️⃣ Mortal Blow",
	"2️⃣ Blighted Force",
	"3️⃣ Rolling Smash",
	"4️⃣ Sky Uppercat",
	"5️⃣ Whirl Wind",
	"6️⃣ Descending Blades",
	"7️⃣ Sword Rain",
	"8️⃣ Demon Slash",
}
local quinn_skill_table = {
	"1️⃣ Death Spike",
	"2️⃣ Phobos Strike",
	"3️⃣ Dark Judgement",
	"4️⃣ Hell Gate",
	"5️⃣ Dark Luminous",
	"6️⃣ Eclipse",
	"7️⃣ Black Tempest",
	"8️⃣ True Form",
}
local mount_skill_table = {
	"1️⃣ Thundering Blow",
	"2️⃣ Hurricane",
	"3️⃣ Danger-Bulldozer",
	"4️⃣ Giga-Blitz",
	"5️⃣ Static Field",
	"6️⃣ Mjollnir",
	"7️⃣ Holy Bulwalk",
	"8️⃣ Thunder Mount",
}
local lunae_skill_table = {
	"1️⃣ Spiral Galaxy",
	"2️⃣ Milky Way",
	"3️⃣ Nova Dance",
	"4️⃣ Crescent Clever",
	"5️⃣ Shooting Star",
	"6️⃣ Full Moon",
	"7️⃣ Doom Bloom",
	"8️⃣ Judgement Of Keeper",
}

--Maximus skill cooldown and skill damage
local maximus_cd_table = {'14.0', '15.0', '20.0', '23.0', '45.0', '40.0', '66.0', '73.0'}
local maximus_dmg_table = {'2.7', '2.9', '1.6', '3.0', '1.0', '3.75', '3.2', '4.0'}
local maximus_address_table_cd = {}
local maximus_address_table_dmg = {}

--Quinn skill cooldown and skill damage
local quinn_cd_table = {'14.0', '14.0', '20.0', '13.0', '45.0', '40.0', '54.0', '80.0'}
local quinn_dmg_table = {'2.1', '2.0', '0.8', '1.5', '1.2', '0.8', '0.5', '1.5'}
local quinn_address_table_cd = {}
local quinn_address_table_dmg = {}

--Mount skill cooldown and skill damage
local mount_cd_table = {'17.0', '15.0', '21.0', '40.0', '45.0', '33.0', '60.0', '70.0'}
local mount_dmg_table = {'1.8', '2.1', '1.6', '3.0', '2.0', '2.9', '0.6', '13.0'}
local mount_address_table_cd = {}
local mount_address_table_dmg = {}

--Lunae skill cooldown and skill damage
local lunae_cd_table = {'7.0', '14.0', '20.0', '28.0', '35.0', '40.0', '60.0', '66.0'}
local lunae_dmg_table = {'0.35', '3.0', '1.3', '1.2', '1.6', '3.0', '2.1', '5.0'}
local lunae_address_table_cd = {}
local lunae_address_table_dmg = {}

--Address Start and End Stop to speed up finding address
--may different with yours. you can edit to default
local skill_start_sc = 0x7500000000 -- '0' is default
local skill_end_sc = 0x76FFFFFFFF -- '-1' is default (all address)

local selected_skill_cd = {}
local selected_skill_dmg = {}

function Char_Selector()
	char_selector = gg.choice(char_table)
	if char_selector == 1 then Max_Addr()
	elseif char_selector == 2 then Quinn_Addr()
	elseif char_selector == 3 then Mount_Addr()
	elseif char_selector == 4 then Lunae_Addr()
	elseif char_selector == 5 then os.exit()
	else Char_Selector()
	end
	Main()
end


--start Main function
function Main()
	-- print ('---------------main----------------')
	local main_choose = gg.choice({'Skill Cooldown','Skill Damage','Revert & Select Char'})
	if main_choose == 1	then Ch_Skill_Cooldown()
	elseif main_choose == 2	then Skill_Damage()
	elseif main_choose == 3	then Revert()
	else
		gg.showUiButton()
		while true do
			if gg.isClickedUiButton() then
				Main()
			end
		gg.sleep(100)
		end
	end
end

--@brief    Search Address and separate cooldown value and skill damage address
--params    skill_num. number of skill see: skill table
--params    filter_result. max saved address. 4 is maximum 4 address are saved.
--params    str_skill_cd. String skill cooldown. get from characters cd_table
--params    str_skill_dmg. String skill damage. get from characters cd_table
function Extract_Address(
	skill_num,
	skill_name,
	filter_result,
	str_skill_cd,
	str_skill_dmg)

	local search_str = str_skill_cd..';'..str_skill_dmg
	local filter = function (comparator, t)
		local res = {}
		for idx, val in ipairs(t) do
			if t[idx].value == comparator then
				res[#res+1] = val
			end
		end
		return res
	end
	gg.toast('Searching Address '..skill_name)
	gg.searchNumber(
		search_str, 
		gg.TYPE_DOUBLE, 
		false, 
		gg.SIGN_EQUAL, 
		skill_start_sc, 
		skill_end_sc, 
		0)
	local result_counts = gg.getResultsCount()
	local scan_results = {}
	if result_counts > filter_result then
		local skip = result_counts - filter_result
		scan_results = gg.getResults(filter_result, skip)
	else
		scan_results = gg.getResults(result_counts)
	end
	-- print('scan result : ', scan_results)
	local cd_address_t = {}
	cd_address_t = filter(str_skill_cd, scan_results)

	local dmg_address_t = {}
	dmg_address_t = filter(str_skill_dmg, scan_results)

	if char_selector == 1 then 
		maximus_address_table_cd[skill_num] = {}
		maximus_address_table_dmg[skill_num] = {}
		maximus_address_table_cd[skill_num] = cd_address_t
		maximus_address_table_dmg[skill_num] = dmg_address_t
	elseif char_selector == 2 then
		quinn_address_table_cd[skill_num] = {}
		quinn_address_table_dmg[skill_num] = {}
		quinn_address_table_cd[skill_num] = cd_address_t
		quinn_address_table_dmg[skill_num] = dmg_address_t
	elseif char_selector == 3 then print("Mount")
		mount_address_table_cd[skill_num] = {}
		mount_address_table_dmg[skill_num] = {}
		mount_address_table_cd[skill_num] = cd_address_t
		mount_address_table_dmg[skill_num] = dmg_address_t
	elseif char_selector == 4 then print("Lunae")
		lunae_address_table_cd[skill_num] = {}
		lunae_address_table_dmg[skill_num] = {}
		lunae_address_table_cd[skill_num] = cd_address_t
		lunae_address_table_dmg[skill_num] = dmg_address_t
	end
	gg.clearResults()
end


function Max_Addr()
	print('-------MAXIMUS------')
	for skill_num, skill_name in ipairs(maximus_skill_table) do
		--Extract_Address(char_num)
		Extract_Address(
			skill_num,
			skill_name,
			maximus_saved_addr,
			maximus_cd_table[skill_num],
			maximus_dmg_table[skill_num])
		print('check value:')
		print('maximus_skill : ', maximus_skill_table[skill_num])
		print('addr_cd:', maximus_address_table_cd[skill_num])
		print('addr_dmg:',maximus_address_table_dmg[skill_num])
	end
	print('---------END-------')
end

function Quinn_Addr()
	print('-------QUINN------')
	for skill_num, skill_name in ipairs(quinn_skill_table) do
		--Extract_Address(char_num)
		Extract_Address(
			skill_num,
			skill_name,
			quinn_saved_addr,
			quinn_cd_table[skill_num],
			quinn_dmg_table[skill_num])
		
		print('check value:')
		print('quinn_skill : ', quinn_skill_table[skill_num])
		print('addr_cd:', quinn_address_table_cd[skill_num])
		print('addr_dmg:',quinn_address_table_dmg[skill_num])
	end
	print('---------END-------')
end

function Mount_Addr()
	print('-------MOUNT------')
	for skill_num, skill_name in ipairs(mount_skill_table) do
		--Extract_Address(char_num)
		Extract_Address(
			skill_num,
			skill_name,
			mount_saved_addr,
			mount_cd_table[skill_num],
			mount_dmg_table[skill_num])
		print('check value:')
		print('mount_skill : ', mount_skill_table[skill_num])
		print('addr_cd:', mount_address_table_cd[skill_num])
		print('addr_dmg:',mount_address_table_dmg[skill_num])
	end
	print('---------END-------')
end

function Lunae_Addr()
	print('-------LUNAE------')
	for skill_num, skill_name in ipairs(lunae_skill_table) do
		--Extract_Address(char_num)
		Extract_Address(
			skill_num,
			skill_name,
			lunae_saved_addr,
			lunae_cd_table[skill_num],
			lunae_dmg_table[skill_num])
		print('check value:')
		print('lunae_skill : ', lunae_skill_table[skill_num])
		print('addr_cd:', lunae_address_table_cd[skill_num])
		print('addr_dmg:',lunae_address_table_dmg[skill_num])
	end
	print('---------END-------')
end

function Ch_Skill_Cooldown()
	print('-------Skill Cooldown------')
	--changes to multiple choice
	if char_selector == 1 then Skill_Cooldown_Editor(gg.multiChoice(maximus_skill_table), maximus_cd_table, maximus_address_table_cd) Main()
	elseif char_selector == 2 then Skill_Cooldown_Editor(gg.multiChoice(quinn_skill_table), quinn_cd_table, quinn_address_table_cd) Main()
	elseif char_selector == 3 then Skill_Cooldown_Editor(gg.multiChoice(mount_skill_table), mount_cd_table, mount_address_table_cd) Main()
	elseif char_selector == 4 then Skill_Cooldown_Editor(gg.multiChoice(lunae_skill_table), lunae_cd_table, lunae_address_table_cd) Main()
	end
end

--@brief    Load table address and edit the value
--params    selected_skill. all Char have 8 skill. idx=number skill, value=true if selected.
--params    char_cd_table. native cooldown value
--params    char_address_table_cd. addresses (long) to load.
function Skill_Cooldown_Editor(selected_skill, char_cd_table, char_address_table_cd)
	selected_skill_cd = selected_skill
	local selected_address_table = {}
	local cooldown = '0'
	print ('skill select : ', selected_skill_cd)
	for id=1, 8 do
		if selected_skill_cd[id] then 
			selected_address_table = char_address_table_cd[id]
			cooldown = '0'
			gg.clearResults()
			gg.loadResults(selected_address_table)
			gg.getResults(50)
			gg.editAll(cooldown, gg.TYPE_DOUBLE)
			gg.clearResults()
		else
			selected_address_table = char_address_table_cd[id]
			cooldown = char_cd_table[id]
			gg.clearResults()
			gg.loadResults(selected_address_table)
			gg.getResults(50)
			gg.editAll(cooldown, gg.TYPE_DOUBLE)
			gg.clearResults()
		end
	end
end

function Skill_Damage()
	print('-------Skill Damage------')
	local sdm = {}
	for i=1, max_dmg_choices do	sdm[i] = tostring(i) end
	local ch_dmg = gg.choice(sdm) --key and value are same
	print('skill damage : ', ch_dmg)
	--changes to multiple choice
	if char_selector == 1 then Skill_Damage_Editor(gg.multiChoice(maximus_skill_table), maximus_dmg_table, maximus_address_table_dmg, ch_dmg) Main()
	elseif char_selector == 2 then Skill_Damage_Editor(gg.multiChoice(quinn_skill_table), quinn_dmg_table, quinn_address_table_dmg, ch_dmg) Main()
	elseif char_selector == 3 then Skill_Damage_Editor(gg.multiChoice(mount_skill_table), mount_dmg_table, mount_address_table_dmg, ch_dmg) Main()
	elseif char_selector == 4 then Skill_Damage_Editor(gg.multiChoice(lunae_skill_table), lunae_dmg_table, lunae_address_table_dmg, ch_dmg) Main()
	end
end

--@brief    Load table address and edit the value
--params    selected_skill. all Char have 8 skill. idx=number skill, value=true if selected.
--params    char_dmg_table. native damage value
--params    char_address_table_dmg. addresses (long) to load.
--params    dmg_multiplier.
function Skill_Damage_Editor(selected_skill, char_dmg_table, char_address_dmg, dmg_multiplier)
	selected_skill_dmg = selected_skill
	local selected_address_table = {}
	local calc_dmg
	print ('skill select : ', selected_skill_dmg)
	for id=1, 8 do
		if selected_skill_dmg[id] then
			selected_address_table = char_address_dmg[id]
			calc_dmg = tonumber(char_dmg_table[id]*dmg_multiplier)

			gg.clearResults()
			gg.loadResults(selected_address_table)
			gg.getResults(50)
			gg.editAll(calc_dmg, gg.TYPE_DOUBLE)
			gg.clearResults()
		else
			selected_address_table = char_address_dmg[id]
			calc_dmg = tonumber(char_dmg_table[id])
			gg.clearResults()
			gg.loadResults(selected_address_table)
			gg.getResults(50)
			gg.editAll(calc_dmg, gg.TYPE_DOUBLE)
			gg.clearResults()
		end
	end
end

--@brief    NOT WORK
function Revert()
    print('----revert all changes----')
    gg.alert('may not work.')
	local select_all_skill = {}
	if char_selector == 1 then 
		--revert cd skill
		Skill_Cooldown_Editor(select_all_skill, maximus_cd_table, maximus_address_table_cd)
		Skill_Damage_Editor(select_all_skill, maximus_dmg_table, maximus_address_table_cd)
	elseif char_selector == 2 then
		Skill_Cooldown_Editor(select_all_skill, quinn_cd_table, quinn_address_table_cd)
		Skill_Damage_Editor(select_all_skill, quinn_dmg_table, quinn_address_table_cd)
	elseif char_selector == 3 then
		Skill_Cooldown_Editor(select_all_skill, mount_cd_table, mount_address_table_cd)
		Skill_Damage_Editor(select_all_skill, mount_dmg_table, mount_address_table_cd)
	elseif char_selector == 4 then
		Skill_Cooldown_Editor(select_all_skill, lunae_cd_table, lunae_address_table_cd)
		Skill_Damage_Editor(select_all_skill, lunae_dmg_table, lunae_address_table_cd)
	end
	Char_Selector()
end
Char_Selector()