property pRecyclerButtonSpr, pNormalMem, pButtonLoc, pStatusWindowID, pSkippedFrames, pFLashOn, pHighlightMem

on construct me 
  pRecyclerButtonSpr = void()
  pButtonLoc = point(5, 5)
  pNormalMem = member(getmemnum(getVariableValue("recycler.status.icon.normal")))
  pHighlightMem = member(getmemnum(getVariableValue("recycler.status.icon.highlight")))
  pStatusWindowID = getText("recycler_status_window_title")
end

on deconstruct me 
  removePrepare(me.getID())
  if (ilk(pRecyclerButtonSpr) = #sprite) then
    pRecyclerButtonSpr.visible = 0
  end if
  pRecyclerButtonSpr = void()
end

on showRecyclerButton me, tstate 
  if voidp(tstate) then
    tstate = "normal"
  end if
  if pRecyclerButtonSpr.ilk <> #sprite then
    pRecyclerButtonSpr = sprite(reserveSprite(me.getID()))
    if (pRecyclerButtonSpr = sprite(0)) then
      return FALSE
    end if
  end if
  pRecyclerButtonSpr.member = pNormalMem
  pRecyclerButtonSpr.ink = 8
  pRecyclerButtonSpr.loc = pButtonLoc
  pRecyclerButtonSpr.locZ = 200000000
  pRecyclerButtonSpr.visible = 1
  setEventBroker(pRecyclerButtonSpr.spriteNum, me.getID() & "_spr")
  pRecyclerButtonSpr.registerProcedure(#eventProcRecyclerButton, me.getID(), #mouseUp)
  pRecyclerButtonSpr.setcursor("cursor.finger")
  if (tstate = "highlight") then
    me.setFlashing(1)
  else
    me.setFlashing(0)
  end if
  return TRUE
end

on hideRecyclerButton me 
  if pRecyclerButtonSpr.ilk <> #sprite then
    return FALSE
  end if
  pRecyclerButtonSpr.visible = 0
end

on setFlashing me, tFlashingOn 
  if voidp(tFlashingOn) then
    tFlashingOn = 0
  end if
  if tFlashingOn then
    receivePrepare(me.getID())
  else
    removePrepare(me.getID())
    if (pRecyclerButtonSpr.ilk = #sprite) then
      pRecyclerButtonSpr.member = pNormalMem
    end if
  end if
end

on openCloseStatusWindow me 
  if windowExists(pStatusWindowID) then
    me.closeStatusWindow()
  else
    me.createStatusWindow()
  end if
end

on eventProcRecyclerButton me, tEvent, tSprID, tProp 
  if (tEvent = #mouseUp) then
    if tSprID <> "recycler_note_ok" then
      if (tSprID = "rec_status_icon_spr") then
        me.openCloseStatusWindow()
      end if
    end if
  end if
end

on createStatusWindow me 
  if not createWindow(pStatusWindowID, "habbo_full.window") then
    return(error(me, "Failed to create status window", #createStatusWindow))
  end if
  tWindowObj = getWindow(pStatusWindowID)
  tWindowObj.merge("recycler_notification.window")
  tWindowObj.registerProcedure(#eventProcRecyclerButton, me.getID(), #mouseUp)
end

on closeStatusWindow me 
  removeWindow(pStatusWindowID)
end

on prepare me 
  pSkippedFrames = (pSkippedFrames - 1)
  if pSkippedFrames < 0 then
    pSkippedFrames = 15
  else
    return FALSE
  end if
  if pFLashOn then
    pRecyclerButtonSpr.member = pNormalMem
    pFLashOn = 0
  else
    pRecyclerButtonSpr.member = pHighlightMem
    pFLashOn = 1
  end if
end
