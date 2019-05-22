package com.sirolf2009.music.component

import javafx.scene.control.Label
import jm.music.data.Note
import org.tbee.javafx.scene.layout.MigPane
import javafx.scene.text.TextAlignment
import com.sirolf2009.music.DurationsNamed

class NoteView extends MigPane {

	new(Note note) {
		super("", "[grow]", "[grow][]")
		setPrefWidth(note.getDuration() * 20)
		add(new Label(note.getNote()) => [
			setTextAlignment(TextAlignment.CENTER)
		], "center, growy, wrap")
		add(new Label(DurationsNamed.getName(note.getDuration())) => [
			setTextAlignment(TextAlignment.CENTER)
		], "center")
	}

}
