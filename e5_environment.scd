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
[	"e5_functions.scd",
	"e5_synths.scd",
	"e5_data.scd",
].do(_.loadRelative);

)

/******************************************************************************/

// arrange windows
~f_placeWindow.value(Document.listener, Document.current);

/******************************************************************************/

(
// gui stuff
var	dec, guiComp, guiBpm, guiKey, guiScale, guiPlay, guiPart, guiGen,
	guiWidget, guiGrid, guiCreatePart;

// inspector window
w= Window.new("", Rect(0, 300, 810, 560), false/*, false*/).front;

dec= w.addFlowLayout;

guiComp= Array.fill(2);

guiBpm= EZSmoothSlider(w,
	300@20,
	"bpm :".padR,
	[10, 500, \lin, 1],
	{|me|
		~data.global.bpm= me.value;
		(me.value.asString ++ "bpm".padL).postln;
	}
);
guiBpm.setColors(Color.black.alpha_(0.25), Color.grey(0.95));
guiBpm.value_(~data.global.bpm);

guiKey= EZPopUpMenu.new(w, 130@20, "key : ");
["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "Bb", "B"].do{|item, i|
	guiKey.addItem(item, {item. postln});
};
guiKey.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
guiKey.value=0;

guiScale= EZPopUpMenu.new(w, 200@20, "scale : ");
ScaleInfo.scales.keys.asArray.sort.do{|item, i|
	guiScale.addItem(item, {|me| [me.value, item].postln});
};
guiScale.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
guiScale.value=11;

// window positions button

dec.shift(20, 0);

SmoothButton(w, 50@20)
	.states_([[ "tidy up" ]] )
	.action_({
		~f_placeWindow.value(Document.listener, Document.current, w);
	})
	.canFocus_(false)
	.border_(1)
	.radius_(1);

dec.nextLine;

guiCreatePart= SmoothButton(w, 100@20)
	.states_([[ "create part...", Color.grey(0.95), Color.black.alpha_(0.25)]] )
	.action_({
		SCRequestString( "part name", "enter the name of the new part",
			{|str|
				~f_createPart.value(str);
				~data.postln;
//				("your name is " ++ str).postln;
			});

//		~f_placeWindow.value(Document.listener, Document.current, w);
	})
	.canFocus_(false)
	.border_(1)
	.radius_(1);

//dec.nextLine;

// Play
guiPlay= SmoothButton(w, 80@20)
	.states_([
		[ \play, Color.black, Color.green ],
		[ \stop, Color.black, Color.red ] ] )
	.action_({
	})
	.border_(1)
	.radius_(5)
	.canFocus_(false);

dec.shift(0, 10);

c= CompositeView.new(w, w.view.bounds.width-8@(w.view.bounds.height-42))
	.background_(Color.black.alpha_(0.125));
c.addFlowLayout;

guiPart= EZPopUpMenu.new(c, 190@20, "part : ");
[	"kick1", "kick2", "snare1", "snare2", "hh", "perc",
	"bass_main", "-", "new..." ].do{|item, i|
	guiPart.addItem(item, {item. postln});
};
guiPart.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
guiPart.value=0;

guiGen= EZPopUpMenu.new(c, 190@20, "generator : ");
SynthDescLib.global.synthDescs.keys.asArray.sort.do{|item, i|
	guiGen.addItem(item, {item. postln});
};
guiGen.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
guiGen.value=0;

guiComp[0]= CompositeView.new(c, c.bounds.width-8@100)
	.background_(Color.rand.alpha_(0.5));
guiComp[0].addFlowLayout;

guiComp[1]= CompositeView.new(c, c.bounds.width-8@100)
	.background_(Color.rand.alpha_(0.5));
guiComp[1].addFlowLayout;

guiWidget= EZPopUpMenu.new(guiComp[0], 190@20, "widget : ");
["beatbox row", "knob row", "matrix", "text", "toggle"].do{|item, i|
	guiWidget.addItem(item, {|me|
		me.value.switch(
			0, { // view, seq, states
				~f_beatboxRow.value(guiComp[0], (0 ! 16), [\,1])
				},
			1, {},
			2, {},
			3, {},
			4, {},
			{"Whoops! Widget menu fucked up!".postln;}
		);
		[me.value, item]. postln;
	});
};
guiWidget.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
guiWidget.value=0;

guiGrid= EZPopUpMenu.new(guiComp[0], 150@20, "grid : ");
[ "4", "6", "8", "12", "16", "24", "32" ].do{|item, i|
	guiGrid.addItem(item, {item. postln});
};
guiGrid.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
guiGrid.value=4;

guiComp[0].decorator.shift(350, 0);

// add new widget
SmoothButton(guiComp[0], 35@20)
	.states_([[ '+', Color.grey(0.95), Color.black.alpha_(0.25)]] )
	.action_({|me|})
	.border_(1)
	.canFocus_(false)
	.radius_(1);

// refresh gui
SmoothButton(guiComp[0], 35@20)
	.states_([
		[\roundArrow, Color.grey(0.95), Color.black.alpha_(0.25)]
	])
	.action_({|me|})
	.border_(1)
	.canFocus_(false)
	.radius_(1);

)

/******************************************************************************/

// WRITE CODE HERE

// create a part
~f_createPart.value("kick1");
//~data.kick1= ();
//~data.kick1.player= ();
//~data.kick1.gen= ();

/******************************************************************************/

// TEST CODE

//SynthDef(\sample, {arg out = 3, freq = 100; Out.ar(out, SinOsc.ar(freq))}) ;
//SynthDefAutogui(\sample) ; // a synth is created

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
