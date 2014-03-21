2048Manipulator  [![Build Status](https://secure.travis-ci.org/exKAZUu/2048Manipulator.png?branch=master)](http://travis-ci.org/exKAZUu/2048Manipulator)
===============

# What Is This
- 2048Manipulator is a Xtend (Java) program that manipulates the 2048 game (http://gabrielecirulli.github.io/2048/).
- 2048Manipulator provides both a class that your Java program can use and a main method that any program can use via Standard I/O.

# How to Use
## Java
Please see [ManipulatorOf2048Test.java](src/test/java/net/exkazuu/manipulator2048/ManipulatorOf2048Test.java).

```
ManipulatorOf2048 man = new ManipulatorOf2048();
man.move(Direction.UP);
int score = man.getScore();
String board = man.stringifyTiles();
System.out.println("Score: " + score);
System.out.println("board");
```

# How to compile
1. ```mvn package```
