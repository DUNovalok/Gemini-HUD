-- GEMINI FOUNDATION

--Solo remote controller
HUD_version = '1.0.0'

--LUA parameters

--vars
atlas = require("atlas")
stellarObjects = atlas[0]
shipPos = vec3(construct.getWorldPosition())
safeWorldPos = vec3({13771471,7435803,-128971})

--shield
damageLine = ''
ccsLineHit = ''
damage = 0
maxSHP = 210 --svg shield X right side coordinate
shieldMaxHP = shield.getMaxShieldHitpoints()
last_shield_hp = shield.getShieldHitpoints()
HP = shield.getShieldHitpoints()/shieldMaxHP * 100
svghp = maxSHP * (HP * 0.01)

--CCS
ccshit = 0
maxCCS = 139.5
coreMaxStress = core.getmaxCoreStress()
last_core_stress = core.getCoreStress()
CCS = last_core_stress/coreMaxStress * 100
ccshp1 = maxCCS * (CCS * 0.01)
ccshp = ccshp1

--FUEL
maxFUEL = maxCCS
fuel_lvl = json.decode(spacefueltank_1.getWidgetData()).percentage
FUEL_svg = maxFUEL * (fuel_lvl * 0.01)

AM_last_stress = 0
EM_last_stress = 0
TH_last_stress = 0
KI_last_stress = 0
AM_svg = 0
EM_svg = 0
TH_svg = 0
KI_svg = 0

function resistance_SVG()
   local res = shield.getResistances()
   if res[1] > 0 then
      AM_stroke_color = '#FFB12C'
      AMstrokeWidth = 2
   else
      AM_stroke_color = 'rgb(66, 167, 245)'
      AMstrokeWidth = 1
   end
   if res[2] > 0 then
      EM_stroke_color = '#FFB12C'
      EMstrokeWidth = 2
   else
      EM_stroke_color = 'rgb(66, 167, 245)'
      EMstrokeWidth = 1
   end
   if res[3] > 0 then
      KI_stroke_color = '#FFB12C'
      KIstrokeWidth = 2
   else
      KI_stroke_color = 'rgb(66, 167, 245)'
      KIstrokeWidth = 1
   end
   if res[4] > 0 then
      TH_stroke_color = '#FFB12C'
      THstrokeWidth = 2
   else
      TH_stroke_color = 'rgb(66, 167, 245)'
      THstrokeWidth = 1
   end
end

function actionRes(res)
   if res[1] > 0 then
      AM_stroke_color = '#FFB12C'
      AMstrokeWidth = 2
      unit.setTimer('AM',0.016)
   else
      AM_stroke_color = 'rgb(66, 167, 245)'
      AMstrokeWidth = 1
   end
   if res[2] > 0 then
      EM_stroke_color = '#FFB12C'
      EMstrokeWidth = 2
      unit.setTimer('EM',0.016)
   else
      EM_stroke_color = 'rgb(66, 167, 245)'
      EMstrokeWidth = 1
   end
   if res[3] > 0 then
      KI_stroke_color = '#FFB12C'
      KIstrokeWidth = 2
      unit.setTimer('KI',0.016)
   else
      KI_stroke_color = 'rgb(66, 167, 245)'
      KIstrokeWidth = 1
   end
   if res[4] > 0 then
      TH_stroke_color = '#FFB12C'
      THstrokeWidth = 2
      unit.setTimer('TH',0.016)
   else
      TH_stroke_color = 'rgb(66, 167, 245)'
      THstrokeWidth = 1
   end
end

resistance_SVG()
am=0
am_x = -50
am_opacity = 1
em=0
em_x = 0
em_opacity = 1
ki=0
ki_x = 0
ki_opacity = 1
th=0
th_x = 0
th_opacity = 1
AM_res = ''
EM_res = ''
KI_res = ''
TH_res = ''

function damage_SVG()
   if damage > 0 then
      damage = damage - 0.1
      damageLine = [[<rect x="]].. svghp + 145 ..[[" y="225" width="]]..damage..[[" height="50" style="fill: #de1656; stroke: #de1656;" bx:origin="0.5 0.5"/>]]
   end
   if damage <= 0 then
      damage = 0
      damageLine = ''
   end

   if ccshit > 0 then
      ccshp = ccshp + 0.25
      if ccshp >= ccshp1 then
         ccshp = ccshp1
         ccsLineHit = ''
         ccshit = 0
      end
   end
