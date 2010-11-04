/**
 *
 * terminal environment
 *
 */

Document.listener.bounds_(Rect(0, 41, 810, 254));
//Document.current.bounds.postln;
Document.current.bounds_(Rect(811, 41, 627, 837));


(
// inspector window
w= Window.new("", Rect(0, 300, 810, 560)).front;

//SynthDef(\sample, {arg out = 3, freq = 100; Out.ar(out, SinOsc.ar(freq))}) ;
SynthDefAutogui(\sample) ; // a synth is created

)