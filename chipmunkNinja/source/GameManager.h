//
//  GameManager.h
//  The Great Scape
//
//  Created by Maxwell Dayvson da Silva on 2/11/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface GameManager : NSObject {
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    BOOL hasPlayerDied;
    SceneTypes currentScene;
}
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL hasPlayerDied;

+(GameManager*)sharedGameManager;                                  
-(void)runSceneWithID:(SceneTypes)sceneID;
@end

