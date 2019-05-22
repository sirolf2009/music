package com.sirolf2009.music

import javafx.collections.ListChangeListener.Change
import javafx.scene.Node
import javafx.scene.layout.AnchorPane

class StickyAnchorPane extends AnchorPane {

	new(Node content) {
		this()
		getChildren().add(content)
	}

	new() {
		getChildren().addListener [ Change<? extends Node> change |
			while(change.next()) {
				change.getAddedSubList().forEach [
					maximize(it)
				]
			}
		]
	}

	def static maximize(AnchorPane parent, Node child) {
		AnchorPane.setTopAnchor(child, 0d)
		AnchorPane.setRightAnchor(child, 0d)
		AnchorPane.setBottomAnchor(child, 0d)
		AnchorPane.setLeftAnchor(child, 0d)
	}

}
