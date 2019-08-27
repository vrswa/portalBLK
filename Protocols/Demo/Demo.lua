function BLK_Protocol_Run(onExitCB)
  Log("BLK_Protocol_Run: comenzo!")
  BLKManifestsMenu(1)
end

function BLKManifestsMenu(n) --A: Menu que muestra la lista de misiones (hay una por cada manifest)
  manifests = GetLocalManifests()
  if(tablelength(manifests) == 0) then
    Modal("No manifest found, please sync with server!")
  else
    pos = n % tablelength(manifests)
    if (pos == 0) then
      pos =  tablelength(manifests)
    end
    Log("Inicio BLKMainMenu: manifesto " .. "(" .. pos .. " de " .. tablelength(manifests) .. ")")

    BLKGenericUI({
      SyncBtn = true,
      left = function()
        BLKManifestsMenu(n - 1)
      end,
      right = function()
        BLKManifestsMenu(n + 1)
      end,
      syncMenu = {
        onCancel = function()
          BLKManifestsMenu(n)
        end
      }
    })

    manifest = {}
    counter = 1
    for k,v in pairs(manifests) do
      if(counter == pos) then
        manifest = k
      end
      counter = counter + 1
    end

    Cmp({    --A: Dibujo el boton para entrar al manifest
        type = "button",
        title = "",
        pos = {SCR_W / 2 - 250, SCR_H / 2 - 250, 0},
        texture = "BLK/Manifest.png",
        align = "center",
        fontSize = 60,
        width = 500,
        height = 500,
        textCol = {1,1,1},
        imgCol = {1,1,1},
        onClick = function()
          BLKGuidesMenu(manifest, manifests[manifest], 1 , function() BLKManifestsMenu(n) end)
        end
        })
    Cmp({    --A: Nombre del manifesto
        type = "label",
        title = manifest,
        pos = {SCR_W / 2 - 500, 50, 0},
        align = "center",
        fontSize = 60,
        width = 1000,
        height = 120,
        textCol = {1,1,1},
        imgCol = {.4,.4,.4,0},
        onClick = function()
          actions.back()
        end
        })

  end
end

function BLKGuidesMenu(manifestName, manifest , n, onBack)  --A: Menu que muestra la lista de guias en el manifesto de la mision
  Log("BLKGuidesMenu: manifestName " .. manifestName)
  guidesLength = tablelength(manifest.GuiasDeEmbarque)
  if(manifest.GuiasDeEmbarque ~= nil) then
    if(guidesLength == 0) then
      Modal("No guide found in the manifest!")
    else
      pos = n % guidesLength
      if (pos == 0) then
        pos = guidesLength
      end
      Log("Inicio BLKGuidesMenu: guia " .. "(" .. pos .. " de " .. guidesLength .. ")")

      BLKGenericUI({
        SyncBtn = true,
        back = onBack,
        left = function()
          BLKGuidesMenu(manifestName, manifest, n - 1, onBack)
        end,
        right = function()
          BLKGuidesMenu(manifestName, manifest, n + 1, onBack)
        end,
        syncMenu = {
          onCancel = function()
            BLKGuidesMenu(manifestName, manifest , n, onBack)
          end
        }--A: Le puse 2 porq sino llamaba a una func global q se llama igual
      })

      guide = {}
      counter = 1
      for k,v in pairs(manifest.GuiasDeEmbarque) do
        if(counter == pos) then
          guide = k
        end
        counter = counter + 1
      end

      Cmp({    --A: Dibujo el boton para entrar al manifest
          type = "button",
          title = "",
          pos = {SCR_W / 2 - 250, SCR_H / 2 - 250, 0},
          texture = "BLK/AWB.png",
          align = "center",
          fontSize = 60,
          width = 500,
          height = 500,
          textCol = {1,1,1},
          imgCol = {1,1,1},
          onClick = function()
            GuideSelected(manifest, guide)
          end
          })
      Cmp({    --A: Dibujo el boton para crear una nueva mision
          type = "label",
          title = guide,
          pos = {SCR_W / 2 - 500, 50, 0},
          align = "center",
          fontSize = 60,
          width = 1000,
          height = 120,
          textCol = {1,1,1},
          imgCol = {.4,.4,.4,0},
          onClick = function()
          end
          })



      end
  else
    Log("BLKGuidesMenu manifest.GuiasDeEmbarque not found!")
  end
end

function BLKItemsMenu(guideName, manifest, guide, n , onBack) --A: Entro a un menu donde estan los items de la guia seleccionada
  Log("BLKGuidesMenu: manifestName " .. manifestName)
  itemsLength = tablelength(guide.Items)
end

