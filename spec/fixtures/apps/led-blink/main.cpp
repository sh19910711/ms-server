#include <app.h>


LED MainLED;

void setup() {
    static int i = 0;
    MainLED = LED(LED_PIN);

    Timer.set_interval(BLINK_INTERVAL, []() {
        if (i % 2 == 0)
            MainLED.on();
        else
            MainLED.off();

        i++;
    });
}
