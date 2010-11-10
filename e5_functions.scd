/**
 *
 * e5 functions
 *
 * This file contains most of the functions used by terminal.
 *
 */

/******************************************************************************/

~f_placeWindow= {|listener, current, inspector|
	// this function resizes and positions
	// the default terminal windows

	if (listener.notNil, {
		listener.bounds_(Rect(0, 41, 810, 254));
		"listener window placed".postln;
	});

	if (current.notNil, {
		current.bounds_(Rect(811, 41, 627, 837));
		(current.title ++ "window placed".padL).postln;
	});

	if (inspector.notNil, {
		inspector.bounds_(Rect(0, 300, 810, 560));
		"inspector window placed".postln;
	});""
};

/******************************************************************************/

~f_createPart= {|name|
	("~data." ++ name ++ "=();").interpret;
	("~data." ++ name ++ ".player= ();").interpret;
	("~data." ++ name ++ ".gen= ();").interpret;
};

/******************************************************************************/

~f_playbufGui= {|layout|	

	var	guiView, guiOut, guiBufnum, guiAmp, guiStartPos, guiLoop, guiRate,
		guiLength, guiPanPos, guiCmpGain, guiCmpThresh, guiCmpAtk, guiCmpRel,
		guiCmpSlopeBelow, guiCmpSlopeAbove, guiEnv, guiLayout;
	
//	w= Window("E5:PartName:playbuf", Rect(741, 367, 500, 310)).front;
//	w.addFlowLayout;
	guiView= CompositeView(layout, 500@310).background_(Color.rand);
	guiView.addFlowLayout(0@0);
	
	guiOut= EZPopUpMenu(guiView, 140@20, "out : ", labelWidth: 40)
		.action_{|me| };
	guiBufnum= EZPopUpMenu(guiView, 160@20, "sample : ", labelWidth: 50)
		.action_{|me| };
	guiLoop= SmoothButton(guiView, 40@20)
		.states_([
			["loop", Color.black, Color.white], 
			["loop", Color.white, Color.black] ])
		.radius_(1)
		.action_{|me| };
	w.view.decorator.nextLine;
	
	////////////////////////////////////////////////////////////////////////////////
	
	guiLayout= CompositeView(guiView, 328@120).background_(Color.rand);
	guiLayout.addFlowLayout(0@0);
	StaticText(guiLayout, 328@20)
		.string_("controls")
		.stringColor_(Color.white)
		.background_(Color.black.alpha_(0.7))
		.align_(\center);
	guiLayout.decorator.margin_(4@4).nextLine.shift(2,0);
	["amp", "start", "rate", "length", "pan"].do{|label, i|
		StaticText(guiLayout, 60@11)
			.string_(label)
			.background_(Color.white.alpha_(0.5))
			.font_(Font("MINI7Tight", 7))
			.align_(\center)
			.action_{|me| };
	};
	guiLayout.decorator.nextLine;
	guiAmp= Knob(guiLayout, 60@53)
		.action_{|me| };
	guiAmp.color[0] = Color.clear;
	guiStartPos= Knob(guiLayout, 60@53)
		.action_{|me| };
	guiStartPos.color[0] = Color.clear;
	guiRate= Knob(guiLayout, 60@53)
		.action_{|me| };
	guiRate.color[0] = Color.clear;
	guiLength= Knob(guiLayout, 60@53)
		.action_{|me| };
	guiLength.color[0] = Color.clear;
	guiPanPos= Knob(guiLayout, 60@53)
		.action_{|me| };
	guiPanPos.color[0] = Color.clear;
	guiLayout.decorator.nextLine;
	5.do{
		SmoothNumberBox(guiLayout, 60@20)
			.value_(1.0)
			.stringColor_(Color.green)
			.normalColor_(Color.green)
			.background_(Color.black)
			.font_(Font("Monaco", 9))
			.align_(\center)
			.action_({|me| me.value.postln; });
	};
	
	////////////////////////////////////////////////////////////////////////////////
	
	guiLayout= CompositeView(guiView, 160@120).background_(Color.rand);
	guiLayout.addFlowLayout(0@0);
	StaticText(guiLayout, 160@20)
		.string_("envelope")
		.stringColor_(Color.white)
		.background_(Color.black.alpha_(0.7))
		.align_(\center);
	guiLayout.decorator.margin_(4@4).nextLine;
	guiEnv= EnvelopeView(guiLayout, 152@91)
		.action_{|me| };
	
	////////////////////////////////////////////////////////////////////////////////
	
	w.view.decorator.nextLine;
	guiLayout= CompositeView(guiView, 328@111).background_(Color.rand);
	guiLayout.addFlowLayout(0@0);
	StaticText(guiLayout, 328@20)
		.string_("compressor")
		.stringColor_(Color.white)
		.background_(Color.black.alpha_(0.7))
		.align_(\center);
	guiLayout.decorator.margin_(4@4).nextLine;
	["gain", "thresh", "attack", "release", "below", "above"].do{|label, i|
		StaticText(guiLayout, 50@11)
			.string_(label)
			.background_(Color.white.alpha_(0.5))
			.font_(Font("MINI7Tight", 7))
			.align_(\center);
	};
	guiLayout.decorator.nextLine;
	guiCmpGain= Knob(guiLayout, 50@44)
		.action_{|me| };
	guiCmpGain.color[0] = Color.clear;
	guiCmpThresh= Knob(guiLayout, 50@44)
		.action_{|me| };
	guiCmpThresh.color[0] = Color.clear;
	guiCmpAtk= Knob(guiLayout, 50@44)
		.action_{|me| };
	guiCmpAtk.color[0] = Color.clear;
	guiCmpRel= Knob(guiLayout, 50@44)
		.action_{|me| };
	guiCmpRel.color[0] = Color.clear;
	guiCmpSlopeBelow= Knob(guiLayout, 50@44)
		.action_{|me| };
	guiCmpSlopeBelow.color[0] = Color.clear;
	guiCmpSlopeAbove= Knob(guiLayout, 50@44)
		.action_{|me| };
	guiCmpSlopeAbove.color[0] = Color.clear;
	guiLayout.decorator.nextLine;
	6.do{
		SmoothNumberBox(guiLayout, 50@20)
			.value_(1.0)
			.stringColor_(Color.green)
			.normalColor_(Color.green)
			.background_(Color.black)
			.font_(Font("Monaco", 9))
			.align_(\center)
			.action_({|me| me.value.postln; });
	};


};

