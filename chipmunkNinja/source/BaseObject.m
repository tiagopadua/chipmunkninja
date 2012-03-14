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

