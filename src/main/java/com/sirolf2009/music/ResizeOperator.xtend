package com.sirolf2009.music

import javafx.beans.property.DoubleProperty
import javafx.geometry.Point2D
import javafx.scene.Cursor
import javafx.scene.Node
import javafx.scene.input.MouseEvent
import javafx.scene.layout.Pane
import javafx.scene.layout.Region
import javafx.scene.paint.Color
import javafx.scene.shape.Rectangle
import org.eclipse.xtend.lib.annotations.Accessors

class ResizeOperator {

	def static void makeResizable(Region region) {
		makeResizable(region, EAST)
	}

	def static void makeResizable(Region region, DragNodeSupplier... nodeSuppliers) {
		val mouseLocation = new Wrapper<Point2D>()
		val dragNodes = nodeSuppliers.map[apply(region, mouseLocation)].toList()
		region.parentProperty().addListener [ obs, oldVal, newVal |
			dragNodes.forEach [
				val currentParent = oldVal as Pane
				if(currentParent !== null) {
					currentParent.getChildren().remove(it)
				}
				if(newVal !== null) {
					(newVal as Pane).getChildren().add(it)
				}
			]
		]
	}

	def static void dragNorth(MouseEvent event, Wrapper<Point2D> mouseLocation, Region region, double handleRadius) {
		val deltaY = event.getSceneY() - mouseLocation.value.getY()
		val newY = region.getLayoutY() + deltaY
		if(newY != 0 && newY >= handleRadius && newY <= region.getLayoutY() + region.getHeight() - handleRadius) {
			region.setLayoutY(newY)
			region.setPrefHeight(region.getPrefHeight() - deltaY)
		}
	}

	def static void dragEast(MouseEvent event, Wrapper<Point2D> mouseLocation, Region region, double handleRadius) {
		val deltaX = event.getSceneX() - mouseLocation.value.getX()
		val newMaxX = region.getLayoutX() + region.getWidth() + deltaX
		if(newMaxX >= region.getLayoutX() && newMaxX <= region.getParent().getBoundsInLocal().getWidth() - handleRadius) {
			region.setPrefWidth(region.getPrefWidth() + deltaX)
		}
	}

	def static void dragSouth(MouseEvent event, Wrapper<Point2D> mouseLocation, Region region, double handleRadius) {
		val deltaY = event.getSceneY() - mouseLocation.value.getY()
		val newMaxY = region.getLayoutY() + region.getHeight() + deltaY
		if(newMaxY >= region.getLayoutY() && newMaxY <= region.getParent().getBoundsInLocal().getHeight() - handleRadius) {
			region.setPrefHeight(region.getPrefHeight() + deltaY)
		}
	}

	def static void dragWest(MouseEvent event, Wrapper<Point2D> mouseLocation, Region region, double handleRadius) {
		val deltaX = event.getSceneX() - mouseLocation.value.getX()
		val newX = region.getLayoutX() + deltaX
		if(newX != 0 && newX <= region.getParent().getBoundsInLocal().getWidth() - handleRadius) {
			region.setLayoutX(newX)
			region.setPrefWidth(region.getPrefWidth() - deltaX)
		}
	}

	def static void setUpDragging(Node node, Wrapper<Point2D> mouseLocation, Cursor hoverCursor) {
		node.setOnMouseEntered [
			node.getParent().setCursor(hoverCursor)
		]
		node.setOnMouseExited [
			node.getParent().setCursor(Cursor.DEFAULT)
		]
		node.setOnDragDetected [
			node.getParent().setCursor(Cursor.CLOSED_HAND)
			mouseLocation.value = new Point2D(getSceneX(), getSceneY())
		]

		node.setOnMouseReleased [
			node.getParent().setCursor(Cursor.DEFAULT)
			mouseLocation.value = null
		]
	}

	@Accessors static class Wrapper<T> {
		T value
	}

	static interface DragNodeSupplier {

		def Node apply(Region region, Wrapper<Point2D> mouseLocation)

	}

	static val handleRadius = 6d

	public static val NORTH_WEST = new DragNodeSupplier() {
		override Node apply(Region region, Wrapper<Point2D> mouseLocation) {
			val DoubleProperty xProperty = region.layoutXProperty()
			val DoubleProperty yProperty = region.layoutYProperty()
			val Rectangle resizeHandleNW = new Rectangle(handleRadius, handleRadius, Color.BLACK)
			resizeHandleNW.xProperty().bind(xProperty.subtract(handleRadius / 2))
			resizeHandleNW.yProperty().bind(yProperty.subtract(handleRadius / 2))
			setUpDragging(resizeHandleNW, mouseLocation, Cursor.NW_RESIZE)
			resizeHandleNW.setOnMouseDragged [
				if(mouseLocation.value !== null) {
					dragNorth(it, mouseLocation, region, handleRadius)
					dragWest(it, mouseLocation, region, handleRadius)
					mouseLocation.value = new Point2D(getSceneX(), getSceneY())
				}
			]
			return resizeHandleNW
		}
	}

	public static val EAST = new DragNodeSupplier() {
		override Node apply(Region region, Wrapper<Point2D> mouseLocation) {
			val xProperty = region.layoutXProperty()
			val yProperty = region.layoutYProperty()
			val widthProperty = region.prefWidthProperty()
			val heightProperty = region.prefHeightProperty()
			val halfHeightProperty = heightProperty.divide(2)

			val resizeHandleE = new Rectangle(handleRadius, handleRadius, Color.BLACK)
			resizeHandleE.xProperty().bind(xProperty.add(widthProperty).subtract(handleRadius / 2))
			resizeHandleE.yProperty().bind(yProperty.add(halfHeightProperty).subtract(handleRadius / 2))

			setUpDragging(resizeHandleE, mouseLocation, Cursor.E_RESIZE)

			resizeHandleE.setOnMouseDragged [
				if(mouseLocation.value !== null) {
					dragEast(it, mouseLocation, region, handleRadius)
					mouseLocation.value = new Point2D(getSceneX(), getSceneY())
				}
				consume()
			]
			return resizeHandleE
		}
	}

}
