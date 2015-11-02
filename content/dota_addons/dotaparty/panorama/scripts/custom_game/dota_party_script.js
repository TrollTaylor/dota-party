"use strict";


function buttonPress()
{

	GameEvents.SendCustomGameEventToServer( "rollDice", { "roller" : Players.GetLocalPlayer() } );



}	



(function()
{


  Game.AddCommand( "DiceRoll", buttonPress, "", 0 );


})();