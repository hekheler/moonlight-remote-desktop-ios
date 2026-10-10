//
//  Localization.h
//  Moonlight
//
//  Streaming preferences kept in user defaults, and the ML() text wrapper.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// Streaming preferences kept in user defaults (not in the Core Data settings)
static NSString* const MLTrackpadSpeedKey = @"TrackpadSpeed";          // pointer speed multiplier
static NSString* const MLControlsOnRightKey = @"PortraitControlsOnRight"; // close/rotate side in portrait
static NSString* const MLDirectTextInputKey = @"DirectTextInput";        // YES: send each key as typed
static NSString* const MLVideoFillModeKey = @"VideoFillMode";            // 0 fit, 1 fill (crop), 2 stretch
static NSString* const MLPanOnStartKey = @"PanOnStreamStart";
// Keep the stored key so existing ON/OFF preferences survive the timing change.
static NSString* const MLImeOffBeforeTextSendKey = @"ImeOffOnInputStart";
static NSString* const MLShiftForKeyboardKey = @"LandscapeShiftForKeyboard";

static inline BOOL MLBoolPreference(NSString *key, BOOL defaultValue) {
    NSNumber *value = [NSUserDefaults.standardUserDefaults objectForKey:key];
    return value == nil ? defaultValue : value.boolValue;
}

static inline NSInteger MLVideoFillMode(void) {
    NSNumber* mode = [[NSUserDefaults standardUserDefaults] objectForKey:MLVideoFillModeKey];
    return mode != nil ? mode.integerValue : 0;
}

static inline CGFloat MLTrackpadSpeed(void) {
    double speed = [[NSUserDefaults standardUserDefaults] doubleForKey:MLTrackpadSpeedKey];
    return speed > 0 ? speed : 2.0;
}

// UI text goes through ML() at every call site. It used to return Japanese on
// Japanese devices; the translations were removed, so it returns the English.
static inline NSString* ML(NSString* english) {
    return english;
}
