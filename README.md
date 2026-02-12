 ###  Grid-based realtime card battler ###

The aim is to create a simple game where the player fights off an increasing difficulty of monsters using cards that they draw from a deck. The aim is for the player to use a card in their hand on the monsters around them e.g. a sword card will allow one sweep attack in a direction. That card will go back into the deck when used and can be drawn again later to be used again.


--- Card Engine thoughts ---

Some thought needs to be given to how the cards will be cycled, my initial thought was to have 3 cards in your hand and when you've used them all to daw 3 more. Since i want this to be a realtime game does this mean the faster someone is the more actions they can take, I feel like speed is something to be rewarded but I want there to be dimishing returns. 
1. have a cooldown after all the cards are used to shuffle and deal again. This rewards speed but has a cap
2. have a cooldown between all actions(movement included). This limits the reward from being quick to the length of the cooldown
3. have a cooldown between playing cards but not between movements.
4. have each card have a seperate cooldown
5. have no cooldowns at all. Rewards speed to the player's/engine's limits
6. have a meter that increases every card played until it hits a limit that forces the player to recover for a period of time. This meter would steadily lower over time so you could use several cards for a burst of actions but you will have to let it recharge afterwards.


--- Battle thoughts ---

I plan to create similar game play to my previous adventure game except using cards to do actions instead of having attacks on cooldown. That way I have an environment I can generate easily and a framework for programming enemies and attacks. Based on initial thoughts on card ideas it might be good to be able to play the cards in a direction e.g. click sword/shield card then click direction to attack/block in a direction. This gives us a reason to use a grid based system, so that direction is important.


--- Cards played meter thoughts ---

This idea would make this meter part of, or wholly, the resource management system that would keep the player focused throughout the game from start to finsih. This would also open up card ideas that interract with the card meter in some way e.g. reduce the time spent in overload, reduce the amount of the meter that each card increases it by.


--- Overall gameplay/progression thoughts ---

This is the part of a game that I find the hardest to be able to generate useful ideas. I want this game to be reletively simple to make so that I can actually finish it. I want there to be a fight selection process so the player decides who they fight. I liked a previous idea I had that there be 3 easier enemies you can fight before fighting the boss and then progressing through that system 5 (?) times. The player would get loot from the 4 fights(new cards etc.) and a larger loot item from the boss but wouldn't have to fight any of the easier fights if they didn't want to. The less of the 4 fights they engage with the better the boss loot.
So this sounds like a roguelike game.



--- Card ideas ---

 - Sword - slashes 3 tiles in a given direction
 - Shield - blocks the next attack from a direction by 5?
 - a dud card of some kind, doesn't use stamina and allows us to draw a new hard faster
