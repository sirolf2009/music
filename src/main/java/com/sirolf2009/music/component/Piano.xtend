package com.sirolf2009.music.component

import javafx.scene.Group
import javafx.scene.paint.Color
import javafx.scene.shape.Rectangle
import jm.constants.Durations
import jm.constants.Pitches
import jm.music.data.Note
import jm.music.data.Part
import jm.music.data.Phrase
import jm.music.data.Score
import jm.util.Play
import org.tbee.javafx.scene.layout.MigPane

class Piano extends MigPane {

	new() {
		super("fill")
		addOctave(Pitches.C0)
		addOctave(Pitches.C1)
		addOctave(Pitches.C2)
		addOctave(Pitches.C3)
		addOctave(Pitches.C4)
		addOctave(Pitches.C5)
		addOctave(Pitches.C6)
		addOctave(Pitches.C7)
		addOctave(Pitches.C8)
		addOctave(Pitches.C9)

	}

	def addOctave(MigPane migPane, int pitch) {
		val whiteWidth = 62
		val blackOffset = 50
		var Group root = new Group()
		var Rectangle r = new Rectangle(0, 60, 60, 200)
		r.setFill(Color.WHITE)
		r.setStroke(Color.BLACK)
		r.setOnMouseClicked = [play(pitch)]
		var Rectangle ra = new Rectangle(blackOffset, 60, 20, 130)
		ra.setFill(Color.BLACK)
		ra.setOnMouseClicked = [play(pitch + 1)]
		var Rectangle r1 = new Rectangle(whiteWidth, 60, 60, 200)
		r1.setFill(Color.WHITE)
		r1.setStroke(Color.BLACK)
		r1.setOnMouseClicked = [play(pitch + 2)]
		var Rectangle r1a = new Rectangle(whiteWidth + blackOffset, 60, 20, 130)
		r1a.setFill(Color.BLACK)
		r1a.setOnMouseClicked = [play(pitch + 3)]
		var Rectangle r2 = new Rectangle(whiteWidth * 2, 60, 60, 200)
		r2.setFill(Color.WHITE)
		r2.setStroke(Color.BLACK)
		r2.setOnMouseClicked = [play(pitch + 4)]
		var Rectangle r3 = new Rectangle(whiteWidth * 3, 60, 60, 200)
		r3.setFill(Color.WHITE)
		r3.setStroke(Color.BLACK)
		r3.setOnMouseClicked = [play(pitch + 5)]
		var Rectangle r3a = new Rectangle(whiteWidth * 3 + blackOffset, 60, 20, 130)
		r3a.setFill(Color.BLACK)
		r3a.setOnMouseClicked = [play(pitch + 6)]
		var Rectangle r4 = new Rectangle(whiteWidth * 4, 60, 60, 200)
		r4.setFill(Color.WHITE)
		r4.setStroke(Color.BLACK)
		r4.setOnMouseClicked = [play(pitch + 7)]
		var Rectangle r4a = new Rectangle(whiteWidth * 4 + blackOffset, 60, 20, 130)
		r4a.setFill(Color.BLACK)
		r4a.setOnMouseClicked = [play(pitch + 8)]
		var Rectangle r5 = new Rectangle(whiteWidth * 5, 60, 60, 200)
		r5.setFill(Color.WHITE)
		r5.setStroke(Color.BLACK)
		r5.setOnMouseClicked = [play(pitch + 9)]
		var Rectangle r5a = new Rectangle(whiteWidth * 5 + blackOffset, 60, 20, 130)
		r5a.setFill(Color.BLACK)
		r5a.setOnMouseClicked = [play(pitch + 10)]
		var Rectangle r6 = new Rectangle(whiteWidth * 6, 60, 60, 200)
		r6.setFill(Color.WHITE)
		r6.setStroke(Color.BLACK)
		r6.setOnMouseClicked = [play(pitch + 11)]
		root.getChildren().addAll(r, r1, r2, r3, r4, r5, r6)
		root.getChildren().addAll(ra, r1a, r3a, r4a, r5a)
		migPane.add(root)
	}

	def play(int pitch) {
		Play.midi(new Score(new Part(new Phrase(new Note(pitch, Durations.WHOLE_NOTE)))), false, false, 10, 0)
	}

}
