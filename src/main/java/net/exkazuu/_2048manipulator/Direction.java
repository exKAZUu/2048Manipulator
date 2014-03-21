package net.exkazuu._2048manipulator;

public enum Direction {
	UP(0, -1), RIGHT(1, 0), DOWN(0, 1), LEFT(-1, 0);

	int dx, dy;

	Direction(int dx, int dy) {
		this.dx = dx;
		this.dy = dy;
	}
}
