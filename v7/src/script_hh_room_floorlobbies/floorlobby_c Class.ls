property pBubbleList

on construct me 
  if not threadExists(#room) then
    return(error(me, "Room thread not found!!!", #construct))
  end if
  tRoomVis = getThread(#room).getInterface().getRoomVisualizer()
  if tRoomVis = 0 then
    return(error(me, "Room visualizer not found!", #construct))
  end if
  member.paletteRef = member(getmemnum("floorlobby_c palette"))
  i = 1
  repeat while 1
    tSpr = tRoomVis.getSprById("floor_" & i)
    if not tSpr then
    else
      member.paletteRef = member(getmemnum("floorlobby_c palette"))
      i = i + 1
    end if
  end repeat
  pBubbleList = []
  i = 1
  repeat while i <= 15
    tObj = createObject(#temp, "Floor Bubble Bottom Class")
    tObj.define(tRoomVis.getSprById("bubble" & i))
    pBubbleList.add(tObj)
    i = 1 + i
  end repeat
  receiveUpdate(me.getID())
  return(1)
end

on deconstruct me 
  removeUpdate(me.getID())
  pBubbleList = []
  return(1)
end

on update me 
  call(#update, pBubbleList)
end