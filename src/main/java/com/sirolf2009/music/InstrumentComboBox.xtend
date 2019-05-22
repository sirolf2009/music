package com.sirolf2009.music

import javafx.beans.value.ObservableValue
import javafx.collections.FXCollections
import javafx.scene.control.ComboBox
import javafx.beans.binding.Bindings

class InstrumentComboBox extends ComboBox<String> {

	val ObservableValue<Integer> instrumentProperty

	new() {
		super(FXCollections.observableArrayList(InstrumentsNamed.getNames()))
		instrumentProperty = Bindings.createObjectBinding([InstrumentsNamed.getInstrument(getSelectionModel().getSelectedItem())], getSelectionModel().selectedItemProperty())
	}
	
	def instrumentProperty() {
		return instrumentProperty
	}
	
	def getInstrument() {
		return instrumentProperty.getValue()
	}
	
	def setChord(int instrument) {
		getSelectionModel().select(InstrumentsNamed.getName(instrument))
	}

}
