package net.exkazuu._2048manipulator

import com.google.common.collect.ImmutableList
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.List
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
			System.err.println("Failed to quit the given driver.");
		}
	}
}

class Manipulator {
	val WebDriver driver
	val JavascriptExecutor jsExecutor
	var int waitTimeForUpdate
	var lastTiles = #[#[0]]
	var lastMovedCount = -1

	new() {
		this(new FirefoxDriver());
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

	def stringifyTiles(List<List<Integer>> tiles) {
		tiles.stringifyTileLines.join(System.lineSeparator)
	}

	def stringifyTileLines(List<List<Integer>> tiles) {
		tiles.map[it.join(' ')]
	}

	def getScore() {
		val es = driver.findElements(By.className("score-container"))
		if (es != null) {
			parseIntIgnoringPlus(es.head.text)
		}
	}

	def getBestScore() {
		val es = driver.findElements(By.className("best-container"))
		if (es != null) {
			parseIntIgnoringPlus(es.head.text)
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
		if (!canMove(direction)) {
			return
		}
		val index = Direction.values.indexOf(direction)
		if (index >= 0) {
			jsExecutor.executeScript("game.move(" + index + ");")
		}
		updateTiles()
	}

	def canMove(Direction direction) {
		val range = (0 .. 3)
		range.exists [ y |
			range.exists [ x |
				val pt = lastTiles.get(y).get(x)
				if (pt == 0) {
					return false;
				}
				val nx = x + direction.dx
				val ny = y + direction.dy
				if (!range.contains(nx) || !range.contains(ny)) {
					return false;
				}
				val nt = lastTiles.get(ny).get(nx)
				if (nt == 0 || nt == pt) {
					return true
				}
				return false
			]
		]
	}

	private static def parseIntIgnoringPlus(String text) {
		val index = text.indexOf('+')
		val textWithoutPlus = if(index >= 0) text.substring(0, index) else text
		Integer.parseInt(textWithoutPlus.trim)
	}

	private def updateTiles() {
		val tiles = jsExecutor.executeScript(
			"return game.grid.cells.map(function(array) { return array.map(function(t) { if (t) return t.value; else return null; } ); });") as List<List<Long>>
		lastTiles = ImmutableList.copyOf(
			(0 .. 3).map [ y |
				ImmutableList.copyOf(
					tiles.map [
						val tile = it.get(y)
						if(tile != null) tile.intValue else 0
					]
				)
			])
		lastMovedCount = lastMovedCount + 1
	}

	static def main(String[] args) {
		val man = new Manipulator()
		val reader = new BufferedReader(new InputStreamReader(System.in))
		while (!man.gameOver) {
			System.out.println("Score: " + man.score + ", Best: " + man.bestScore)
			System.out.println(man.stringifyTiles)
			val cmds = Direction.values.filter([man.canMove(it)]).map[it.toString.toLowerCase]
			System.out.println("Please enter a command [" + (cmds + #["restart"]).join(", ") + "]:")
			System.out.print("> ")
			val line = reader.readLine
			if (line == null) {
				return
			}
			val command = line.trim.toUpperCase
			if (command == "RESTART") {
				man.restart()
			} else {
				try {
					val direction = Direction.valueOf(command)
					man.move(direction)
				} catch (IllegalArgumentException e) {
					System.err.println("Unknown command: " + command)
				}
			}
		}

		System.out.println("Game Over!")
	}
}
