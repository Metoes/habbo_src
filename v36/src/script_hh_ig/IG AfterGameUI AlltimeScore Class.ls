on addWindows me 
  me.pWindowID = "ac"
  tService = me.getIGComponent("AfterGame")
  if (tService = 0) then
    return FALSE
  end if
  tGameRef = tService.getScoreData()
  if (tGameRef = 0) then
    return FALSE
  end if
  tWrapObjRef = me.getWindowWrapper()
  if (tWrapObjRef = 0) then
    return FALSE
  end if
  tWrapObjRef.moveTo(4, 2)
  tOwnTeamId = tGameRef.getOwnPlayerTeam()
  tOwnTeamInfo = tGameRef.getTeam(tOwnTeamId)
  tOwnTeamPos = tOwnTeamInfo.getaProp(#pos)
  tOwnTeamScore = tOwnTeamInfo.getaProp(#score)
  tOwnPlayerInfo = tGameRef.getPlayerById(me.getOwnPlayerGameIndex(), tOwnTeamId)
  tWrapObjRef.addOneWindow(me.getWindowItemId(1), "ig_ag_score_min.window", me.pWindowSetId, [#scrollFromLocX:-100, #spaceBottom:2])
  me.setTeamScore(me.getWindowItemId(1), tOwnTeamId, tOwnTeamScore)
  me.setTeamColorBackground(me.getWindowItemId(1), tOwnTeamId)
  me.setScoreWindowIcon(me.getWindowItemId(1), tOwnTeamPos)
  me.setScoreWindowPlayer(me.getWindowItemId(1), 1, tOwnPlayerInfo, 1)
  tScrollStartOffset = -100
  if tGameRef.hasTeamScores() then
    tWrapObjRef.addOneWindow(me.getWindowItemId(3), "ig_ag_teamhigh_top.window", me.pWindowSetId, [#scrollFromLocX:-130])
    tWrapObjRef.addOneWindow(me.getWindowItemId(4), "ig_ag_teamhigh_mid.window", me.pWindowSetId, [#scrollFromLocX:-130])
    tWrapObjRef.addOneWindow(me.getWindowItemId(5), "ig_ag_teamhigh_brk.window", me.pWindowSetId, [#scrollFromLocX:-130])
    tWrapObjRef.addOneWindow(me.getWindowItemId(6), "ig_ag_teamhigh_mid.window", me.pWindowSetId, [#scrollFromLocX:-160])
    tWrapObjRef.addOneWindow(me.getWindowItemId(7), "ig_ag_teamhigh_brk.window", me.pWindowSetId, [#scrollFromLocX:-160])
    tWrapObjRef.addOneWindow(me.getWindowItemId(8), "ig_ag_teamhigh_mid.window", me.pWindowSetId, [#scrollFromLocX:-190])
    tWrapObjRef.addOneWindow(me.getWindowItemId(9), "ig_ag_teamhigh_btm.window", me.pWindowSetId, [#scrollFromLocX:-190, #spaceBottom:2])
    me.showTeamHighScore(tGameRef)
  end if
  tWrapObjRef.addOneWindow(me.getWindowItemId(10), "ig_ag_highscores_top.window", me.pWindowSetId, [#scrollFromLocX:-230])
  tWrapObjRef.addOneWindow(me.getWindowItemId(11), "ig_ag_highscores_btm.window", me.pWindowSetId, [#scrollFromLocX:-230, #spaceBottom:2])
  me.showPersonalHighScore(tGameRef)
  return TRUE
end

on setTeamScore me, tWndID, tTeamIndex, tScore 
  tWndObj = getWindow(tWndID)
  if (tWndObj = 0) then
    return FALSE
  end if
  tElem = tWndObj.getElement("ig_name_team")
  if (tElem = 0) then
    return FALSE
  end if
  tElem.setText(getText("ig_teamname_" & tTeamIndex))
  tElem = tWndObj.getElement("ig_score_team")
  if (tElem = 0) then
    return FALSE
  end if
  tElem.setText(tScore)
  return TRUE
end

on showTeamHighScore me, tGameRef 
  tdata = tGameRef.getProperty(#level_team_scores)
  if not listp(tdata) then
    return FALSE
  end if
  tOwnTeamId = tGameRef.getOwnPlayerTeam()
  if tdata.count < 3 then
    tCount = tdata.count
  else
    tCount = 3
  end if
  i = 1
  repeat while i <= tCount
    tWndObj = getWindow(me.getWindowItemId((2 + (i * 2))))
    if (tWndObj = 0) then
      return FALSE
    end if
    tItem = tdata.getAt(i)
    tPlayers = tItem.getaProp(#players)
    tHighlight = (tItem.getaProp(#id) = tOwnTeamId)
    tElem = tWndObj.getElement("ig_teamhigh_rank")
    if (tElem = 0) then
      return FALSE
    end if
    if tHighlight then
      tFontStruct = getStructVariable("struct.font.bold")
      tElem.setFont(tFontStruct)
    end if
    tElem.setText(i & ".")
    tElem = tWndObj.getElement("ig_teamhigh_score")
    if (tElem = 0) then
      return FALSE
    end if
    if tHighlight then
      tElem.setFont(tFontStruct)
    end if
    tElem.setText(tItem.getaProp(#score))
    if tHighlight then
      tElem = tWndObj.getElement("ig_teamhigh_teamscore")
      if (tElem = 0) then
        return FALSE
      end if
      tElem.setFont(tFontStruct)
    end if
    tText = ""
    tBreak = 0
    tLineCount = (1 + (tPlayers.count / 2))
    j = 1
    repeat while j <= tPlayers.count
      if tPlayers.getAt(j).length > 14 then
        tText = tText & tPlayers.getAt(j).getProp(#char, 1, 12) & "..."
      else
        tText = tText & tPlayers.getAt(j)
      end if
      if tBreak then
        tText = tText & "\r"
      else
        if j < tPlayers.count then
          tText = tText & ", "
        end if
      end if
      tBreak = not tBreak
      j = (1 + j)
    end repeat
    tElem = tWndObj.getElement("ig_teamhigh_team")
    if (tElem = 0) then
      return FALSE
    end if
    tElem.setText(tText)
    tFont = tElem.getFont()
    tLineHeight = tFont.getaProp(#lineHeight)
    tHeight = ((((tPlayers.count + 1) / 2) * tLineHeight) + 16)
    tWndObj.resizeTo(tWndObj.getProperty(#width), tHeight)
    i = (1 + i)
  end repeat
  return TRUE
end

on showPersonalHighScore me, tGameRef 
  tWndObj = getWindow(me.getWindowItemId(11))
  tdata = tGameRef.getProperty(#top_level_scores)
  if not listp(tdata) then
    return FALSE
  end if
  tOwnId = me.getOwnPlayerGameIndex()
  tDataCount = tdata.count
  if tDataCount > 5 then
    tDataCount = 5
  end if
  i = 1
  repeat while i <= tdata.count
    tItem = tdata.getAt(i)
    tOwnUser = (tItem.getaProp(#room_index) = tOwnId)
    tElem = tWndObj.getElement("ig_highscore_rank" & i)
    if (tElem = 0) then
      return FALSE
    end if
    if tOwnUser then
      tFontStruct = getStructVariable("struct.font.bold")
      tElem.setFont(tFontStruct)
    end if
    tElem.setText(i & ".")
    tElem = tWndObj.getElement("ig_highscore_player" & i)
    if (tElem = 0) then
      return FALSE
    end if
    if tOwnUser then
      tElem.setFont(tFontStruct)
    end if
    tElem.setText(tItem.getaProp(#name))
    tElem = tWndObj.getElement("ig_highscore_score" & i)
    if (tElem = 0) then
      return FALSE
    end if
    if tOwnUser then
      tElem.setFont(tFontStruct)
    end if
    tElem.setText(tItem.getaProp(#score))
    i = (1 + i)
  end repeat
  return TRUE
end

on setScoreWindowPlayer me, tWindowID, tPlayerPos, tPlayerInfo 
  if tPlayerInfo <> 0 then
    tOwnUser = (tPlayerInfo.getaProp(#room_index) = me.getOwnPlayerGameIndex())
  end if
  tWndObj = getWindow(tWindowID)
  if (tWndObj = 0) then
    return FALSE
  end if
  tElem = tWndObj.getElement("ig_icon_player")
  if (tElem = 0) then
    return FALSE
  end if
  if (tPlayerInfo = 0) then
    tElem.hide()
  else
    tElem.show()
    tImage = me.getHeadImage(tPlayerInfo.getaProp(#figure), tPlayerInfo.getaProp(#sex), 18, 18)
    if tImage <> 0 then
      tElem.feedImage(tImage)
    end if
  end if
  tElem = tWndObj.getElement("ig_name_player")
  if (tElem = 0) then
    return FALSE
  end if
  if (tPlayerInfo = 0) then
    tElem.hide()
  else
    tElem.show()
    tElem.setText(tPlayerInfo.getaProp(#name))
    if tOwnUser then
      tFontStruct = getStructVariable("struct.font.bold")
      tElem.setFont(tFontStruct)
    end if
  end if
  tElem = tWndObj.getElement("ig_score_player")
  if (tElem = 0) then
    return FALSE
  end if
  if (tPlayerInfo = 0) then
    tElem.hide()
  else
    tElem.show()
    tElem.setText(tPlayerInfo.getaProp(#score))
    if tOwnUser then
      tElem.setFont(tFontStruct)
    end if
  end if
  return TRUE
end

on setScoreWindowIcon me, tWndID, tTeamPosition 
  tWndObj = getWindow(tWndID)
  if (tWndObj = 0) then
    return FALSE
  end if
  tElem = tWndObj.getElement("ig_icon_medal")
  if (tElem = 0) then
    return FALSE
  end if
  tMemNum = getmemnum("ig_icon_medal_" & tTeamPosition)
  if (tMemNum = 0) then
    return FALSE
  end if
  tElem.setProperty(#image, member(tMemNum).image)
  return TRUE
end

on getOwnPlayerGameIndex me 
  tSession = getObject(#session)
  if (tSession = 0) then
    return FALSE
  end if
  if not tSession.exists("user_game_index") then
    return(-1)
  end if
  tIndex = tSession.GET("user_game_index")
  return(tIndex)
end

on getOwnPlayerName me 
  tSession = getObject(#session)
  if (tSession = 0) then
    return FALSE
  end if
  if not tSession.exists(#user_name) then
    return FALSE
  end if
  return(tSession.GET(#user_name))
end

on getWindowItemId me, tNum 
  return(me.getWindowId() & "_" & tNum)
end