end

function ccs_SVG()
   --AM
   if AM_stress ~= AM_last_stress then
      AM_last_stress = AM_stress
   end
   if AM_svg < AM_last_stress then
      AM_svg = AM_svg + 0.01
      if AM_svg >= AM_stress then AM_svg = AM_stress
   end
end
if AM_svg > AM_last_stress then
   AM_svg = AM_svg - 0.01
   if AM_svg <= AM_stress then AM_svg = AM_stress end
end
--EM
if EM_stress ~= EM_last_stress then
   EM_last_stress = EM_stress
end
if EM_svg < EM_last_stress then
   EM_svg = EM_svg + 0.01
   if EM_svg >= EM_stress then EM_svg = EM_stress end
end
if EM_svg > EM_last_stress then
   EM_svg = EM_svg - 0.01
   if EM_svg <= EM_stress then EM_svg = EM_stress end
end
--TH
if TH_stress ~= TH_last_stress then
   TH_last_stress = TH_stress
end
if TH_svg < TH_last_stress then
   TH_svg = TH_svg + 0.01
   if TH_svg >= TH_stress then TH_svg = TH_stress end
end
if TH_svg > TH_last_stress then
   TH_svg = TH_svg - 0.01
   if TH_svg <= TH_stress then TH_svg = TH_stress end
end
--KI
if KI_stress ~= KI_last_stress then
   KI_last_stress = KI_stress
end
if KI_svg < KI_last_stress then
   KI_svg = KI_svg + 0.01
   if KI_svg >= KI_stress then KI_svg = KI_stress end
end
if KI_svg > KI_last_stress then
   KI_svg = KI_svg - 0.01
   if KI_svg <= KI_stress then KI_svg = KI_stress end
end
end

local stress = shield.getStressRatioRaw()
AM_stress = stress[1]
EM_stress = stress[2]
KI_stress = stress[3]
TH_stress = stress[4]

ccs_SVG()

function setTag(tag)
local tag = tag:sub(5)
system.print('Activated new transponder tag "'..tag..'"')
tag = {tag}
transponder.setTags(tag)
end

function zeroConvertToWorldCoordinates(pos)
local num  = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'
local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)

if systemId==nil or bodyId==nil or latitude==nil or longitude==nil or altitude==nil then
   system.print("Invalid pos!")
   destination_bm=""
   return vec3()
end

if (systemId == "0" and bodyId == "0") then
   --convert space bm
   return vec3(latitude,
   longitude,
   altitude)
end
longitude = math.rad(longitude)
latitude = math.rad(latitude)
local planet = atlas[tonumber(systemId)][tonumber(bodyId)]
local xproj = math.cos(latitude);
local planetxyz = vec3(xproj*math.cos(longitude),
xproj*math.sin(longitude),
math.sin(latitude));
return vec3(planet.center) + (planet.radius + altitude) * planetxyz
end

if databank_1.getStringValue(15) ~= "" then
asteroidPOS = databank_1.getStringValue(15)
else
asteroidPOS = ''
end
GHUD_marker_name = "Asteroid" --export:
GHUD_shield_auto_calibration = true --export: (AUTO/MANUAL) shield mode
GHUD_shield_calibration_max = true --export: (MAX/50) calibration of the entire shield power by the largest resist based on DPS
GHUD_departure_planet = 'Alioth' --export: Departure ID planet
GHUD_destination_planet = 'Jago' --export: Destination ID planet
GHUD_background_color = "#142027" --export: Background color
GHUD_pipe_text_color = "#FFFFFF" --export: Pipe text color
GHUD_pipe_Y = -0.1 --export:
GHUD_pipe_X = 15.5 --export:
GHUD_Y = 50 --export:
GHUD_right_block_X = 30 --export:
GHUD_left_block_X = 12 --export:
collectgarbages = true --export:

if GHUD_marker_name == "" then GHUD_marker_name = "Asteroid" end
asteroidcoord = {}
if asteroidPOS ~= "" then
asteroidcoord = zeroConvertToWorldCoordinates(asteroidPOS)
else
asteroidcoord = {0,0,0}
end

--icons
local icons = {}
function iconStatusCheck(status)
if status == 'on' or status == 1 then
   return 'on'
else
   return ''
end
end

