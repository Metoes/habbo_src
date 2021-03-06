property pAnimFrameDuration, pUpdateCount, pProgramOn, pAnimLoop, pAnimFrameCounter, pAnimFrame, pTotalFrameCount, pTotalLoopCount, pUpdatesToWaitOnLastFrame

on prepare me, tdata 
  pUpdateCount = 0
  pAnimFrame = 0
  pAnimLoop = 1
  pUpdatesToWaitOnLastFrame = 1
  if (me.pXFactor = 32) then
    pAnimFrameDuration = 1
    pTotalLoopCount = 0
  else
    pAnimFrameDuration = 15
    pTotalLoopCount = 1
  end if
  pAnimFrameCounter = pAnimFrameDuration
  pTotalFrameCount = 1
  if (tdata.getAt(#stuffdata) = "ON") then
    me.setOn()
  else
    me.setOff()
  end if
  return TRUE
end

on updateStuffdata me, tValue 
  if (tValue = "ON") then
    me.setOn()
  else
    me.setOff()
  end if
end

on update me 
  if me.count(#pSprList) < 4 then
    return FALSE
  end if
  pUpdateCount = (pUpdateCount + 1)
  if pUpdateCount < 3 then
    return TRUE
  end if
  pUpdateCount = 0
  tName = me.getPropRef(#pSprList, 4).member.name
  tDelim = the itemDelimiter
  the itemDelimiter = "_"
  tName = tName.getProp(#item, 1, (tName.count(#item) - 1)) & "_"
  the itemDelimiter = tDelim
  if pProgramOn then
    if pAnimLoop >= 1 then
      pAnimFrameCounter = (pAnimFrameCounter + 1)
      if pAnimFrameCounter < pAnimFrameDuration then
        return TRUE
      end if
      pAnimFrameCounter = 0
      tNewName = tName & pAnimFrame
      pAnimFrame = (pAnimFrame + 1)
      if pTotalFrameCount <= pAnimFrame and memberExists(tName & (pAnimFrame + 1)) then
        pTotalFrameCount = (pAnimFrame + 1)
      end if
      if (pAnimFrame = pTotalFrameCount) then
        if pAnimLoop < pTotalLoopCount then
          pAnimFrame = 1
          pAnimLoop = (pAnimLoop + 1)
        else
          pAnimLoop = 0
          tNewName = tName & pAnimFrame
          pUpdatesToWaitOnLastFrame = (30 + random(40))
        end if
      end if
    else
      if (pAnimLoop = 0) then
        if pAnimFrame <= pUpdatesToWaitOnLastFrame then
          pAnimFrame = (pAnimFrame + 1)
          return TRUE
        else
          pAnimFrame = 1
          pAnimLoop = 1
          return TRUE
        end if
      end if
    end if
  else
    tNewName = tName & "0"
  end if
  if memberExists(tNewName) then
    tmember = member(getmemnum(tNewName))
    me.getPropRef(#pSprList, 4).castNum = tmember.number
    me.getPropRef(#pSprList, 4).width = tmember.width
    me.getPropRef(#pSprList, 4).height = tmember.height
  end if
  me.getPropRef(#pSprList, 4).locZ = (me.getPropRef(#pSprList, 1).locZ + 2)
end

on setOn me 
  pFramesToWaitOnLastFrame = 0
  pAnimFrameCounter = pAnimFrameDuration
  if (me.pXFactor = 32) then
    pTotalLoopCount = (4 + random(6))
  else
    pTotalLoopCount = 1
  end if
  pAnimLoop = 1
  pAnimFrame = 1
  pProgramOn = 1
end

on setOff me 
  pProgramOn = 0
end

on select me 
  if the doubleClick then
    if pProgramOn then
      tOnString = "OFF"
    else
      tOnString = "ON"
    end if
    getThread(#room).getComponent().getRoomConnection().send("SETSTUFFDATA", [#string:string(me.getID()), #string:tOnString])
  end if
end
