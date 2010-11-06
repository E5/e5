/**
 *
 * terminal environment
 *
 * This file sets up the terminal gui. It will call the other files too.
 * It's the big boss file.
 *
 */

(
// Run this first

// Evaluate other files
[	"terminal_functions.scd",
	"terminal_blackbox_synths.scd",
//	"terminal_blackbox_data.scd",
].do(_.loadRelative);

//"terminal_functions.scd".loadRelative;
//"terminal_blackbox_synths.scd".loadRelative;
//"terminal_blackbox_data.scd".loadRelative;
)
// arrange windows
~f_placeWindow.value(Document.listener, Document.current);

(

var dec;

// inspector window
w= Window.new("", Rect(0, 300, 810, 560)).front;

dec= w.addFlowLayout;

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

// Play
SmoothButton(w, 100@40)
	.states_([
		[ \play, Color.black, Color.green ],
		[ \stop, Color.black, Color.red ] ] )
	.action_({
	})
//	.border_(1.6)
	.radius_(10)
	.canFocus_(false);

// window positions button

dec.shift(250, 0);

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

/******************************************************************************/

// TEST CODE

(
// autogui on a CompositeView

// SynthDef(\test, {arg out = 3, freq = 100; Out.ar(out, SinOsc.ar(freq))}) ;
w = Window.new("SupaSyntha", Rect(20, 20, 400, 200)).front ;
v=CompositeView.new(w,w.view.bounds.insetBy(10)).background_(Color.rand);
//v.decorator=FlowLayout(v.bounds);
	Synth(\Sinner)
		.set(\out, 0, \freq, 440)
		.autogui(window:v, step:30/*, vOff: height*(i%6), hOff:250*((i/6)).asInteger*/);
)
v.visible_(true)
