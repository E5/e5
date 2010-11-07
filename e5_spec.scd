
/*

terminal spec
 
- an environment for playing and composing.

********************************************************************************

- Uses pre-made synths but will have a flexible
  routing system.

- Four windows:

	- Document, for starting a session and coding

	- Listener

	- Inspector: autogui window for editing controls
	  and sequences. Also for routing and stuff.

	- Mixer. Usually hidden. Probably based around MixerChannel
	  (ddwLib).
  
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

- Widgets:

	- Beatbox row

	  A row of triggers. Assoc. controls are 'numsteps', 'grid' (16 for 16ths,
	  24 for 24ths, etc.), 'states' (eg, [\,1, 0.5], or [\, 220]) and
	  'target' (parameter to control).

	- Knob row

	  A row of knobs. Assoc. controls are 'numsteps', 'grid' (16 for 16ths,
	  24 for 24ths, etc.), 'spec' (eg, [10, 100, \lin, 1], or \amp) and
	  'target' (parameter to control).
.
	- Text

	  A text view for entering a single value, or a function.

	- Toggle

	  A single button, for constant sounding synths (non-sequenced).

	- MultiSlider

	- XYPad

	- Matrix

	  My unfinished 'piano roll' editor. For multiple parameters.

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

