
/*

terminal spec
 
- an environment for playing and composing.

********************************************************************************

- Uses pre-made synths but will have a flexible
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
	  ~data.kick1= (); // no need to define as a 'part'
	  ~data.kick1.player[\dur]= 0.25; // anything for a Pbind
	  ~data.kick1.player[\midinote]= (60.dup(14) ++ [59,58]);
	  ~data.kick1.player[\trigger]=
	  	[1, \, \, \, \, \, \, \, 1, \, \, \, \, \, \, \,];

	  Part either automatically appears in inspector, or:
       ~data.kick1.player.inspect; // or something

	- Then select a synth on the inspector, or create a synth:
	  ~data.kick1.synth= = Synth(\tml_gen_playbuf);

- Each section (widget & synth) must have associated macros. Eg, beatbox row
  macros:
	- Shift left / rght
	- All off / on
	- Randomise all
	- Randomise non-quarter notes
	- Vary
	- New macro...

- Each section (widget & synth) must have a 'lock' button, to protect from
  accidental fuckups.

*/

