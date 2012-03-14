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

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kCreditsScene=3,
    kGameLevel1=4
} SceneTypes;

typedef enum {
    kStateIdle,
    kStateBreathing,
    kStateFirstJumping,
    kStateJumping,
    kStateFlying,
    kStateHolding,
    kStateTakingDamage,
    kStateDead
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kTempObject,
    kChipmunk,
    kTree,
    kThorn,
    kBackground,
    kStar,
    kChainsaw
} GameObjectType;

typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
} GameManagerSoundState;


#define BACKGROUND_TRACK_LEVEL1 @"level1_music.mp3"
#define JUMP_TRACK @"jump.mp3"
#define JUMP_END_TRACK @"jump_end.mp3"
#define DIE_TRACK @"die.mp3"
#define CHAINSAW_TRACK @"chainsaw.mp3"

#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]
#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]


@protocol ThornDelegate
-(void)onDestroyThorn:(id)thorn;
@end

@protocol ChipmunkDelegate
-(void)onUpdateBackground:(double)deltaY andDeltaTime:(double)deltaTime;
@end

@protocol GameplayLayerDelegate
-(void)createObjectOfType:(GameObjectType)objectType 
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue;
@end
