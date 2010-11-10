(
/**
 *
 * e5 synths
 *
 * All terminal synths have the prefix 'e5_'
 * plus 'gen_' or 'mod_' 
 *
 * Will use fredrik olofsson's enkalib as
 * an inspiration.
 *
 */

// Simple buffer player
SynthDef(\e5_gen_playbuf, {|out= 0, bufnum=0, amp=0.5, startPos=0, loop=0, t_trig=1, rate=1.0, length= 1.0, panPos=0, cmp_gain=1, cmp_threshhold=1.0|
	var signal, env;

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
		signal * cmp_gain,
		signal * cmp_gain,
		thresh: cmp_threshhold,
		slopeBelow: 1,
		slopeAbove: 0.5,
		clampTime: 0.01,
		relaxTime: 0.01
	);

	signal= Balance2.ar(signal[0], signal[1], panPos);
	signal= EnvGen.kr(Env.cutoff(1, 1), 0, amp, 0, BufDur.kr(bufnum) * length) * signal;

	Out.ar(out, signal);

}, metadata: (
	specs: (
		out: [0, 7, 'lin', 1, 0, ""],
		bufnum: [0, 1000, 'lin', 1, 0, ""],
		amp: [0, 1, 'amp', 0, 0, ""],
		startPos: [0, 1, 'lin', 0, 0, ""],
		loop: [0, 1, \lin, 1, 0, ""],
		t_trig: [0, 1, \lin, 1, 0, ""],
		rate: \rate.asSpec,
		length: [0, 1, 'lin', 0, 0, ""],
		panPos: \pan.asSpec,
		cmp_gain: [0, 100, \lin, 0, 1, ""],
		cmp_threshhold: [0, 1, 'amp', 0, 0, ""]
	))
).add;


// Cylob's Electribe drum synth
SynthDef(\e5_gen_ER_1, {
	|outBus = 0, trig=0, midiFreq = 60, gate = 1.0, amp = 0.5, freqMult = 1,
	waveType = 0, modType = 0, modDepth = 0.0, modSpeed = 4.0, ampDecay = 0.1|

	var freq, output, modEnvGen, ampEnvGen, pitchMod, white, waveFreq;

	freq = midiFreq.midicps * freqMult;
	white = WhiteNoise.ar;
	modEnvGen = EnvGen.kr(Env.perc(0.0001, modSpeed.reciprocal, 1, -6), gate, doneAction: 2);
	pitchMod = 
		Select.kr(modType, 
			[
			LFSaw.ar(modSpeed), LFPulse.ar(modSpeed), 
			LFTri.ar(modSpeed), Latch.ar(white, Impulse.ar(modSpeed)), 
			white,
			white * modEnvGen, modEnvGen
			]
		);

	waveFreq = (freq * (1 + (pitchMod * modDepth))).clip(40, inf);

	output = 
		Select.ar(waveType, 
			[
			SinOsc.ar(waveFreq),
			LFTri.ar(waveFreq)
			]
		);

	ampEnvGen = EnvGen.kr(Env.perc(0.0001, ampDecay, 1, -6), gate);
	output = output * ampEnvGen * amp;
	output = Limiter.ar(output, 0.9, 0.01);

	Out.ar(outBus, output ! 2);

	}, metadata: (
	specs: (
		midiFreq: [1, 128, 'lin', 0, 60, ""],
		amp: [0, 1, 'amp', 0, 0, ""],
		freqMult: [0.25, 8, 'lin', 0, 0, ""],
		waveType: [0, 1, 'lin', 1, 0, ""],
		modType: [0, 1, 'lin', 1, 0, ""],
		modDepth: [0, 10, 'lin', 0, 0, ""],
		modSpeed: [0, 10, 'lin', 0, 4.0, ""],
		ampDecay: [0, 4, 'lin', 0, 0.1, ""]
	))
).add;

