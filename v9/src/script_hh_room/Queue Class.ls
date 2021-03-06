property pState, pAnimate, pFrameCounter, pMaxSkipFrames, pAnimFrame, pAnimStartTime, pAnimationTime

on prepare me, tdata 
  pAnimationTime = 600
  pMaxSkipFrames = 1
  pAnimFrame = 0
  pFrameCounter = 0
  tstate = tdata.getAt(#extra)
  if not voidp(tstate) then
    pState = tstate
  else
    pState = 2
  end if
  if (pState = 3) then
    pAnimStartTime = the milliSeconds
  end if
  tSpriteNo = 2
  repeat while tSpriteNo <= count(me.pSprList)
    removeEventBroker(me.getPropRef(#pSprList, tSpriteNo).spriteNum)
    tSpriteNo = (1 + tSpriteNo)
  end repeat
  return TRUE
end

on updateStuffdata me, tValue 
  pState = tValue
end

on setAnimation me, tValue 
  pAnimate = 1
  pAnimStartTime = the milliSeconds
  return TRUE
end

on update me 
  if pState < 2 then
    return TRUE
  else
    if pAnimate <> 1 then
      return TRUE
    else
      pFrameCounter = (pFrameCounter + 1)
      if pFrameCounter > pMaxSkipFrames then
        pFrameCounter = 0
        pAnimFrame = (pAnimFrame + 1)
        if pAnimFrame > 2 then
          pAnimFrame = 0
        end if
        the itemDelimiter = "_"
        tMemName = me.getPropRef(#pSprList, 4).member.name
        tClass = tMemName.getProp(#item, 1, (tMemName.count(#item) - 6))
        tNewName = tClass & "_d_0_1_1_" & me.getProp(#pDirection, 1) & "_" & pAnimFrame
        if memberExists(tNewName) then
          if me.count(#pSprList) > 3 then
            me.getPropRef(#pSprList, 4).castNum = abs(getmemnum(tNewName))
          end if
        end if
        if (pState = 2) then
          if (the milliSeconds - pAnimStartTime) > pAnimationTime then
            pAnimate = 0
          end if
        end if
      end if
    end if
  end if
end
