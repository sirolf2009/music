package com.sirolf2009.music.component

import com.google.common.util.concurrent.AtomicDouble
import com.sirolf2009.music.AnimatedZoomOperator
import com.sirolf2009.music.DurationComboBox
import com.sirolf2009.music.ResizeOperator
import com.sirolf2009.music.ResizeOperator.DragNodeSupplier
import com.sirolf2009.music.ResizeOperator.Wrapper
import com.sirolf2009.music.StickyAnchorPane
import java.util.ArrayList
import javafx.beans.property.BooleanProperty
import javafx.beans.property.DoubleProperty
import javafx.beans.property.SimpleBooleanProperty
import javafx.beans.property.SimpleDoubleProperty
import javafx.collections.FXCollections
import javafx.geometry.Insets
import javafx.geometry.Point2D
import javafx.scene.Cursor
import javafx.scene.Node
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.control.ScrollPane
import javafx.scene.control.TextField
import javafx.scene.control.ToggleButton
import javafx.scene.control.ToolBar
import javafx.scene.input.MouseEvent
import javafx.scene.layout.Background
import javafx.scene.layout.BackgroundFill
import javafx.scene.layout.CornerRadii
import javafx.scene.layout.Pane
import javafx.scene.layout.Priority
import javafx.scene.layout.Region
import javafx.scene.layout.VBox
import javafx.scene.paint.Color
import javafx.scene.shape.Rectangle
import jm.constants.Pitches
import jm.music.data.Note
import jm.music.data.Part
import jm.music.data.Phrase
import jm.music.data.Score
import jm.util.Play
import jm.util.View
import org.eclipse.xtend.lib.annotations.Accessors

class PianoRollView extends VBox {

	static val noteHeight = 16
	static val noteWidth = 16

	val shouldSnap = new SimpleBooleanProperty()
	val durationProperty = new SimpleDoubleProperty()
	val Part part

	new() {
		this(new Part())
	}

	new(Part part) {
		this.part = part

		val even = Color.gray(0.9)
		val odd = Color.gray(0.8)

		val tracks = new ArrayList((Pitches.C4 ..< Pitches.C5).toList().reverse().map [
			new PitchTrack(it, if(it % 2 == 0) even else odd, shouldSnap, durationProperty)
		].toList())
		val trackContainer = new VBox(tracks) => [
			this.getChildren().add(it)
			VBox.setVgrow(it, Priority.ALWAYS)
		]
		val zoomOperator = new AnimatedZoomOperator()

		setOnScroll(zoomOperator.zoomX(trackContainer))

		getChildren().add(new ToolBar(new TextField(part.getTitle()) => [
			textProperty().addListener [ obs, oldVal, newVal |
				part.setTitle(newVal)
			]
		], new ToggleButton("Snap to grid") => [
			shouldSnap.bind(selectedProperty())
			setSelected(true)
		], new DurationComboBox() => [
			this.durationProperty.bind(it.durationProperty())
		], new Button("Play") => [
			setOnAction [
				part.removeAllPhrases()
				tracks.map[
					getPhrase()
				].forEach[part.add(it)]
				Play.midi(new Score(part), false, false, 10, 0)
				View.pianoRoll(part)
			]
		], new Button("Reset Zoom") => [
			setOnAction [
				zoomOperator.resetZoom(trackContainer)
			]
		]))
	}

	@Accessors static class PitchTrack extends Pane {

		val int pitch
		val Rectangle ghost
		val BooleanProperty shouldSnap
		val DoubleProperty durationProperty
		val notes = FXCollections.<TrackNode>observableArrayList()

