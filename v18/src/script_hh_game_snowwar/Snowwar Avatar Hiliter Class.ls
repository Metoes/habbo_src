property pNameSpriteNum, pBottomSpriteNum, pNameFieldMemName

on display me, tName, tScore, tTeamId, tloc, tOwnPlayer 
  if not stringp(tName) then
    return(error(me, "String expected by hiliter.", #display))
  end if
  pNameSpriteNum = reserveSprite("sw_hiliter1_" & tName & tTeamId)
  pBottomSpriteNum = reserveSprite("sw_hiliter2_" & tName & tTeamId)
  if (pNameSpriteNum = 0) or (pBottomSpriteNum = 0) then
    return FALSE
  end if
  tText = getText("gs_mouseover_player")
  tText = replaceChunks(tText, "\\x", tName)
  tText = replaceChunks(tText, "\\r", "\r")
  tText = replaceChunks(tText, "\\y", tScore)
  tmember = me.getNameFieldMember(tText, tTeamId)
  tsprite = sprite(pNameSpriteNum)
  if tmember <> 0 then
    tsprite.member = tmember
  end if
  tsprite.locZ = 1000000
  tsprite.loc = point((tloc.getAt(1) - (tmember.width / 2)), (tloc.getAt(2) + 10))
  tsprite.ink = 36
  if not tOwnPlayer then
    tmember = member(getmemnum("sw_avatar_hilite_team_" & tTeamId))
    tsprite = sprite(pBottomSpriteNum)
    if (tmember.type = #bitmap) then
      tsprite.member = tmember
    end if
    tsprite.locZ = (tloc.getAt(3) - 1)
    tsprite.loc = point(tloc.getAt(1), tloc.getAt(2))
    tsprite.ink = 36
  end if
  return TRUE
end

on hide me 
  if memberExists(pNameFieldMemName) then
    removeMember(pNameFieldMemName)
  end if
  if pNameSpriteNum > 0 then
    releaseSprite(pNameSpriteNum)
  end if
  if pBottomSpriteNum > 0 then
    releaseSprite(pBottomSpriteNum)
  end if
  pNameSpriteNum = void()
  pBottomSpriteNum = void()
  return FALSE
end

on getNameFieldMember me, tText, tTeamId 
  pNameFieldMemName = "____sw_hilite_field"
  if not memberExists(pNameFieldMemName) then
    tNameFieldMem = member(createMember(pNameFieldMemName, #text))
  else
    tNameFieldMem = getMember(pNameFieldMemName)
  end if
  if (tNameFieldMem.type = #empty) then
    return FALSE
  end if
  tTeamColor = rgb(string(getVariable("snowwar.teamcolors.team" & tTeamId)))
  tFontStruct = getStructVariable("struct.font.bold")
  tNameFieldMem.color = tTeamColor
  tNameFieldMem.fontSize = tFontStruct.getAt(#fontSize)
  tNameFieldMem.alignment = #center
  tNameFieldMem.fontStyle = tFontStruct.getAt(#fontStyle)
  tNameFieldMem.font = tFontStruct.getAt(#font)
  tNameFieldMem.text = tText
  return(tNameFieldMem)
end
