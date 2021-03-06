/*******************************************************************************

E5 Functions

This file contains most of the functions used by E5.

*******************************************************************************/

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
	});
};

/******************************************************************************/

~f_createPart= {|name|
	("~data." ++ name ++ "=();").interpret;
	("~data." ++ name ++ ".player= ();").interpret;
	("~data." ++ name ++ ".gen= ();").interpret;
};

/******************************************************************************/

~f_beatboxRow= {|view, seq, states|
	// this function draws a drum machine row
	// Will most likely become a Class, later.
	var layout, triggers;
	states = states ? [0, 1];
	seq = seq ? (Array.fill(16, {states.choose}));

	triggers= Array.fill(seq.size);

	layout= CompositeView(view,
		(view.bounds.width-8) @ 70
	).background_(Color.grey/*rand*/);

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

	~f_macroMenu.value(layout, seq);

//	seq
};

/******************************************************************************/

~f_macroMenu= {|layout, seq|
	// this function draws a macro popup menu
	var workSeq= seq.copy;

	layout.decorator.nextLine;

	g = EZPopUpMenu.new(layout, 300@20, "macros : ");
	[
		["execute...", {"execute...". postln;}],
		["-", {}],
		["shift left", {"shift left". postln;}],
		["shift right", {"shift right". postln;}],
		["All min", {"All min". postln;}],
		["All max", {"All max". postln;}],
		["Randomise all", {"Randomise all". postln;}],
		["Randomise non-quarter notes", {"Randomise non-quarter notes". postln;}],
		["Vary", {"Vary". postln;}],
		["-", {}],
		["new...", {"new...". postln;}],
	].do{|item, i|
		g.addItem(item[0], item[1]/*{item. postln}*/);
	};
	g.setColors(
		Color.black.alpha_(0.25), Color.grey(0.95),
		Color.black.alpha_(0.25), Color.black);
	g.value=0;
//	layout.refresh;

//	seq
};

/******************************************************************************/

~f_Macros= {|seq, select=0|
	var macro, workSeq= seq.copy;
	macro= [
		["execute...", {"execute...". postln;}],
		["new...", {"new...". postln;}],
		["revert", {workSeq= seq.copy; "revert". postln;}],
//		["-", {}],
		["shift left", {workSeq= workSeq.rotate(-1); "shift left". postln;}],
		["shift right", {workSeq= workSeq.rotate(1); "shift right". postln;}],
		["All min", {workSeq= Array.fill(seq.size, {0}); "All min". postln;}],
		["All max", {workSeq= Array.fill(seq.size, {1.0}); "All max". postln;}],
		["Randomise all", {workSeq= Array.fill(seq.size, {1.0.rand}); "Randomise all". postln;}],
		["Randomise non-quarter notes", {"Randomise non-quarter notes". postln;}],
		["Vary", {workSeq= seq + Array.fill(seq.size, {0.1.rand}); "Vary". postln;}],
//		["-", {}],
	];
	workSeq= macro[select][1].value;
	workSeq
};

/******************************************************************************/

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
"\t~f_macroMenu".postln;
""
