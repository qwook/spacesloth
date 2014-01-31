#Map API
---
##Global
#####Methods
`swapCollision(  )`  
`changeMap( string )`  
`playSound( name[, volume]) )`  
`playSound( name, music )`  

##Player
#####Methods
`swapCollision(  )`  
`changeMap( string )`  
`playSound( name[, volume]) )`  
`multiplyVelocity( x, y )`  
`addVelocity( x, y )`  
`setVelocity( x, y )`  
`applyImpulse( x, y )`  
`setFriction( number )` 
`teleportTo( object )`  

##Everything Else
#####Events:
`onSpawn`
#####Methods
`setVelocity( x, y )`  
`setVisible( boolean )`  
`setFrozen( boolean )`  
`teleportTo( object )`  
`destroy(  )`

##PhysBox
A box that's used for testing and stuff.
Everything is secretly derived from it for no good reason.
#####Events:
`onSpawn`
#####Methods
`setVelocity( number, number, number )`  
`setVisible( boolean )`  
`setFrozen( boolean )`  
`teleportTo( object )`  
`teleportTo( object )`  
`destroy(  )`

##Toggle
Toggles a button on and off.
#####Events:
`onToggle`
`onPress`
`onRelease`

##Button
Activates only when player is touching button
#####Events:
`onPress`
`onRelease`

##Trigger
A rectangle that activates then the player enters.
#####Attributes:
`filter` : `PLAYER, PHYSBOX, TILE`
#####Events:
`onTrigger`
`onBothPlayers`
`onTriggerEnd`
`onBothPlayersEnd`

##Camera
Moves the camera to a position on the map.
#####Methods
`setActivated( boolean )`

##Timer
#####Attributes:
`time` : `the time it takes for the timer to end`
#####Methods
`start(  )`

##Text
Draws a text.
#####Attributes:
`string` : `the text you want to put here`
#####Methods
`type( )` types out the text you put in
