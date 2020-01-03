package com.sirolf2009.music

import javafx.animation.KeyFrame
import javafx.animation.KeyValue
import javafx.animation.Timeline
import javafx.event.EventHandler
import javafx.geometry.Bounds
import javafx.scene.Node
import javafx.scene.input.ScrollEvent
import javafx.util.Duration

class AnimatedZoomOperator {

	static val DEFAULT_ZOOM_FACTOR = 1.5
	val Timeline timeline

	new() {
		this.timeline = new Timeline(60)
	}

	def EventHandler<ScrollEvent> zoom(Node node) {
		return zoom(node, DEFAULT_ZOOM_FACTOR)
	}

	def EventHandler<ScrollEvent> zoomX(Node node) {
		return zoomX(node, DEFAULT_ZOOM_FACTOR)
	}

	def EventHandler<ScrollEvent> zoomY(Node node) {
		return zoomY(node, DEFAULT_ZOOM_FACTOR)
	}

	def EventHandler<ScrollEvent> zoom(Node node, double zoomFactor) {
		new EventHandler<ScrollEvent>() {
			override handle(ScrollEvent evt) {
				zoom(node, evt, zoomFactor)
			}
		}
	}

	def EventHandler<ScrollEvent> zoomX(Node node, double zoomFactor) {
		new EventHandler<ScrollEvent>() {
			override handle(ScrollEvent evt) {
				zoomX(node, evt, zoomFactor)
			}
		}
	}

	def EventHandler<ScrollEvent> zoomY(Node node, double zoomFactor) {
		new EventHandler<ScrollEvent>() {
			override handle(ScrollEvent evt) {
				zoomY(node, evt, zoomFactor)
			}
		}
	}

	def void zoom(Node node, ScrollEvent evt) {
		zoom(node, evt, DEFAULT_ZOOM_FACTOR)
	}

	def void zoomX(Node node, ScrollEvent evt) {
		zoomX(node, evt, DEFAULT_ZOOM_FACTOR)
	}

	def void zoomY(Node node, ScrollEvent evt) {
		zoomY(node, evt, DEFAULT_ZOOM_FACTOR)
	}

	def void zoom(Node node, ScrollEvent evt, double zoomFactor) {
		if(evt.getDeltaY() <= 0) { // zoom out
			zoom(node, 1 / zoomFactor, evt.getSceneX(), evt.getSceneY())
		} else {
			zoom(node, zoomFactor, evt.getSceneX(), evt.getSceneY())
		}
	}

	def void zoomX(Node node, ScrollEvent evt, double zoomFactor) {
		if(evt.getDeltaY() <= 0) { // zoom out
			zoomX(node, 1 / zoomFactor, evt.getSceneX())
		} else {
			zoomX(node, zoomFactor, evt.getSceneX())
		}
	}

	def void zoomY(Node node, ScrollEvent evt, double zoomFactor) {
		if(evt.getDeltaY() <= 0) { // zoom out
			zoomY(node, 1 / zoomFactor, evt.getSceneY())
		} else {
			zoomY(node, zoomFactor, evt.getSceneY())
		}
	}

	def void zoom(Node node, double factor, double x, double y) {
		zoomX(node, factor, x)
		zoomY(node, factor, y)
	}

	def void zoomX(Node node, double factor, double x) {
		// determine scale
		val double oldScale = node.getScaleX()
		val double scale = oldScale * factor
		val double f = (scale / oldScale) - 1
		// determine offset that we will have to move the node
		val Bounds bounds = node.localToScene(node.getBoundsInLocal())
		val double dx = (x - (bounds.getWidth() / 2 + bounds.getMinX()))
		// timeline that scales and moves the node
		timeline.getKeyFrames().clear()
		timeline.getKeyFrames().addAll(new KeyFrame(Duration.millis(200), new KeyValue(node.translateXProperty(), node.getTranslateX() - f * dx)), //
		new KeyFrame(Duration.millis(200), new KeyValue(node.scaleXProperty(), scale)))
		timeline.play()
	}

	def void zoomY(Node node, double factor, double y) {
		// determine scale
		val double oldScale = node.getScaleY()
		val double scale = oldScale * factor
		val double f = (scale / oldScale) - 1
		// determine offset that we will have to move the node
		val Bounds bounds = node.localToScene(node.getBoundsInLocal())
		val double dy = (y - (bounds.getHeight() / 2 + bounds.getMinY()))
		// timeline that scales and moves the node
		timeline.getKeyFrames().clear()
		timeline.getKeyFrames().addAll(new KeyFrame(Duration.millis(200), new KeyValue(node.translateYProperty(), node.getTranslateY() - f * dy)), //
		new KeyFrame(Duration.millis(200), new KeyValue(node.scaleYProperty(), scale)))
		timeline.play()
	}

	def void resetZoom(Node node) {
		timeline.getKeyFrames().clear()

		timeline.getKeyFrames().addAll(new KeyFrame(Duration.millis(200), new KeyValue(node.translateXProperty(), 0)), //
		new KeyFrame(Duration.millis(200), new KeyValue(node.translateYProperty(), 0)), //
		new KeyFrame(Duration.millis(200), new KeyValue(node.scaleXProperty(), 1)), //
		new KeyFrame(Duration.millis(200), new KeyValue(node.scaleYProperty(), 1)))
		timeline.play()
	}
}
