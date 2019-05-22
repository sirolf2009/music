package com.sirolf2009.music

import javafx.beans.value.ObservableValue
import javafx.collections.FXCollections
import javafx.scene.control.ComboBox
import javafx.beans.binding.Bindings

class ChordComboBox extends ComboBox<String> {

	val ObservableValue<int[]> chordProperty

	new() {
		super(FXCollections.observableArrayList(ChordsNamed.getNames()))
		chordProperty = Bindings.createObjectBinding([ChordsNamed.getChord(getSelectionModel().getSelectedItem())], getSelectionModel().selectedItemProperty())
	}
	
	def chordProperty() {
		return chordProperty
	}
	
	def getChord() {
		return chordProperty.getValue()
	}
	
	def setChord(int[] chord) {
		getSelectionModel().select(ChordsNamed.getName(chord))
	}

}
