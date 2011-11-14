/*******************************************************************************

E5 Environment

This file sets up the E5 environment. It will call the other files too.
It's the big boss file.

*******************************************************************************/

(
// Run this first

// Evaluate other files
[	"e5_functions.scd",
	"e5_synths.scd",
	"e5_data.scd",
].do(_.loadRelative);

~data.global.gen= [];
~data.global.mod= [];
SynthDescLib.global.synthDescs.keys.asArray.sort.do{|item, i|
	item = item.asString;
	if(item.contains("e5_gen_"), {
		item.postln;
		~data.global.gen= ~data.global.gen.add(
			item.replace("e5_gen_", ""));
	});
	if(item.contains("e5_mod_"), {
		~data.global.mod= ~data.global.mod.add(
			item.replace("e5_mod_", ""));
	});
};

)

/******************************************************************************/

// arrange windows
~f_placeWindow.value(Document.listener, Document.current);

/******************************************************************************/

(
// gui stuff
var dec, guiComp, guiBpm, guiKey, guiScale, guiPlay;

// Inspector window
w= Window.new("", Rect(0, 296, 925, 560), false/*, false*/).front;
//w.background_(Color.grey(0.1).alpha_(0.9));

dec= w.addFlowLayout;

guiComp= Array.fill(2);

guiBpm= EZSmoothSlider(w,
	300@20,
	"bpm:".padR,
	[10, 500, \lin, 1],
	{|me|
		~data.global.bpm= me.value;
		(me.value.asString ++ "bpm".padL).postln;
	},
	labelWidth: 32
);

guiBpm.labelView.align_( \left );

guiBpm.value_(~data.global.bpm);

guiKey= EZPopUpMenu.new(w, 130@20, "key : ", labelWidth: 32);
["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "Bb", "B"].do{|item, i|
	guiKey.addItem(item, {item. postln});
};

guiKey.value= 7;

guiScale= EZPopUpMenu.new(w, 200@20, "scale : ", labelWidth: 40);

ScaleInfo.scales.keys.asArray.sort.do{|item, i|
	guiScale.addItem(item, {|me| [me.value, item].postln});
};

guiScale.value= 82;

// Save button
SmoothButton(w, 40@20)
	.states_([[ "save", Color.grey(0.95), Color.black.alpha_(0.25) ]] )
	.action_({
		CocoaDialog.savePanel({|path|
			var tmp;
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

// Load button
SmoothButton(w, 40@20)
	.states_([[ "load", Color.grey(0.95), Color.black.alpha_(0.25) ]] )
	.action_({
		CocoaDialog.getPaths({|paths|
			var tmp;
			tmp= ZArchive.read(paths[0]);
			~data= tmp.readItem;
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

dec.shift(20, 0);

// Window positioning button
SmoothButton(w, 50@20)
	.states_([[ "tidy up" ]] )
	.action_({
		~f_placeWindow.value(Document.listener, Document.current, w);
	})
	.canFocus_(false)
	.border_(1)
	.radius_(1);

dec.nextLine;

// Play button
guiPlay= SmoothButton(w, 100@30)
	.states_([
		[ \play, Color.black, Color.green ],
		[ \stop, Color.black, Color.clear ] ] )
	.action_({
	})
//	.border_(1)
	.radius_(0)
	.canFocus_(false);

dec.nextLine;

TabbedView.newTall(
	w,
	nil,
	["beatbox", "b-line", "drone", "etc.", "mixer",]
).followEdges_(false)
.tabPosition_(\left);

)

/******************************************************************************/

