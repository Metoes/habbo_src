property pUserList, pUserListFilter, pTicketsLeft

on construct me 
  pUserList = void()
  pExcludeList = []
  pUserListFilter = 1
  pTicketsLeft = 0
  return(1)
end

on deconstruct me 
  return(me.deconstruct())
end

on getUserList me 
  if pUserList = void() then
    return(me.getHandler().send_LIST_POSSIBLE_INVITEES(pUserListFilter))
  end if
  return(pUserList)
end

on changeUserListFilter me, tFilter 
  if tFilter = void() then
    return(0)
  end if
  if tFilter = pUserListFilter then
    return(1)
  end if
  pUserListFilter = tFilter
  return(me.getHandler().send_LIST_POSSIBLE_INVITEES(pUserListFilter))
end

on getUserListFilter me 
  return(pUserListFilter)
end

on sendInviteToListIndex me, tIndex, tMessage 
  if tIndex = void() then
    return(0)
  end if
  if pUserList = void() then
    return(0)
  end if
  if pUserList.count < tIndex then
    return(0)
  end if
  tUserName = pUserList.getAt(tIndex)
  me.getHandler().send_INVITE_USER(tUserName, tMessage)
  me.append(tUserName)
  return(1)
end

on sendInviteToName me, tUserName, tMessage 
  if tUserName = "" then
    return(0)
  end if
  me.getHandler().send_INVITE_USER(tUserName, tMessage)
  me.append(tUserName)
  return(1)
end

on excludeListIndex me, tIndex 
  if tIndex = void() then
    return(0)
  end if
  if pUserList = void() then
    return(0)
  end if
  if pUserList.count < tIndex then
    return(0)
  end if
  tUserName = pUserList.getAt(tIndex)
  me.append(tUserName)
  return(1)
end

on saveInviteTicketCount me, tNum 
  pTicketsLeft = tNum
  return(1)
end

on getInviteTicketCount me 
  return(pTicketsLeft)
end

on showInviteResponse me, tdata 
  return(1)
end

on saveInviteData me, tdata 
  pUserListFilter = tdata.getaProp(#list_type)
  pUserList = tdata.getaProp(#invitee_list)
  return(1)
end

on update me 
end

on render me 
end