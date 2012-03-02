//
//  BaseObject.h
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConstants.h"
#import "GameManager.h"

@interface BaseObject : CCSprite {
    BOOL isActive;
    CGSize screenSize;
    GameObjectType gameObjectType;
    CharacterStates characterState;
}
@property (readwrite) BOOL isActive;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;
@property (readwrite) CharacterStates characterState;
-(CGRect)getRealBoundingBox;
-(void)changeState:(CharacterStates)newState; 
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects; 
-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className;

@end