// SOSkick -------
// http://www.soundonsound.com/sos/jan02/articles/synthsecrets0102.asp
// increase mod_freq and mod_index for interesting electronic percussion
SynthDef(\e5_gen_SOSkick,
	{|out = 0, freq = 50, mod_freq = 5, mod_index = 5, sustain = 0.4, amp = 0.8, beater_noise_level = 0.025|
	var pitch_contour, drum_osc, drum_lpf, drum_env;
	var beater_source, beater_hpf, beater_lpf, lpf_cutoff_contour, beater_env;
	var kick_mix;
	pitch_contour = Line.kr(freq*2, freq, 0.02);
	drum_osc = PMOsc.ar(	pitch_contour,
				mod_freq,
				mod_index/1.3,
				mul: 1,
				add: 0);
	drum_lpf = LPF.ar(in: drum_osc, freq: 1000, mul: 1, add: 0);
	drum_env = drum_lpf * EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
	beater_source = WhiteNoise.ar(beater_noise_level);
	beater_hpf = HPF.ar(in: beater_source, freq: 500, mul: 1, add: 0);
	lpf_cutoff_contour = Line.kr(6000, 500, 0.03);
	beater_lpf = LPF.ar(in: beater_hpf, freq: lpf_cutoff_contour, mul: 1, add: 0);
	beater_env = beater_lpf * EnvGen.ar(Env.perc, 1.0, doneAction: 2);
	kick_mix = Mix.new([drum_env, beater_env]) * 2 * amp;

	Out.ar(out, [kick_mix, kick_mix])

}, metadata: (
	specs: (
		freq: [20, 20000, 'exp', 0, 440, " Hz"],
		mod_freq: [20, 20000, 'exp', 0, 440, " Hz"],
		mod_index: [0, 100, 'lin', 0, 0, ""],
		sustain: [0, 1, 'amp', 0, 0, ""],
		amp: [0, 1, 'amp', 0, 0, ""],
		beater_noise_level: [0, 1, 'amp', 0, 0, ""]	)
)).add;

// SOSsnare -------
// http://www.soundonsound.com/sos/Mar02/articles/synthsecrets0302.asp
SynthDef(\e5_gen_SOSsnare,
	{|out = 0, sustain = 0.1, drum_mode_level = 0.25,
	snare_level = 40, snare_tightness = 1000,
	freq = 405, amp = 0.8, noiseType=0|
	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var snare_noise, snare_brf_1, snare_brf_2, snare_brf_3, snare_brf_4, snare_reson;
	var snare_env;
	var snare_drum_mix;

	drum_mode_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
	drum_mode_sin_1 = SinOsc.ar(freq*0.53, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.85),
					184,
					0.5/1.3,
					mul: drum_mode_env*5,
					add: 0);
	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drum_mode_level;

// choose either noise source below
	snare_noise = Select.ar(noiseType, [Crackle.ar(2.01, 1), LFNoise0.ar(20000, 0.1)]);
	snare_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
	snare_brf_1 = BRF.ar(in: snare_noise, freq: 8000, mul: 0.5, rq: 0.1);
	snare_brf_2 = BRF.ar(in: snare_brf_1, freq: 5000, mul: 0.5, rq: 0.1);
	snare_brf_3 = BRF.ar(in: snare_brf_2, freq: 3600, mul: 0.5, rq: 0.1);
	snare_brf_4 = BRF.ar(in: snare_brf_3, freq: 2000, mul: snare_env, rq: 0.0001);
	snare_reson = Resonz.ar(snare_brf_4, snare_tightness, mul: snare_level) ;
	snare_drum_mix = Mix.new([drum_mode_mix, snare_reson]) * 5 * amp;
	Out.ar(out, [snare_drum_mix, snare_drum_mix])
}, metadata: (
	specs: (
		sustain: [0, 1, 'amp', 0, 0, ""],
		drum_mode_level: [0, 1, 'amp', 0, 0, ""],
		snare_level: [0, 1, 'amp', 0, 0, ""],
		snare_tightness: [0, 5000, \lin, 1, 1],
		freq: [20, 20000, 'exp', 0, 440, " Hz"],
		amp: [0, 1, 'amp', 0, 0, ""],
		noiseType: [0, 1, 'lin', 1, 0, ""]

	)
)).add;


