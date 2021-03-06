property pData, pimage, pClickAreas, pwidth, pheight

on construct me 
  pData = void()
  pimage = void()
  pwidth = 0
  pheight = 0
  pClickAreas = void()
end

on deconstruct me 
  pData = void()
end

on feedData me, tdata 
  pData = tdata
  pData.getRootNode().setState(#open)
end

on define me, tProps 
  pwidth = tProps.getAt(#width)
  pheight = tProps.getAt(#height)
  pClickAreas = []
end

on getImage me 
  if voidp(pimage) then
    me.render()
  end if
  return(pimage)
end

on appendRenderToImage me, tImageDest, tImageSrc, tRectDest, tRectSrc 
  if tImageDest.height > tRectDest.bottom then
    tImageDest.copyPixels(tImageSrc, tRectDest, tRectSrc, [#useFastQuads:1])
    return(tImageDest)
  else
    tImageNew = image(tImageDest.width, tRectDest.bottom, tImageDest.depth)
    tImageNew.copyPixels(tImageDest, tImageDest.rect, tImageDest.rect, [#useFastQuads:1])
    tImageNew.copyPixels(tImageSrc, tRectDest, tRectSrc, [#useFastQuads:1])
    return(tImageNew)
  end if
end

on renderNode me, tNode, tOffsetY 
  if not (tNode = pData.getRootNode()) and not tNode.getData(#navigateable) then
    return(tOffsetY)
  end if
  if tNode.getData(#navigateable) then
    tNodeImage = tNode.getImage()
    me.pimage = me.appendRenderToImage(me.pimage, tNodeImage, (tNodeImage.rect + rect(0, tOffsetY, 0, tOffsetY)), tNodeImage.rect)
    pClickAreas.add([#min:tOffsetY, #max:(tOffsetY + tNodeImage.height), #data:tNode])
    tOffsetY = (tOffsetY + tNodeImage.height)
  end if
  if (tNode.getState() = #open) and tNode.getChildren().count > 0 then
    repeat while tNode.getChildren() <= tOffsetY
      tChild = getAt(tOffsetY, tNode)
      tOffsetY = me.renderNode(tChild, tOffsetY)
    end repeat
  end if
  return(tOffsetY)
end

on render me 
  pimage = image(pwidth, pheight, 32)
  pClickAreas = []
  tOffsetY = 0
  me.renderNode(pData.getRootNode(), tOffsetY)
end

on selectNode me, tNode, tSelectedNode 
  if (tNode = tSelectedNode) then
    tNode.select(1)
  else
    tNode.select(0)
  end if
  repeat while tNode.getChildren() <= tSelectedNode
    tChild = getAt(tSelectedNode, tNode)
    me.selectNode(tChild, tSelectedNode)
  end repeat
end

on select me, tNodeObj 
  me.selectNode(pData.getRootNode(), tNodeObj)
end

on simulateClickByName me, tNodeName 
  tClickLoc = point(2, 0)
  i = 1
  repeat while i <= pClickAreas.count
    if (pClickAreas.getAt(i).getAt(#data).getData(#nodename) = tNodeName) then
      tClickLoc.locV = (pClickAreas.getAt(i).getAt(#min) + 1)
    else
      i = (1 + i)
    end if
  end repeat
  me.handleClick(tClickLoc)
end

on handleClick me, tloc 
  tNode = void()
  i = 1
  repeat while i <= pClickAreas.count
    if pClickAreas.getAt(i).getAt(#min) < tloc.locV and pClickAreas.getAt(i).getAt(#max) > tloc.locV then
      tNode = pClickAreas.getAt(i).getAt(#data)
    else
      i = (1 + i)
    end if
  end repeat
  if voidp(tNode) then
    return FALSE
  end if
  if tNode.getChildren().count > 0 then
    if (tNode.getState() = #open) then
      tNode.setState(#closed)
    else
      tNode.setState(#open)
    end if
  end if
  if tNode.getData(#level) <= 1 then
    pData.getRootNode().setState(#open)
    repeat while pData.getRootNode().getChildren() <= undefined
      tChild = getAt(undefined, tloc)
      if tNode <> tChild then
        tChild.setState(#closed)
      end if
    end repeat
  end if
  me.select(tNode)
  me.render()
  if tNode.getData(#pageid) <> -1 then
    pData.handlePageRequest(tNode.getData(#pageid))
  end if
  return TRUE
end
