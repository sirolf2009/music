package com.sirolf2009.music.lyrics

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.net.URL
import java.nio.charset.Charset
import java.time.Duration
import java.util.List
import java.util.regex.Matcher
import java.util.regex.Pattern
import javafx.geometry.Insets
import javafx.scene.control.Label
import javafx.scene.control.ListView
import javafx.scene.input.MouseEvent
import javafx.scene.layout.Background
import javafx.scene.layout.BackgroundFill
import javafx.scene.layout.CornerRadii
import javafx.scene.paint.Color
import javafx.scene.text.Font
import javafx.scene.text.FontPosture
import javafx.stage.Popup
import org.apache.commons.io.IOUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.fxmisc.richtext.StyleClassedTextArea
import org.fxmisc.richtext.event.MouseOverTextEvent

class Rappad extends StyleClassedTextArea {

	val wordTerminators = #[" ", "\n", ".", ",", "!", "?"]

	new() {
		val popup = new Popup()
		val popupList = new ListView<String>()
		val popupMsg = new Label()
		popupMsg.setStyle('''-fx-background-color: black;-fx-text-fill: white;-fx-padding: 5;''')
		popup.getContent().add(popupList)
		setMouseOverTextDelay(Duration.ofMillis(500))
		addEventHandler(MouseOverTextEvent.MOUSE_OVER_TEXT_BEGIN) [
			val charPos = getCharacterIndex()
			val wordStart = getWordStart(charPos)
			val wordEnd = getWordEnd(charPos)
			val word = getText(wordStart, wordEnd)
			popupList.getItems().clear()
			popupList.getItems().setAll(getRhymes(word).sortBy[getScore()].reverse().map[getWord()])
			val pos = getScreenPosition()
			popup.show(Rappad.this, pos.getX(), pos.getY() + 10)
		]
		addEventHandler(MouseEvent.MOUSE_CLICKED) [
			popup.hide()
		]
		setParagraphGraphicFactory [
			if(it == -1) {
				return null
			}
			val syllables = paragraph.getText().syllables()
			return new Label(if(paragraph.getText().isEmpty()) " " else '''«syllables»''') => [
				setBackground(new Background(new BackgroundFill(Color.web("#aaa"), CornerRadii.EMPTY, Insets.EMPTY)))
				setFont(Font.font("monospace", FontPosture.ITALIC, 13))
				setPadding(new Insets(0.5, 0.8, 0.5, 0.8))
			]
		]
	}

	def getWordStart(int charPos) {
		val wordStart = (0 ..< charPos).map[charPos - it].findFirst[wordTerminators.contains(getText(it, it + 1))]
		if(wordStart === null) {
			return 0
		}
		return wordStart + 1
	}

	def getWordEnd(int charPos) {
		val wordStart = (charPos ..< getLength()).findFirst[wordTerminators.contains(getText(it, it + 1))]
		if(wordStart === null) {
			return getLength()
		}
		return wordStart
	}

	def getRhymes(String word) {
		val url = new URL('''http://api.rhymezone.com/words?k=rz_sug_related&max=1000&rel_rry=«word»''')
		new Gson().fromJson(IOUtils.toString(url, Charset.defaultCharset()), new TypeToken<List<Rhyme>>() {
		}.getType()) as List<Rhyme>
	}

	@Accessors static class Rhyme {
		var String word
		var int score
		var int numSyllables
	}

	def static int syllables(String s) {
		val p = Pattern.compile("([ayeiou]+)")
		val String lowerCase = s.toLowerCase()
		val Matcher m = p.matcher(lowerCase)
		var int count = 0
		while(m.find())
			count++
		if(lowerCase.endsWith("e")) count--
		return if(count < 0) 1 else count
	}

}
