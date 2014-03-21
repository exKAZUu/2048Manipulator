package net.exkazuu.manipulator2048;

import com.google.common.base.Objects;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Collections;
import java.util.List;
import net.exkazuu.manipulator2048.Direction;
import net.exkazuu.manipulator2048.WebDriveQuitThread;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IntegerRange;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;

@SuppressWarnings("all")
public class Manipulator {
  private final WebDriver driver;
  
  private final JavascriptExecutor jsExecutor;
  
  private int waitTimeForUpdate;
  
  private List<List<Integer>> lastTiles = Collections.<List<Integer>>unmodifiableList(Lists.<List<Integer>>newArrayList(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(0))));
  
  private int lastMovedCount = (-1);
  
  public Manipulator() {
    this(new FirefoxDriver());
  }
  
  public Manipulator(final WebDriver driver) {
    this(driver, 1000);
  }
  
  public Manipulator(final WebDriver driver, final int waitTimeForUpdate) {
    this.driver = driver;
    this.jsExecutor = ((JavascriptExecutor) driver);
    boolean _equals = Objects.equal(this.jsExecutor, null);
    if (_equals) {
      throw new IllegalArgumentException("The given WebDriver instance does not support JavascriptExecutor.");
    }
    this.waitTimeForUpdate = waitTimeForUpdate;
    Runtime _runtime = Runtime.getRuntime();
    WebDriveQuitThread _webDriveQuitThread = new WebDriveQuitThread(driver);
    _runtime.addShutdownHook(_webDriveQuitThread);
    driver.get("http://gabrielecirulli.github.io/2048/");
    this.restart();
  }
  
  public int getMovedCount() {
    return this.lastMovedCount;
  }
  
  public List<List<Integer>> getTiles() {
    return this.lastTiles;
  }
  
  public String stringifyTiles() {
    return this.stringifyTiles(this.lastTiles);
  }
  
  public List<String> stringifyTileLines() {
    return this.stringifyTileLines(this.lastTiles);
  }
  
  public String stringifyTiles(final List<List<Integer>> tiles) {
    List<String> _stringifyTileLines = this.stringifyTileLines(tiles);
    String _lineSeparator = System.lineSeparator();
    return IterableExtensions.join(_stringifyTileLines, _lineSeparator);
  }
  
  public List<String> stringifyTileLines(final List<List<Integer>> tiles) {
    final Function1<List<Integer>,String> _function = new Function1<List<Integer>,String>() {
      public String apply(final List<Integer> it) {
        return IterableExtensions.join(it, " ");
      }
    };
    return ListExtensions.<List<Integer>, String>map(tiles, _function);
  }
  
  public int getScore() {
    int _xblockexpression = (int) 0;
    {
      By _className = By.className("score-container");
      final List<WebElement> es = this.driver.findElements(_className);
      int _xifexpression = (int) 0;
      boolean _notEquals = (!Objects.equal(es, null));
      if (_notEquals) {
        WebElement _head = IterableExtensions.<WebElement>head(es);
        String _text = _head.getText();
        _xifexpression = Manipulator.parseIntIgnoringPlus(_text);
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }
  
  public int getBestScore() {
    int _xblockexpression = (int) 0;
    {
      By _className = By.className("best-container");
      final List<WebElement> es = this.driver.findElements(_className);
      int _xifexpression = (int) 0;
      boolean _notEquals = (!Objects.equal(es, null));
      if (_notEquals) {
        WebElement _head = IterableExtensions.<WebElement>head(es);
        String _text = _head.getText();
        _xifexpression = Manipulator.parseIntIgnoringPlus(_text);
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }
  
  public int restart() {
    int _xblockexpression = (int) 0;
    {
      this.jsExecutor.executeScript("game = new GameManager(4, KeyboardInputManager, HTMLActuator, LocalScoreManager);");
      _xblockexpression = this.updateTiles();
    }
    return _xblockexpression;
  }
  
  public boolean isGameOver() {
    By _className = By.className("game-over");
    List<WebElement> _findElements = this.driver.findElements(_className);
    boolean _isEmpty = _findElements.isEmpty();
    return (!_isEmpty);
  }
  
  public void move(final Direction direction) {
    boolean _canMove = this.canMove(direction);
    boolean _not = (!_canMove);
    if (_not) {
      return;
    }
    Direction[] _values = Direction.values();
    final int index = ((List<Direction>)Conversions.doWrapArray(_values)).indexOf(direction);
    if ((index >= 0)) {
      this.jsExecutor.executeScript((("game.move(" + Integer.valueOf(index)) + ");"));
    }
    this.updateTiles();
  }
  
  public boolean canMove(final Direction direction) {
    boolean _xblockexpression = false;
    {
      final IntegerRange range = new IntegerRange(0, 3);
      final Function1<Integer,Boolean> _function = new Function1<Integer,Boolean>() {
        public Boolean apply(final Integer y) {
          final Function1<Integer,Boolean> _function = new Function1<Integer,Boolean>() {
            public Boolean apply(final Integer x) {
              List<Integer> _get = Manipulator.this.lastTiles.get((y).intValue());
              final Integer pt = _get.get((x).intValue());
              if (((pt).intValue() == 0)) {
                return Boolean.valueOf(false);
              }
              final int nx = ((x).intValue() + direction.dx);
              final int ny = ((y).intValue() + direction.dy);
              boolean _or = false;
              boolean _contains = range.contains(nx);
              boolean _not = (!_contains);
              if (_not) {
                _or = true;
              } else {
                boolean _contains_1 = range.contains(ny);
                boolean _not_1 = (!_contains_1);
                _or = _not_1;
              }
              if (_or) {
                return Boolean.valueOf(false);
              }
              List<Integer> _get_1 = Manipulator.this.lastTiles.get(ny);
              final Integer nt = _get_1.get(nx);
              boolean _or_1 = false;
              if (((nt).intValue() == 0)) {
                _or_1 = true;
              } else {
                boolean _equals = Objects.equal(nt, pt);
                _or_1 = _equals;
              }
              if (_or_1) {
                return Boolean.valueOf(true);
              }
              return Boolean.valueOf(false);
            }
          };
          return Boolean.valueOf(IterableExtensions.<Integer>exists(range, _function));
        }
      };
      _xblockexpression = IterableExtensions.<Integer>exists(range, _function);
    }
    return _xblockexpression;
  }
  
  private static int parseIntIgnoringPlus(final String text) {
    int _xblockexpression = (int) 0;
    {
      final int index = text.indexOf("+");
      String _xifexpression = null;
      if ((index >= 0)) {
        _xifexpression = text.substring(0, index);
      } else {
        _xifexpression = text;
      }
      final String textWithoutPlus = _xifexpression;
      String _trim = textWithoutPlus.trim();
      _xblockexpression = Integer.parseInt(_trim);
    }
    return _xblockexpression;
  }
  
  private int updateTiles() {
    int _xblockexpression = (int) 0;
    {
      Object _executeScript = this.jsExecutor.executeScript(
        "return game.grid.cells.map(function(array) { return array.map(function(t) { if (t) return t.value; else return null; } ); });");
      final List<List<Long>> tiles = ((List<List<Long>>) _executeScript);
      IntegerRange _upTo = new IntegerRange(0, 3);
      final Function1<Integer,ImmutableList<Integer>> _function = new Function1<Integer,ImmutableList<Integer>>() {
        public ImmutableList<Integer> apply(final Integer y) {
          final Function1<List<Long>,Integer> _function = new Function1<List<Long>,Integer>() {
            public Integer apply(final List<Long> it) {
              int _xblockexpression = (int) 0;
              {
                final Long tile = it.get((y).intValue());
                int _xifexpression = (int) 0;
                boolean _notEquals = (!Objects.equal(tile, null));
                if (_notEquals) {
                  _xifexpression = tile.intValue();
                } else {
                  _xifexpression = 0;
                }
                _xblockexpression = _xifexpression;
              }
              return Integer.valueOf(_xblockexpression);
            }
          };
          List<Integer> _map = ListExtensions.<List<Long>, Integer>map(tiles, _function);
          return ImmutableList.<Integer>copyOf(_map);
        }
      };
      Iterable<List<Integer>> _map = IterableExtensions.<Integer, List<Integer>>map(_upTo, _function);
      ImmutableList<List<Integer>> _copyOf = ImmutableList.<List<Integer>>copyOf(_map);
      this.lastTiles = _copyOf;
      _xblockexpression = this.lastMovedCount = (this.lastMovedCount + 1);
    }
    return _xblockexpression;
  }
  
  public static void main(final String[] args) {
    try {
      final Manipulator man = new Manipulator();
      InputStreamReader _inputStreamReader = new InputStreamReader(System.in);
      final BufferedReader reader = new BufferedReader(_inputStreamReader);
      boolean _isGameOver = man.isGameOver();
      boolean _not = (!_isGameOver);
      boolean _while = _not;
      while (_while) {
        {
          int _score = man.getScore();
          String _plus = ("Score: " + Integer.valueOf(_score));
          String _plus_1 = (_plus + ", Best: ");
          int _bestScore = man.getBestScore();
          String _plus_2 = (_plus_1 + Integer.valueOf(_bestScore));
          System.out.println(_plus_2);
          String _stringifyTiles = man.stringifyTiles();
          System.out.println(_stringifyTiles);
          Direction[] _values = Direction.values();
          final Function1<Direction,Boolean> _function = new Function1<Direction,Boolean>() {
            public Boolean apply(final Direction it) {
              return Boolean.valueOf(man.canMove(it));
            }
          };
          Iterable<Direction> _filter = IterableExtensions.<Direction>filter(((Iterable<Direction>)Conversions.doWrapArray(_values)), _function);
          final Function1<Direction,String> _function_1 = new Function1<Direction,String>() {
            public String apply(final Direction it) {
              String _string = it.toString();
              return _string.toLowerCase();
            }
          };
          final Iterable<String> cmds = IterableExtensions.<Direction, String>map(_filter, _function_1);
          Iterable<String> _plus_3 = Iterables.<String>concat(cmds, Collections.<String>unmodifiableList(Lists.<String>newArrayList("restart")));
          String _join = IterableExtensions.join(_plus_3, ", ");
          String _plus_4 = ("Please enter a command [" + _join);
          String _plus_5 = (_plus_4 + "]:");
          System.out.println(_plus_5);
          System.out.print("> ");
          final String line = reader.readLine();
          boolean _equals = Objects.equal(line, null);
          if (_equals) {
            return;
          }
          String _trim = line.trim();
          final String command = _trim.toUpperCase();
          boolean _equals_1 = Objects.equal(command, "RESTART");
          if (_equals_1) {
            man.restart();
          } else {
            try {
              final Direction direction = Direction.valueOf(command);
              man.move(direction);
            } catch (final Throwable _t) {
              if (_t instanceof IllegalArgumentException) {
                final IllegalArgumentException e = (IllegalArgumentException)_t;
                System.err.println(("Unknown command: " + command));
              } else {
                throw Exceptions.sneakyThrow(_t);
              }
            }
          }
        }
        boolean _isGameOver_1 = man.isGameOver();
        boolean _not_1 = (!_isGameOver_1);
        _while = _not_1;
      }
      System.out.println("Game Over!");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
