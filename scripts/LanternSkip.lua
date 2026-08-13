
function _OnInit()
GameVersion = 0
print('Beast Castle Lanturn Skip')
SetDriveToMax=false

end

function GetVersion() --Define anchor addresses
if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	OnPC = true
	if ReadString(0x9A9330,4) == 'KH2J' then --EGS
		GameVersion = 2
		Save = 0x09A9330
		Now = 0x0716DF8
		Slot1  = 0x2A23018
		Cntrl = 0x2A16C68
		PlayerGaugePointer = 0x0ABCCC8 
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
		GameVersion = 3
		Save = 0x09A98B0
		Now = 0x0717008
		Slot1    = 0x2A23598
		Cntrl = 0x2A171E8
		PlayerGaugePointer = 0x0ABD248 
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
		GameVersion = 4
		Save = 0x09A98B0
		Now = 0x0717008
		Slot1    = 0x2A23598
		Cntrl = 0x2A171E8
		PlayerGaugePointer = 0x0ABD248 
	end
end

end
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
function RevertSora()
	if ReadByte(Save+0x3524)~=0 or ReadByte(Save+0x3525)~=0 then --player would revert here in normal
		WriteByte(Save+0x3524,0) --revert sora to base
		WriteByte(Save+0x3525,0) -- remove summon
		SetDriveToMax=true
	end
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
	PrevPlace = ReadShort(Now+0x30)
end
--3077
if Place==3077 and Map==2 and Btl==22 and Evt==2 then
	Warp(0x05,12,0,0,0,3) --revert drive?
	RevertSora()
	WriteByte(Save+0x07C0,5) -- place 2053 west hall
	WriteByte(Save+0x07C0+2,2)
	WriteByte(Save+0x07C0+4,0)
	
	WriteByte(Save+0x07C6,0) --west wing
	WriteByte(Save+0x07C6+2,1)
	WriteByte(Save+0x07C6+4,0)

	WriteByte(Save+0x07A2+4,1) -- start beast fight
end
--if in a weird state where the door is closed but its after lanterns
if Place==3077 and Map==2 and Btl==1 and Evt==0 then
	if PrevPlace==2053 then
		Warp(0x05,12,1,0,0,3)
	else
		Warp(0x05,12,0,0,0,3)
	end
end
if Place==3077 and SetDriveToMax then --if player has been reverted
	WriteByte(Slot1+0x01B1,ReadByte(Slot1+0x01B2)) --set gauge to max
	if ReadByte(Slot1+0x01B1) == ReadByte(Slot1+0x01B2) and ReadLong(PlayerGaugePointer)~=0 then --check if it has and sora is laoded
		SetDriveToMax=false -- only refill it once
	end
end

end
