-- Comp AC mod by Padfoot
-- Based off Gema Mod by Jg99
PLUGIN_NAME = "Competitive Assaultcube Plugin"
PLUGIN_AUTHOR = "Padfoot"
PLUGIN_VERSION = "0.1"

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

function inter(time, map)
	a = math.random(3, 10)
	count = 0
	while count <= a do
		shuffleteams()
		count = count + 1
		end
	say("Teams have been shuffled")
	setautoteam(0)
	say("AutoTeam has been turned off")
	match = true
	changemap(map, 5, time)
	say("Good Luck and Have Fun!!!")
end

function match(time, map)
	setautoteam(0)
	say("AutoTeam has been turned off")
	match = true
	changemap(map, 5, time)
	say("Good Luck and Have Fun!!!")
end

function getPlayers()
	for player_cn in rvsf() do
		--add the player to the nplayers array
		table.insert(nplayers, player_cn)
	end
	for player_cn in cla() do
		--add the player to the nplayers array/table
		table.insert(nplayers, player_cn)
end

function setready(cn)
	table.remove(nplayers, cn)
	table.insert(rplayers, cn)
	string = getname(cn).."is now ready."
	say(string)
end

function notready(player)
	table.remove(rplayers, cn)
	table.insert(nplayers, cn)
	string = getname(cn)..."is not ready."
end

function say(text, cn)
  if cn == nil then cn = -1 end -- to all
  clientprint(cn, text)
end

--function playerSay(cn, text)
--	text2 = string.format("Log: Player %s says: %s. Their IP is: %s", getname(cn), text, getip(cn))
--	logline(4, text2)
--	if co

--Variables go here
--rplayers = {} --instead of having an array of both not ready players and ready players, I decided to only have not ready players, as almost the same effect can be achieved.
nplayers = {}
numplay = 0
match = false
--Commands go here :)
-- Paramaters are {admin required, show message}
commands =
{
  [".ready"] =
  {
	function (cn)
		if nplayers[cn] ~= nil then
			setready(cn)
		end
	end
  };

	[".notready"] = {
		function(cn)
			if nplayers[cn] == nil then
				notready(cn)
			end
		end
	};


	[".inter"] = {
	 function (cn, args)
		if table.getn(nplayers) == 0 then
			nargs = split(args, " ")
			inter(nargs[2], nargs[1])
    else
      print("Not all players are ready. The player(s) not ready is/are"..)
		end
	 end

	};

	[".match"] = {
	 function (cn, args)
		if table.getn(nplayers) == 0 then
			nargs = split(args, " ")
			match(nargs[2], nargs[1])
		end
	 end
	};
}

--Handlers
function onPlayerSayText(cn, text)
  	texta = split(text, " ")
	text2 = string.format("SCLog: Player %s says: %s. Their IP is: %s",getname(cn), texta ,getip(cn))
	logline(4, text2)

	local parts = split(text, " ")
	local command, args = parts[1], slice(parts, 2)
	local callback = commands[command][1]
	if commands[command] ~= nil then
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
	--  end

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
	--  end

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
	rplayers = {}
	numplay = 0
	match = false
end
onPlayerTeamChange(cn, team, reason)
	--Stop people from changing if they are playing a match
	if match == true
		if team == 1 or team == 0
			say(getname(cn)..", they are playing a match. You can't join.")
			setteam(cn, 4, 3)
		end
	end
end