// SOShats -------
// http://www.soundonsound.com/sos/Jun02/articles/synthsecrets0602.asp
SynthDef(\e5_gen_SOShats,
	{|out = 0, freq = 6000, sustain = 0.1, amp = 0.8|
	var root_cymbal, root_cymbal_square, root_cymbal_pmosc;
	var initial_bpf_contour, initial_bpf, initial_env;
	var body_hpf, body_env;
	var cymbal_mix;
	
	root_cymbal_square = Pulse.ar(freq, 0.5, mul: 1);
	root_cymbal_pmosc = PMOsc.ar(root_cymbal_square,
					[freq*1.34, freq*2.405, freq*3.09, freq*1.309],
					[310/1.3, 26/0.5, 11/3.4, 0.72772],
					mul: 1,
					add: 0);
	root_cymbal = Mix.new(root_cymbal_pmosc);
	initial_bpf_contour = Line.kr(15000, 9000, 0.1);
	initial_env = EnvGen.ar(Env.perc(0.005, 0.1), 1.0);
	initial_bpf = BPF.ar(root_cymbal, initial_bpf_contour, mul:initial_env);
	body_env = EnvGen.ar(Env.perc(0.005, sustain, 1, -2), 1.0, doneAction: 2);
	body_hpf = HPF.ar(in: root_cymbal, freq: Line.kr(9000, 12000, sustain),mul: body_env, add: 0);
	cymbal_mix = Mix.new([initial_bpf, body_hpf]) * amp;
	Out.ar(out, [cymbal_mix, cymbal_mix])
}, metadata: (
	specs: (
		freq: [20, 20000, 'exp', 0, 440, " Hz"],
		sustain: [0, 1, 'amp', 0, 0, ""],
		amp: [0, 1, 'amp', 0, 0, ""]
	)
)).add;


// SOStom -------
// http://www.soundonsound.com/sos/Mar02/articles/synthsecrets0302.asp

SynthDef(\e5_gen_SOStom,
	{|out = 0, sustain = 0.4, drum_mode_level = 0.25,
	freq = 90, drum_timbre = 1.0, amp = 0.8|
	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var stick_noise, stick_env;
	var drum_reson, tom_mix;

	drum_mode_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
	drum_mode_sin_1 = SinOsc.ar(freq*0.8, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.9),
								freq*0.85,
								drum_timbre/1.3,
								mul: drum_mode_env*5,
								add: 0);
	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drum_mode_level;
	stick_noise = Crackle.ar(2.01, 1);
	stick_env = EnvGen.ar(Env.perc(0.005, 0.01), 1.0) * 3;
	tom_mix = Mix.new([drum_mode_mix, stick_env]) * 2 * amp;
	Out.ar(out, [tom_mix, tom_mix])
}, metadata: (
	specs: (
		sustain: [0, 1, 'amp', 0, 0, ""],
		drum_mode_level: [0, 1, 'amp', 0, 0, ""],
		freq: [20, 20000, 'exp', 0, 440, " Hz"],
		drum_timbre: [0, 1, 'amp', 0, 0, ""],
		amp: [0, 1, 'amp', 0, 0, ""]
	))
).add;

/**
 *
 * Processors
 *
 */
 
SynthDef(\e5_mod_compressor, {
	|out=0, in=0, mix= 1, gain=1, thresh=1, slopeBelow=1, slopeAbove=0.5, clampTime=0.01,
	relaxTime=0.01, makeUp=1|
	var signal, fx;

	signal= In.ar(in, 1);
	fx= Compander.ar(
		signal * gain,
		signal * gain,
		thresh,
		slopeBelow,
		slopeAbove,
		clampTime,
		relaxTime,
		makeUp
	);

	ReplaceOut.ar(out, XFade2.ar(signal, fx, mix));
}
).add;

/*
	description: this is a ...
*/
//SynthDef(\e5_mod_ring, {|out= 0, in= 0, ringFreq=15|
//	var signal, fx;
//	signal= In.ar(in, 1);
//	fx= signal * SinOsc.ar(ringFreq);
//	ReplaceOut.ar(out, XFade2.ar(signal, fx, mix));
//}, metadata: (
//	specs: (
//		myRing: ControlSpec(0.001, 100, \exp, 0, 5, "Hz")
//	)
//)).add;

/*
	example:
	b= Synth(\xxxx_mod_template);
	a= Synth(\xxxx_gen_template);
	b.set(\myRing, 15);
	b.set(\mix, 0);			//-1= dry, 1= wet
	b.free;
	a.set(\gate, 0);	
*/

"Synths loaded...".postln;
//~data.postln;
""

)
