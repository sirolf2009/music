package com.sirolf2009.music

import javafx.scene.control.ComboBox
import javafx.beans.value.ObservableValue
import javafx.collections.FXCollections
import javafx.beans.binding.Bindings

class DurationComboBox extends ComboBox<String> {
	
	val ObservableValue<Double> durationProperty

	new() {
		super(FXCollections.observableArrayList(DurationsNamed.getNames()))
		durationProperty = Bindings.createObjectBinding([DurationsNamed.getDuration(getSelectionModel().getSelectedItem())], getSelectionModel().selectedItemProperty())
	}
	
	def durationProperty() {
		return durationProperty
	}
	
	def getDuration() {
		return durationProperty.getValue()
	}
	
	def setDuration(double duration) {
		getSelectionModel().select(DurationsNamed.getName(duration))
	}
	
}