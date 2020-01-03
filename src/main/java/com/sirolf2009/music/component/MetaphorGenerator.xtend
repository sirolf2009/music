package com.sirolf2009.music.component

import java.nio.file.Files
import java.nio.file.Paths
import java.util.List
import java.util.Random
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.control.TextField
import org.tbee.javafx.scene.layout.MigPane

class MetaphorGenerator extends MigPane {

	val TextField adjective
	val TextField concreteNoun
	val TextField abstractNoun
	val Random random

	new() {
		adjective = new TextField()
		concreteNoun = new TextField()
		abstractNoun = new TextField()
		random = new Random()
		add(new Button("Reset All") => [
			setOnAction [
				randomAdjective()
				randomConcreteNoun()
				randomAbstractNoun()
			]
		], "span 5, wrap, center")
		add(new Label("The"))
		add(adjective)
		add(concreteNoun)
		add(new Label("of"))
		add(abstractNoun, "wrap")
		add(new Button("Reset") => [
			setOnAction [randomAdjective()]
		], "skip 1")
		add(new Button("Reset") => [
			setOnAction [randomConcreteNoun()]
		])
		add(new Button("Reset") => [
			setOnAction [randomAbstractNoun()]
		], "skip 1")
		randomAdjective()
		randomConcreteNoun()
		randomAbstractNoun()
	}

	def randomAdjective() {
		randomWord(adjective, adjectives)
	}

	def randomConcreteNoun() {
		randomWord(concreteNoun, concreteNouns)
	}

	def randomAbstractNoun() {
		randomWord(abstractNoun, abstractNouns)
	}

	def randomWord(TextField field, List<String> words) {
		field.setText(words.get(random.nextInt(words.size())))
	}

	static val adjectives = Files.readAllLines(Paths.get("adjectives"))
	static val concreteNouns = Files.readAllLines(Paths.get("concreteNouns"))
	static val abstractNouns = Files.readAllLines(Paths.get("abstractNouns"))

}
