property pThread

on construct me 
  return TRUE
end

on deconstruct me 
  if objectp(pThread) then
    if objectp(pThread.getBaseLogic()) then
      pThread.getBaseLogic().initVariables()
    end if
    if objectp(pThread.getProcManager()) then
      pThread.getProcManager().removeProcessors()
    end if
  end if
  pThread = void()
  return TRUE
end

on defineClient me, tSystemObj 
  pThread = tSystemObj
  if (pThread = 0) then
    return(error(me, "Client game framework not found:" && me.getID(), #defineClient))
  end if
  if getmemnum(me.getID() & ".variable.index") then
    dumpVariableField(me.getID() & ".variable.index")
  end if
  pThread.getBaseLogic().defineClient(me.getID())
  pThread.getMessageHandler().defineClient(me.getID())
  pThread.getComponent().defineClient(me.getID())
  pThread.getProcManager().defineClient(me.getID())
  pThread.getProcManager().distributeEvent(#facadeok, me.getID())
  return TRUE
end

on getNumTickets me 
  if (getObject(#session) = 0) then
    return FALSE
  end if
  return(getObject(#session).GET("user_ph_tickets"))
end

on getSpectatorModeFlag me 
  if (me.getVarMgr() = 0) then
    return FALSE
  end if
  return(me.getVarMgr().GET(#spectatormode_flag))
end

on getTournamentFlag me 
  if (me.getVarMgr() = 0) then
    return FALSE
  end if
  if not me.getVarMgr().exists(#tournament_flag) then
    return FALSE
  end if
  return(me.getVarMgr().GET(#tournament_flag))
end

on getWorldReady me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().getWorldReady())
end

on getGamestatus me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getBaseLogic().getGamestatus())
end

on setGameStatus me, tStatus 
  tVarMgr = me.getVarMgr()
  if (tVarMgr = 0) then
    return FALSE
  end if
  return(tVarMgr.set(#game_status, tStatus))
end

on getInstanceList me 
  if (me.getVarMgr() = 0) then
    return FALSE
  end if
  return(me.getVarMgr().GET(#instancelist))
end

on getObservedInstance me 
  if (me.getVarMgr() = 0) then
    return FALSE
  end if
  return(me.getVarMgr().GET(#observed_instance_data))
end

on getGameParameters me 
  if (me.getVarMgr() = 0) then
    return FALSE
  end if
  if not me.getVarMgr().exists(#gameparametervalues_format) then
    return FALSE
  end if
  return(me.getVarMgr().GET(#gameparametervalues_format))
end

on getJoinParameters me 
  if (me.getVarMgr() = 0) then
    return FALSE
  end if
  if not me.getVarMgr().exists(#joinparametervalues_format) then
    return FALSE
  end if
  return(me.getVarMgr().GET(#joinparametervalues_format))
end

on setInstanceListUpdates me, tBoolean 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().setInstanceListUpdates(tBoolean))
end

on sendGetInstanceList me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendGetInstanceList())
end

on observeInstance me, tID 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendObserveInstance(tID))
end

on unobserveInstance me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendUnobserveInstance())
end

on initiateCreateGame me, tTeamId 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendInitiateCreateGame(tTeamId))
end

on cancelCreateGame me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getBaseLogic().cancelCreateGame())
end

on createGame me, tParamList, tTeamId 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendGameParameterValues(tParamList, tTeamId))
end

on deleteGame me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendDeleteGame())
end

on initiateJoinGame me, tInstanceId, tTeamId 
  if (pThread = 0) then
    return FALSE
  end if
  pThread.getBaseLogic().store_joinparameters(me, [:])
  return(pThread.getMessageSender().sendInitiateJoinGame(tInstanceId, tTeamId))
end

on joinGame me, tInstanceId, tTeamId, tParamList 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendJoinParameterValues(tInstanceId, tTeamId, tParamList))
end

on leaveGame me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendLeaveGame())
end

on kickPlayer me, tPlayerId 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendKickPlayer(tPlayerId))
end

on watchGame me, tInstanceId 
  if (pThread = 0) then
    return FALSE
  end if
  if (tInstanceId = void()) then
    tInstance = me.getObservedInstance()
    if (tInstance = 0) then
      return FALSE
    end if
    tInstanceId = tInstance.getAt(#id)
  end if
  return(pThread.getMessageSender().sendWatchGame(tInstanceId))
end

on startGame  
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendStartGame())
end

on rejoinGame me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendRejoinGame())
end

on enterLounge me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getBaseLogic().enterLounge())
end

on sendGameEventMessage me, tdata 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendGameEventMessage(tdata))
end

on sendGameSystemEvent me, tTopic, tdata 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getProcManager().distributeEvent(tTopic, tdata))
end

on sendHabboRoomMove me, tLocX, tLocY 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getMessageSender().sendHabboRoomMove(tLocX, tLocY))
end

on createGameObject me, tID, ttype, tDataToStore 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().createGameObject(tID, ttype, tDataToStore))
end

on getGameObject me, tID 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().getGameObject(tID))
end

on getGameObjectProperty me, tID, tProp 
  if (pThread = 0) then
    return FALSE
  end if
  tObject = pThread.getComponent().getGameObject(tID)
  if (tObject = 0) then
    return(error(me, "Game object doesn't exist:" && tID, #getGameObjectProperty))
  end if
  return(tObject.getGameObjectProperty(tProp))
end

on getGameObjectIdsOfType me, ttype 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().getGameObjectIdsOfType(ttype))
end

on updateGameObject me, tID, tdata 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().updateGameObject(tID, tdata))
end

on removeGameObject me, tID 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().removeGameObject(tID))
end

on clearTurnBuffer me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getTurnManager()._ClearTurnBuffer())
end

on executeGameObjectEvent me, tID, tEvent, tdata 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().executeGameObjectEvent(tID, tEvent, tdata))
end

on get360AngleFromComponents me, tX, tY 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().getGeometry().getAngleFromComponents(tX, tY))
end

on get8AngleFromComponents me, tX, tY 
  if (pThread = 0) then
    return FALSE
  end if
  tAngle360 = pThread.getWorld().getGeometry().getAngleFromComponents(tX, tY)
  return(pThread.getWorld().getGeometry().direction360to8(tAngle360))
end

on GetVelocityTable me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().getGeometry().GetVelocityTable())
end

on convertTileToWorldCoordinate me, tX, tY, tZ 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().convertTileToWorldCoordinate(tX, tY, tZ))
end

on gettileatworldcoordinate me, tX, tY, tZ 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().gettileatworldcoordinate(tX, tY, tZ))
end

on convertworldtotilecoordinate me, tX, tY, tZ 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().convertworldtotilecoordinate(tX, tY, tZ))
end

on convertWorldToScreenCoordinate me, tX, tY, tZ 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().convertWorldToScreenCoordinate(tX, tY, tZ))
end

on sqrt me, tInteger 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().pSquareRoot.fast_sqrt(tInteger))
end

on getGeometry me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld().getGeometry())
end

on getWorld me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getWorld())
end

on startTurnManager me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getBaseLogic().startTurnManager())
end

on stopTurnManager me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getBaseLogic().stopTurnManager())
end

on getNewTurnContainer me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getTurnManager().getNewTurnContainer())
end

on dump me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getComponent().dump())
end

on getVarMgr me 
  if (pThread = 0) then
    return FALSE
  end if
  return(pThread.getVariableManager())
end