function icons.space(status)
return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 197.6 107.43">
<path class="a" d="M197.19,25.35c-4.31-15-38.37-12.36-60-9.09A53.64,53.64,0,0,0,46.29,42.48C26.28,51.21-3.9,67.12.42,82.08,2.81,90.36,14.68,93.74,31.3,93.74a197.4,197.4,0,0,0,29.09-2.56A53.64,53.64,0,0,0,151.31,65C179.87,52.59,200.82,37.94,197.19,25.35Zm-98.38-16A44.44,44.44,0,0,1,143.2,53.71,45.3,45.3,0,0,1,143,58.4a363,363,0,0,1-38.9,13.51,361.77,361.77,0,0,1-40,9.27A44.32,44.32,0,0,1,98.81,9.32ZM9.37,79.5c-.83-2.89,7.34-13.18,35.74-26.27,0,.16,0,.32,0,.48a53.27,53.27,0,0,0,8.58,29C26.33,86.24,10.55,83.58,9.37,79.5ZM98.81,98.11a44.13,44.13,0,0,1-26.65-9c11.34-2.18,23.07-5,34.47-8.28s22.84-7.12,33.6-11.31A44.43,44.43,0,0,1,98.81,98.11ZM152.5,54.2c0-.16,0-.32,0-.49a53.34,53.34,0,0,0-8.56-29c31-4.05,43.45.32,44.28,3.2C189.42,32,177.43,42.64,152.5,54.2Z" />
</svg>
]]
end

function icons.marker(status)
return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 148.21 197.07">
<path class="a" d="M74.1,42.8a31.32,31.32,0,1,0,31.32,31.32A31.35,31.35,0,0,0,74.1,42.8Zm0,52A20.73,20.73,0,1,1,94.83,74.1,20.75,20.75,0,0,1,74.1,94.83Z" />
<path class="a" d="M74.12,0A74.21,74.21,0,0,0,0,74.13c0,18.39,6.93,32.36,18.88,50.26,12.45,18.7,49.42,68.42,51,70.54a5.28,5.28,0,0,0,8.49,0c1.57-2.11,38.53-51.84,51-70.53,11.95-17.9,18.88-31.87,18.88-50.26A74.18,74.18,0,0,0,74.12,0Zm46.42,118.51c-9.84,14.77-36.1,50.4-46.42,64.36-10.33-14-36.59-49.59-46.43-64.36-12.78-19.15-17.1-30.35-17.1-44.39a63.53,63.53,0,1,1,127,0C137.64,88.16,133.32,99.36,120.54,118.51Z" />
</svg>
]]
end

function icons.ship(status)
return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 196.27 188.83">
<path class="a" d="M183.91,132c-11.23-12.44-48.54-50.86-55.11-57.61V45.16C128.8,13.89,106.58,0,98.14,0S67.47,13.89,67.47,45.16V74.43C60.91,81.18,23.6,119.6,12.36,132-.2,146-.06,162.53,0,170.49v1.41a3.8,3.8,0,0,0,3.8,3.8H57.45a40.18,40.18,0,0,1-5.55,6.53,3.8,3.8,0,0,0,2.58,6.6H141.8a3.8,3.8,0,0,0,2.57-6.6,39.67,39.67,0,0,1-5.54-6.53h53.62a3.8,3.8,0,0,0,3.8-3.8v-1.41C196.33,162.53,196.47,146,183.91,132ZM98.14,7.61c3.91,0,23.06,10.23,23.06,37.55v90.08H75.08V45.16C75.08,17.84,94.22,7.61,98.14,7.61Zm8.8,135.23,7.14,38.39H82.19l7.14-38.39ZM7.61,168.1c0-7.87.84-20.37,10.4-31,9.31-10.31,36.81-38.75,49.46-51.79v60.27c0,7.76-2.34,15.68-5.64,22.48Zm67.47-22.48v-2.78H81.6l-7.14,38.39H62.86C69.54,172.09,75.08,158.76,75.08,145.62Zm46.73,35.6-7.14-38.38h6.53v2.78c0,13.14,5.53,26.47,12.22,35.6Zm12.64-13.12c-3.31-6.8-5.65-14.72-5.65-22.48V85.35c12.65,13,40.15,41.48,49.46,51.79,9.57,10.6,10.38,23.09,10.41,31Z" />
</svg>
]]
end

