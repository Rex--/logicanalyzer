#include "LogicAnalyzer_Board_Settings.h"

#ifdef WS2812B_LED

    #ifndef __LOGICANALYZER_W2812B__

        #define __LOGICANALYZER_W2812B__

        void init_led();
        void led_on();
        void led_off();
        void set_led(uint32_t led, uint8_t r, uint8_t g, uint8_t b);
        void set_all(uint8_t r, uint8_t g, uint8_t b);
        void send_led_data();
        void led_set(uint8_t r, uint8_t g, uint8_t b);

    #endif

#endif