package com.sirolf2009.music

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Side;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.CustomMenuItem;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.util.LinkedList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.stream.Collectors

/**
 * This class is a TextField which implements an "autocomplete" functionality, based on a supplied list of entries.
 * @author Caleb Brinkman https://gist.github.com/floralvikings/10290131
 */
class AutoCompleteTextField extends TextField {

	/** The existing autocomplete entries. */
	val SortedSet<String> entries
	/** The popup used to select an entry. */
	val ContextMenu entriesPopup;

	/** Construct a new AutoCompleteTextField. */
	new() {
		super()
		entries = new TreeSet()
		entriesPopup = new ContextMenu()
		textProperty().addListener(new ChangeListener<String>() {
			override changed(ObservableValue<? extends String> observableValue, String s, String s2) {
				if(getText().length() == 0) {
					entriesPopup.hide();
				} else {
					val searchResult = new LinkedList<String>();
					val List<String> filteredEntries = entries.stream().filter[toLowerCase().contains(getText().toLowerCase())].collect(Collectors.toList()) 
					searchResult.addAll(filteredEntries)
//					searchResult.addAll(entries.subSet(getText(), getText() + Character.MAX_VALUE));
					if(entries.size() > 0) {
						populatePopup(searchResult);
						if(!entriesPopup.isShowing() && getScene() !== null) {
							entriesPopup.show(AutoCompleteTextField.this, Side.BOTTOM, 0, 0);
						}
					} else {
						entriesPopup.hide();
					}
				}
			}
		});

		focusedProperty().addListener(new ChangeListener<Boolean>() {
			override changed(ObservableValue<? extends Boolean> observableValue, Boolean aBoolean, Boolean aBoolean2) {
				entriesPopup.hide();
			}
		});

	}

	def showPopup(List<String> searchResult) {
		if(entries.size() > 0) {
			populatePopup(searchResult);
			if(!entriesPopup.isShowing()) {
				entriesPopup.show(AutoCompleteTextField.this, Side.BOTTOM, 0, 0);
			}
		} else {
			entriesPopup.hide();
		}
	}

	/**
	 * Get the existing set of autocomplete entries.
	 * @return The existing autocomplete entries.
	 */
	def SortedSet<String> getEntries() { return entries; }

	/**
	 * Populate the entry set with the given search results.  Display is limited to 10 entries, for performance.
	 * @param searchResult The set of matching strings.
	 */
	def private void populatePopup(List<String> searchResult) {
		val menuItems = new LinkedList();
		// If you'd like more entries, modify this line.
		val maxEntries = 10;
		val count = Math.min(searchResult.size(), maxEntries);
		(0 ..< count).forEach [
			val result = searchResult.get(it);
			val entryLabel = new Label(result);
			val item = new CustomMenuItem(entryLabel, true);
			item.setOnAction(new EventHandler<ActionEvent>() {
				override handle(ActionEvent actionEvent) {
					setText(result);
					entriesPopup.hide();
					fireEvent(new ActionEvent())
				}
			});
			menuItems.add(item);
		]
		entriesPopup.getItems().clear();
		entriesPopup.getItems().addAll(menuItems);

	}
}
