package net.exkazuu.manipulator2048

import java.io.BufferedReader
import java.io.InputStreamReader
import net.exkazuu.gameaiarena.player.ExternalComputerPlayer
import org.apache.commons.cli.BasicParser
import org.apache.commons.cli.CommandLine
import org.apache.commons.cli.HelpFormatter
import org.apache.commons.cli.Options
import org.apache.commons.cli.ParseException

class Main {
	static val WORK_DIR = "w"
	static val AI_PROGRAM = "a"
	static val SIMPLE = "s"
	static val LOG = "l"
	static val HELP = "h"

	static def printHelp(Options options) {
		val help = new HelpFormatter()
		help.printHelp("java -jar 2048Manipularot.jar [OPTIONS]\n" + "[OPTIONS]: ", "", options, "", true)
	}

	static def buildOptions() {
		return new Options().addOption(WORK_DIR, true, "Set working directory for an external program.").
			addOption(AI_PROGRAM, true, "Set a path of an external AI program.").addOption(HELP, false,
				"Print this help.").addOption(SIMPLE, false, "Enable simple output mode.").addOption(LOG, false,
				"Enable logging mode.")
	}

	static def main(String[] args) {
		val options = buildOptions()
		try {
			val parser = new BasicParser()
			val cl = parser.parse(options, args)
			if (cl.hasOption(HELP)) {
				printHelp(options)
			} else {
				startGame(cl)
			}
		} catch (ParseException e) {
			System.err.println("Error: " + e.getMessage())
			printHelp(options)
			System.exit(-1)
		}
	}

	static def startGame(CommandLine cl) {
		val man = new ManipulatorOf2048()
		val reader = new BufferedReader(new InputStreamReader(System.in))
		val simpleMode = cl.hasOption(SIMPLE) || cl.hasOption(AI_PROGRAM)
		var writeLine = [String s|System.out.println(s)]
		var readLine = [|reader.readLine]
		if (cl.hasOption(AI_PROGRAM)) {
			val aiPath = cl.getOptionValue(AI_PROGRAM)
			val workDir = cl.getOptionValue(WORK_DIR)
			val program = new ExternalComputerPlayer(aiPath.split(' '), workDir)
			writeLine = [program.writeLine(it)]
			readLine = [|program.readLine]
			if (cl.hasOption(LOG)) {
				program.addOuputLogStream(System.out)
				program.addErrorLogStream(System.err)
			}
		}
		while (!man.isGameOver) {
			if (simpleMode) {
				writeLine.apply("1")
				writeLine.apply(man.getScore + " " + man.getBestScore)
				writeLine.apply(man.stringifyTiles)
			} else {
				System.out.println("Score: " + man.getScore + ", Best: " + man.getBestScore)
				System.out.println(man.stringifyTiles)
				val cmds = Direction.values.filter([man.canMove(it)]).map[it.toString.toLowerCase]
				System.out.println("Please enter a command [" + (cmds + #["restart"]).join(", ") + "]:")
				System.out.print("> ")
			}
			val line = readLine.apply()
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
		if (simpleMode) {
			writeLine.apply("0")
			writeLine.apply(man.getScore + " " + man.getBestScore)
		} else {
			writeLine.apply("Game Over!")
			writeLine.apply("Score: " + man.getScore + ", Best: " + man.getBestScore)
		}
		writeLine.apply(man.stringifyTiles)
		if (!simpleMode) {
			writeLine.apply("Please enter any key.")
		}
		readLine.apply()
		man.quit()
	}
}
