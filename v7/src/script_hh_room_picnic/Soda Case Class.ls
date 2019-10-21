property pTokenList

on prepare me 
  pTokenList = value(getVariable("obj_" & me.pClass, "lemonade"))
  if not listp(pTokenList) then
    pTokenList = [7]
  end if
  return TRUE
end

on select me 
  if not threadExists(#room) then
    return(error(me, "Room thread not found!!!", #select))
  end if
  tUserObj = getThread(#room).getComponent().getOwnUser()
  if not tUserObj then
    return(error(me, "User object not found:" && getObject(#session).get("user_name"), #select))
  end if
  if abs((me.pLocX - tUserObj.pLocX)) < 2 and abs((me.pLocY - tUserObj.pLocY)) < 2 then
    me.giveDrink()
  end if
  return TRUE
end

on giveDrink me 
  getThread(#room).getComponent().getRoomConnection().send("LOOKTO", me.pLocX && me.pLocY)
  getThread(#room).getComponent().getRoomConnection().send("CARRYDRINK", pTokenList.getAt(random(pTokenList.count)))
end
