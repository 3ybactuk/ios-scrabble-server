# ios-scrabble-server
iOS Team Project

## Task description
In teams of three you should design and implement a backend
service that provides an API for a game «[Scrabble](https://en.wikipedia.org/wiki/Scrabble)». The service must
accept requests and respond accordingly.

## Task requirements

The service should allow participants to register and authorize.
* The service should allow participants to:
  * Create gaming rooms
  * Join open gaming rooms
  * Join private rooms via invitation code
* Participant who creates a gaming room becomes its admin.
* Admin should be able to:
  *  Kick participants
  *  Start a round of the game
  *  Pause a round of the game
  *  Close the room
* Gaming room should have:
  * Invite code that can be shared
  * Leaderboard with players nicknames and points
  * Number of letter tiles left in the bag
  * The board with currently added words
  * Letter tiles of an individual player
* Players should play one by one by placing **valid** words made of letters in their
possession on the board. Each letter is then counted with its value and underlying
bonuses to form the score to be added to the leaderboard

## Grading

| Grade    |          |
|----------|--------------------------------------------------------------------------------------------|
| 4     | Service is accessible, it uses a database | 
| 5     | Service is only accessible with provided API key   | 
| 6     | Service allows users to sign up and sign in using JWT  | 
| 7     | Service has gaming rooms that can be joined, and it provides a fully playable API   | 
| 8     | All task requirements are fulfilled including word validation  | 
| 9     | All task requirements are fulfilled, server supports connections from different user devices   | 
| 10    | Your team's service was the best among submitted  | 