		new(int pitch, Color background, BooleanProperty shouldSnap, DoubleProperty durationProperty) {
			this.pitch = pitch
			this.shouldSnap = shouldSnap
			this.durationProperty = durationProperty
			setBackground(new Background(new BackgroundFill(background, CornerRadii.EMPTY, Insets.EMPTY)))
			setHeight(noteHeight)
			setMinHeight(noteHeight)
			setMaxHeight(noteHeight)
			setWidth(500)
			setPrefWidth(500)

			ghost = new Rectangle(0, 0, noteWidth, noteHeight) => [
				setFill(Color.gray(0.5, 0.5))
				setMouseTransparent(true)
			]
			durationProperty.addListener [ obs, oldVal, newVal |
				ghost.setWidth(newVal.doubleValue() * noteWidth)
			]
			setOnMouseEntered [ evt |
				updateGhostPos(evt)
				getChildren().add(ghost)
			]
			setOnMouseMoved [ evt |
				updateGhostPos(evt)
			]
			setOnMouseExited [ evt |
				getChildren().remove(ghost)
			]
			setOnMouseClicked [
				if(isStillSincePress()) {
					getChildren().add(new TrackNode(ghost) => [
						notes.add(it)
						setOnMouseClicked [ evt |
							PitchTrack.this.getChildren().remove(it)
							notes.remove(it)
							evt.consume()
						]
					])
					consume()
				}
			]

			getChildren().add(new Label(new Note(pitch, 1d).getNote()))
		}

		def getPhrase() {
			val phrase = new Phrase(new Note(pitch, 1d).getNote(), 0d)
			notes.sortBy[getLayoutX()]
			val previousEnd = new AtomicDouble(0)
			notes.forEach [
				val currentStart = getLayoutX() / noteWidth
				val duration = getWidth() / noteWidth
				phrase.add(new Note(Pitches.REST, currentStart - previousEnd.get()))
				phrase.add(new Note(pitch, duration))
				previousEnd.set(currentStart + duration)
			]
			return phrase
		}

		def updateGhostPos(MouseEvent evt) {
			ghost.setX(if(shouldSnap.get()) {
				evt.getX().snapToGrid()
			} else {
				evt.getX()
			})
		}

	}
	
	def static snapToGrid(double xPos) {
		(Math.floorDiv(xPos.intValue(), noteWidth)) * noteWidth
	}

	static class TrackNode extends StickyAnchorPane {

		new(Rectangle ghost) {
			setLayoutX(ghost.getX())
			setLayoutY(ghost.getY())
			getChildren().add(new Rectangle(0, 0, ghost.getWidth(), ghost.getHeight()) => [
				setOnMouseEntered [ evt |
					setFill(Color.GRAY)
				]
				setOnMouseExited [ evt |
					setFill(Color.BLACK)
				]
				this.prefWidthProperty().bindBidirectional(widthProperty())
				this.prefHeightProperty().bindBidirectional(heightProperty())
			])
			ResizeOperator.makeResizable(this, EAST, WEST)
		}

	}
	
	public static val EAST = new DragNodeSupplier() {
		override Node apply(Region region, Wrapper<Point2D> mouseLocation) {
			val xProperty = region.layoutXProperty()
			val yProperty = region.layoutYProperty()
			val widthProperty = region.prefWidthProperty()

			val resizeHandleE = new Rectangle(2, region.getHeight(), Color.BLACK)
			resizeHandleE.heightProperty().bind(region.heightProperty())
			resizeHandleE.xProperty().bind(xProperty.add(widthProperty).subtract(2))
			resizeHandleE.yProperty().bind(yProperty)

			ResizeOperator.setUpDragging(resizeHandleE, mouseLocation, Cursor.W_RESIZE)

			resizeHandleE.setOnMouseDragged [
				if(mouseLocation.value !== null) {
					ResizeOperator.dragEast(it, mouseLocation, region, 2)
					mouseLocation.value = new Point2D(getSceneX(), getSceneY())
				}
				consume()
			]
			return resizeHandleE
		}
	}
	
	public static val WEST = new DragNodeSupplier() {
		override Node apply(Region region, Wrapper<Point2D> mouseLocation) {
			val xProperty = region.layoutXProperty()
			val yProperty = region.layoutYProperty()

			val resizeHandleW = new Rectangle(2, region.getHeight(), Color.BLACK)
			resizeHandleW.heightProperty().bind(region.heightProperty())
			resizeHandleW.xProperty().bind(xProperty)
			resizeHandleW.yProperty().bind(yProperty)

			ResizeOperator.setUpDragging(resizeHandleW, mouseLocation, Cursor.E_RESIZE)

			resizeHandleW.setOnMouseDragged [
				if(mouseLocation.value !== null) {
					ResizeOperator.dragWest(it, mouseLocation, region, 2)
					mouseLocation.value = new Point2D(getSceneX(), getSceneY())
				}
				consume()
			]
			return resizeHandleW
		}
	}

}
