-- Comp AC mod by Padfoot
-- Based off Gema Mod by Jg99
PLUGIN_NAME = "Competitive Assaultcube Plugin"
PLUGIN_AUTHOR = "Padfoot"
PLUGIN_VERSION = "0.1"
--ToDo: Fix ready system. Fix match system so second map is played.
include("ac_server")

function slice(array, S, E)
	local result = {}
	local length = #array
	S = S or 1
	E = E or length
	if E < 0 then
		E = length + E + 1
	elseif E > length then
		E = length
	end
	if S < 1 or S > length then
		return {}
	end
	local i = 1
	for j = S, E do
		result[i] = array[j]
		i = i + 1
	end
	return result
end

function inter(time)
	setautoteam(false)
  if getautoteam() == false then
	   say("AutoTeam has been turned off")
	else
    say("Shit, something broke.")
  end
  match = true
  if hasShuffled == false then
		a = math.random(3, 10)
  	count = 0
  	while count <= a do
    	shuffleteams()
    	count = count + 1
  	end
		hasShuffled = true
		say("Teams have been shuffled "..a.." times.")
	end
	if redmap ~= '' and blumap ~= '' then
		changemap(redmap, 5, time)
		setmastermode(2)
		say("Good Luck and Have Fun!!!")
		say("Mastermode is "..getmastermode())
		hasShuffled = false
	else
		say("Not all maps have been selected")
end
end

function playmatch(time)
	setautoteam(false)
	if getautoteam() == false then
		 say("AutoTeam has been turned off")
	else
		say("Shit, something broke.")
	end
	match = true
	if stage == 1 then
		changemap(blumap, 5, time)
		stage = 2
	else
		changemap(redmap, 5, time)
		stage = 1
	end
	say("Good Luck and Have Fun!!!")
	setmastermode(2)
	say("Mastermode is "..getmastermode())
end

function getPlayers()
	for player_cn in rvsf() do
		--add the player to the nplayers array
		table.insert(nplayers, player_cn)
	end
	for player_cn in cla() do
		--add the player to nplayers
		table.insert(nplayers, player_cn)
	end
	-- Get number of players
	ppl = table.getn(nplayers)
	say(ppl.." players here.")
end

function setready(cn)
	local i = get_key(nplayers, cn)
	table.remove(nplayers, i)
	string = getname(cn).." is now \fLready."
	say(string)
	num = #nplayers
	say("There are "..num.." players who are not ready")
end

function notready(cn)
	print(get_key(nplayers, cn))
	if get_key(nplayers, cn) then return end
  table.insert(nplayers, cn)
	string = getname(cn).." is \f3not \f3ready."
	say(string)
	num = #nplayers
	say("There are "..num.." players who are not ready")
end

function say(text, cn)
	if cn == nil then cn = -1 end -- to all
	clientprint(cn, text)
end

function setmap(cn, team, map)
	if team == "CLA" then
		if getteam(cn) == 0 then
			redmap = map
			say("Team "..team.." has selected "..map)
		end
	elseif team == "RVSF" then
		if getteam(cn) == 1 then
			blumap = map
			say("Team "..team.." has selected "..map)
		end
	else
		say("Something broke!")
	end
end

function get_key(tab, value)
  for key, val in pairs(tab) do
    if val == value then
      return key
    end
  end
	return nil
end
--function playerSay(cn, text)
--	text2 = string.format("Log: Player %s says: %s. Their IP is: %s", getname(cn), text, getip(cn))
--	logline(4, text2)
--	if co

--Varilables go here
nplayers = {}
match = false
stage = 0
blumap = ''
redmap = ''
hasShuffled = false

--Commands go here :)
commands =
{
	["!setmap"] = {
	function (cn, args)
		--Usage !setmap <team> <map>
		setmap(cn, args[1], args[2])
	end
	};

	["!ready"] = {
	function (cn)
		if get_key(nplayers, cn) ~= nil then
			setready(cn)
		end
	end
	};

	["!notready"] = {
		function (cn)
			if get_key(nplayers, cn) then return end
			notready(cn)
		end
	};


	["!inter"] = {
	 function (cn, args)
		if table.getn(nplayers) == 0 then
			say("Not all players are ready!")
		end
	end
	};

	["!match"] = {
	 function (cn, args)
		if table.getn(nplayers) == 0 then
			if blumap ~= '' and redmap ~= '' then
				playmatch(args[1])
			else
				say("Not all maps have been selected!")
			end
		else
			say("Not all players are ready!")
		end
	 end
	};
}

--Handlers
function onPlayerSayText(cn, text)
	text2 = string.format("SCLog: Player %s says: %s. Their IP is: %s",getname(cn), text ,getip(cn))
	logline(4, text2)

	local parts = split(text, " ")
	if table.getn(parts) == 1 then
		command = parts[1]
	else
		command, args = parts[1], slice(parts, 2)
	end

	if commands[command] ~= nil then
		local callback = commands[command][1]
				-- If there is a command there, carry out the command
				callback(cn, args)
		end
		if isadmin(cn) then
			SayToAllA(text,cn)
			return PLUGIN_BLOCK
		else
				SayToAll(text,cn)
				return PLUGIN_BLOCK
		end
end

function SayToAll(text, except)
	 for n=0,20,1 do
		-- if isconnected(n) and n ~= except then
	if dup then
			say("\f4|\fX" .. except .. "\f4|\fR#\f5" .. getname(except) .. ":\f9 " .. text,n)
		elseif isconnected(n) and n ~= except then
		 say("\f4|\fX" .. except .. "\f4|\fR#\f5" .. getname(except) .. ":\f9 " .. text,n)
	 end
	--	end

		 end
	 end

function SayToAllA(text, except)
	 for n=0,20,1 do
		-- if isconnected(n) and n ~= except then
	if dup then
			say("\f4|\fX" .. except .. "\f4|\f3#\f5" .. getname(except) .. ":\f9 " .. text,n)
		elseif isconnected(n) and n ~= except then
		say("\f4|\fX" .. except .. "\f4|\f3#\f5" .. getname(except) .. ":\f9 " .. text,n)
	 end
	--	end

		 end
	 end

function SayToAll2(text, except)
	 if isconnected(n) and n ~= except then
			say("\fR[SERVER INFO] \f4",text,n)
	end
end

function onMapEnd()
	--Reset all of the values
	nplayers = {}
	match = false
  setmastermode(0)
	blumap = ''
	redmap = ''
	if stage == 1 then
		playmatch()
	end
end

function onMapChange(map, mode)
	getPlayers()
end

function onPlayerTeamChange(cn, team, reason)
	--Stop people from changing if they are playing a match
	if match == true then
		if team == 1 or team == 0 then
			say(getname(cn)..", they are playing a match. You can't join.", cn)
      return PLUGIN_BLOCK, false
    end
  end
end

function onPlayerConnect(cn)
	 say("\f4Hello \fR" .. getname(cn) .. "!")
-- say("\fR [SERVER INFO]" .. getname(cn) .. "\fR connected!!! with ip \f4" .. getip(cn) .. "")
setautoteam(false)
end
