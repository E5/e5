/**
 *
 * e5 environment
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

var tmp; // for utility

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

// save button
SmoothButton(w, 40@20)
	.states_([[ "save", Color.grey(0.95), Color.black.alpha_(0.25) ]] )
	.action_({
		CocoaDialog.savePanel({|path|
			path.postln;
			tmp= ZArchive.write(path);
			tmp.writeItem(~data);
			tmp.writeClose;
		},{
			"save cancelled".postln;
		});
	})
	.canFocus_(false)
	.border_(1)
	.radius_(1);

// load button
SmoothButton(w, 40@20)
	.states_([[ "load", Color.grey(0.95), Color.black.alpha_(0.25) ]] )
	.action_({
		CocoaDialog.getPaths({|paths|
			tmp= ZArchive.read(paths[0]);
			~data=tmp.readItem;
			tmp.close;
//			paths.do({|p|
//				p.postln;
//			})
			},{
				"cancelled".postln;
			},
			false // allow multiple
		);
	})
	.canFocus_(false)
	.border_(1)
	.radius_(1);

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
//				~data.postln;
				// empty the items list
				guiPart.items=[];
				// fill it with all the part names
				~data.keys.reject{|key| key== \global; }.asArray.sort.do{|item, i|
					guiPart.addItem(item, {item. postln});
				};
//				guiPart.items.size.postln;
			}/*.defer*/);
//			guiPart.value_(guiPart.items.size);
			guiPart.items.postln;
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
~data.keys.reject{|key| key== \global; }.asArray.do{|item, i|
	guiPart.addItem(item, {item. postln});
};

if (guiPart.items[0].isNil, {guiPart.addItem("no parts", {})});
//guiPart.items[0].postln;
//guiPart.addItem("no parts", {});

guiPart.setColors(
	Color.black.alpha_(0.25), Color.grey(0.95),
	Color.black.alpha_(0.25), Color.black);
guiPart.value=0;

guiGen= EZPopUpMenu.new(c, 190@20, "generator : ");

tmp= SynthDescLib.global.synthDescs.select({|def|
		def.name.contains("e5_gen_");
});

tmp.do{|item, i|
		guiGen.addItem(
			item.name.replace("e5_gen_", ""),
			{item.name.postln;}
		);};

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
~data.keys.reject{|key| key== \global; }.asArray.do{|item, i|
	guiPart.addItem(item, {item. postln});
};
//~data.kick1= ();
//~data.kick1.player= ();
//~data.kick1.gen= ();

/******************************************************************************/

// TEST CODE

//SynthDef(\sample, {arg out = 3, freq = 100; Out.ar(out, SinOsc.ar(freq))}) ;
//SynthDefAutogui(\sample) ; // a synth is created

(
// Designing a playbuf gui
var guiOut, guiBufnum, guiAmp, guiStartPos, guiLoop, guiRate, guiLength, guiPanPos, guiCmpGain, guiCmpThresh, guiCmpAtk, guiCmpRel, guiCmpSlopeBelow, guiCmpSlopeAbove, guiEnv, guiLayout;

w= Window("E5:PartName:playbuf", Rect(741, 386, 429, 291)).front;
w.addFlowLayout;
guiOut= EZPopUpMenu(w, 140@20, "out : ", labelWidth: 40)
	.action_{|me| };
guiBufnum= EZPopUpMenu(w, 160@20, "sample : ", labelWidth: 50)
	.action_{|me| };
guiLoop= SmoothButton(w, 40@20)
	.states_([
		["loop", Color.black, Color.white], 
		["loop", Color.white, Color.black] ])
	.radius_(1)
	.action_{|me| };
w.view.decorator.nextLine;
//guiLayout= CompositeView.background_(Color.rand);
//guiLayout.addFlowLayout(0@0);
StaticText(w, 266@20)
	.string_("controls".padL)
	.stringColor_(Color.white)
	.background_(Color.black)
	/*.align_(\center)*/;
StaticText(w, 150@20)
	.string_("envelope".padL)
	.stringColor_(Color.white)
	.background_(Color.black)
	/*.align_(\center)*/;
w.view.decorator.nextLine;
["amp", "start", "rate", "length", "pan"].do{|label, i|
	StaticText(w, 50@20)
		.string_(label)
		.background_(Color.white)
		.align_(\center)
		.action_{|me| };
};
w.view.decorator.nextLine;
guiAmp= Knob(w, 50@44)
	.action_{|me| };
guiStartPos= Knob(w, 50@44)
	.action_{|me| };
guiRate= Knob(w, 50@44)
	.action_{|me| };
guiLength= Knob(w, 50@44)
	.action_{|me| };
guiPanPos= Knob(w, 50@44)
	.action_{|me| };
w.view.decorator.nextLine;
5.do{
	StaticText(w, 50@20)
		.string_("0.0")
		.stringColor_(Color.green)
		.background_(Color.black)
		.font_(Font("Monaco", 9))
		.align_(\center)
		.action_{|me| };
};
w.view.decorator.nextLine.shift(270, -96);
guiEnv= EnvelopeView(w, 150@92)
	.action_{|me| };
w.view.decorator.nextLine;
StaticText(w, 320@20)
	.string_("compressor".padL)
	.stringColor_(Color.white)
	.background_(Color.black)
	/*.align_(\center)*/;
w.view.decorator.nextLine;
["gain", "threshold", "attack", "release", "below", "above"].do{|label, i|
	StaticText(w, 50@20)
		.string_(label)
		.background_(Color.white)
		.align_(\center);
};
w.view.decorator.nextLine;
guiCmpGain= Knob(w, 50@44)
	.action_{|me| };
guiCmpThresh= Knob(w, 50@44)
	.action_{|me| };
guiCmpAtk= Knob(w, 50@44)
	.action_{|me| };
guiCmpRel= Knob(w, 50@44)
	.action_{|me| };
guiCmpSlopeBelow= Knob(w, 50@44)
	.action_{|me| };
guiCmpSlopeAbove= Knob(w, 50@44)
	.action_{|me| };
w.view.decorator.nextLine;
6.do{
	StaticText(w, 50@20)
		.string_("0.0")
		.stringColor_(Color.green)
		.background_(Color.black)
		.font_(Font("Monaco", 9))
		.align_(\center)
		.action_{|me| };
};

)

/******************************************************************************/

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

/******************************************************************************/

c= ~data.keys.reject{|key|
	key== \global;
}.asArray;
c