
function _OnInit()
GameVersion = 0
print('Magic Carpet Skip')
end

function GetVersion() --Define anchor addresses
if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	OnPC = true
	if ReadString(0x9A9330,4) == 'KH2J' then --EGS
		GameVersion = 2
		print('GoA Epic Version')
		Save = 0x09A9330
		Now = 0x0716DF8
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
		GameVersion = 3
		print('GoA Steam Global Version')
		Save = 0x09A98B0
		Now = 0x0717008
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
		GameVersion = 4
		print('GoA Steam JP Version')
		Save = 0x09A98B0
		Now = 0x0717008
	end
end

end
Slot1    = 0x2A23018
function Warp(W,R,D,M,B,E) --Warp into the appropriate World, Room, Door, Map, Btl, Evt
M = M or ReadShort(Save + 0x10 + 0x180*W + 0x6*R)
B = B or ReadShort(Save + 0x10 + 0x180*W + 0x6*R + 2)
E = E or ReadShort(Save + 0x10 + 0x180*W + 0x6*R + 4)
WriteByte(Now+0x00,W)
WriteByte(Now+0x01,R)
WriteShort(Now+0x02,D)
WriteShort(Now+0x04,M)
WriteShort(Now+0x06,B)
WriteShort(Now+0x08,E)
--Record Location in Save File
WriteByte(Save+0x000C,W)
WriteByte(Save+0x000D,R)
WriteShort(Save+0x000E,D)
end

function Events(M,B,E) --Check for Map, Btl, and Evt
return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
end

function _OnFrame()
if GameVersion == 0 then --Get anchor addresses
	GetVersion()
	return
elseif GameVersion < 0 then --Incompatible version
	return
end
if true then --Define current values for common addresses
	Place  = ReadShort(Now+0x00)
	Map    = ReadShort(Now+0x04)
	Btl    = ReadShort(Now+0x06)
	Evt    = ReadShort(Now+0x08)
end

if Place == 3591 and Map==4 and Btl==14 and Evt == 17 then
	Warp(0x07,0x0B,0x00,0x01) -- warp to ruined chamber
	WriteByte(Save+0x0AD2+4,0x0A)--set cutscene in the ruined chamber to play
end

if Place == 3591 and Map==61 and Btl == 61 and Evt==61 then -- auto scroll carpet skip
	Warp(0x07,0x06,0x33,0x00,0x00,0x14) -- warp to save point room
	WriteByte(Save+0x0AA2+4,0x0A) -- set genie jafar flag
end
end
