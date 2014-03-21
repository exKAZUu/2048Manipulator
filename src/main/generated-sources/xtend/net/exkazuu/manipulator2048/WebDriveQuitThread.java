package net.exkazuu.manipulator2048;

import org.eclipse.xtext.xbase.lib.Exceptions;
import org.openqa.selenium.WebDriver;

@SuppressWarnings("all")
public class WebDriveQuitThread extends Thread {
  private final WebDriver driver;
  
  public WebDriveQuitThread(final WebDriver driver) {
    this.driver = driver;
  }
  
  public void run() {
    try {
      this.driver.quit();
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception e = (Exception)_t;
        System.err.println("Failed to quit the given driver.");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
}
