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
w= Window.new("", Rect(318, 650, 832, 206)).front;
f= FlowView(w, Rect(8, 8, 816, 40), 8@8, 4@8)
	.background_(Color.rand.alpha_(0.2));
b=[];

PopUpMenu.new(f, 144@24)
	.items_(["kick", "snare", "hh", "er perc-1"])
	.action_{|me| }
	.focusColor_(Color.clear);

SmoothButton.new(f, 24@24)
	.states_([
		[ "E", Color.grey(0.1), Color.white.alpha_(0.67) ] ])
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

f.decorator.shift(32, 0);

16.do {|i|
	SmoothButton.new(f, 24@24)
		.states_([
			[ \stop, Color.grey(0.1), Color.clear ],
			[ \none, Color.grey(0.1), Color.clear ] ])
		.action_{|me| }
		.radius_(8)
		.focusColor_(Color.clear)
		.value_(2.rand);
//	f.decorator.shift(-4,0);
};

f.decorator.shift(0, 6);

// selection button (radio)
b= b.add(SmoothButton.new(f, 12@12)
	.states_([
		[ \none, Color.grey(0.1), Color.clear ],
		[ \none, Color.clear, Color.grey(0.1) ] ])
	.action_{|me| }
	.focusColor_(Color.clear)
	.border_(1);
);

f.decorator.shift(32, -6);

["+", "-", "=", "!"].do {|item|
	SmoothButton.new(f, 20@24)
		.states_([
			[ item, Color.grey(0.1), Color.white.alpha_(0.67) ] ])
		.action_{|me| }
		.radius_(3)
		.focusColor_(Color.clear);
};

1.do { // this loop is just for testing the f.resizeToFit
	f.startRow;
	PopUpMenu.new(f, 144@24)
		.action_{|me| }
		.items_(["probability", "volume", "pan", "-", "lp cutoff",
			"hp cutoff", "reverb", "delay", "-"])
		.focusColor_(Color.clear);
	f.decorator.shift(60, 0);
	a= MultiSliderView.new(f, 444/*16*13+2*/@24)
		.value_(Array.fill(16, {|v| v*0.05}))
		.action_{|me| }
		.focusColor_(Color.clear);
	a.elasticMode_(1)
//		.indexThumbSize_(32)
		.thumbSize_(34)
		.valueThumbSize_(2);

	f.decorator.shift(0, 6);

	// selection button (radio)
	b= b.add(SmoothButton.new(f, 12@12)
		.states_([
			[ \none, Color.grey(0.1), Color.clear ],
			[ \none, Color.clear, Color.grey(0.1) ] ])
		.action_{|me| }
		.focusColor_(Color.clear)
		.border_(1);
	);
};
f.resizeToFit(false,true);

)
