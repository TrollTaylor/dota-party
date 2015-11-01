"use strict";


function buttonPress()
{


	$.Msg("Yep");

}	



(function()
{


  Game.AddCommand( "DiceRoll", buttonPress, "", 0 );


})();