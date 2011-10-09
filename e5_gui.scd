/*******************************************************************************

E5 GUI

This is a temporary file for designing the E5 module GUIs. I'll experiment and
design here, without cluttering up my main file.

*******************************************************************************/

(
// Run this first

// Evaluate other files
//[	"e5_functions.scd",
//	"e5_synths.scd",
//	"e5_data.scd",
//].do(_.loadRelative);

//~data.global.gen= [];
//~data.global.mod= [];
//SynthDescLib.global.synthDescs.keys.asArray.sort.do{|item, i|
//	item = item.asString;
//	if(item.contains("e5_gen_"), {
//		item.postln;
//		~data.global.gen= ~data.global.gen.add(
//			item.replace("e5_gen_", ""));
//	});
//	if(item.contains("e5_mod_"), {
//		~data.global.mod= ~data.global.mod.add(
//			item.replace("e5_mod_", ""));
//	});
//};

)

/******************************************************************************/

(
// Designing a drum machine gui

var guiDisloser, numControlRows=2, guiPlus, guiMinus, tabV, f_drawTabV, f_updateTabV;

q= ();
q.beatBox= ();
q.beatBox.instruments= ["kick", "snare", "hh", "er perc-1"];
q.beatBox.controls= [ "probability", "volume", "pan", "attack", "decay", "lp cutoff",
					"hp cutoff", "reverb", "delay", "bitcrush", "distortion" ];
q.beatBox.numRows= 3;
q.beatBox.row= [];
//q.beatBox.row[0].instrument= 0;
//q.beatBox.row[0].length= 16;
//q.beatBox.row[0].beat= {2.rand} ! q.beatBox.row[0].length;
//q.beatBox.row[0].controlRow= (unassigned: -1);

q.beatBox.numRows.do{|i|
	q.beatBox.row= q.beatBox.row.add(());
	q.beatBox.row[i].instrument= i;
	q.beatBox.row[i].length= 16;
	q.beatBox.row[i].beat= {2.rand} ! q.beatBox.row[i].length;
	q.beatBox.row[i].controlRow= (control: 0, data: 1.0 ! q.beatBox.row[i].length);
};

w= Window.new("", Rect(318, 662, 856, 194)).front;

f= CompositeView(w, Rect(8, 8, 830, 32/*84*/), 4@4)
	.background_(Color.blue.alpha_(0.2));
f.addFlowLayout;

f.bounds.postln;

guiDisloser= SmoothButton.new(f, 18@18)
	.states_([
		[ \triangle, Color.grey(0.1), Color.clear ],
		[ \down, Color.grey(0.1), Color.clear ], ])
	.action_{|me| if(me.value == 0, {
			tabV.view.visible= false;
			f.bounds_(Rect(8, 8, 830, 32));
		},{
			tabV.view.visible= true;
			f.bounds_(Rect(8, 8, 830, 84));
		});
	}
	.radius_(3)
	.border_(0)
	.focusColor_(Color.clear);

PopUpMenu.new(f, 144@24)
	.items_(q.beatBox.instruments)
//	.items_(["kick", "snare", "hh", "er perc-1"])
	.action_{|me| }
	.focusColor_(Color.clear);

16.do {|i|
	SmoothButton.new(f, 24@24)
		.states_([
			[ \stop, Color.grey(0.1), Color.clear ],
			[ \none, Color.grey(0.1), Color.clear ] ])
		.action_{|me| }
		.radius_(8)
		.focusColor_(Color.clear)
		.value_(2.rand);
};

["+", "-", "=", "!"].do {|item|
	SmoothButton.new(f, 20@24)
		.states_([ [ item, Color.grey(0.1), Color.white.alpha_(0.67) ] ])
		.action_{|me| }
		.radius_(3)
		.focusColor_(Color.clear);
};

guiPlus= SmoothButton.new(f, 24@24)
	.states_([ [ '+', Color.grey(0.1), Color.white.alpha_(0.67) ] ])
	.action_{|me| }
	.radius_(3)
	.focusColor_(Color.clear);

guiMinus= SmoothButton.new(f, 24@24)
	.states_([ [ '-', Color.grey(0.1), Color.white.alpha_(0.67) ] ])
	.action_{|me| }
	.radius_(3)
	.focusColor_(Color.clear);
guiMinus.enabled= false;

SmoothButton.new(f, 24@24)
	.states_([
		[ \i, Color.grey(0.1), Color.white.alpha_(0.67) ] ])
	.action_{|me|
		x= SCModalSheet.new(w, 380@70);
		Button(x, Rect(20,20,340,30))
			.states_([
				["Dismiss me", Color.black, Color.red]
			])
			.onClose_({"Dismissed!".postln})
			.action_({ x.close });
	}
	.radius_(3)
	.focusColor_(Color.clear);

f.decorator.nextLine.shift(22, 0);

tabV= TabbedView.newFlat(
	f,
	f.bounds.width-30@48,
	q.beatBox.row[0].controlRow.keys.asArray
)
	.tabPosition_(\left)
	.followEdges_(false)
	.tabWidth_(144);

f_drawTabV= {|tabView, numRows, control=0|
	if(numRows > 0, {
		tabView.views.do({|tab, i|
			tab.flow({|v|
				v.decorator.margin_(4@0);
				a= MultiSliderView.new(v, 444@24)
					.value_(Array.fill(16, {|i| i*0.05}))
					.action_{|me| }
					.focusColor_(Color.clear);
				a.elasticMode_(1)
					.indexThumbSize_(32)
					.thumbSize_(34)
					.valueThumbSize_(2);
			
				PopUpMenu.new(v, 144@24)
					.action_{|me|
						f_updateTabV.value(tabView, i, tabView.activeTab, me.value);
					}
					.items_(q.beatBox.controls)
					.focusColor_(Color.clear)
					.value_(control);
			
				SmoothButton.new(v, 24@24)
					.states_([
						[ \i, Color.grey(0.1), Color.white.alpha_(0.67) ] ])
					.action_{|me|
						x= SCModalSheet.new(w, 380@70);
						Button(x, Rect(20,20,340,30))
							.states_([
								["Dismiss me", Color.black, Color.red]
							])
							.onClose_({"Dismissed!".postln})
							.action_({ x.close });
					}
					.radius_(3)
					.focusColor_(Color.clear);
			
				v.decorator.nextLine;
			
				["+", "-", "=", "!"].do {|item|
					SmoothButton.new(v, 20@16)
						.states_([ [ item, Color.grey(0.1), Color.white.alpha_(0.67) ] ])
						.action_{|me| }
						.radius_(3)
						.focusColor_(Color.clear);
				};
		});})
	},{
		tabView.view.visible= false;
	});
};

f_updateTabV= {|view, row, activeTab, control|
	view.insert(activeTab, q.beatBox.controls[control] );
	view.removeAt(activeTab + 1);
	view.activeTab.postln;
	q.beatBox.row[0].controlRow= (q.beatBox.controls[control]: []);
	f_drawTabV.value(view, numControlRows, control);
};

f_drawTabV.value(tabV, numControlRows);
tabV.view.visible= false;

//tabV.labels.postln;
//a.keys.asArray[0]

)

