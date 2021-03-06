property pScore

on prepare me, tdata 
  pScore = 0
  tTemp = tdata.getaProp(#stuffdata)
  me.setScore(tTemp, me.pSprList)
  return TRUE
end

on relocate me, tSpriteList 
  me.setScore(pScore, tSpriteList)
end

on updateStuffdata me, tValue 
  me.setScore(tValue, me.pSprList)
end

on setScore me, tScore, tSpriteList 
  if tSpriteList.count < 4 then
    return FALSE
  end if
  if (me.pXFactor = 32) then
    tClass = "s_hockey_score"
    if (me.getProp(#pDirection, 1) = 2) then
      tLoc3 = (tSpriteList.getAt(1).loc + [26, -100])
      tLoc4 = (tSpriteList.getAt(1).loc + [32, -103])
    else
      tLoc3 = (tSpriteList.getAt(1).loc + [-44, -105])
      tLoc4 = (tSpriteList.getAt(1).loc + [-38, -102])
    end if
  else
    tClass = "hockey_score"
    if (me.getProp(#pDirection, 1) = 2) then
      tLoc3 = (tSpriteList.getAt(1).loc + [26, -100])
      tLoc4 = (tSpriteList.getAt(1).loc + [36, -105])
    else
      tLoc3 = (tSpriteList.getAt(1).loc + [-44, -105])
      tLoc4 = (tSpriteList.getAt(1).loc + [-34, -100])
    end if
  end if
  tScore = integer(tScore)
  if tScore < 0 then
    pScore = "x"
    tSpriteList.getAt(3).blend = 0
    tSpriteList.getAt(4).blend = 0
    return TRUE
  end if
  pScore = integer(tScore)
  if pScore.ilk <> #integer then
    pScore = 0
  end if
  if pScore < 0 then
    pScore = 99
  end if
  if pScore > 99 then
    pScore = 0
  end if
  tString = string(pScore)
  if (length(tString) = 1) then
    tString = "0" & tString
  end if
  tSpriteList.getAt(3).member = member(getmemnum(tClass & "_" & me.getProp(#pDirection, 1) & "_" & tString.getProp(#char, 1)))
  tSpriteList.getAt(4).member = member(getmemnum(tClass & "_" & me.getProp(#pDirection, 1) & "_" & tString.getProp(#char, 2)))
  tSpriteList.getAt(3).loc = tLoc3
  tSpriteList.getAt(4).loc = tLoc4
  tSpriteList.getAt(3).width = tSpriteList.getAt(3).member.width
  tSpriteList.getAt(3).height = tSpriteList.getAt(3).member.height
  tSpriteList.getAt(4).width = tSpriteList.getAt(4).member.width
  tSpriteList.getAt(4).height = tSpriteList.getAt(4).member.height
  tSpriteList.getAt(3).blend = 100
  tSpriteList.getAt(4).blend = 100
  return TRUE
end

on select me 
  if me.count(#pSprList) < 1 then
    return FALSE
  end if
  tConnection = getThread(#room).getComponent().getRoomConnection()
  if (tConnection = 0) then
    return FALSE
  end if
  tUpdate = 0
  tScore = pScore
  tloc = point((the mouseH - me.getPropRef(#pSprList, 1).left), (the mouseV - me.getPropRef(#pSprList, 1).top))
  if (me.pXFactor = 32) then
    tRect1 = rect(0, 53, 12, 66)
    tRect2 = rect(13, 53, 23, 66)
  else
    tRect1 = rect(14, 108, 22, 116)
    tRect2 = rect(26, 108, 34, 116)
  end if
  if pScore <> "x" then
    if inside(tloc, tRect1) then
      tUpdate = 1
      tConnection.send("USEFURNITURE", [#integer:integer(me.getID()), #integer:1])
    else
      if inside(tloc, tRect2) then
        tUpdate = 1
        tConnection.send("USEFURNITURE", [#integer:integer(me.getID()), #integer:2])
      end if
    end if
  end if
  if tUpdate then
    return TRUE
  end if
  if the doubleClick then
    tConnection.send("USEFURNITURE", [#integer:integer(me.getID()), #integer:0])
  end if
  return TRUE
end
