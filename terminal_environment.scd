/**
 *
 * terminal environment
 *
 * This file sets up the terminal gui. It will call the other files too.
 * It's the big boss file.
 *
 */

// Evaluate other files
"terminal_functions.scd".loadRelative;
"terminal_blackbox_synths.scd".loadRelative;
//"terminal_blackbox_data.scd".loadRelative;

// arrange windows
~f_placeWindow.value(Document.listener, Document.current);

(

var dc;

// inspector window
w= Window.new("", Rect(0, 300, 810, 560)).front;

dc= w.addFlowLayout;

g = EZSmoothSlider(w,
	390@20,
	"bpm".padR,
	[100, 200, \lin, 1],
	{|me|
		(me.value.asString ++ "bpm".padL).postln;
	}
);
g.setColors(Color.grey,Color.white);
g.value_(140);


// window positions button

dc.shift(358, 0);

SmoothButton(w, 50@20)
	.states_([[ "tidy up" ]] )
	.action_({
		~f_placeWindow.value(Document.listener, Document.current, w);
	})
	.border_(1.6)
	.radius_(5);

PopUpMenu(w, 180@20)
	.items_(SynthDescLib.global.synthDescs.keys.asArray.sort)
	.action_({|me| [me.value, me.item].postln;});

//SynthDef(\sample, {arg out = 3, freq = 100; Out.ar(out, SinOsc.ar(freq))}) ;
//SynthDefAutogui(\sample) ; // a synth is created
)