#Magic Carpet Level Reader by Moburma

#VERSION 0.2
#LAST MODIFIED: 15/04/2023

<#
.SYNOPSIS
   This script can read uncompressed Magic Carpet level files (LEV00xxx.DAT) and output human readable information 
   on all Things placed in that level, including enemies, scenery spells, 2D coordinates and 
   what type of creature/switch/etc they are. Also outputs Wizard data - how many wizards in level and their ability 
   levels.

.DESCRIPTION    
    Reads Magic Carpet Level files and outputs character definitions as human readable data in a CSV 
    in current directory. 
    

.PARAMETER Filename
   
   The level file to open. E.g. LEV00000.DAT, and then if you want a map drawn or not: -map

   MCLevelReader.ps1  LEV00000.DAT -map


.RELATED LINKS
    
    https://github.com/michaelhoward/MagicCarpetFileFormat
    
#>

Param (
    [Parameter()]
     [string]$filename,

    [Parameter()]
     [switch]$map
 

) 


 if ($map.IsPresent) {
    $drawmap = 1
    $bmpaassem =[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $bmp = New-Object System.Drawing.Bitmap(256, 256)
    write-host "Creating level map bitmap"
}


if ($filename -eq $null){
write-host "Error - No argument provided. Please supply a target level file to read!" -ForegroundColor Red
write-host ""
write-host "Example: MCLevelReader.ps1 LEV000001.DAT"
}
Else{

if ((Test-Path -Path $filename -PathType Leaf) -eq 0){
write-host "Error - No file with that name found. Please supply a target level file to read!" -ForegroundColor Red
write-host ""
write-host "Example: MCLevelReader.ps1 LEV000001.DAT"
exit
}

$levfile = Get-Content $filename -Encoding Byte -ReadCount 0
$rnccheck = Get-Content $filename -TotalCount 1

if ($rnccheck -like "RNC*"){
write-host "RNC header detected, you must uncompress this file first before running!" -ForegroundColor Red
exit
}


function convert16bitint($Byteone, $Bytetwo) {
   
$converbytes16 = [byte[]]($Byteone,$Bytetwo)
$converted16 =[bitconverter]::ToInt16($converbytes16,0)

return $converted16

}

function convert32bitint($Byteone, $Bytetwo, $Bytethree, $ByteFour) {
   
$converbytes32 = [byte[]]($Byteone,$Bytetwo,$Bytethree,$ByteFour)
$converted32 =[bitconverter]::ToUInt32($converbytes32,0)

return $converted32

}


function identifyThing ($class){ 

Switch ($class) {

    0{ return 'Unknown'}
    1{ return 'N/A'}
    2{ return 'Scenery'}
    3{ return 'Player Spawn'}
    4{ return 'N/A'}
    5{ return 'Creature'}
    6{ return 'N/A'}
    7{ return 'Weather'}
    8{ return 'N/A'}
    9{ return 'N/A'}
    10{ return 'Effect'}
    11{ return 'Switch'}
    12{ return 'Spell'}


}
}


function identifycreature ($model){ #Returns what the creature type name is

switch ($model)
{

    0{ return 'Dragon'}
    1{ return 'Vulture'}
    2{ return 'Bee'}
    3{ return 'Worm'}
    4{ return 'Archer'}
    5{ return 'Crab'}
    6{ return 'Kraken'}
    7{ return 'Troll'}
    8{ return 'Griffin'}
    9{ return 'Skeleton'}
    10{ return 'Emu'}
    11{ return 'Genie'}
    12{ return 'Builder'}
    13{ return 'Townie'}
    14{ return 'Trader'}
    15{ return 'Unknown'}
    16{ return 'Wyvern'}

    default { return "Unknown" }
  

}
}


function identifyscenery($model){ #Returns what the scenery type name is

Switch ($model){  

    0{ return 'Tree'}
    1{ return 'Standing Stone'}
    2{ return 'Dolmen'}
    3{ return 'Bad Stone'}
    4{ return '2D Dome'}
    5{ return '2D Dome'}
    default { return "Unknown" }



}


}



function identifyEffect($model){ #Returns what the effect name is

Switch ($model){  

    0{ return 'Unknown'}
    1{ return 'Big explosion'}
    2{ return 'Unknown'}
    3{ return 'Unknown'}
    4{ return 'Unknown'}
    5{ return 'Splash'}
    6{ return 'Fire'}
    7{ return 'Unknown'}
    8{ return 'Mini Volcano'}
    9{ return 'Volcano'}
    10{ return 'Mini crater'}
    11{ return 'Crater'}
    12{ return 'Unknown'}
    13{ return 'White smoke'}
    14{ return 'Black smoke'}
    15{ return 'Earthquake'}
    16{ return 'Unknown'}
    17{ return 'Meteor'}
    18{ return 'Unknown'}
    19{ return 'Unknown'}
    20{ return 'Unknown'}
    21{ return 'Steal Mana'}
    22{ return 'Unknown'}
    23{ return 'Lightning'}
    24{ return 'Rain of Fire'}
    25{ return 'Unknown'}
    26{ return 'Unknown'}
    27{ return 'Unknown'}
    28{ return 'Wall'}
    29{ return 'Path'}
    30{ return 'Unknown'}
    31{ return 'Canyon'}
    32{ return 'Unknown'}
    33{ return 'Unknown'}
    34{ return 'Teleport'}
    35{ return 'Unknown'}
    36{ return 'Unknown'}
    37{ return 'Unknown'}
    38{ return 'Unknown'}
    39{ return 'Mana Ball'}
    40{ return 'Unknown'}
    41{ return 'Unknown'}
    42{ return 'Unknown'}
    43{ return 'Unknown'}
    44{ return 'Unknown'}
    45{ return 'Villager Tent'}
    46{ return 'Unknown'}
    47{ return 'Unknown'}
    48{ return 'Unknown'}
    49{ return 'Unknown'}
    50{ return 'Ridge Node'}
    51{ return 'Unknown'}
    52{ return 'Crab Egg'}
    default { return "Unknown" }

}

}


function identifySwitch($model){ #Returns what kind of switch this is

Switch ($model){  
 
    0{ return 'Hidden Inside'}
    1{ return 'Hidden outside'}
    2{ return 'Hidden Inside re'}
    3{ return 'Unknown'}
    4{ return 'On victory'}
    5{ return 'Death Inside'}
    6{ return 'Death Outside'}
    7{ return 'Death inside re'}
    8{ return 'Unknown'}
    9{ return 'Obvious Inside'}
    10{ return 'Obvious outside'}
    11{ return 'Unknown'}
    12{ return 'Unknown'}
    13{ return 'Dragon'}
    14{ return 'Vulture'}
    15{ return 'Bee'}
    16{ return 'None'}
    17{ return 'Archer'}
    18{ return 'Crab'}
    19{ return 'Kraken'}
    20{ return 'Troll'}
    21{ return 'Griffon'}
    22{ return 'Unknown'}
    23{ return 'Unknown'}
    24{ return 'Genie'}
    25{ return 'Unknown'}
    26{ return 'Unknown'}
    27{ return 'Unknown'}
    28{ return 'Unknown'}
    29{ return 'Wyvern'}
    30{ return 'Creature all'}

}

}


function identifyspawn ($model){ 

Switch ($model) {

    0{ return 'Unknown'}
    1{ return 'Unknown'}
    2{ return 'Unknown'}
    3{ return 'Unknown'}
    4{ return 'Flyer1'}
    5{ return 'Flyer2'}
    6{ return 'Flyer3'}
    7{ return 'Flyer4'}
    8{ return 'Flyer5'}
    9{ return 'Flyer6'}
    10{ return 'Flyer7'}
    11{ return 'Flyer8'}


}
}

function identifyspell ($model){ 

Switch ($model) {

    0{ return 'Fireball'}
    1{ return 'Heal'}
    2{ return 'Speed Up'}
    3{ return 'Posession'}
    4{ return 'Shield'}
    5{ return 'Beyond Sight'}
    6{ return 'Earthquake'}
    7{ return 'Meteor'}
    8{ return 'Volcano'}
    9{ return 'Crater'}
    10{ return 'Teleport'}
    11{ return 'Duel'}
    12{ return 'Invisible'}
    13{ return 'Steal Mana'}
    14{ return 'Rebound'}
    15{ return 'Lightning'}
    16{ return 'Castle'}
    17{ return 'Skeleton'}
    18{ return 'Thunderbolt'}
    19{ return 'Mana Magnet'}
    20{ return 'Fire Wall'}
    21{ return 'Reverse Speed'}
    22{ return 'Global Death'}
    23{ return 'Rapid Fireball'}
    
}
}

function identifyweather($model){ #Returns what the weather type is

Switch ($model){  

    0{ return 'Unknown'}
    1{ return 'Unknown'}
    2{ return 'Unknown'}
    3{ return 'Unknown'}
    4{ return 'Wind'}
    default { return "Unknown" }
}


}


function Wizardname($wizardname){ #Returns what the Wizard's name is

Switch ($wizardname){  

    1{ return 'Vodor'}
    2{ return 'Gryshnak'}
    3{ return 'Mahmoud'}
    4{ return 'Syed'}
    5{ return 'Raschid'}
    6{ return 'Alhabbal'}
    7{ return 'Scheherazade'}
    

}


}


function SpellLoadout($spellstart){
$spellList = ""

if ($levfile[$spellstart] -eq 1){
$spellList += "Fireball, "
} 

if ($levfile[$spellstart+1] -eq 1){
$spellList += "Shield, "
} 

if ($levfile[$spellstart+2] -eq 1){
$spellList += "Accelerate, "
} 

if ($levfile[$spellstart+3] -eq 1){
$spellList += "Posession, "
} 

if ($levfile[$spellstart+4] -eq 1){
$spellList += "Health, "
} 

if ($levfile[$spellstart+5] -eq 1){
$spellList += "Beyond Sight, "
} 

if ($levfile[$spellstart+6] -eq 1){
$spellList += "Earthquake, "
}

if ($levfile[$spellstart+7] -eq 1){
$spellList += "Meteor, "
}

if ($levfile[$spellstart+8] -eq 1){
$spellList += "Volcano, "
}

if ($levfile[$spellstart+9] -eq 1){
$spellList += "Crater, "
}

if ($levfile[$spellstart+10] -eq 1){
$spellList += "Teleport, "
}

if ($levfile[$spellstart+11] -eq 1){
$spellList += "Duel, "
}

if ($levfile[$spellstart+12] -eq 1){
$spellList += "Invisible, "
}

if ($levfile[$spellstart+13] -eq 1){
$spellList += "Steal Mana, "
}

if ($levfile[$spellstart+14] -eq 1){
$spellList += "Rebound, "
}

if ($levfile[$spellstart+15] -eq 1){
$spellList += "Lightning, "
}

if ($levfile[$spellstart+16] -eq 1){
$spellList += "Castle, "
}

if ($levfile[$spellstart+17] -eq 1){
$spellList += "Undead Army, "
}

if ($levfile[$spellstart+18] -eq 1){
$spellList += "Lightning Storm, "
}

if ($levfile[$spellstart+19] -eq 1){
$spellList += "Mana Magnet, "
}

if ($levfile[$spellstart+19] -eq 1){
$spellList += "Wall of Fire, "
}

if ($levfile[$spellstart+20] -eq 1){
$spellList += "Reverse Acceleration, "
}

if ($levfile[$spellstart+21] -eq 1){
$spellList += "Global Death, "
}

if ($levfile[$spellstart+21] -eq 1){
$spellList += "Rapid Fireball"
}

Return $spellList

}

$thingcount = 1999
$counter = 0
$Wnumber = 1
#Check File type

$manatotal =  convert32bitint $levfile[0] $levfile[1] $levfile[2] $levfile[3]
$manatarget = $levfile[38800]



Write-host "Level Mana Target is $manatarget % of $manatotal"

$playerspells = SpellLoadout 37088
write-host "Player Spells: $playerspells"
write-host ""

write-host "Class,ThingType,Model,ThingName,XPos,YPos,DisId,SwiSz,SwiId,Parent,Child"   #console headers
$Fileoutput = @()
$Wizardoutput = @()

$fpos = 1090


DO
{

$counter = $counter +1

#echo $fpos

$class =  convert16bitint $levfile[$fpos] $levfile[$fpos+1]
$ThingType = identifything $class
$Model =  convert16bitint $levfile[$fpos+2] $levfile[$fpos+3]
$Xpos = convert16bitint $levfile[$fpos+4] $levfile[$fpos+5]
$Ypos =  convert16bitint $levfile[$fpos+6] $levfile[$fpos+7]
$DisId = convert16bitint $levfile[$fpos+8] $levfile[$fpos+9]
$SwiSz = convert16bitint $levfile[$fpos+10] $levfile[$fpos+11]
$SwiId = convert16bitint $levfile[$fpos+12] $levfile[$fpos+13] 
$Parent = convert16bitint $levfile[$fpos+14] $levfile[$fpos+15]
$Child =  convert16bitint $levfile[$fpos+16] $levfile[$fpos+17]


if ($class -eq 0){
$ThingName = "Blank"
}

if ($class -eq 2){ 
$ThingName = identifyscenery $model
    if ($drawmap -eq 1){
    $bmp.SetPixel($xpos, $ypos, 'Green')
    }
}
if ($class -eq 3){ 
$ThingName = identifyspawn $model
    if ($drawmap -eq 1){
    $bmp.SetPixel($xpos, $ypos, 'Yellow')
    }
}
if ($class -eq 5){ 
$ThingName = identifycreature $model
    if ($drawmap -eq 1){
    $bmp.SetPixel($xpos, $ypos, 'Red')
    }
}
if ($class -eq 7){ 
$ThingName = identifyweather $model
}
if ($class -eq 10){ 
$ThingName = identifyeffect $model
if ($drawmap -eq 1){
    $bmp.SetPixel($xpos, $ypos, 'Cyan')
    }

}
if ($class -eq 11){ 
$ThingName = identifyswitch $model
if ($drawmap -eq 1){
    $bmp.SetPixel($xpos, $ypos, 'white')
    }

}
if ($class -eq 12){ 
$ThingName = identifyspell $model
    if ($drawmap -eq 1){
    $bmp.SetPixel($xpos, $ypos, 'Purple')
    }
}




#Output to console

$consoleoutput = "$counter, $class, $ThingType, $model, $Thingname, $xpos, $ypos, $disid, $swisz, $swiid, $parent, $child" 
write-host $consoleoutput

#output toarray to output CSV file 

$CharacterEntry = New-Object PSObject
$CharacterEntry | Add-Member -type NoteProperty -Name 'Class' -Value $class
$CharacterEntry | Add-Member -type NoteProperty -Name 'ThingType' -Value $ThingType
$CharacterEntry | Add-Member -type NoteProperty -Name 'Model' -Value $Model
$CharacterEntry | Add-Member -type NoteProperty -Name 'ThingName' -Value $Thingname
$CharacterEntry | Add-Member -type NoteProperty -Name 'XPos' -Value $XPos
$CharacterEntry | Add-Member -type NoteProperty -Name 'YPos' -Value $YPos
if($disid -eq -1){
$disid = 65535
}

$CharacterEntry | Add-Member -type NoteProperty -Name 'DisId' -Value $DisId
$CharacterEntry | Add-Member -type NoteProperty -Name 'SwiSz' -Value $swisz

if($swiid -eq -1){
$swiid = 65535
}
$CharacterEntry | Add-Member -type NoteProperty -Name 'SwiId' -Value $swiid
$CharacterEntry | Add-Member -type NoteProperty -Name 'Parent' -Value $parent
$CharacterEntry | Add-Member -type NoteProperty -Name 'Child' -Value $child



$Fileoutput += $characterentry

$ThingCount = $ThingCount - 1


$fpos = $fpos + 18
}
UNTIL ($ThingCount -eq 0)

#Output to CSV
$csvname = [io.path]::GetFileName("$filename")
$pathname = get-location
#$pathname = $pathname.tostring()

$fileext = $csvname+".Things.csv"
$mapname = $csvname+".png"
write-host "Exporting Things list to $fileext"

$Fileoutput | export-csv -NoTypeInformation $fileext

if($drawmap -eq 1){
write-host "Exporting map to $pathname\$mapname"
$bmp.Save($pathname.tostring()+"\"+$mapname)

}

$fpos = 37292

$numwizards = $levfile[38802] - 1
$CLevel = 38805

DO
{

$Wname =  WizardName $Wnumber
$Aggression =  $levfile[$fpos]
$Perception =  $levfile[$fpos+4] 
$Reflexes =   $levfile[$fpos+8]
$CastleLevel = $levfile[$CLevel]

if ($wnumber -eq 1){
$wizardspells = SpellLoadout 37304
}
Elseif ($wnumber -eq 2){
$wizardspells = SpellLoadout 37520
}
Elseif ($wnumber -eq 3){
$wizardspells = SpellLoadout 37736
}
Elseif ($wnumber -eq 4){
$wizardspells = SpellLoadout 37952
}
Elseif ($wnumber -eq 5){
$wizardspells = SpellLoadout 38168
}
Elseif ($wnumber -eq 6){
$wizardspells = SpellLoadout 38384
}
Elseif ($wnumber -eq 7){
$wizardspells = SpellLoadout 38600
}

if ($Wnumber -gt  $numwizards){
$wpresent = "No"
}
Else{
$wpresent = "Yes"
}


$WizardEntry = New-Object PSObject
$WizardEntry| Add-Member -type NoteProperty -Name 'WizardName' -Value $wname
$WizardEntry | Add-Member -type NoteProperty -Name 'Aggression' -Value $Aggression
$WizardEntry | Add-Member -type NoteProperty -Name 'Perception' -Value $Perception
$WizardEntry | Add-Member -type NoteProperty -Name 'Reflexes' -Value $Reflexes
$WizardEntry | Add-Member -type NoteProperty -Name 'CastleLevel' -Value $CastleLevel
$WizardEntry | Add-Member -type NoteProperty -Name 'Present' -Value $wpresent
$WizardEntry | Add-Member -type NoteProperty -Name 'SpellLoadout' -Value $wizardspells

$Wizardoutput += $WizardEntry

$wnumber = $wnumber + 1
$fpos = $fpos + 216
$CLevel = $CLevel + 1

}UNTIL ($wnumber -eq 8)

$fileext = $csvname+".Wizards.csv"

write-host "Exporting Wizard data to $fileext"

$Wizardoutput | export-csv -NoTypeInformation $fileext

}

