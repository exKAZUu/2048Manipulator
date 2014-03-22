package net.exkazuu.manipulator2048

import com.google.common.base.Preconditions
import com.google.common.collect.ImmutableMap
import java.util.List
import java.util.Map
import net.exkazuu.gameaiarena.api.Point2
import org.openqa.selenium.By
import org.openqa.selenium.JavascriptExecutor
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

class WebDriveQuitThread extends Thread {
	val WebDriver driver

	new(WebDriver driver) {
		this.driver = driver
	}

	override run() {
		try {
			driver.quit
		} catch (Exception e) {
		}
	}
}

class ManipulatorOf2048 {
	val WebDriver driver
	val JavascriptExecutor jsExecutor
	var int waitTimeForUpdate
	var Map<Point2, Integer> lastTiles = emptyMap
	var lastMovedCount = -1

	new() {
		this(new FirefoxDriver())
	}

	new(WebDriver driver) {
		this(driver, 1000)
	}

	new(WebDriver driver, int waitTimeForUpdate) {
		this.driver = driver
		this.jsExecutor = driver as JavascriptExecutor
		if (jsExecutor == null) {
			throw new IllegalArgumentException("The given WebDriver instance does not support JavascriptExecutor.")
		}
		this.waitTimeForUpdate = waitTimeForUpdate
		Runtime.runtime.addShutdownHook(new WebDriveQuitThread(driver))
		driver.get("http://gabrielecirulli.github.io/2048/")
		restart()
	}

	def getMovedCount() {
		lastMovedCount
	}

	def getTiles() {
		lastTiles
	}

	def stringifyTiles() {
		lastTiles.stringifyTiles
	}

	def stringifyTileLines() {
		lastTiles.stringifyTileLines
	}

	def stringifyTiles(Map<Point2, Integer> tiles) {
		tiles.stringifyTileLines.join(System.lineSeparator)
	}

	def stringifyTileLines(Map<Point2, Integer> tiles) {
		val range = (0 .. 3)
		range.map[y|range.map[x|tiles.get(new Point2(x, y))].join(' ')]
	}

	def getScore() {
		val score = jsExecutor.executeScript("return game.score;") as Long
		if (score != null) {
			score.intValue
		}
	}

	def getBestScore() {
		val bestScore = jsExecutor.executeScript("return game.scoreManager.storage.bestScore;") as String
		if (bestScore != null) {
			Integer.parseInt(bestScore.trim)
		}
	}

	def restart() {
		jsExecutor.executeScript("game = new GameManager(4, KeyboardInputManager, HTMLActuator, LocalScoreManager);")
		updateTiles()
	}

	def isGameOver() {
		!driver.findElements(By.className("game-over")).empty
	}

	def move(Direction direction) {
		Preconditions.checkNotNull(direction)

		if (!canMove(direction)) {
			return false
		}
		val index = Direction.values.indexOf(direction)
		jsExecutor.executeScript("game.move(" + index + ");")
		updateTiles()
		true
	}

	def canMove(Direction direction) {
		Preconditions.checkNotNull(direction)

		Point2.getPoints(4, 4).exists [ p |
			val oldTile = lastTiles.get(p)
			if (oldTile == 0) {
				return false
			}
			val newX = p.x + direction.dx
			val newY = p.y + direction.dy
			val newTile = lastTiles.get(new Point2(newX, newY))
			newTile != null && (newTile == 0 || newTile == oldTile)
		]
	}

	private def updateTiles() {
		val tiles = jsExecutor.executeScript(
			"return game.grid.cells.map(function(array) { return array.map(function(t) { if (t) return t.value; else return null; } ); });") as List<List<Long>>
		lastTiles = ImmutableMap.copyOf(
			Point2.getPoints(4, 4).toInvertedMap [
				val tile = tiles.get(it.x).get(it.y)
				if (tile != null) tile.intValue else 0
			])
		lastMovedCount = lastMovedCount + 1
	}
}
