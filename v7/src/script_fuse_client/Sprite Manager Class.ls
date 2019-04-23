property pTotalSprList, pFreeSprList, pClientList, pEventBroker

on construct me 
  pTotalSprList = void()
  pFreeSprList = void()
  pClientList = void()
  pEventBroker = script(getVariable("event.broker.behavior"))
  return(me.preIndexChannels())
end

on deconstruct me 
  return(1)
end

on getProperty me, tPropID 
  if tPropID = #totalSprCount then
    return(pTotalSprList.count)
  else
    if tPropID = #freeSprCount then
      return(pFreeSprList.count)
    else
      return(0)
    end if
  end if
end

on setProperty me, tPropID, tValue 
  return(0)
end

on reserveSprite me, tClientID 
  if pFreeSprList.count = 0 then
    return(error(me, "Out of free sprite channels!", #reserveSprite))
  end if
  tSprNum = pFreeSprList.getAt(1)
  tSprite = sprite(tSprNum)
  pFreeSprList.deleteAt(1)
  puppetSprite(tSprNum, 1)
  tSprite.stretch = 0
  tSprite.locV = -1000
  tSprite.visible = 1
  pClientList.setAt(tSprNum, tClientID)
  return(tSprNum)
end

on releaseSprite me, tSprNum 
  if pTotalSprList.getPos(tSprNum) < 1 then
    return(error(me, "Sprite not marked as usable:" && tSprNum, #releaseSprite))
  end if
  if pFreeSprList.getPos(tSprNum) > 0 then
    return(error(me, "Attempting to release free sprite!", #releaseSprite))
  end if
  tSprite = sprite(tSprNum)
  tSprite.member = member(0)
  tSprite.scriptInstanceList = []
  tSprite.rect = rect(0, 0, 1, 1)
  tSprite.locZ = tSprNum
  tSprite.visible = 0
  tSprite.castNum = 0
  tSprite.cursor = 0
  tSprite.blend = 100
  puppetSprite(tSprNum, 0)
  tSprite.locZ = void()
  pFreeSprList.append(tSprNum)
  pClientList.setAt(tSprNum, 0)
  return(1)
end

on releaseAllSprites me 
  pFreeSprList = []
  repeat while pTotalSprList.count <= undefined
    tSprNum = getAt(undefined, undefined)
    me.releaseSprite(tSprNum)
  end repeat
  return(1)
end

on setEventBroker me, tSprNum, tid 
  if pTotalSprList.getPos(tSprNum) < 1 then
    return(error(me, "Sprite not marked as usable:" && tSprNum, #setEventBroker))
  end if
  if pFreeSprList.getPos(tSprNum) > 0 then
    return(error(me, "Attempted to modify non-reserved sprite!", #setEventBroker))
  end if
  tSprite = sprite(tSprNum)
  tSprite.scriptInstanceList = [new(pEventBroker)]
  tSprite.setID(tid)
  return(1)
end

on removeEventBroker me, tSprNum 
  if pTotalSprList.getPos(tSprNum) < 1 then
    return(error(me, "Sprite not marked as usable:" && tSprNum, #removeEventBroker))
  end if
  if pFreeSprList.getPos(tSprNum) > 0 then
    return(error(me, "Attempted to modify non reserved sprite!", #removeEventBroker))
  end if
  sprite(tSprNum).scriptInstanceList = []
  return(1)
end

on print me, tCount 
  if integerp(tCount) then
    if tCount > the lastChannel then
      tCount = the lastChannel
    end if
    i = 1
    repeat while i <= tCount
      put(sprite(i) && member.name && "--" && sprite(i).locZ && "--" && sprite(i).rect && "--" && pClientList.getAt(sprite(i).spriteNum))
      i = 1 + i
    end repeat
    exit repeat
  end if
  repeat while sprite(i).spriteNum && "--" <= undefined
    tNum = getAt(undefined, tCount)
    if pFreeSprList.getPos(tNum) < 1 then
      tSymbol = "#"
    else
      tSymbol = space()
    end if
    put(sprite(tNum) && member.name && "--" && sprite(tNum).locZ && "--" && sprite(tNum).rect && "--" && pClientList.getAt(tNum))
  end repeat
end

on preIndexChannels me 
  pTotalSprList = []
  pFreeSprList = []
  pClientList = []
  i = 1
  repeat while i <= the lastChannel
    pTotalSprList.add(i)
    pClientList.add(0)
    puppetSprite(i, 1)
    sprite(i).visible = 0
    i = 1 + i
  end repeat
  pFreeSprList = pTotalSprList.duplicate()
  pTotalSprList.sort()
  return(1)
end