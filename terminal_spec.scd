
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

     ~data.player.kick1= (); // event
     ~data.player.kick1.dur= 0.25; // anything for a Pbind
     ~data.player.kick1.midinote= (60.dup(14) ++ [59,58]);
     ~data.player.kick1.trigger= [1, \, \, \, \, \, \, \, 1, \, \, \, \, \, \, \,];

	or

	~data.kick1= (); // no need to define as a 'part'
	~data.kick1.player[\dur]= 0.25; // anything for a Pbind
     ~data.kick1.player[\midinote]= (60.dup(14) ++ [59,58]);
     ~data.kick1.player[\trigger]= [1, \, \, \, \, \, \, \, 1, \, \, \, \, \, \, \,];

   - either automatically appear in inspector, or:

     ~data.kick1.player.inspect;

   - Then select a synth on the inspector, or create a synth:

	~data.kick1.synth= = Synth(\tml_gen_playbuf);
*/

