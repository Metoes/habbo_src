property pArrowSpr, pCounter, pUserId, pLastLoc, pLastDir, pSize, pAnimFlag, pAnimCntr

on construct me 
  pArrowSpr = sprite(reserveSprite(me.getID()))
  pArrowSpr.ink = 8
  pArrowSpr.visible = 0
  pLastLoc = void()
  pLastDir = void()
  pUserId = ""
  pAnimFlag = 0
  pAnimCntr = 0
  return TRUE
end

on deconstruct me 
  removeUpdate(me.getID())
  releaseSprite(pArrowSpr.spriteNum)
  return TRUE
end

on Init me 
  tXFactor = getThread(#room).getInterface().getGeometry().pXFactor
  pArrowSpr.locZ = (getIntVariable("window.default.locz") - 2020)
  pArrowSpr.visible = 0
  if integer(tXFactor) > 32 then
    pSize = "h"
  else
    pSize = "sh"
  end if
end

on show me, tUserID, tAnimFlag 
  if stringp(tUserID) then
    pUserId = tUserID
  else
    pUserId = getThread(#room).getInterface().getSelectedObject()
  end if
  pArrowSpr.loc = point(-1000, -1000)
  pArrowSpr.visible = 1
  pCounter = 0
  pLastLoc = void()
  pLastDir = void()
  pAnimCntr = 0
  pAnimFlag = (tAnimFlag = 1)
  receiveUpdate(me.getID())
  return TRUE
end

on hide me 
  removeUpdate(me.getID())
  pArrowSpr.loc = point(-1000, -1000)
  pArrowSpr.visible = 0
  return TRUE
end

on update me 
  pCounter = not pCounter
  if pCounter then
    return FALSE
  end if
  tHumanObj = getThread(#room).getComponent().getUserObject(pUserId)
  if (tHumanObj = 0) then
    return(me.hide())
  end if
  tHumanLoc = tHumanObj.getPartLocation("hd")
  tHumanDir = tHumanObj.getDirection()
  if voidp(pLastLoc) then
    pLastLoc = point(0, 0)
  end if
  tChanges = 0
  if tHumanDir <> pLastDir then
    tChanges = 1
  end if
  if ilk(tHumanLoc) <> #point or ilk(pLastLoc) <> #point then
    return FALSE
  else
    if tHumanLoc <> pLastLoc then
      if tHumanLoc.getAt(1) <> pLastLoc.getAt(1) then
        tChanges = 1
      else
        if abs((tHumanLoc.getAt(2) - pLastLoc.getAt(2))) > 1 then
          tChanges = 1
        end if
      end if
    end if
  end if
  if tChanges then
    pLastLoc = tHumanLoc
    pLastDir = tHumanDir
    tdir = 2
    if tHumanDir < 4 then
      pArrowSpr.flipH = 0
    else
      pArrowSpr.flipH = 1
    end if
    pArrowSpr.member = member(getmemnum("puppet_hilite_" & pSize & "_" & tdir))
    if (pSize = "h") then
      tLocV = 60
    else
      tLocV = 40
    end if
    pArrowSpr.loc = point(tHumanLoc.getAt(1), (tHumanLoc.getAt(2) - tLocV))
    return TRUE
  end if
  if (pSize = "h") then
    tLocV = 60
  else
    tLocV = 40
  end if
  if pAnimFlag then
    pAnimCntr = ((pAnimCntr + 4) mod 32)
    tOffY = (tHumanLoc.getAt(2) + (-8 * sin((float(pAnimCntr) / 10))))
    pArrowSpr.locV = (tOffY - tLocV)
  end if
end
