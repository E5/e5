/**
 *
 * terminal functions
 *
 * This file contains most of the functions used by terminal.
 *
 */

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

"Functions loaded...".postln;
"\t~f_placeWindow".postln;
""