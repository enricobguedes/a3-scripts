
// Function to cound and display shots fired
// Used for either training or competition 
// Author: Enrico - 11/2024


// --- MISSION CFG / SERVER INIT / FUNCTION CFG---

arr_TimedShotsFired = []; 
publicVariable "arr_TimedShotsFired"; 
 
enr_fnc_ShotTimer = { 
    params ["_thePlayer"]; 
 
    _randomNum = random 4;  // select a random number between 1 to n for the timer to start
    sleep _randomNum; 
    _source = playSound "AlarmCar"; // choose which sound you want to beep/play when the timer starts
    _source spawn { 
    sleep 0.25; // use this value to control how long th sound will play"
    deleteVehicle _this; 
    }; 
 
    // Script logic
    _initialTime = time; 
    _index = _thePlayer addEventHandler ["Fired", { 
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"]; 
    arr_TimedShotsFired pushBack time; 
    publicVariable "arr_TimedShotsFired"; 
    }]; 
  
    sleep 5; 
    _thePlayer removeEventHandler ["Fired", _index]; 
    _result = "Number of shots fired: " + str (count arr_TimedShotsFired); 
    _shotCount = 1;
    {  
        _roundedShots= [_x - _initialTime,3] call BIS_fnc_cutDecimals; 
        _result =  _result + "\n" +  (str (_shotCount)) + "- " + (str (_roundedShots)) + "sec"; 
        _shotCount = _shotCount + 1;
    } forEach arr_TimedShotsFired; 
    arr_TimedShotsFired = [];  // reset 
    publicVariable "arr_TimedShotsFired";

    // control output (this case is a simple hint)
    hint _result; 
}; 

publicVariable "enr_fnc_ShotTimer"; 

// for public result: _result remoteExec ["hint", 0];
// Make sure to add the following to some item the player can carry
// And this will make him portably access the timer OR
// You can add this to a static object and the player
// Should be able to use it.

this addAction ["IPSC - Shot Timer", {
params ["_target", "_caller", "_actionId", "_arguments"];
[_caller] call enr_fnc_ShotTimer;
}];

