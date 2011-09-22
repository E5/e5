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

//	layout.decorator.nextLine;
//
//	// this 'macros' code should really be in it's own function or class.
//	g = EZPopUpMenu.new(layout, 300@20, "macros : ");
//	[
//		"execute...",
//		"-",
//		"shift left",
//		"shift right",
//		"All off",
//		"All on",
//		"Randomise all",
//		"Randomise non-quarter notes",
//		"Vary",
//		"-",
//		"new...",
//	].do{|item, i|
//		g.addItem(item, {item. postln});
//	};
//	g.setColors(
//		Color.black.alpha_(0.25), Color.grey(0.95),
//		Color.black.alpha_(0.25), Color.black);
//	g.value=0;

	seq
};

~f_macroMenu= {|layout, seq|
	// this function draws a macro popup menu
//	var layout, triggers;
//	states = states ? [0, 1];
//	seq = seq ? (Array.fill(16, {states.choose}));
//
//	triggers= Array.fill(seq.size);
//
//	layout= CompositeView(view,
//		(view.bounds.width-8) @ 70
//	).background_(Color.grey/*rand*/);
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

	layout.decorator.nextLine;

	// this 'macros' code should really be in it's own function or class.
	g = EZPopUpMenu.new(layout, 300@20, "macros : ");
	[
		"execute...",
		"-",
		"shift left",
		"shift right",
		"All off",
		"All on",
		"Randomise all",
		"Randomise non-quarter notes",
		"Vary",
		"-",
		"new...",
	].do{|item, i|
		g.addItem(item, {item. postln});
	};
	g.setColors(
		Color.black.alpha_(0.25), Color.grey(0.95),
		Color.black.alpha_(0.25), Color.black);
	g.value=0;

//	seq
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