function BLKGenericUI(actions)  --A: IU generica q se reusa en la app : derecha, izq , atras, etc
  CleanCanvas("*")

  if(actions.back ~= nil) then
    Cmp({    --A: Dibujo el boton para crear una nueva mision
        type = "button",
        title = "B",
        pos = {100, SCR_H - 220, 0},
        align = "center",
        fontSize = 60,
        width = 120,
        height = 120,
        textCol = {1,1,1},
        imgCol = {.4,.4,.4,.5},
        border = true,
        borderCol = {1,1,1},
        onClick = function()
          actions.back()
        end
        })
  end

  if ((actions.SyncBtn or false) == true) then
    Cmp({  --A: Dibujo el boton para Updatear las misiones
      type = "button",
      title = "S",
      pos = {SCR_W - 220, SCR_H - 220, 0},
      align = "center",
      fontSize = 60,
      width = 120,
      height = 120,
      textCol = {1,1,1},
      imgCol = {.4,.4,.4,.5},
      border = true,
      borderCol = {1,1,1},
      onClick = function()
        SyncMenu(actions.syncMenu)
      end,
    })
  end

  if(actions.left ~= nil) then
    Cmp({    --A: Dibujo el boton para crear una nueva mision
        type = "button",
        title = "",
        pos = {100, SCR_H / 2, 0},
        align = "center",
        fontSize = 60,
        texture = "BLK/RightArrow.png",
        width = 120,
        height = 120,
        textCol = {1,1,1},
        imgCol = {1,1,1},
        onClick = function()
          actions.left()
        end
        })
  end

  if(actions.right ~= nil) then
    Cmp({    --A: Dibujo el boton para crear una nueva mision
        type = "button",
        title = "",
        pos = {SCR_W - 220, SCR_H / 2, 0},
        align = "center",
        fontSize = 60,
        texture = "BLK/RightArrow.png",
        width = 120,
        height = 120,
        textCol = {1,1,1},
        imgCol = {1,1,1,1},
        onClick = function()
          actions.right()
        end
        })
  end
end

function SyncMenu(cbs)
  CleanCanvas("*")

  Cmp({  --A: Dibujo el boton para bajar el dataset, mato las missiones actuales
    type = "button",
    title = "Bajar Dataset",
    pos = {SCR_W / 2 - 400, SCR_H - 200, 0},
    align = "center",
    fontSize = 60,
    width = 800,
    height = 120,
    textCol = {1,1,1},
    imgCol = {.4,.4,.4,.5},
    border = true,
    borderCol = {1,1,1},
    onClick = function()
      CleanCanvas("*")
      Cmp({  --A: Dibujo el boton para Updatear el protocolo
        type = "label",
        title = "Actualizando Protocolos...",
        pos = {SCR_W / 2 - 400, SCR_H - 600, 0},
        align = "center",
        fontSize = 60,
        width = 800,
        height = 120,
        textCol = {1,1,1},
        imgCol = {.4,.4,.4,0},
        })
      UpdateManifests(
      function()
        ResetMissions()
        CleanCanvas("*")
        Modal("Dataset actualizado, misiones reseteadas!", function() BLKManifestsMenu(1) end)
      end
      )
    end,
    })

  Cmp({  --A: Dibujo el boton para subir las misiones
    type = "button",
    title = "Subir Misiones",
    pos = {SCR_W / 2 - 400, SCR_H - 400, 0},
    align = "center",
    fontSize = 60,
    width = 800,
    height = 120,
    textCol = {1,1,1},
    imgCol = {.4,.4,.4,.5},
    border = true,
    borderCol = {1,1,1},
    onClick = function()
      Modal("Subir Misiones no implementado!")
    end,
    })

  Cmp({  --A: Dibujo el boton para Updatear el protocolo
    type = "button",
    title = "Actualizar Protocolos",
    pos = {SCR_W / 2 - 400, SCR_H - 600, 0},
    align = "center",
    fontSize = 60,
    width = 800,
    height = 120,
    textCol = {1,1,1},
    imgCol = {.4,.4,.4,.5},
    border = true,
    borderCol = {1,1,1},
    onClick = function()
      UpdateAllProtocols(cbs.OnProtocolsUpdate or function() Modal("Protocolos Actualizados!",function() SyncMenu(cbs) end) end)
    end,
    })

  Cmp({  --A: Dibujo el boton para Updatear los recursos de blk
    type = "button",
    title = "Actualizar Recursos",
    pos = {SCR_W / 2 - 400, SCR_H - 800, 0},
    align = "center",
    fontSize = 60,
    width = 800,
    height = 120,
    textCol = {1,1,1},
    imgCol = {.4,.4,.4,.5},
    border = true,
    borderCol = {1,1,1},
    onClick = function()
      Modal("Actualizar recursos no implementado!")
    end,
    })

  Cmp({  --A: Dibujo el boton para cancelar
    type = "button",
    title = "Cancelar",
    pos = {SCR_W / 2 - 400, SCR_H - 1000, 0},
    align = "center",
    fontSize = 60,
    width = 800,
    height = 120,
    textCol = {1,1,1},
    imgCol = {.4,.4,.4,.5},
    border = true,
    borderCol = {1,1,1},
    onClick = cbs.onCancel,
    })    --A: IU generica q se reusa en la app : derecha, izq , atras, etc