/******************************************************************************/

// Player Widgets

~f_beatboxRow= {|view, seq, states|
	// this function draws a drum machine row
	// Will most likely become a Class, later.
	var layout, triggers;
	states = states ? [0, 1];
	seq = seq ? (Array.fill(16, {states.choose}));

	triggers= Array.fill(seq.size);

	layout= CompositeView(view,
		(view.bounds.width-8) @ 70
	).background_(Color.rand);

	layout.addFlowLayout(0@0);

	seq.size.do{|i|
		var x;
		triggers[i]= SmoothButton.new(layout, 32 @ 32)
			.radius_(10)
			.canFocus_(false)
			.border_(3)
			.action_{|me|
					seq[i]= me.value;
					seq.postln;
				}
			.value_(seq[i]);
		if (i%4 == 0, {
			triggers[i].states_([
				[\none, Color.grey(0.1), Color.grey(0.85).alpha_(0.25)],
				[\record, Color.grey(0.1), Color.grey(0.85).alpha_(0.25)],
			])
			},{
			triggers[i].states_([
				[\none, Color.grey(0.1), Color.white.alpha_(0.4)],
				[\record, Color.grey(0.1), Color.white.alpha_(0.4)],
			])
			});
		
		};

	layout.decorator.nextLine;

	g = EZPopUpMenu.new(layout, 300@20, "macros : ");
	[ "execute...", "-", "shift left", "shift right", "All off", "All on", "Randomise all", "Randomise non-quarter notes",
		"Vary", "-", "new..." ].do{|item, i|
		g.addItem(item, {item. postln});
	};
	g.setColors(
		Color.black.alpha_(0.25), Color.grey(0.95),
		Color.black.alpha_(0.25), Color.black);
	g.value=0;

	seq
};

//~f_knobRow= {|view, seq, spec|
//	// this function draws a row of knobs
//	// Will most likely become a Class, later.
//	var layout, knobs;
//	states = states ? [0, 1];
//	seq = seq ? (Array.fill(16, {states.choose}));
//
//	knobs= Array.fill(seq.size);
//
//	layout= CompositeView(view,
//		(view.bounds.width-8) @ 40
//	)/*.background_(Color.rand)*/;
//
//	layout.addFlowLayout(0@0);
//
//	seq.size.do{|i|
//		var x;
//		triggers[i]= SmoothButton.new(layout, 32 @ 32)
//			.radius_(10)
//			.canFocus_(false)
//			.border_(3)
//			.action_{|me|
//					seq[i]= me.value;
//					seq.postln;
//				}
//			.value_(seq[i]);
//		if (i%4 == 0, {
//			triggers[i].states_([
//				[\none, Color.grey(0.1), Color.grey(0.85).alpha_(0.25)],
//				[\record, Color.grey(0.1), Color.grey(0.85).alpha_(0.25)],
//			])
//			},{
//			triggers[i].states_([
//				[\none, Color.grey(0.1), Color.white.alpha_(0.4)],
//				[\record, Color.grey(0.1), Color.white.alpha_(0.4)],
//			])
//			});
//		
//		};
//		seq
//};

/******************************************************************************/

"Functions loaded...".postln;
"\t~f_placeWindow".postln;
"\t~f_createPart".postln;
"\t~f_beatboxRow".postln;
""