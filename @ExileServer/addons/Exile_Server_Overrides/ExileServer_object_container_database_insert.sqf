/**
 * ExileServer_object_container_database_insert
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 * 64Bit Conversion File Header (Extdb3) - Validatior
 */
 
private["_containerObject","_position","_vectorDirection","_vectorUp","_territoryFlag","_territoryID","_data","_extDB2Message","_containerID","_cargoContainers"];
_containerObject = _this;
_position = getPosATL _containerObject;
_vectorDirection = vectorDir _containerObject;
_vectorUp = vectorUp _containerObject;
_territoryFlag = _containerObject call ExileClient_util_world_getTerritoryAtPosition;
_territoryID = if (isNull _territoryFlag) then { '' } else  { _territoryFlag getVariable ["ExileDatabaseID", '']};
if !(ExileContainerCargo isEqualTo []) then
{
	_data =
	[
		typeOf _containerObject,
		_containerObject getVariable ["ExileOwnerUID", ""],
		_position select 0,
		_position select 1,
		_position select 2,
		_vectorDirection select 0,
		_vectorDirection select 1,
		_vectorDirection select 2,
		_vectorUp select 0,
		_vectorUp select 1,
		_vectorUp select 2,
		ExileContainerCargo select 0,
		ExileContainerCargo select 1,
		ExileContainerCargo select 2,
		ExileContainerCargo select 3,
		ExileContainerCargo select 4,
		"0000",
		_territoryID
	];
} else
{
	_data =
	[
		typeOf _containerObject,
		_containerObject getVariable ["ExileOwnerUID", ""],
		_position select 0,
		_position select 1,
		_position select 2,
		_vectorDirection select 0,
		_vectorDirection select 1,
		_vectorDirection select 2,
		_vectorUp select 0,
		_vectorUp select 1,
		_vectorUp select 2,
		[],
		[],
		[],
		[],
		0,
		"0000",
		_territoryID
	];
};
_extDB2Message = ["insertContainer", _data] call ExileServer_util_extDB2_createMessage;
_containerID = _extDB2Message call ExileServer_system_database_query_insertSingle;
if !(ExileContainerCargo isEqualTo []) then
{
	[_containerObject, (_data select 11)] call ExileServer_util_fill_fillItems;
	[_containerObject, (_data select 12)] call ExileServer_util_fill_fillMagazines;
	[_containerObject, (_data select 13)] call ExileServer_util_fill_fillWeapons;
	_cargoContainers = format ["loadContainerCargo:%1", _containerID] call ExileServer_system_database_query_selectSingle;
	if !(_cargoContainers isEqualTo []) then
	{
		[_containerObject, (_cargoContainers select 0)] call ExileServer_util_fill_fillContainers;
	};
	ExileContainerCargo = [];
};
_containerObject setVariable ["ExileDatabaseID", _containerID];
_containerObject setVariable ["ExileIsPersistent", true];
_containerObject setVariable ["ExileIsContainer", true];
_containerObject setVariable ["ExileAccessCode","0000"];
_containerObject setVariable ["ExileTerritoryID", _territoryID];
_containerObject setVariable ["ExileMoney", parseNumber (_data select 15), true];
_containerObject addMPEventHandler ["MPKilled", { if !(isServer) exitWith {}; (_this select 0) call ExileServer_object_container_event_onMpKilled; }];
if(getNumber(configFile >> "CfgVehicles" >> typeOf _containerObject >> "exileIsLockable") isEqualTo 1)then
{
	_containerObject setVariable ["ExileIsLocked",-1,true];
	_containerObject setVariable ["ExileHackAttempts", 0];
	_containerObject setVariable ["ExileHackerUID", "", true];
};
_containerID
