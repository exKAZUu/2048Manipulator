package net.exkazuu._2048manipulator;

import static org.hamcrest.Matchers.*;
import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

public class ManipulatorTest {
  @Test
  public void test() {
    Manipulator man = new Manipulator();
    assertThat(man.getScore(), is(0));

    int zero = 0, two = 0;
    for (List<Integer> tiles : man.getTiles()) {
      for (int tile : tiles) {
        if (tile == 0)
          zero++;
        else if (tile == 2)
          two++;
      }
    }
    assertThat(zero, is(14));
    assertThat(two, is(2));

    boolean changed = false;
    for (Direction direction : Direction.values()) {
      changed |= man.move(direction);
    }
    assertThat(changed, is(true));

    while (!man.isGameOver()) {
      for (Direction direction : Direction.values()) {
        man.move(direction);
      }
    }
    int score = man.getScore();
    assertThat(score, is(not(0)));

    for (Direction direction : Direction.values()) {
      man.move(direction);
    }
    assertThat(man.getScore(), is(score));
  }
}