function icons.player(status)
return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 63.36 198">
<circle class="a" cx="31.68" cy="17.82" r="17.82" />
<path class="a" d="M43.56,41.58H19.8A19.86,19.86,0,0,0,0,61.38v45.54A19.85,19.85,0,0,0,11.88,125v57.12A15.89,15.89,0,0,0,27.72,198h7.92a15.89,15.89,0,0,0,15.84-15.84V125a19.85,19.85,0,0,0,11.88-18.12V61.38A19.86,19.86,0,0,0,43.56,41.58Z" />
</svg>
]]
end

--debug coroutine
function coroutine.xpcall(co)
local output = {coroutine.resume(co)}
if output[1] == false then
   local tb = traceback(co)

   local message = tb:gsub('"%-%- |STDERROR%-EVENTHANDLER[^"]*"', 'chunk')
   system.print(message)

   message = output[2]:gsub('"%-%- |STDERROR%-EVENTHANDLER[^"]*"', 'chunk')
   system.print(message)
   return false, output[2], tb
end
return table.unpack(output)
end

function calcDistance(origCenter, destCenter, location)
local pipe = (destCenter - origCenter):normalize()
local r = (location-origCenter):dot(pipe) / pipe:dot(pipe)
if r <= 0. then
   return (location-origCenter):len()
elseif r >= (destCenter - origCenter):len() then
   return (location-destCenter):len()
end
local L = origCenter + (r * pipe)
pipeDistance =  (L - location):len()

return pipeDistance
end

function calcDistanceStellar(stellarObjectOrigin, stellarObjectDestination, currenLocation)
local origCenter = vec3(stellarObjectOrigin.center)
local destCenter = vec3(stellarObjectDestination.center)

return calcDistance(origCenter, destCenter, currenLocation)
end

function closestPipe()
while true do
   local smallestDistance = nil;
   local nearestPlanet = nil;
   local i = 0
   for obj in pairs(stellarObjects) do
      i = i + 1
      if (stellarObjects[obj].type[1] == 'Planet' or stellarObjects[obj].isSanctuary == true) then
         local planetCenter = vec3(stellarObjects[obj].center)
         local distance = vec3(shipPos - planetCenter):len()

         if (smallestDistance == nil or distance < smallestDistance) then
            smallestDistance = distance;
            nearestPlanet = obj;
         end
      end
      if i > 30 then
         i = 0
         coroutine.yield()
      end
   end
   i = 0
   closestPlanet = stellarObjects[nearestPlanet]
   nearestPipeDistance = nil
   nearestAliothPipeDistance= nil
   for obj in pairs(stellarObjects) do
      if (stellarObjects[obj].type[1] == 'Planet' or stellarObjects[obj].isSanctuary == true) then
         for obj2 in pairs(stellarObjects) do
            i = i + 1
            if (obj2 > obj and (stellarObjects[obj2].type[1] == 'Planet' or stellarObjects[obj2].isSanctuary == true)) then
               pipeDistance = calcDistanceStellar(stellarObjects[obj], stellarObjects[obj2], shipPos)
               if nearestPipeDistance == nil or pipeDistance < nearestPipeDistance then
                  nearestPipeDistance = pipeDistance;
                  sortestPipeKeyId = obj;
                  sortestPipeKey2Id = obj2;
               end
               if stellarObjects[obj].name[1] == "Alioth" and (nearestAliothPipeDistance == nil or pipeDistance < nearestAliothPipeDistance) then
                  nearestAliothPipeDistance = pipeDistance;
                  sortestAliothPipeKeyId = obj;
                  sortestAliothPipeKey2Id = obj2;
               end
            end
            closestPipeData.value = stellarObjects[sortestPipeKeyId].name[1] .. " - " .. stellarObjects[sortestPipeKey2Id].name[1]
            --closestPipeDistData.value = string.format("%03.2f", nearestPipeDistance / 200000.0)
            --closestAliothPipeData.value = stellarObjects[sortestAliothPipeKeyId].name[1] .. " - " .. stellarObjects[sortestAliothPipeKey2Id].name[1]
            --closestAliothPipeDistData.value = string.format("%03.2f", nearestAliothPipeDistance / 200000.0)
            if i > 30 then
               i = 0
               coroutine.yield()
            end
         end
      end
   end
end
end