/******************************************************************************/

(
// Designing a playbuf gui

var	guiView, guiOut, guiBufnum, guiAmp, guiStartPos, guiLoop, guiRate,
	guiLength, guiPanPos, guiCmpGain, guiCmpThresh, guiCmpAtk, guiCmpRel,
	guiCmpSlopeBelow, guiCmpSlopeAbove, guiEnv, guiLayout, guiWidget;

w= Window("", Rect(741, 398, 536, 279)).front;
w.addFlowLayout;

guiOut= EZPopUpMenu(w, 140@20, "out:", labelWidth: 40)
	.action_{|me| };
guiOut.labelView.font_(Font("Monaco", 9));

guiBufnum= EZPopUpMenu(w, 160@20, "sample:", labelWidth: 50)
	.action_{|me| };
guiBufnum.labelView.font_(Font("Monaco", 9));

guiLoop= SmoothButton(w, 20@20)
	.states_([
		[\roundArrow, Color.black, Color.white], 
		[\roundArrow, Color.white, Color.black] ])
	.radius_(1)
	.action_{|me| };

w.view.decorator.nextLine;

guiLayout= CompositeView(w, 364@127).background_(Color.blue.alpha_(0.2));
guiLayout.addFlowLayout(4@4, 4@4);

StaticText(guiLayout, 356@20)
	.string_("controls")
	.stringColor_(Color.white)
	.background_(Color.black.alpha_(0.7))
	.font_(Font("Monaco", 9))
	.align_(\center);

guiLayout.decorator.nextLine;

["amp", "start", "rate", "length", "pan"].do{|label, i|
	guiWidget= CompositeView(guiLayout, 68@95)
		.background_(Color.blue.alpha_(0.2));
	guiWidget.addFlowLayout;

	StaticText(guiWidget, 60@11)
		.string_(label)
		.background_(Color.white.alpha_(0.5))
		.font_(Font("MINI7Tight", 7))
		.align_(\center)
		.action_{|me| };

	guiWidget.decorator.nextLine;

	guiAmp= Knob(guiWidget, 60@53)
		.action_{|me| };
	guiAmp.color[0] = Color.grey;

	guiWidget.decorator.nextLine;

	SmoothNumberBox(guiWidget, 60@15)
		.value_(1.0)
		.stringColor_(Color.green)
		.normalColor_(Color.green)
		.background_(Color.black)
		.font_(Font("Monaco", 9))
		.align_(\center)
		.action_({|me| me.value.postln; })
		.radius_(0);

	guiWidget.decorator.nextLine;
};

guiLayout= CompositeView(w, 160@127)
	.background_(Color.blue.alpha_(0.2));
guiLayout.addFlowLayout(4@4, 4@4);

StaticText(guiLayout, 152@20)
	.string_("envelope")
	.stringColor_(Color.white)
	.background_(Color.black.alpha_(0.7))
	.font_(Font("Monaco", 9))
	.align_(\center);

guiLayout.decorator.nextLine;

guiEnv= EnvelopeView(guiLayout, 152@95)
	.action_{|me| [me.index, me.value].postln;}
	.value_([[0.0, 0.15, 0.5, 1.0], [0.1, 1.0, 0.7, 0.0]])
	.curves_([5, 5, -5]);

w.view.decorator.nextLine;

guiLayout= CompositeView(w, 364@116)
	.background_(Color.blue.alpha_(0.2));
guiLayout.addFlowLayout(4@4, 4@4);

StaticText(guiLayout, 356@20)
	.string_("compressor")
	.stringColor_(Color.white)
	.background_(Color.black.alpha_(0.7))
	.font_(Font("Monaco", 9))
	.align_(\center);

guiLayout.decorator.nextLine;

["gain", "thresh", "attack", "release", "below", "above"].do{|label, i|
	guiWidget= CompositeView(guiLayout, 56@84)
		.background_(Color.blue.alpha_(0.2));
	guiWidget.addFlowLayout;

	StaticText(guiWidget, 48@11)
		.string_(label)
		.background_(Color.white.alpha_(0.5))
		.font_(Font("MINI7Tight", 7))
		.align_(\center);

	guiWidget.decorator.nextLine;

	guiCmpGain= Knob(guiWidget, 48@53)
		.action_{|me| };
	guiCmpGain.color[0] = Color.grey;

	guiWidget.decorator.nextLine;

	SmoothNumberBox(guiWidget, 48@15)
		.value_(1.0)
		.stringColor_(Color.green)
		.normalColor_(Color.green)
		.background_(Color.black)
		.font_(Font("Monaco", 9))
		.align_(\center)
		.action_({|me| me.value.postln; });
};

)
