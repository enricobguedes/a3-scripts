
// Script to calculate impact zones of competition
// targets and display results for competitions.
//
// Can be used in tandem with the shotTimer.
//
// 
// Used for either training or competition 
// Author: Enrico - 04/28/2025 
//
// DEMO VERSION.
// Known issues: 
// 1-) height over bore (aka where EYES vs MUZZLE is)
// 2-) Still have to carve out the small edges of shapes

// add to static object IE: Target
this addEventHandler ["HitPart", { 
 (_this select 0)  params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", 
 "_ammo", "_vector", "_radius", "_surfaceType"] ;
 _tar=_target; _shot=_shooter; _proj=_projectile; _pos=_position;
 _vel=_velocity; _sel=_selection; _amm=_ammo; _vec=_vector; _rad=_radius;
 _st=_surfaceType; [_tar, _shot, _proj, _pos, _vel, _sel,_amm,
 _vec,  _rad, _st] call ENR_fnc_ipsc_HitZone; 
}];


ENR_fnc_ipsc_HitZone = {   
params ["_tar", "_shooter", "_dam", "_pos", "_impact", "_targetSelection", "_ammo", "_hitSurf", "_radius", "_st" ];   
  
// Figure out what exactly is our target 
// and deal with it appropriately 
switch (typeOf _tar) do {  
  case "GK_ipsc_HZR";  
  case "GK_ipsc_HZL"; 
  case "GK_ipsc_Z";  
  case "GK_ipsc_tape";  
  case "GK_ipsc_std": { [_pos, typeOf _tar] call ENR_fnc_calcVectors; break };  
  default {  
    hint format ["Type of %1 is not supported", typeOf _tar];   
  };  
 };   
};  
  
 
// Function to calculate the vectors dinamically 
// and display result data from impacts. 
// Params:  
// vector (array) _shotPlacement -> shot placement on target 
// String (_tar = object) -> expects classname from object caller. 
ENR_fnc_calcVectors = {   
  params ["_shotPlacement", "_kindOfTarget"];   
   
  // separate appropriate values to lighten the performance  
  // impact of calculating full vectors 
  _hitPlaceX= _shotPlacement select 0;   
  _hitPlaceY= _shotPlacement select 2;   
  _staticTarget= [(_shotPlacement select 1),1] call BIS_fnc_cutDecimals;   
   
  // Get the object reference from world it lives in 
  _objectPlace= getPosWorld cursorObject;   
   
  // Calculate the impact based on the real world referance  
  _calculatedImpactX= _hitPlaceX - (_objectPlace select 0);   
  _calculatedImpactY= _hitPlaceY - (_objectPlace select 2);   
   
  // avoid dealing with negatives and streamline operations 
  if (_calculatedImpactX < 0) then {   
    _calculatedImpactX= _calculatedImpactX * -1;   
  };       
   
  // ipsc_std is the only one odd out of the bunch 
  if (_calculatedImpactY < 0 && _kindOfTarget=="GK_ipsc_std") then {   
    _calculatedImpactY= _calculatedImpactY * -1;   
  };   
  
  [_calculatedImpactX, _calculatedImpactY ] call ENR_fnc_calcHitZone; 
}; 
 
ENR_fnc_calcHitZone = { 
  params ["_impactX", "_impactY"];   
 
  // determine the Coeficients of what is valid
  // WIP, will later convert to some fancy datastructure
  _impactZone="No hit";   
  _aZoneCoeficientX=0.068848;
  _cZoneCoeficientX=0.1342; //without edges
  _cZoneCoeficientY=0;
  _dZoneCoeficientX=0.2050;
  _dZoneOutOfBoundsX1=0.20507;       
  _dZoneOutOfBoundsX2=0.13525;
  _dZoneOutOfBoundsY1=0.28443;
  _aZoneHeadCoefX=0.04560;
  _aZoneCoeficientY1=0;
  _aZoneCoeficientY2=0;
  _aZoneHeadCoefY1=0;   
  _aZoneHeadCoefY2=0;
  _dZoneCoeficientY1=0;
  _dZoneCoeficientY2=0;   
   
  // since ipsc_std is the odd out of the bunch, 
  // I had to separate both y1 and y2 from the targets. 
  if (_kindOfTarget == "GK_ipsc_std" ) then {   
    _aZoneCoeficientY1=0.6505;   
    _aZoneCoeficientY2=0.3927;
    _dZoneCoeficientY1=6.5440;
    _dZoneCoeficientY2=0.1482;
    _cZoneCoeficientY=0.2840;
    _aZoneHeadCoefY1=0.8105;
    _aZoneHeadCoefY2=0.7621;
  } else {    
    _aZoneCoeficientY1=0.1590;   
    _aZoneCoeficientY2=-0.09656;
    _cZoneCoeficientY=-0.2057;
    _dZoneCoeficientY1=6.5440;
    _dZoneCoeficientY2=-0.3435;
    _aZoneHeadCoefY1=0.3202;
    _aZoneHeadCoefY2=0.2710;  
  };   
  
  if (_calculatedImpactX < _dZoneCoeficientX && (_calculatedImpactY < _dZoneCoeficientY1 && _calculatedImpactY > _dZoneCoeficientY2)) then {
    _impactZone="D";
    if (_calculatedImpactX < _cZoneCoeficientX && _calculatedImpactY > _cZoneCoeficientY) then {
      _impactZone="C";
      if(_calculatedImpactX < _aZoneCoeficientX && (_calculatedImpactY < _aZoneCoeficientY1 && _calculatedImpactY > _aZoneCoeficientY2 )) then {
        _impactZone="A"; 
     };
   };
 };
  if (_calculatedImpactX < _aZoneHeadCoefX && (_calculatedImpactY < _aZoneHeadCoefY1 && _calculatedImpactY > _aZoneHeadCoefY2)) then {
    _impactZone="A Head";
};


hint format ["Hit: %1 \n Impact at: %2x and %3y", _impactZone, _impactX, _impactY];  
};
