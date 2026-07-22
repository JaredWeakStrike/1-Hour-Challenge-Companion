
function _OnInit()
    GameVersion = 0
end
function _OnFrame()
    if true then --Define current values for common addresses
        if GameVersion==0 then
            if ReadString(0x9A9330,4) == 'KH2J' then --EGS
                drive1=0x3F200E
                drive2=0x4011A4
                drive3=0x3E2AEC
                drive4=0x4011F8
                drive5=0x3FFE34
                drive6=0x3C223E
                drive7=0x3F202A
                GameVersion=1
                Now = 0x0716DF8
                Save = 0x09A9330
            end
            if ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
                drive1=0x3F2D2E
                drive2=0x401EC4
                drive3=0x3E380C
                drive4=0x401F18
                drive5=0x400B54
                drive6=0x3C2F5E
                drive7=0x3F2D4A
                GameVersion=2
                Now = 0x0717008
                Save = 0x09A98B0
            end
        end
        if GameVersion==0 then
            return
        end

        World  = ReadByte(Now+0x00)
        Room   = ReadByte(Now+0x01)
        Place  = ReadShort(Now+0x00)
        Door   = ReadShort(Now+0x02)
        Map    = ReadShort(Now+0x04)
        Btl    = ReadShort(Now+0x06)
        Evt    = ReadShort(Now+0x08)
        PrevPlace = ReadShort(Now+0x30)
    end

    -- if room is before datas and place is before datas and they are not in stt
	-- if world == 100aw then give ability to go into drive
	-- credit to ksx for the base of this lua script
    if World==9 or (Room==33 and Place==8450 and ReadShort(Save+0x1CF9)<1) then
        if ReadByte(drive1) == 0x74 then
            WriteByte(drive1, 0x77)
            WriteShort(drive2, 0x820F)
            WriteByte(drive3, 0x72)
            WriteShort(drive4, 0x820F)
            WriteByte(drive5, 0x7D)
            WriteByte(drive6, 0x7D)
            WriteByte(drive7, 0x03)
            end
    elseif ReadByte(drive1)==0x77 then
        WriteByte(drive1, 0x74)
        WriteShort(drive2, 0x850F)
        WriteByte(drive3, 0x78)
        WriteShort(drive4, 0x850F)
        WriteByte(drive5, 0x74)
        WriteByte(drive6, 0x74)
        WriteByte(drive7, 0x01)
    end
end