end

function GetMissionsManifests(protocolId)  --A: devuelve los manifestos de todas las misiones
  r = {}
  missionsFolder = "BLK/Protocols/" .. protocolId .. "/Missions"
  FileTool.EnsureDir(missionsFolder)
  folders = FileTool.DirList(missionsFolder)
end

function GetLocalManifests()  --A: devuelve los manifestos originales del dataset
  r = {}
  FileTool.EnsureDir("BLK/Dataset")
  files = FileTool.FileList("BLK/Dataset")
  Log("GetMissionsManifests: se encontraron los siguientes jsons: ")
  for i=0, #files - 1 do
    Log(files[i])
  end
  counter = 0
  for i = 0, #files - 1 do
    r[files[i]] = ser_json_r(FileTool.GetFileAsString("BLK/Dataset/" .. files[i]))
    counter = counter + 1
  end
  Log("GetMissionsManifests: " .. tablelength(r) .. " manifests found")
  return r
end

function UpdateManifests(cb)  --A: pisa los manifestos originales locales con los del server
  FileTool.EnsureDir("BLK/Dataset")
  GetManifestsList(function(data) OnManifestList(data, cb) end)
end

function GetManifestsList(OnManifestCB) --U: Traiga lista de manifest para bajar
  HttpCxMgrGet(
    BLKApiURL .. "/Dataset",
    function(wr)
      Log("UpdateManifests CB: " .. wr.downloadHandler.text)
      OnManifestCB(ser_json_r(wr.downloadHandler.text))
    end,
    false,
    {filter = "all"}
  )
end

function OnManifestList(manifestList, cb)
  GetManifest(manifestList, 1, cb)
end

function GetManifest(manifestsList, n, cb)  --A: funcion recursiva q devuelve los manifestos
  if(n <= tablelength(manifestsList)) then
    counter = 1
    for k,v in pairs(manifestsList) do
      if(counter == n) then
        GetManifestFile(v, function() GetManifest(manifestsList, n+1 , cb) end)
      end
      counter = counter + 1
    end
  else --A: Termine de descargar todos los files del directorio
    LoadAllManifests(manifestsList, cb)
  end
end

function GetManifestFile(fileName, cb)
  Log("Descargando " .. fileName)
  HttpCxMgrGet(
    BLKApiURL .. "/Dataset/" .. fileName,
    function(wr)
      Log("UpdateManifests Descargo: " .. fileName)
      FileTool.SetFile("BLK/Dataset/" .. fileName , wr.downloadHandler.data)
      cb()
    end,
    false,
    {filter = "all"}
    )
end

function LoadAllManifests(manifestsList, cb)
  manifests = {}
  Log("GetManifest: manifests found:")
  for k,v in pairs(manifestsList) do
    manifests[v] = ser_json_r(FileTool.GetFileAsString("BLK/Dataset/" .. v))
    Log("GetManifest: manifest = " .. k .. " " .. v)
  end
  Log("GetManifest: termino")
  cb(manifests)
end

function ResetMissions(manifests)  --A: borra las misiones locales y las crea con los manifestos del dataset local
  FileTool.EnsureDir("BLK/Protocols")
  procs = FileTool.DirList("BLK/Protocols")
  for i=0, #procs - 1 do
    FileTool.EnsureDir("BLK/Protocols/" .. procs[i] .. "/Missions")
    miss = FileTool.DirList("BLK/Protocols/" .. procs[i] .. "/Missions")
    FileTool.DeleteAll("BLK/Protocols/" .. procs[i] .. "/Missions")
    FileTool.EnsureDir("BLK/Protocols/" .. procs[i] .. "/Missions")
  end
end

function UpdateAllProtocols(cb)
  Log("le pego a : " .. BLKApiURL .. "/Protocols")
  HttpCxMgrGet(
  BLKApiURL .. "/Protocols",
  function(wr)
    Log("UpdateAllProtocols: " .. wr.downloadHandler.text)
    procs = ser_json_r(wr.downloadHandler.text)
    UpdateProtocol(procs, 1, cb)
  end,
  false,
  {filter = "all"}
  )
end

function UpdateProtocol(protocols, n, cb)
  if(n <= tablelength(protocols)) then
    counter = 1
    for k,v in pairs(protocols) do
      if (counter == n) then
        proc = v.protocolId
        HttpCxMgrGet(
          BLKApiURL .. "/Protocols/" .. proc,
          function(wr)
            UpdateFiles(
              wr.downloadHandler.data,
              "BLK/Protocols/" .. proc ,
              1,
              UpdateProtocol(protocols, n + 1, cb)
            )
          end,
          false,
          {filter = "all"}
        )
        counter = counter + 1
      else
        counter = counter + 1
      end
    end
  else
    cb()
  end
end

function UpdateFiles(files, path, n, cb)

  --Log("UpdateProtocol: " .. proc)
--  FileTool.SetFile("BLK/Protocols/" .. proc, wr.downloadHandler.data)
end