--2D Planet radar and AR planets
screenHeight = system.getScreenHeight()
screenWidth = system.getScreenWidth()
DisplayRadar = false
function drawonradar(coordonate,PlaneteName)
local constructUp = vec3(construct.getWorldOrientationUp())
local constructForward = vec3(construct.getWorldOrientationForward())
local constructRight = vec3(construct.getWorldOrientationRight())
local ConstructWorldPos = shipPos
local ToCible=coordonate-ConstructWorldPos
local Xcoord = mySignedAngleBetween(ToCible, constructForward, constructUp)/math.pi --*RadarR
local Ycoord = mySignedAngleBetween(ToCible, constructForward, constructRight)/math.pi --*RadarR+RadarY
local XcoordR=Xcoord*math.sqrt(1-Ycoord*Ycoord/2)*RadarR+RadarX
local YcoordR=Ycoord*math.sqrt(1-Xcoord*Xcoord/2)*RadarR+RadarY
svgradar=svgradar..string.format([[
<circle cx="%f" cy="%f" r="4" fill="red" />
<text x="%f" y="%f" font-size="12px" fill="yellow">%s</text>
]],XcoordR,YcoordR,XcoordR+4,YcoordR,PlaneteName)
end

function mySignedAngleBetween(vecteur1, vecteur2, planeNormal)

local normVec1 = vecteur1:project_on_plane(planeNormal):normalize()
local normVec2 = vecteur2:normalize()

local angle = math.acos(normVec1:dot(normVec2))
local crossProduct = vecteur1:cross(vecteur2)

if crossProduct:dot(planeNormal) < 0 then
   return -angle
else
   return angle
end
end

function getClosestPlanet(wp)
local ClosestPlanet={}
ClosestPlanet.distance=999999999999
for BodyId in pairs(atlas[0]) do
   local planet=atlas[0][BodyId]
   local distance=(vec3(planet.center)-wp):len()
   if math.min(ClosestPlanet.distance,distance)==distance then
      ClosestPlanet.name=planet.name[1]
      ClosestPlanet.distance=distance
   end
end
return planet
end

function getClosestPlanet1(wp)
local ClosestPlanet={}
ClosestPlanet.distance=999999999999
for BodyId in pairs(atlas[0]) do
   local planet=atlas[0][BodyId]
   local distance=(vec3(planet.center)-wp):len()
   if math.min(ClosestPlanet.distance,distance)==distance then
      ClosestPlanet.name=planet.name[1]
      ClosestPlanet.distance=distance
   end
end
return ClosestPlanet.name,ClosestPlanet.distance
end

function getClosestPipe1(wp,startLocation)
local ClosestPlanet={}
ClosestPlanet.pipedistance=999999999999
for BodyId in pairs(atlas[0]) do
   local stopLocation=atlas[0][BodyId]
   local pipe=vec3(startLocation.center) - vec3(stopLocation.center)
   local pipedistance=(wp - vec3(startLocation.center)):project_on_plane(pipe):len()
   if math.min(ClosestPlanet.pipedistance,pipedistance)==pipedistance and (vec3(startLocation.center)-wp):len()<pipe:len() and (vec3(stopLocation.center)-wp):len()<pipe:len() then
      ClosestPlanet.pipename=stopLocation.name[1]
      ClosestPlanet.pipedistance=pipedistance
   end
end
return ClosestPlanet.pipename, ClosestPlanet.pipedistance
end

function getSafeZoneDistance(wp)
local CenterSafeZone = vec3(13771471, 7435803, -128971)
local distance=math.floor(((wp-CenterSafeZone):len()-18000000))
return distance
end

playerName = system.getPlayerName(unit.getMasterPlayerId())
xDelta = -238
yDelta = -108
mapScale = .99999
planetScale = 1200
aliothsize = 8000
moonScale = 3000
map = 0
warpScan = 0
targetList = ''
altb=false
safew=''
varcombat = core.getPvPTimer()
function pD()
local pipeD = ''
if nearestPipeDistance >= 100000 then
   pipeD = ''..string.format('%0.2f', nearestPipeDistance/200000)..' su'
elseif nearestPipeDistance >= 1000 and nearestPipeDistance < 100000 then
   pipeD = ''..string.format('%0.1f', nearestPipeDistance/1000)..' km'
else
   pipeD = ''..string.format('%0.0f', nearestPipeDistance)..' m'
end
if nearestPipeDistance >= 600000 then
   return closestPipeData.value.. '<br>' .. '<green1>'..pipeD..'</green1>'
