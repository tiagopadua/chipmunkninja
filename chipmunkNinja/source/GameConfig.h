
#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationNone

#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone

#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif

