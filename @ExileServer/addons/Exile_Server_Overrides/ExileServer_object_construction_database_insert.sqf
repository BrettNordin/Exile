/**
 * ExileServer_object_construction_database_insert
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 * 64Bit Conversion File Header (Extdb3) - Validatior
 */

private["_constructionObject","_position","_vectorDirection","_vectorUp","_territoryFlag","_territoryID","_data","_extDB2Message","_constructionID"];
_constructionObject = _this;
_position = getPosATL _constructionObject;
_vectorDirection = vectorDir _constructionObject;
_vectorUp = vectorUp _constructionObject;
_territoryFlag = _constructionObject call ExileClient_util_world_getTerritoryAtPosition;
_territoryID = if (isNull _territoryFlag) then { '' } else  { _territoryFlag getVariable ["ExileDatabaseID", 'NULL']};
_data =
[
	typeOf _constructionObject,
	_constructionObject getVariable ["ExileOwnerUID", ""],
	_position select 0,
	_position select 1,
	_position select 2,
	_vectorDirection select 0,
	_vectorDirection select 1,
	_vectorDirection select 2,
	_vectorUp select 0,
	_vectorUp select 1,
	_vectorUp select 2,
	_territoryID
];
_extDB2Message = ["insertConstruction", _data] call ExileServer_util_extDB2_createMessage;
_constructionID = _extDB2Message call ExileServer_system_database_query_insertSingle;
_constructionObject setVariable ["ExileDatabaseID", _constructionID];
_constructionObject setVariable ["ExileTerritoryID", _territoryID];

_constructionID
