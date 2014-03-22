2048Manipulator  [![Build Status](https://secure.travis-ci.org/exKAZUu/2048Manipulator.png?branch=master)](http://travis-ci.org/exKAZUu/2048Manipulator)
===============

# What Is This
- 2048Manipulator is a Xtend (Java) program that manipulates the 2048 game (http://gabrielecirulli.github.io/2048/).
- 2048Manipulator provides both a Java class that your Java program can use and a standalone program that any program can use via Standard I/O.

# How to Use
## Java
Please see [ManipulatorOf2048Test.java](src/test/java/net/exkazuu/manipulator2048/ManipulatorOf2048Test.java).

```
ManipulatorOf2048 man = new ManipulatorOf2048();
man.move(Direction.UP);
int score = man.getScore();
String board = man.stringifyTiles();
System.out.println("Score: " + score);
System.out.println(board);
man.quit();
```

## C++
Please see [main.cpp](sample/main.cpp).
Run the following command: ```java -jar 2048Manipulator.jar -a "a.out"```.

## Ruby
Please see [main.rb](sample/main.rb).
Run the following command: ```java -jar 2048Manipulator.jar -a "ruby main.rb"```.

## Python
Please see [main.py](sample/main.py).
Run the following command: ```java -jar 2048Manipulator.jar -a "python main.py"```.

# How to compile
1. ```mvn package```
