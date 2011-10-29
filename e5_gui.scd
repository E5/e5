(

/*******************************************************************************

E5 GUI

This is a file for designing the E5 module GUIs. I'll experiment and
design here, without cluttering up my main file.

*******************************************************************************/

// Data

var comp, guiDisloser, numControlRows=1, numRows=1, guiPlus, guiMinus, tabV,
	f_drawTabV, f_updateTabV, guiFlow;

q= ();

q.beatBox= (); // holds all beatBox data

q.beatBox.instruments= ["kick", "snare", "hh", "er perc-1"]; // instr names

q.beatBox.controls= [ // control names
	"probability", "volume", "pan", "attack", "decay", "lp cutoff",
	"hp cutoff", "reverb", "delay", "bitcrush", "distortion" ];

q.beatBox.row= Array.fill(numRows, {|i| // array holding each beatBox row
	(
		instrument: i, // default instr
		length: 16, // default pattern length
		beat: {2.rand} ! 16, // default pattern
		controlRow: [ ( // array of dicts for this row's controllers
			controlType: 0, // default controller type index
			controlData: {1.0.rand} ! 16 // default control values
		) ]
	)
});

/******************************************************************************/

// Functions

f_drawTabV= {|tabView, numRows, control=0|
	tabView.views.do({|tab, i|
		tab.flow({|thisTab|
			var controlSlider;
			thisTab.decorator.margin= 4@4; // not working

			SmoothButton(thisTab, 24@24)
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
		
			thisTab.decorator.shift(118, 0);

			controlSlider= MultiSliderView(thisTab, 444@24)
				.value_(Array.fill(16, {|i| i*0.05}))
				.action_{|me| }
				.focusColor_(Color.clear);
			controlSlider.elasticMode_(1)
				.indexThumbSize_(32)
				.thumbSize_(34)
				.valueThumbSize_(2);
		
		});
	});
};

f_updateTabV= {|thisTab, row, activeTab, control label|
	// this function updates the current tab label
	thisTab.insert(activeTab, label/*q.beatBox.controls[control]*/ );
	thisTab.removeAt(activeTab + 1);
	q.beatBox.row[0].controlRow[0]= (q.beatBox.controls[control]: []);
	f_drawTabV.value(thisTab, numControlRows, control);
};

/******************************************************************************/

// GUI

comp= Array.fill(numRows);
tabV= Array.fill(numRows);

w= Window.new("", Rect(318, 492, 855, 376)).front;

guiFlow= FlowView.new(w, Rect(0, 0, w.bounds.width, w.bounds.height),
	margin: 8@8, gap: 8@8)
	/*.background_(Color.yellow)*/;

numRows.do {|i|
	comp[i]= CompositeView(guiFlow, Rect(8, 8+(i*4)+(i*32), 840, 32), 4@4)
		.background_(Color.grey/*.rand.alpha_(0.2)*/);
	comp[i].addFlowLayout;
	
	guiDisloser= SmoothButton.new(comp[i], 18@18)
		.states_([
			[ \triangle, Color.grey(0.1), Color.clear ],
			[ \down, Color.grey(0.1), Color.clear ], ])
		.action_{|me| if(me.value == 0, {
				tabV[i].view.visible= false;
				comp[i].bounds_(Rect(8, 8, 840, 32));
				guiFlow.resizeToFit(true, true);
			},{
				tabV[i].view.visible= true;
				comp[i].bounds_(Rect(8, 8, 840, 84));
				guiFlow.resizeToFit(true, true);
			});
		}
		.radius_(3)
		.border_(0)
		.focusColor_(Color.clear);
	
	PopUpMenu.new(comp[i], 144@24)
		.items_(q.beatBox.instruments)
		.action_{|me| }
		.focusColor_(Color.clear)
		.value_(i);
	
	16.do {|j|
		SmoothButton.new(comp[i], 24@24)
			.states_([
				[ \stop, Color.grey(0.1), Color.white.alpha_(0.5) ],
				[ \none, Color.grey(0.1), Color.white.alpha_(0.5) ] ])
			.action_{|me| }
			.radius_(8)
			.focusColor_(Color.clear)
			.value_(2.rand);
	};
	
//	["+", "-", "=", "!"].do {|item|
//		SmoothButton.new(comp[i], 20@24)
//			.states_([
//				[ item, Color.grey(0.1), Color.white.alpha_(0.67) ] ])
//			.action_{|me| }
//			.radius_(3)
//			.focusColor_(Color.clear);
//	};
	
//	guiPlus= SmoothButton.new(comp[i], 24@24)
//		.states_([ [ '+', Color.grey(0.1), Color.white.alpha_(0.67) ] ])
//		.action_{|me| }
//		.radius_(3)
//		.focusColor_(Color.clear);
//	
//	guiMinus= SmoothButton.new(comp[i], 24@24)
//		.states_([ [ '-', Color.grey(0.1), Color.white.alpha_(0.67) ] ])
//		.action_{|me| }
//		.radius_(3)
//		.focusColor_(Color.clear);
//	guiMinus.enabled= false;
	
	SmoothButton.new(comp[i], 24@24)
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
	
	comp[i].decorator.nextLine.shift(22, 0);
	
	tabV[i]= TabbedView.newFlat(
		comp[i],
		comp[i].bounds.width-30@48,
//		[q.beatBox.controls[q.beatBox.row[0].controlRow[0].controlType]]
		q.beatBox.controls
	)
	.tabPosition_(\bottom)
	/*.followEdges_(false)
	.tabWidth_(144)*/;
};

guiFlow.resizeToFit(true, true);

numRows.do {|i|
	f_drawTabV.value(
		tabV[i],
		numControlRows,
		q.beatBox.row[0].controlRow[0].controlType);

	tabV[i].view.visible= false;
};

""
)

/*******************************************************************************

//tabV.labels.postln;
//a.keys.asArray[0]


*******************************************************************************/
