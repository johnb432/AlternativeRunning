#define COMPONENT main
#include "script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_ALTERNATIVE_RUNNING
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_ALTERNATIVE_RUNNING
    #define DEBUG_SETTINGS DEBUG_SETTINGS_ALTERNATIVE_RUNNING
#endif

#include "script_macros.hpp"

// Include BI DIK codes
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
