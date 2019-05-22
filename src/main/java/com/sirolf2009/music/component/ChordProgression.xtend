package com.sirolf2009.music.component

import com.sirolf2009.music.ChordComboBox
import com.sirolf2009.music.DurationComboBox
import com.sirolf2009.music.InstrumentComboBox
import javafx.beans.binding.Bindings
import javafx.collections.FXCollections
import javafx.geometry.Orientation
import javafx.scene.Node
import javafx.scene.control.Button
import javafx.scene.control.ComboBox
import javafx.scene.control.ContentDisplay
import javafx.scene.control.Label
import javafx.scene.control.ListCell
import javafx.scene.control.ListView
import javafx.scene.control.TextField
import javafx.scene.text.TextAlignment
import jm.constants.Durations
import jm.constants.Pitches
import jm.constants.Scales
import jm.music.data.CPhrase
import jm.music.data.Note
import jm.music.data.Part
import jm.music.data.Phrase
import jm.music.data.Score
import jm.util.Play
import org.tbee.javafx.scene.layout.MigPane
import jm.util.View
import javafx.stage.Stage
import javafx.scene.Scene
import javafx.scene.layout.BorderPane

/**
 * 
 * Chord = any harmonic set of pitches consisting of multiple notes
 * 
 * https://www.musictheoryacademy.com/understanding-music/chord-progressions/
 *     Choose a key to write in (if you are just starting out the C major, G major, A minor and E minor are good keys to start with)
 *     Work out the primary chords (I, IV, V). Start to build your progressions with these. Then move on to using secondary chords (II, III, VI) to develop your chord progressions further.
 *     Always start and end your chord progression on chord I
 *     Try using some common progressions (see below)
 *     Try adding some circle progressions (see below)
 * 
 * 
 * https://blog.landr.com/chord-progressions/
 * 
 * In elementary piano, the left hand (lower notes) typically plays chords, while the right hand plays the melody. 
 * If you're playing pop or rock and singing, you might want to play the chords with the right hand and the bass note of each chord with the left hand.
 * 
 * Your melody should move with your chord progressions. So, if your first chord is a C Major.  Your melody should be within the notes of that chord C, E and G. 
 *  
 */
class ChordProgression extends MigPane {

	static val functions = #["Tonic", "Subdominant", "Tonic", "Subdominant", "Dominant", "Tonic", "Dominant"]

	static val scales = #{
		"Major" -> Scales.MAJOR_SCALE,
		"Minor" -> Scales.MINOR_SCALE,
		"Blues" -> Scales.BLUES_SCALE
	}

	static val pitches = #{
		"C" -> Pitches.C4,
		"F" -> Pitches.F4
	}

	new() {
		super("fillx", "[] [grow]")
		val scale = addComponent("Scale", new ComboBox(FXCollections.observableArrayList("Major", "Minor", "Blues")).selected("Major"))
		val pitch = addComponent("Pitch", new ComboBox(FXCollections.observableArrayList("C", "F")).selected("C"))
		val chord = addComponent("Chord", new ChordComboBox().selected("Major"))
		val instrumentSelector = addComponent("Instrument", new InstrumentComboBox().selected("Piano"))
		
		val chordProgression = FXCollections.observableArrayList()

		val selectedChords = new ListView<Note>() => [
			setOrientation(Orientation.HORIZONTAL)
			setItems(chordProgression)
			setCellFactory [
				new ListCell<Note>() {
					override protected updateItem(Note item, boolean empty) {
						super.updateItem(item, empty)
						if(item === null || empty) {
							setGraphic(null)
						} else {
							setGraphic(new NoteView(item))
							setOnMouseClicked [
								chordProgression.remove(item)
							]
						}
					}
				}
			]
		]

		val duration = addComponent("Duration", new DurationComboBox().selected("Whole Note"))
		addComponent("Available Chords", new ListView() => [
			setOrientation(Orientation.HORIZONTAL)
			itemsProperty().bind(Bindings.createObjectBinding([
				if(scale.hasSelection() && pitch.hasSelection && chord.hasSelection()) {
					FXCollections.observableArrayList(scales.get(scale.getSelectionModel().getSelectedItem()).map [
						val root = pitches.get(pitch.getSelectionModel().getSelectedItem()) + it
						new Note(root, Durations.WHOLE_NOTE)
					].toList())
				} else {
					FXCollections.emptyObservableList()
				}
			], scale.selectedItemProperty(), pitch.selectedItemProperty(), chord.selectedItemProperty()))
			setCellFactory [
				new ListCell<Note>() {
					override protected updateItem(Note item, boolean empty) {
						super.updateItem(item, empty)
						setContentDisplay(ContentDisplay.TOP)
						if(item === null || empty) {
							setText(null)
							setGraphic(null)
						} else {
							setText(item.getNote())
							setGraphic(new Label('''
							(«getItems().indexOf(item)+1»)
							(«functions.get(getItems().indexOf(item))»)''') => [
								setTextAlignment(TextAlignment.CENTER)
							])
							setOnMouseClicked [
								Play.midi(new Score(new Part(new Phrase(item) => [setInstrument(instrumentSelector.getInstrument())])), false, false, 10, 0)
								chordProgression.add(new Note(item.getPitch(), duration.getDuration()))
							]
						}
					}
				}
			]
		])
		val progression = addComponent("Progression", new TextField())
		addComponent("Key", new Label() => [
			textProperty().bind(pitch.selectedItemProperty().asString().concat(" ").concat(scale.selectedItemProperty().asString()))
		])
		add(new Button("Generate") => [
			setOnAction [
				val cphrase = new CPhrase(0, instrumentSelector.getInstrument())
				val chords = scales.get(scale.getSelectionModel().getSelectedItem()).map [
					val root = pitches.get(pitch.getSelectionModel().getSelectedItem()) + it
					val selectedChord = chord.getChord()
					getPitches(root, selectedChord)
				].toList()
				progression.getText().split(",").map[Integer.parseInt(it) - 1].map[chords.get(it)].forEach [
					cphrase.addChord(it, duration.getDuration())
				]
				val part = new Part(cphrase)
				Play.midi(new Score(part), false, false, 10, 0)
			]
		], "wrap")

		addComponent("Song", selectedChords)
		add(new Button("Play") => [
			setOnAction [
				val phrase = new CPhrase(0, instrumentSelector.getInstrument())
				selectedChords.getItems().forEach [
					phrase.addChord(getPitches(getPitch(), chord.getChord()), getDuration())
				]
				val part = new Part(phrase)
				Play.midi(new Score(part), false, false, 10, 0)
				new Stage() => [
					setScene(new Scene(new BorderPane(new PianoRollView(part))))
					show()
				]
			]
		])

	}
	
	def <B extends ComboBox<T>, T> selected(B box, T item) {
		box.getSelectionModel().select(item)
		return box
	} 

	def hasSelection(ComboBox<?> box) {
		return box.getSelectionModel().getSelectedItem() !== null
	}

	def <B extends ComboBox<T>, T> selectedItemProperty(B box) {
		return box.getSelectionModel().selectedItemProperty()
	}

	def getPitches(int root, int[] chord) {
		return #[root - 12, root] + chord.map[root + it]
	}

	def <T extends Node> addComponent(String name, T component) {
		add(new Label(name))
		add(component, "grow, wrap")
		return component
	}

}
