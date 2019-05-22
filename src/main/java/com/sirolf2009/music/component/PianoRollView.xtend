package com.sirolf2009.music.component

import javafx.scene.layout.Pane
import javafx.scene.paint.Color
import jm.music.data.Note
import jm.music.data.Part
import jm.music.data.Phrase
import javafx.scene.shape.Rectangle
import jm.constants.Pitches

class PianoRollView extends Pane {
	
	/*
	 * Maybe make it a stack pane
	 * fill the first layer in with clickable transparent rectangles
	 * fill the second layer in with the actually added notes
	 */

	val noteHeight = 8
	val noteWidth = 8

	val Part part

	new(Part part) {
		this.part = part
		draw()
	}

	def void draw() {
		part.getPhraseList().forEach[drawPhrase(it)]
	}

	def void drawPhrase(Phrase phrase) {
		phrase.getNoteList().forEach [
			drawNote(phrase, it)
		]
	}

	def void drawNote(Phrase phrase, Note note) {
		if(note.isRest()) {
			return
		}
		setWidth(part.getEndTime() * noteWidth)
		setHeight(part.getHighestPitch() * noteHeight)
		val x = phrase.getNoteStartTime(phrase.getNoteList().indexOf(note)) * noteWidth
		val y = getHeight() - note.getPitch() * noteHeight
		val width = note.getDuration() * noteWidth
//		graphicsContext2D => [
//			setFill(Color.BLACK)
//			fillRect(x, y, width, noteHeight)
//		]
		getChildren().add(
			new Rectangle(x, y, width, noteHeight) => [
				setOnMouseEntered [ evt |
					setFill(Color.GRAY)
				]
				setOnMouseExited [ evt |
					setFill(Color.BLACK)
				]
				setOnMouseClicked [ evt |
					note.setPitch(Pitches.REST)
					getChildren().clear()
					draw()
				]
			]
		)
	}

}
