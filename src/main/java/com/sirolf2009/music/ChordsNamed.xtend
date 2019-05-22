package com.sirolf2009.music

import java.util.HashMap

import static jm.constants.Chords.*

class ChordsNamed {

	static val nameToChords = new HashMap<String, int[]>()
	static val chordsToName = new HashMap<int[], String>()

	static val initializer = {
		register("Major", MAJOR)
		register("Minor", MINOR)
		register("Augmented", AUGMENTED)
		register("Diminished", DIMINISHED)
		register("Suspended 4th", SUSPENDED_FOURTH)
		register("Flatted 5th", FLATTED_FIFTH)
		register("6th", SIXTH)
		register("Minor 6th", MINOR_SIXTH)
		register("7th", SEVENTH)
		register("Minor 7th", MINOR_SEVENTH)
		register("Major 7th", MAJOR_SEVENTH)
		register("7th sharp 5th", SEVENTH_SHARP_FIFTH)
		register("Diminished 7th", DIMINISHED_SEVENTH)
		register("7th flat 5th", SEVENTH_FLAT_FIFTH)
		register("Minor 7th flat 5th", MINOR_SEVENTH_FLAT_FIFTH)
		register("6th added 9th", SIXTH_ADDED_NINTH)
		register("7th sharp 9th", SEVENTH_SHARP_NINTH)
		register("7th flat 9th", SEVENTH_FLAT_NINTH)
		register("9th", NINTH)
		register("Minor 9th", MINOR_NINTH)
		register("11th", ELEVENTH)
		register("Minor 11th", MINOR_ELEVENTH)
		register("13th", THIRTEENTH)
	}
	
	def static getNames() {
		return nameToChords.keySet()
	}
	
	def static getChords() {
		return chordsToName.keySet()
	}

	def static getChord(String name) {
		return nameToChords.get(name)
	}

	def static getName(int[] chord) {
		return chordsToName.get(chord)
	}

	def private static register(String name, int[] chord) {
		nameToChords.put(name, chord)
		chordsToName.put(chord, name)
	}

}
