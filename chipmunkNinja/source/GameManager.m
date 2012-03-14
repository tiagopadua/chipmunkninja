/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Tiago de Pádua <tiagopadua@gmail.com>
 * Created 01/2012
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#import "GameManager.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "OptionsMenuScene.h"
#import "CreditsScene.h"
#import "Level1Scene.h"

@implementation GameManager
static GameManager* _sharedGameManager = nil;
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize hasPlayerDied;

@synthesize managerSoundState;
@synthesize listOfSoundEffectFiles;
@synthesize soundEffectsState;

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])
    {
        if(!_sharedGameManager){
            [[self alloc] init];    
        }
        return _sharedGameManager;
    }
    return nil; 
}

+(id)alloc 
{
    @synchronized ([GameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton");                                          
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        isSoundEffectsON = YES;
        hasPlayerDied = NO;
        currentScene = kNoSceneUninitialized;
        audioInitialized = NO;
        soundEngine = nil;
        managerSoundState = kAudioManagerUninitialized;
    }
    return self;
}

-(void)initAudioAsync {
    managerSoundState = kAudioManagerInitializing;
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed;
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready");
    } 
    
}
-(void)setupAudioEngine {
    if (audioInitialized == YES) {
        return;
    } else {
        audioInitialized = YES;
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation =
        [[NSInvocationOperation alloc] initWithTarget:self
                                             selector:@selector(initAudioAsync)
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}


-(void)playBackgroundTrack:(NSString*)trackFileName {
    int waitCycles = 0;
    if ((managerSoundState != kAudioManagerReady) &&
        (managerSoundState != kAudioManagerFailed)) {
        while (waitCycles < 150) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) ||
                (managerSoundState == kAudioManagerFailed)) {
                break; 
            }
            waitCycles = waitCycles + 1;
        }
    }
    if (managerSoundState == kAudioManagerReady) {
        if ([soundEngine isBackgroundMusicPlaying]) {
            [soundEngine stopBackgroundMusic];
        }
        [soundEngine preloadBackgroundMusic:trackFileName];
        [soundEngine playBackgroundMusic:trackFileName loop:YES];
    }
}
-(void)stopSoundEffect:(ALuint)soundEffectID {
    if (managerSoundState == kAudioManagerReady) {
        [soundEngine stopEffect:soundEffectID];
    }
}
-(ALuint)playSoundEffect:(NSString*)soundEffectKey {
    ALuint soundID = 0;
        
    if (managerSoundState == kAudioManagerReady) {
        soundID = [soundEngine playEffect:soundEffectKey];
        CCLOG(@"PLAY EFFECT %@", soundEffectKey);
    } else {
        CCLOG(@"GameMgr: Sound Manager is not ready, cannot play %@",
              soundEffectKey);
    }
    return soundID;
}

-(void)loadAudioForSceneWithID:(NSNumber*)sceneIDNumber {
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    if(sceneID != kGameLevel1) return;
    
    int waitCycles = 0;
    if (managerSoundState == kAudioManagerInitializing) {
        while (waitCycles < 150) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) ||
                (managerSoundState == kAudioManagerFailed)) {
                break; 
            }
            waitCycles = waitCycles + 1;
        }
    }
    if (managerSoundState == kAudioManagerFailed) {
        return;
    }
    CCLOG(@"PRELOAD EFFECT");
    [soundEngine preloadEffect: JUMP_TRACK];
    [soundEngine preloadEffect: DIE_TRACK];


}
-(void)runSceneWithID:(SceneTypes)sceneID {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    
    id sceneToRun = nil;
    switch (sceneID) {
        case kMainMenuScene: 
            sceneToRun = [MainMenuScene node];
            break;
        case kOptionsScene:
            sceneToRun = [OptionsMenuScene node];
            break;
        case kCreditsScene:
            sceneToRun = [CreditsScene node];
            break;
        case kGameLevel1: 
            sceneToRun = [Level1Scene node];
            break;
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    if (sceneToRun == nil) {
        currentScene = oldScene;
        return;
    }
    [self performSelectorInBackground:@selector(loadAudioForSceneWithID:) withObject:[NSNumber
                                                                                      numberWithInt: currentScene]];
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {        
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }   
}
@end

