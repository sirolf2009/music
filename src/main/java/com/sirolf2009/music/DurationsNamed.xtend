package com.sirolf2009.music

import java.util.HashMap

class DurationsNamed {
	
	static val nameToDuration = new HashMap<String, Double>()
	static val durationToName = new HashMap<Double, String>()
	
	static val initializer = {
		register("Whole Note", 4.0)
		register("Half Note", 2.0)
		register("Quarter Note", 1.0)
		register("Eighth Note", 0.5)
		register("Sixteenth Note", 0.25)
	}
	
	def static getNames() {
		return nameToDuration.keySet()
	}
	
	def static getDurations() {
		return durationToName.keySet()
	}

	def static getDuration(String name) {
		return nameToDuration.get(name)
	}

	def static getName(double duration) {
		return durationToName.get(duration)
	}
	
	def private static register(String chord, Double duration) {
		nameToDuration.put(chord, duration)
		durationToName.put(duration, chord)
	} 
		
}