
/*

terminal spec
 
- an environment for playing and composing.

********************************************************

- uses pre-made synths but will have a flexible
  routing system.

- Three windows:

  - Document, for starting a session and coding
  - Listener
  - Inspector: autogui window for editing controls
    and sequences. Also for routing and stuff.
  
- Based around 'parts'. A part contains:

  - Ugen chain (sound)

  - Player- a pattern or task to trigger the sound

  - Workflow 1:

   - First create a player:

     d.player.kick1= (); // event
     d.player.kick1.dur= 0.25; // anything for a Pbind
     d.player.kick1.midinote= (60.dup(14) ++ [59,58]);
     d.player.kick1.trigger= [1, \, \, \, \, \, \, \, 1, \, \, \, \, \, \, \,];

   - either automatically appear in inspector, or:

     d.player.kick1.inspect;
*/

