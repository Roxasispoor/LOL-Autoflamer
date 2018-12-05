import static java.awt.event.KeyEvent.*;
import java.awt.Robot;

void setup() {
      try
      {
        Keyboard keyboard = new Keyboard();
       keyboard.type("Hello there, how are you?");  
    }
       catch (AWTException e)
    {
    e.printStackTrace();
    }
       
    }
