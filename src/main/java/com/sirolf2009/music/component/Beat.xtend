package com.sirolf2009.music.component

import com.sirolf2009.music.IPartProvider
import java.util.concurrent.Executors
import javafx.scene.control.Button
import javafx.scene.control.CheckBox
import javafx.scene.control.Label
import javafx.scene.control.ToggleButton
import jm.midi.MidiSynth
import jm.music.data.Part
import jm.music.data.Phrase
import jm.music.data.Score
import jm.util.Play
import org.tbee.javafx.scene.layout.MigPane

import static jm.constants.Durations.*
import static jm.constants.Pitches.*
import jm.constants.Instruments

class Beat extends MigPane implements IPartProvider {

	val executor = Executors.newSingleThreadExecutor()
	val Phrase kick
	val Phrase beat
	val Phrase snare
	val Part drums

	new() {
		kick = new Phrase("Kick", 0)
		beat = new Phrase("Beat", 0)
		snare = new Phrase("Snare", 0)
		drums = new Part("Drums", Instruments.DRUM)
		#[kick, beat, snare].forEach [
			addNoteList((0 ..< 16).map[REST], SIXTEENTH_NOTE)
		]
		drums.addPhraseList(#[kick, beat, snare])

		add(new Label("Steps"))
		(1 ..< 16).forEach[add(new Label('''«it»'''))]
		add(new Label("16"), "wrap")

		add(new Label("Kick"))
		addPhraseCheckBoxRow(kick, FS2)

		add(new Label("Beat"))
		addPhraseCheckBoxRow(beat, D2)

		add(new Label("Snare"))
		addPhraseCheckBoxRow(beat, C2)

		add(new Button("Play") => [
			setOnAction [
//				Play.audio(drums, #[new com.sirolf2009.music.SineInst(44100), new com.sirolf2009.music.SineInst(44100), new com.sirolf2009.music.SineInst(44100)])
				executor.submit[Play.midi(new Score(drums), false, false, 10, 0)]
			]
		], "split 2")

		add(new ToggleButton("Repeat") => [
			val synth = new MidiSynth() => [
				setCycle(true)
			]
			setOnAction [evt|
				if(isSelected()) {
					synth.play(new Score(drums))
				} else {
					synth.stop()
				}
			]
		])
	}

	def addPhraseCheckBoxRow(Phrase phrase, int pitch) {
		(0 ..< 15).forEach [ index |
			add(phraseCheckBox(index, phrase, pitch))
		]
		add(phraseCheckBox(15, phrase, pitch), "wrap")
	}

	def phraseCheckBox(int index, Phrase phrase, int pitch) {
		new CheckBox() => [
			selectedProperty().addListener [ obs, oldVal, newVal |
				try {
					if(newVal) {
						kick.getNote(index).setPitch(pitch)
					} else {
						kick.getNote(index).setPitch(REST)
					}
				} catch(Exception e) {
					throw new RuntimeException('''Failed to update note. index=«index» phrase=«phrase» pitch=«pitch» newVal=«newVal»''', e)
				}
			]
		]
	}

	override getPart() {
		return drums
	}

}
