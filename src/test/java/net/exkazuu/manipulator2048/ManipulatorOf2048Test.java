package net.exkazuu.manipulator2048;

import static org.hamcrest.Matchers.*;
import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

public class ManipulatorOf2048Test {
  @Test
  public void test() {
    ManipulatorOf2048 man = new ManipulatorOf2048();
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

    for (Direction direction : Direction.values()) {
      man.move(direction);
    }

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
