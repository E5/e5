/*******************************************************************************

E5 GUI

This is a file for designing the E5 module GUIs. I'll experiment and
design here, without cluttering up my main file.

*******************************************************************************/
// Run these first

// Evaluate other files
["e5_functions.scd", "e5_synths.scd", "e5_data.scd",].do(_.loadRelative);

// arrange windows
~f_placeWindow.value(Document.listener, Document.current);

/******************************************************************************/

(

// Data

var comp, guiDisloser, numControlRows=1, numRows=3, numSteps=16, guiPlus,
	guiMinus, tabV, f_drawTabV, f_updateTabV, guiFlow;

q= ();

q.beatBox= (); // holds all beatBox data

q.beatBox.instruments= [ // instr names
	"kick", "snare", "hh", "er perc-1", "sample"];

q.beatBox.controls= [ // control names
	"probability", "volume", "pan", "attack", "decay", "lp cutoff",
	"hp cutoff", "reverb", "delay", "bitcrush", "distortion" ];

q.beatBox.row= Array.fill(numRows, {|i| // array holding each beatBox row
	(
		instrument: i, // default instr
		length: numSteps, // default pattern length
		beat: {2.rand} ! numSteps, // default pattern
		controlValue: [
			1.0 ! numSteps, // probability
			1.0 ! numSteps, // volume
			0.5 ! numSteps, // pan
			0.0 ! numSteps, // attack
			0.0 ! numSteps, // decay
			0.0 ! numSteps, // lp cutoff
			1.0 ! numSteps, // hp cutoff
			0.0 ! numSteps, // reverb
			0.0 ! numSteps, // delay
			0.0 ! numSteps, // bitcrush
			0.0 ! numSteps, // distortion
		],
		currentTab: 0
	)
});

/******************************************************************************/

// Functions

f_drawTabV= {|tabNum|
	tabV[tabNum].views.do({|tab, i|
		tab.flow({|thisTab|
			var controlSlider, cntlRand, cntlLeft, cntlRight, cntlMax,
				cntlMin;

			thisTab.decorator.margin= 4@4; // not working

			Button(thisTab, 20@20)
				.states_([
					[ "i" ] ])
				.action_{|me|
					v= View(bounds:300@300);
					Button(v, Rect(20, 20, 100, 30)).states_([["yes"],["no"]]);
					v.front;
//					x= SCModalSheet.new(w, 380@70);
//					Button(x, Rect(20,20,340,30))
//						.states_([
//							["Dismiss me", Color.black, Color.red]
//						])
//						.onClose_({"Dismissed!".postln})
//						.action_({ x.close });
				}
				.focusColor_(Color.clear);
		
			thisTab.decorator.shift(172, 0);

			controlSlider= MultiSliderView(thisTab, 444@24)
				.value_(q.beatBox.row[tabNum].controlValue[i])
				.action_{|me|
					q.beatBox.row[tabNum].controlValue[i]= me.value;
				}
				.focusColor_(Color.clear)
				.elasticMode_(1)
				.indexThumbSize_(32)
				.thumbSize_(34)
				.valueThumbSize_(2);
		
			thisTab.decorator.shift(24, 0);

			cntlRand= Button.new(thisTab, 20@20) // rand button
				.states_([
					[ "?" ] ])
				.action_{|me|
					q.beatBox.row[tabNum].controlValue[i]= {1.0.rand} ! numSteps;
					controlSlider.value_(q.beatBox.row[tabNum].controlValue[i])
				};
			
			cntlLeft= Button.new(thisTab, 20@20) // shift left button
				.states_([
					[ "<" ] ])
				.action_{|me|
					q.beatBox.row[tabNum].controlValue[i]
						= q.beatBox.row[tabNum].controlValue[i].rotate(-1);
					controlSlider.value_(q.beatBox.row[tabNum].controlValue[i])
				};
			
			cntlRight= Button.new(thisTab, 20@20) // shift right button
				.states_([
					[ ">" ] ])
				.action_{|me|
					q.beatBox.row[tabNum].controlValue[i]
						= q.beatBox.row[tabNum].controlValue[i].rotate(1);
					controlSlider.value_(q.beatBox.row[tabNum].controlValue[i])
				};
			
			cntlMax= Button.new(thisTab, 20@20) // all on button
				.states_([
					[ "^" ] ])
				.action_{|me|
					q.beatBox.row[tabNum].controlValue[i]= 1.0 ! numSteps;
					controlSlider.value_(q.beatBox.row[tabNum].controlValue[i])
				};
			
			cntlMin= Button.new(thisTab, 20@20) // all off button
				.states_([
					[ "_" ] ])
				.action_{|me|
					q.beatBox.row[tabNum].controlValue[i]= 0 ! numSteps;
					controlSlider.value_(q.beatBox.row[tabNum].controlValue[i])
				};

		});
	});
};

/******************************************************************************/

// GUI

comp= Array.fill(numRows);
tabV= Array.fill(numRows);

w= Window.new("", Rect(5, 471, 849, 376)).front;

guiFlow= FlowView.new(w, Rect(0, 0, w.bounds.width, w.bounds.height),
	margin: 8@8, gap: 8@8);

numRows.do {|i|
	var drumInfo, randTrig, trigLeft, trigRight, trigMax, trigMin,
		drumTrig= Array.fill(numSteps);
	
	comp[i]= CompositeView(guiFlow, Rect(8, 8+(i*4)+(i*32), 834, 32), 4@4)
		.background_(Color.rand);
	comp[i].addFlowLayout;
	
	guiDisloser= Button.new(comp[i], 18@18)
		.states_([
			[">" ],
			[ "<" ], ])
		.action_{|me| if(me.value == 0, {
				tabV[i].view.visible= false;
				comp[i].bounds_(Rect(8, 8, 834, 32));
				tabV[i].focus(q.beatBox.row[i].currentTab);
			},{
				tabV[i].view.visible= true;
				comp[i].bounds_(Rect(8, 8, 834, 84));
				tabV[i].focus(q.beatBox.row[i].currentTab);
			});
			guiFlow.resizeToFit(true, true);
		};
	
	PopUpMenu.new(comp[i], 144@24)
		.items_(q.beatBox.instruments)
		.action_{|me| }
		.value_(i);
	
	drumInfo= Button.new(comp[i], 24@24) // info button
		.states_([ [ "i" ] ])
		.action_{|me|
			v= View(bounds:300@300);
			Button(v, Rect(20, 20, 100, 30)).states_([["yes"],["no"]]);
			v.front;

//			x = Button().front;
//			x= SCModalSheet.new(w, 380@70);
//			Button(x, Rect(20,20,340,30))
//				.states_([
//					["Dismiss me", Color.black, Color.red]
//				])
//				.onClose_({"Dismissed!".postln})
//				.action_({ x.close });
		};
	
	comp[i].decorator.shift(22, 0);
	
	numSteps.do {|j|
		drumTrig[j]= Button.new(comp[i], 24@24)
			.states_([
				[ "" ],
				[ "*" ] ])
			.action_{|me| }
			.value_(q.beatBox.row[i].beat[j]);
	};
	
	comp[i].decorator.shift(22, 0);
	
	randTrig= Button.new(comp[i], 24@24) // rand button
		.states_([
			[ "?" ] ])
		.action_{|me|
			q.beatBox.row[i].beat= {2.rand} ! numSteps;
			drumTrig.do{|item, j|
				item.value_(q.beatBox.row[i].beat[j]);
			};
		};
	
	trigLeft= Button.new(comp[i], 24@24) // shift left button
		.states_([
			[ "<" ] ])
		.action_{|me|
			q.beatBox.row[i].beat= q.beatBox.row[i].beat.rotate(-1);
			drumTrig.do{|item, j|
				item.value_(q.beatBox.row[i].beat[j]);
			};
		};
	
	trigRight= Button.new(comp[i], 24@24) // shift right button
		.states_([
			[ ">" ] ])
		.action_{|me|
			q.beatBox.row[i].beat= q.beatBox.row[i].beat.rotate(1);
			drumTrig.do{|item, j|
				item.value_(q.beatBox.row[i].beat[j]);
			};
		};
	
	trigMax= Button.new(comp[i], 24@24) // all on button
		.states_([
			[ "^" ] ])
		.action_{|me|
			q.beatBox.row[i].beat= 1 ! numSteps;
			drumTrig.do{|item, j|
				item.value_(q.beatBox.row[i].beat[j]);
			};
		};
	
	trigMin= Button.new(comp[i], 24@24) // all off button
		.states_([
			[ "_" ] ])
		.action_{|me|
			q.beatBox.row[i].beat= 0 ! numSteps;
			drumTrig.do{|item, j|
				item.value_(q.beatBox.row[i].beat[j]);
			};
		};
	
	comp[i].decorator.nextLine.shift(22, 0);
	
	tabV[i]= TabbedView.newFlat(
		comp[i],
		comp[i].bounds.width-30@48,
		q.beatBox.controls
	)
	.tabPosition_(\bottom)
	.tabWidth_(\auto)
	.font_(Font("MINI 7 Tight", 7));

	f_drawTabV.value(i);

	tabV[i].view.visible= false;

};

guiFlow.resizeToFit(true, true);

""
)

/*******************************************************************************

//tabV.labels.postln;
//a.keys.asArray[0]


*******************************************************************************/
