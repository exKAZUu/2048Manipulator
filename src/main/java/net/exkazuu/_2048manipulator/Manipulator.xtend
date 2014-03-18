package net.exkazuu._2048manipulator

import com.google.common.collect.ImmutableList
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.List
import org.openqa.selenium.By
import org.openqa.selenium.Keys
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

import static net.exkazuu._2048manipulator.Direction.*

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

class WebDriveQuitThread extends Thread {
	val WebDriver driver

	new(WebDriver driver) {
		this.driver = driver
	}

	override run() {
		driver.quit
	}
}

class Manipulator {
	val WebDriver driver
	var int maxSleepTime
	var lastTiles = #[#[0]]
	var lastTilesString = #[""]

	new() {
		this(new FirefoxDriver());
	}

	new(WebDriver driver) {
		this(driver, 1000)
	}

	new(WebDriver driver, int maxSleepTime) {
		this.driver = driver
		this.maxSleepTime = maxSleepTime
		Runtime.getRuntime().addShutdownHook(new WebDriveQuitThread(driver))
		restart()
	}

	def getTiles() {
		lastTiles
	}

	def getTilesString() {
		lastTilesString
	}

	def parseIntIgnoringPlus(String text) {
		val index = text.indexOf('+')
		val textWithoutPlus = if (index >= 0) text.substring(0, index) else text
		Integer.parseInt(textWithoutPlus.trim)
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
		driver.get("http://gabrielecirulli.github.io/2048/")
		updateTiles()
	}

	def isGameOver() {
		!driver.findElements(By.className("game-over")).empty
	}

	def move(Direction direction) {
		val e = driver.findElement(By.tagName("html"))
		switch (direction) {
			case UP:
				e.sendKeys(Keys.UP)
			case DOWN:
				e.sendKeys(Keys.DOWN)
			case LEFT:
				e.sendKeys(Keys.LEFT)
			case RIGHT:
				e.sendKeys(Keys.RIGHT)
		}
		updateTiles()
	}

	private def List<List<Integer>> getCurrentTiles() {
		ImmutableList.copyOf(
			(1 .. 4).map [ y |
				ImmutableList.copyOf(
					(1 .. 4).map [ x |
						val es = driver.findElements(By.className("tile-position-" + x + "-" + y))
						if (es.empty) 0 else Integer.parseInt(es.last.text)
					])
			])
	}

	private def updateTiles() {
		val time = System.currentTimeMillis
		while (System.currentTimeMillis - time < maxSleepTime) {
			Thread.sleep(10);
			val tiles = currentTiles
			val tilesString = tiles.map[it.join(" ")]
			if (lastTilesString.join != tilesString.join) {
				lastTiles = tiles
				lastTilesString = ImmutableList.copyOf(tilesString)
				return true
			}
		}
		false
	}

	static def main(String[] args) {
		val man = new Manipulator()
		val reader = new BufferedReader(new InputStreamReader(System.in))
		while (!man.gameOver) {
			System.out.println("Score: " + man.score + ", Best: " + man.bestScore)
			man.tilesString.forEach[System.out.println(it)]
			System.out.print("Please enter a command [up, down, left, right, restart]:")
			val line = reader.readLine
			if (line == null) {
				return
			}
			val command = line.trim.toUpperCase
			try {
				val direction = Direction.valueOf(command)
				if (man.move(direction)) {
					System.out.println("Moved " + direction.toString.toLowerCase)
				} else {
					System.out.println("Failed to move " + direction.toString.toLowerCase)
				}
			} catch (IllegalArgumentException e) {
				if (command == "RESTART") {
					man.restart()
				}
			}
		}

		System.out.println("Game Over!")
	}
}
