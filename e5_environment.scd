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
	"terminal_synths.scd",
	"terminal_data.scd",
].do(_.loadRelative);

)

/******************************************************************************/

// arrange windows
~f_placeWindow.value(Document.listener, Document.current);

/******************************************************************************/

(
var dec, comp;

// inspector window
w= Window.new("", Rect(0, 300, 810, 560), false/*, false*/).front;
//w.background_(Color.black);
dec= w.addFlowLayout;

comp= Array.fill(2);

g= EZSmoothSlider(w,
	390@20,
	"bpm :".padR,
	[10, 500, \lin, 1],
	{|me|
		~data.global.bpm= me.value;
		(me.value.asString ++ "bpm".padL).postln;
	}
);
g.setColors(Color.black.alpha_(0.25), Color.grey(0.95));
g.value_(~data.global.bpm);

// Play
SmoothButton(w, 80@20)
	.states_([
		[ \play, Color.black, Color.green ],
		[ \stop, Color.black, Color.red ] ] )
	.action_({
	})
//	.border_(1.6)
	.radius_(5)
	.canFocus_(false);

// window positions button

dec.shift(254, 0);

SmoothButton(w, 50@20)
	.states_([[ "tidy up" ]] )
	.action_({
		~f_placeWindow.value(Document.listener, Document.current, w);
	})
	.border_(1)
	.radius_(1);

dec.shift(0, 10);

c= CompositeView.new(w, w.view.bounds.width-8@(w.view.bounds.height-42))
	.background_(Color.black.alpha_(0.125));
c.addFlowLayout;

g = EZPopUpMenu.new(c, 190@20, "part : ");
[	"kick1", "kick2", "snare1", "snare2", "hh", "perc",
	"bass_main", "-", "new..." ].do{|item, i|
	g.addItem(item, {item. postln});
};
g.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
g.value=0;

g= EZPopUpMenu.new(c, 190@20, "widget : ");
["beatbox row", "knob row", "matrix", "text", "toggle"].do{|item, i|
	g.addItem(item, {|me|
		me.value.switch(
			0, {~f_beatboxRow.value(comp[0], (0 ! 16), [\,1])}, // view, seq, states
			1, {},
			2, {},
			3, {},
			4, {},
			{"Whoops! Widget menu fucked up!".postln;}
		);
		[me.value, item]. postln;
	});
};
g.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
g.value=0;

g= EZPopUpMenu.new(c, 190@20, "synth : ");
SynthDescLib.global.synthDescs.keys.asArray.sort.do{|item, i|
	g.addItem(item, {item. postln});
};
g.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
g.value=0;

comp[0]= CompositeView.new(c, c.bounds.width-8@100)
	.background_(Color.rand.alpha_(0.5));
comp[0].addFlowLayout;

comp[1]= CompositeView.new(c, c.bounds.width-8@100)
	.background_(Color.rand.alpha_(0.5));
comp[1].addFlowLayout;

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