elseif nearestPipeDistance >= 400000 and nearestPipeDistance <= 600000 then
   return closestPipeData.value.. '<br>' .. '<orange1>'..pipeD..'</orange1>'
elseif nearestPipeDistance < 400000 then
   return closestPipeData.value.. '<br>' .. '<red1>'..pipeD..'<red1>'
end
end

shipName = core.getConstructName()
conID = tostring(core.getConstructId()):sub(-3)
bhelper = false
system.showHelper(0)
distS = ''
safetext=''
szsafe=true
tz1=0
tz2=0

function indexSort(tbl)
local idx = {}
for i = 1, #tbl do idx[i] = i end
table.sort(idx, function(a, b) return tbl[a] > tbl[b] end)
return (table.unpack or unpack)(idx)
end

function getResRatioBy2HighestDamage(stress)
local resRatio = {0,0,0,0}
local h1, h2 = indexSort(stress)
if stress[h2] > 0 then
   resRatio[h1] = resMAX/2
   resRatio[h2] = resMAX/2
else
   resRatio[h1] = resMAX
end
return resRatio
end

safeStatus = ''
safeVector = 0
lalt=false
buttonC=false
buttonSpace=false
resMAX = shield.getResistancesPool()
function getRes(stress, resMAX)
local res = {0.15,0.15,0.15,0.15}
if stress[1] >= stress[2] and
stress[1] >= stress[3] and
stress[1] > stress[4] then
   res = {resMAX,0,0,0}
