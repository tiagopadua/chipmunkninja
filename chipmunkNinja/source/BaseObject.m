//
//  BaseObject.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "BaseObject.h"

@implementation BaseObject

@synthesize screenSize;
@synthesize isActive;
@synthesize gameObjectType;
@synthesize characterState;
-(id) init {
    if((self=[super init])){
        CCLOG(@"GameObject init");
        screenSize = [CCDirector sharedDirector].winSize;
        isActive = TRUE;
        gameObjectType = kObjectTypeNone;
    }
    return self;
}
-(CGRect)getRealBoundingBox{
    CGSize contentSize = [self contentSize];
    CGPoint contentPosition = [self position];
    CGRect result = CGRectMake(contentPosition.x, contentPosition.y, contentSize.width, contentSize.height); 
    return result;
}
-(void)changeState:(CharacterStates)newState {
    CCLOG(@"GameObject->changeState method should be overriden");
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    CCLOG(@"updateStateWithDeltaTime method should be overriden");
}

-(CGRect)adjustedBoundingBox {
    CCLOG(@"GameObect adjustedBoundingBox should be overriden");
    return [self boundingBox];
}
-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName andClassName:(NSString*)className {
    
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = 
    [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    

    NSString *rootPath = 
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] 
                     pathForResource:className ofType:@"plist"];
    }
    

    NSDictionary *plistDictionary = 
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    

    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil;
    }
    

    NSDictionary *animationSettings = 
    [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil;
    }
    

    float animationDelay = 
    [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    

    NSString *animationFramePrefix = 
    [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = 
    [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = 
    [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName = 
        [NSString stringWithFormat:@"%@%@.png",
         animationFramePrefix,frameNumber];
        [animationToReturn addFrame:
         [[CCSpriteFrameCache sharedSpriteFrameCache] 
          spriteFrameByName:frameName]];
    }
    
    return animationToReturn;
}

@end

