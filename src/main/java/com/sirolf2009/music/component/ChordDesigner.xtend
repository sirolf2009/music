package com.sirolf2009.music.component

import com.sirolf2009.music.ChordComboBox
import javafx.collections.FXCollections
import javafx.scene.Node
import javafx.scene.control.Label
import org.tbee.javafx.scene.layout.MigPane
import javafx.scene.control.Button
import jm.music.data.Phrase
import jm.constants.Pitches
import jm.constants.Durations
import jm.util.Play
import jm.constants.Chords

/*
 * C, C#, D, D#, E, F, F#, G, G#, A, A#, B
 * 
 * Semitone: from C to C#
 * Tone: from C to D
 * 
 * Chord
 *  Multiple notes that sound nice
 * 
 * Natural Chords
 *  Chords that have the same name as a note
 *  Start with a note and add the third and fifth degree
 *  Can be major/minor/suspended, depending on the third degree
 * 
 * Triad
 *  A natural chord with 3 degrees
 *  e.g. the C chord: C, E, G
 *  e.g. the Fm chord: F, G#, C
 *  
 * Harmonic Function
 *  Represents feeling (emotions) of a chord
 *  Types:
 *   Tonic - rest, stablity, finalization. Like a conclusion
 *   Dominant - Instability, tension. Like a preparation
 *   Pre-dominant - Something between tonic and dominant
 * 
 * Major chords sound cheerful, while minor chords sound sad or cool. Context may change this
 */
class ChordDesigner extends MigPane {
	
	val notes = FXCollections.observableArrayList()
	
	new() {
		val chord = addComponent("Chord", new ChordComboBox())
		add(new Button("Play sound") => [
			setOnAction = [
				//| G7M | C7M | D7 |
				val phrase = new Phrase()
				phrase.addChord(getPitches(Pitches.G4, Chords.DIMINISHED_SEVENTH), Durations.HALF_NOTE) // G7M - “relief”, “solving” and stability feeling - Tonic
				phrase.addChord(getPitches(Pitches.C4, Chords.DIMINISHED_SEVENTH), Durations.HALF_NOTE) // C7M - A middle ground - Pre-dominant
				phrase.addChord(getPitches(Pitches.D7, Chords.SEVENTH), Durations.HALF_NOTE) //D7 - Emits "preparation" to G7M - Dominant
				Play.midiCycle(phrase)
			]
		])
	}
	
	def getPitches(int root, int[] chord) {
		return #[root]+chord.map[root+it]
	}

	def <T extends Node> addComponent(String name, T component) {
		add(new Label(name))
		add(component, "wrap")
		return component
	}
	
}