elseif stress[2] >= stress[1] and
   stress[2] >= stress[3] and
   stress[2] > stress[4] then
      res = {0,resMAX,0,0}
   elseif stress[3] >= stress[1] and
      stress[3] >= stress[2] and
      stress[3] > stress[4] then
         res = {0,0,resMAX,0}
      elseif stress[4] >= stress[1] and
         stress[4] >= stress[2] and
         stress[4] > stress[3] then
            res = {0,0,0,resMAX}
         else
            system.print("ERR1")
         end
         return res
      end
      shoteCount = 0
      lastShotTime = system.getTime()
      resCLWN = ""
      ventCLWN = ""
      if GHUD_shield_auto_calibration
      then
         if GHUD_shield_calibration_max then
            shieldText = "SHIELD (AUTO,MAX)"
         end
         if not GHUD_shield_calibration_max then
            shieldText = "SHIELD (AUTO,50)"
         end
      else
         if GHUD_shield_calibration_max then
            shieldText = "SHIELD (MANUAL,MAX)"
         end

         if not GHUD_shield_calibration_max then
            shieldText = "SHIELD (MANUAL,50)"
         end
      end

      brakeText = ""
      if shield.isActive() == 0 then
         shieldColor = "#fc033d"
      else
         shieldColor = "#2ebac9"
      end

      resisttime = 0
      venttime = 0
      venttimemax = shield.getVentingMaxCooldown()
      resisttimemax = shield.getResistancesMaxCooldown()

      for BodyId in pairs(atlas[0]) do
         local planet=atlas[0][BodyId]
         if planet.name[1] == GHUD_destination_planet then
            DestinationCenter = vec3(planet.center)
            DestinationCenterName = planet.name[1]
         end
         if planet.name[1] == GHUD_departure_planet then
            DepartureCenter = vec3(planet.center)
            DepartureCenterName = planet.name[1]
         end
      end

      mybr=false
      --needs redesign
      html1 = [[
      <style>
      .main1 {
         position: fixed;
         width: 11em;
         padding: 1vh;
         top: 1vh;
         left: 50%;
         transform: translateX(-50%);
         text-align: center;
         background: #142027;
         color: white;
         font-family: "Lucida" Grande, sans-serif;
         font-size: 1.5em;
         border-radius: 5vh;
         border: 0.2vh solid;
         border-color: #fca503;
         </style>
         <div class="main1">BRAKE ENGAGED</div>]]
         dis=0
         accel=0
         resString = ""
         throttle1=0
         fuel1=0

         blink=1
         shieldAlarm = false
         alarmTimer = false
         t2=nil
         coratinka=0

         -- прибавляет к вектору, из двух координат, кусочек длины
         -- и воозращает координату окончания вектора, с учетом прибалвенной длины
         function vectorLengthen(coordinateBegin, coordinateEnd, deltaLen)
            local vector = makeVector(coordinateBegin, coordinateEnd)
            --длина вектора
            local lenVector = vec3(vector):len()
            -- новая длина вектора
            local newLen = lenVector + deltaLen
            local factor = newLen / lenVector
            --новый вектор с удлиненной координатой
            local newVector = vector * factor
            -- надо прибавить к первой начальной координате полученый вектор
            local x = vec3(coordinateBegin).x + vec3(newVector).x
            local y = vec3(coordinateBegin).y + vec3(newVector).y
            local z = vec3(coordinateBegin).z + vec3(newVector).z
            -- итого координата окончания удлиненного вектора
            local resultCoordinate = vec3(x, y, z)
            return resultCoordinate
         end

         function customDistance(distance)
            local distanceS=''
            if distance < 1000 then
               distanceS = ''..string.format('%0.0f', distance)..' m'
            elseif distance < 100000 then
               distanceS = ''..string.format('%0.1f', distance/1000)..' km'
            else
               distanceS = ''..string.format('%0.2f', distance/200000)..' su'
            end
            return distanceS
         end

         local function signedAngleBetween(vec1, vec2, planeNormal)
            local normVec1 = vec1:normalize()
            local normVec2 = vec2:normalize()
            local cosAngle = normVec1:dot(normVec2)
            cosAngle = utils.clamp(cosAngle, -1, 1)
            local angle = math.acos(cosAngle)
            local crossProduct = vec1:cross(vec2)
            if crossProduct:dot(planeNormal) < 0 then
               return -angle - math.pi
            else
               return angle + math.pi
            end
         end
         local function directionToBearing (direction, worldVertical)
            local north = vec3(0, 0, 1)
            local northOnGround = north:project_on_plane(worldVertical)
            local directionOnGround = direction:project_on_plane(worldVertical)
            return signedAngleBetween(northOnGround, directionOnGround, worldVertical)
         end
         function rotateX3D(point, theta)
            theta = theta * math.pi / 180
            local sinTheta = math.sin(theta);
            local cosTheta = math.cos(theta);
            local y = point.y * cosTheta - point.z * sinTheta
            local z = point.z * cosTheta + point.y * sinTheta
            point.y = y
            point.z = z
            return point
         end
         function rotateY3D(point, theta)
            theta = theta * math.pi / 180
            local sinTheta = math.sin(theta);
            local cosTheta = math.cos(theta);
            local x = point.x * cosTheta - point.y * sinTheta
            local y = point.y * cosTheta + point.x * sinTheta
            point.x = x
            point.y = y
            return point
         end
         function rotateZ3D(point, theta)
            theta = theta * math.pi / 180
            local sinTheta = math.sin(theta);
            local cosTheta = math.cos(theta);
            local x = point.x * cosTheta + point.z * sinTheta
            local z = point.z * cosTheta - point.x * sinTheta
            point.x = x
            point.y = y
            return point
         end

         --3D galaxy map
         function drawMap()
            local asteroid=""
            local planet=""
            local asterunits=""
            local asternumbers=""
            local galaxyMap = ''

            galaxyMap = [[
            <div class="system-map">
            <div class="map-actual" style="transform: perspective(1920px) translateZ(-250px);">
            <div class="map-center" style="transform: translate(-50%, -50%) rotateX(]]..yDelta..[[deg) rotateY(0deg) rotateZ(]]..xDelta..[[deg);"></div>
            ]]

            for BodyId in pairs(stellarObjects) do
               --local planetBody = helios[v.bodyId]
               local v = stellarObjects[BodyId]
               local planetName = v.name[1]
               local typeplanet = v.type[1]
               local center = vec3(v.center)
               local distance = customDistance(vec3(shipPos - vec3(v.center)):len())

               local coords = {x=center.x + (-center.x * mapScale), y=center.y + (-center.y * mapScale), z=center.z + (-center.z * mapScale)}
               rotateY3D(coords, xDelta)
               rotateX3D(coords, yDelta)
               local mainPlanet = true;
               local size = planetScale

               if vec3(shipPos - vec3(v.center)):len() > 12000000 then
                  size = planetScale
               else
                  size = aliothsize
               end
               local display = "block"
               if typeplanet ~= 'Planet' then
                  size = moonScale
                  display = "none"
               end

               local planet = [[
               <div class="map-pin" style="display: ]]..display..[[; transform: translate(-50%, -50%) translateX(]]..coords.x..[[px) translateY(]]..coords.y..[[px) translateZ(]]..coords.z..[[px);">
               <div class="pin-data" style="display: ]]..display..[[;">
               <div class="name">]]..planetName..[[</div>
               <div class="units">]]..distance..[[</div>
               </div>
               <div class="planet" style="width: ]]..(v.radius/size)..[[px; height: ]]..(v.radius/size)..[[px;"></div>
               </div>
               ]]

               galaxyMap = galaxyMap .. planet
            end

            local shipPosition = construct.getWorldPosition()
            local shipCoords = {x=shipPosition[1] + (-shipPosition[1] * mapScale), y=shipPosition[2] + (-shipPosition[2] * mapScale), z=shipPosition[3] + (-shipPosition[3] * mapScale)}
            rotateY3D(shipCoords, xDelta)
            rotateX3D(shipCoords, yDelta)

            local playerPosition = [[
            <div class="map-pin player" style="transform: translate(-50%, -50%) translateX(]]..shipCoords.x..[[px) translateY(]]..shipCoords.y..[[px) translateZ(]]..shipCoords.z..[[px);">
            <div class="pin-data">
            <div class="name"></div>
            </div>
            ]]..icons.player()..[[
            </div>
            ]]
            galaxyMap = galaxyMap.. playerPosition

            if asteroidPOS ~= "" then
               local aPosition = asteroidcoord
               local distance = customDistance(vec3(aPosition - shipPos):len())
               local asteroidC = {x=aPosition.x + (-aPosition.x * mapScale), y=aPosition.y + (-aPosition.y * mapScale), z=aPosition.z + (-aPosition.z * mapScale)}
               rotateY3D(asteroidC, xDelta)
               rotateX3D(asteroidC, yDelta)
               local asteroid = [[
               <div class="map-pin" style="transform: translate(-50%, -50%) translateX(]]..asteroidC.x..[[px) translateY(]]..asteroidC.y..[[px) translateZ(]]..asteroidC.z..[[px);">
               <div class="pin-data">
               <div class="name">]]..GHUD_marker_name..[[</div>
               <div class="units">]]..distance..[[</div>
               </div>
               <div class="warp-scan"></div>
               </div>
               ]]
               galaxyMap = galaxyMap..asteroid..'</div></div>'
            end
            galaxyMap = galaxyMap .. '</div></div>'

            return galaxyMap
         end

         mapGalaxy = [[
         <style>
         .system-map {
            position: absolute;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(7, 44, 82, .81);
            left: 0;
         }
         .planet {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid;
            box-sizing: border-box;
            background: rgba(148, 206, 255, .29);
         }
         .map-actual {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            transform-style: preserve-3d;
         }
         .map-center {
            position: absolute;
            content: '';
            width: 2000px;
            height: 2000px;
            top: 50%;
            left: 50%;
            background: repeating-radial-gradient(rgba(0, 17, 35, .23), transparent 112px), repeating-radial-gradient(rgba(148, 206, 255, .34), transparent 75%);
            border-radius: 50%;
         }
         .map-pin {
            position: absolute;
            top: 50%;
            left: 50%;
         }
         .map-pin .icon,
         .map-pin .planet {
            height: 30px;
            width: 30px;
         }
         .pin-data {
            position: absolute;
            bottom: 100%;
            margin-bottom: 10px;
            white-space: nowrap;
            text-align: center;
            width: 200px;
            left: 50%;
            transform: translateX(-50%);
         }
         .pin-data .name {
            font-size: 16px;
            color: white;
            line-height: 16px;
         }
         .pin-data .units {
            font-family: monospace;
            font-size: 14px;
            font-weight: bold;
            line-height: 14px;
         }
         .map-pin.player {
            filter: drop-shadow(0px 0px 20px #edf7ff);
         }
         .map-pin.player .icon {
            fill: #ffde56;
         }
         .con-size {
            width: 20px;
            text-align: center;
            background: #235f92;
            margin-right: 4px;
            color: white;
            height: 18px;
         }
         .warp-scan {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            box-sizing: border-box;
            background: #ff3a56;
         }
         </style>]]

         main1 = coroutine.create(closestPipe)

         transponder.deactivate() --transponder server bug fix
         unit.setTimer('tr',2)

         unit.setTimer("hud",0.02)
