property pTutorWindowID, pPose, pTutorWindow

on construct me 
  me.pTutorWindowID = "Tutor_character"
  createWindow(pTutorWindowID, "guide_character.window")
  me.pTutorWindow = getWindow(pTutorWindowID)
  me.pBubble = createObject(getUniqueID(), ["Bubble Class", "Link Bubble Class"])
  me.hide()
  me.setProperty(#targetID, "guide_image")
  me.setProperty([#offsetx:50])
  me.update()
  if variableExists("tutorial.tutor.default.x") then
    me.pDefPosX = getVariable("tutorial.tutor.default.x")
  else
    me.pDefPosX = 20
  end if
  if variableExists("tutorial.tutor.default.y") then
    me.pDefPosY = getVariable("tutorial.tutor.default.y")
  else
    me.pDefPosY = 250
  end if
  me.pPose = 1
  return(1)
end

on deconstruct me 
  removeObject(me.getID())
  removeWindow(me.getProperty(#id))
end

on hideLinks me 
  me.setLinks(void())
end

on update me 
  me.update()
  return([me.pTutorWindowID, me.getProperty(#windowId)])
end

on setProperties me, tProperties 
  if not listp(tProperties) then
    return(0)
  end if
  i = 1
  repeat while i <= tProperties.count
    me.setProperty(tProperties.getPropAt(i), tProperties.getAt(i))
    i = 1 + i
  end repeat
end

on getProperty me, tProp 
  if tProp = #sex then
    return(me.pSex)
  end if
end

on setProperty me, tProperty, tValue 
  if tProperty = #textKey then
    tText = getText(tValue)
    tText = replaceChunks(tText, "\\n", "\r" & "\r")
    me.setText(tText)
  else
    if tProperty = #offsetx then
      tValue = value(tValue)
      if not tValue then
        me.pPosX = me.pDefPosX
      else
        me.pPosX = tValue
      end if
      me.moveTo(me.pPosX, me.pPosY)
    else
      if tProperty = #offsety then
        tValue = value(tValue)
        if not tValue then
          me.pPosY = me.pDefPosY
        else
          me.pPosY = tValue
        end if
        me.moveTo(me.pPosX, me.pPosY)
      else
        if tProperty = #links then
          me.setLinks(tValue)
          if tValue.ilk = #propList then
            if not voidp(tValue.getaProp(#menu)) then
              me.addText("tutorial_next")
            end if
          end if
        else
          if tProperty = #sex then
            me.pSex = tValue
            me.updateImage()
          else
            if tProperty <> #pose then
              if tProperty = #direction then
                me.pPose = tValue
                me.updateImage()
              else
                if tProperty = #topics then
                  me.pTopicList = tValue
                else
                  if tProperty = #statuses then
                    me.setCheckmarks(tValue)
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
end

on moveTo me, tX, tY 
  me.pPosX = tX
  me.pPosY = tY
  me.moveTo(me.pPosX, me.pPosY)
  me.update()
end

on hide me 
  me.hide()
  me.hide()
end

on show me 
  if voidp(me.pimage) then
    return(0)
  end if
  me.updateImage()
  me.show()
  me.show()
end

on updateImage me 
  if voidp(me.pSex) or voidp(pPose) then
    return(0)
  end if
  tPose = integer(me.pPose)
  me.pFlipped = 0
  if tPose > 10 then
    return(0)
  end if
  tImageElem = pTutorWindow.getElement("guide_image")
  if tPose < 0 then
    tPose = -tPose
    me.pFlipped = 1
  end if
  tMemberName = "tutor_" & me.pSex & "_" & string(tPose)
  me.pimage = member(getmemnum(tMemberName)).image
  if voidp(me.pimage) then
    return(0)
  end if
  tImageElem.feedImage(me.pimage)
  if me.pFlipped then
    tImageElem.flipH()
    tImageElem.render()
  end if
  tImageElem.resizeTo(me.width, me.height, 1)
  me.updateShadow()
end

on updateShadow me 
  tShadow = image(me.width, me.height, 8)
  tBlack = image(me.width, me.height, 8)
  tBlack.fill(tBlack.rect, rgb("#000000"))
  tShadow.copyPixels(tBlack, tShadow.rect, tBlack.rect, [#maskImage:me.createMatte()])
  tElem = me.getElement("guide_shadow")
  tElem.feedImage(tShadow)
  tElem.resizeTo(tShadow.width, tShadow.height, 1)
  if me.pFlipped then
    tElem.flipH()
    tElem.render()
  end if
end