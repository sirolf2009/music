package com.sirolf2009.music

import animatefx.animation.FadeInUp
import animatefx.animation.FadeOutDown
import com.sirolf2009.music.component.Beat
import com.sirolf2009.music.component.ChordProgression
import com.sirolf2009.music.component.PianoRollView
import com.sirolf2009.music.lyrics.Rappad
import javafx.application.Application
import javafx.geometry.Pos
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.scene.control.Menu
import javafx.scene.control.MenuBar
import javafx.scene.control.MenuItem
import javafx.scene.input.KeyCode
import javafx.scene.input.KeyCodeCombination
import javafx.scene.input.KeyCombination
import javafx.scene.layout.AnchorPane
import javafx.scene.layout.HBox
import javafx.scene.layout.StackPane
import javafx.stage.Stage
import org.dockfx.DockNode
import org.dockfx.DockPane
import org.dockfx.DockPos
import org.tbee.javafx.scene.layout.MigPane
import com.sirolf2009.music.component.MetaphorGenerator
import com.sirolf2009.music.component.Piano

class Music extends Application {

	// https://www.khanacademy.org/humanities/music/music-basics2/notes-rhythm/a/glossary-of-musical-terms
	
	/* components TODO
	 * Arpeggio
	 * Note designer
	 * Chord designer
	 */
	
	val components = #{
		"beat" -> [new Beat()],
		"chord progression" -> [new ChordProgression()],
		"piano" -> [new Piano()],
		"piano roll" -> [new PianoRollView()],
		"rap pad" -> [new Rappad()],
		"metaphor" -> [new MetaphorGenerator()]
	}
	
	var StackPane root
	var AnchorPane mainContainer
	var DockPane dockPane
	var AutoCompleteTextField search
	var StackPane searchContainer

	override start(Stage primaryStage) throws Exception {
		dockPane = new DockPane()
		DockPane.initializeDefaultUserAgentStylesheet()

		search = new AutoCompleteTextField() => [
			setId("searchField")
		]
		val send = new Button(">") => [
			setId("search")
			setOnAction [
				openSearchedItem()
			]
		]
		val searchField = new HBox(search, send) => [
			setAlignment(Pos.CENTER)
		]
		searchContainer = new StackPane(searchField)
		searchContainer.setAlignment(Pos.CENTER)
		searchContainer.getStyleClass().add("search")
//		search.getEntries().addAll(components.stream().map[root.relativize(it)].map[toString().replaceLast(".groovy", "")].collect(Collectors.toList()))
		search.setOnAction [
			openSearchedItem()
		]

		val menubar = new MenuBar(
			new Menu("File", null, new MenuItem("Open Node") => [
				setAccelerator(new KeyCodeCombination(KeyCode.F, KeyCombination.CONTROL_DOWN))
				setOnAction [
					if(root.getChildren().contains(searchContainer)) {
						new FadeOutDown(search) => [
							setOnFinished [
								root.getChildren().remove(searchContainer)
							]
							play()
						]
					} else {
						root.getChildren().add(searchContainer)
						search.requestFocus()
						new FadeInUp(search).play()
					}
				]
			])
		)

		mainContainer = new StickyAnchorPane(dockPane)
		root = new StackPane(new MigPane("w 100%, fillx, ins 0, gap 0").add(menubar, "growx, wrap, top").add(mainContainer, "grow, push"))
		val scene = new Scene(root, 800, 600)
		primaryStage.setScene(scene)
		primaryStage.setOnCloseRequest[System.exit(0)]
		primaryStage.setTitle("Music | sirolf2009")
		primaryStage.show()
		
		new DockNode(new Rappad(), "Rap Pad").dock(dockPane, DockPos.TOP)
		new DockNode(new MetaphorGenerator(), "Metaphor").dock(dockPane, DockPos.BOTTOM)
//		new DockNode(new Beat(), "Beat").dock(dockPane, DockPos.RIGHT)
//		new DockNode(new ChordProgression(), "Chord Progression").dock(dockPane, DockPos.BOTTOM)
//		new DockNode(new PianoRollView(), "Piano!").dock(dockPane, DockPos.TOP)
//		new DockNode(new Piano(), "Piano").dock(dockPane, DockPos.TOP)
	}

	def openSearchedItem() {
		val text = search.getText()
		search.setText("")
		root.getChildren().remove(searchContainer)
		val node = components.get(text).apply(null)
		val dockNode = new DockNode(node, text)
		dockNode.dock(dockPane, DockPos.LEFT)
	}

	def static void main(String[] args) {
		launch(args)
	}

}