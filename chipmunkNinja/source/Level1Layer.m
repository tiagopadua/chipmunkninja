//
//  Level1Layer.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "Level1Layer.h"


@implementation Level1Layer

#pragma mark –
#pragma mark Update Method
-(void) update:(ccTime)deltaTime {
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (BaseObject *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }
}

#pragma mark -
-(void)createObjectOfType:(GameObjectType)objectType 
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue {
    
    if (objectType == kTempObject) {
        CCLOG(@"Creating the Tempobject Enemy");
        TempObject *tempObject = [[TempObject alloc] initWithSpriteFrameName:@"chipmunk1.png"];
        [tempObject setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:tempObject z:ZValue tag:100];
        [tempObject release];
    } 
    
}

- (void) dealloc {
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        self.isTouchEnabled = YES; 
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"level1.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"level1.png"];
        
        
        [self addChild:sceneSpriteBatchNode z:0];
        
        
        TempObject *tempObject = [[TempObject alloc] 
                          initWithSpriteFrame:[[CCSpriteFrameCache 
                                                sharedSpriteFrameCache] 
                                               spriteFrameByName:@"chipmunk1.png"]];
        
        
        [tempObject setPosition:ccp(screenSize.width/2, 
                                screenSize.height/2)]; 

        
        [sceneSpriteBatchNode addChild:tempObject z:1 tag:1000];
        
        [self createObjectOfType:kChipmunk 
                      atLocation:ccp(100,
                                     100) 
                      withZValue:10];
        [self scheduleUpdate];
    }
    return self; 
}

@end
