//
//  GameManager.m
//  The Great Scape
//
//  Created by Maxwell Dayvson da Silva on 2/11/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import "GameManager.h"


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
    }
    return self;
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
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {        
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }    
}
@end

