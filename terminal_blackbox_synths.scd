(
/**
 *
 * terminal blackbox synths
 *
 */

// Example synthdef
SynthDef(\sample, {|out= 0, bufnum=0, amp=0.5, startPos=0, loop=0, t_trig=1, rate=1.0, length= 1.0, panPos=0|
	var signal, env, c_gain=1, c_threshhold=1.0;

	signal= PlayBuf.ar(
		2,
		bufnum,
		BufRateScale.kr(bufnum) * rate,
		t_trig,
		startPos,
		loop,
		doneAction: 2
	);

	signal= Compander.ar(
		signal*c_gain,
		signal*c_gain,
		thresh: c_threshhold,
		slopeBelow: 1,
		slopeAbove: 0.5,
		clampTime: 0.01,
		relaxTime: 0.01
	);

	signal= Balance2.ar(signal[0], signal[1], panPos);
	signal= EnvGen.kr(Env.cutoff(1, 1), 0, amp, 0, BufDur.kr(bufnum) * length) * signal;

	Out.ar(out, signal);
}).add;

)
