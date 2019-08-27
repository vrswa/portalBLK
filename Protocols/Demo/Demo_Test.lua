-------------------------------------------
-- s: EMULAR ENTORNO SWA, MOVER A LIB
package.path = "./?.lua;" .. package.path
json = require "json"
json.parse = json.decode
json.serialize = json.encode


SwaLoad = dofile
Log = print
FileTool = {}
FileTool.GetFileAsString = function() return "{}" end
function aToLua(mayBeUArray) --U: si el parametro es un array de Unity, lo convierte a Lua
	if (type(mayBeUArray)=="userdata") then
		local array = mayBeUArray;
		local r= {};
		for idx= 0, #array-1 do
			r[idx+1]= array[idx];
		end
		return r;
	else --A: no sabemos convertir
		return mayBeUArray;
	end
end

function ser_json(d) --U: devuelve un string json
	return json.serialize(aToLua(d));
end

function ser_json_r(s) --U: de string json a table en lua
	return json.parse(s);
end

ser= ser_json; --U: DFLT serializamos como json
ser_r= ser_json_r; --U: DFLT deserializamos como json

function table.clone(org) --U: una copia de una tabla/array/etc
  return {table.unpack(org)}
end
--------------------------------------------
SwaLoad("Demo.lua")

function TestLoadAllManifests()
  local manifestList ={
    "manifesto1","manifesto2","manifesto3"
  }
  LoadAllManifests(manifestList, function() print("Listo!") end)
end

TestLoadAllManifests()
