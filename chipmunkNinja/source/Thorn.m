//
//  Thorns.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 16/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Thorn.h"

@implementation Thorn
@synthesize delegate;
/*- (Thorn*) init:(NSString *)imageFile withWindowSize:(CGSize)windowSize andTreeWidth:(double)treeWidth {
    return [self init:imageFile withWindowSize:windowSize andTreeWidth:treeWidth andPositionRight:FALSE];
}
- (Thorn*) init:(NSString *)imageFile withWindowSize:(CGSize)windowSize andTreeWidth:(double)treeWidth andPositionRight:(BOOL)flipRight {
    self = [CCSprite spriteWithFile:imageFile];
    if (self) {
        if (flipRight) {
            self.flipX = flipRight;
            self.position = ccp(windowSize.width-treeWidth, windowSize.height + self.contentSize.height/2);
        } else {
            self.position = ccp(treeWidth, windowSize.height + self.contentSize.height/2);
        }
        _positionedRight = flipRight;
    }
    return self;
}
-(void)dealloc {
    [super dealloc];
}

-(void) nextFrame:(double)dy {
    self.position = ccp(self.position.x, self.position.y - dy);
}

- (BOOL) isPositionedRight {
    return _positionedRight;
}*/
-(void)createWithNumElements:(int)times andFlipX:(BOOL)flipX
{

    for (int i = 0; i<times; i++) {
        CCSprite* sprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"thorn-right.png"]];
        sprite.anchorPoint = ccp(0.0f, 0.0f);
        sprite.position = ccp(flipX ? 40 : 12, 24*i);
        sprite.scaleX = flipX ? -1.0 : 1.0;
        
        [self addChild:sprite];

    }
    [self setContentSize:CGSizeMake(32, 24*times)];
}
-(void)changeState:(CharacterStates)newState {
    
}

-(void) updatePosition:(double)deltaY {
    self.position = ccp(self.position.x, self.position.y - deltaY);
    if(self.position.y < 0 ){
        [delegate onDestroyThorn:self];
        //[self removeFromParentAndCleanup:TRUE];
    }
}
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
}
- (void) dealloc{
    [super dealloc];
}

-(void) setSide:(BOOL)flipRight{
    [self createWithNumElements: MAX(2, rand() % 5)  andFlipX:flipRight];
    if (flipRight) {
        self.position = ccp(40, screenSize.height + self.contentSize.height/2);
    } else {
        self.position = ccp(screenSize.width-55, screenSize.height + self.contentSize.height/2);
    }
    self.flipX = flipRight;
    CCLOG(@"FLIP SIDE >>>  %d", flipRight);
}
-(Thorn*) init:(BOOL)flipX{
    self = [super init];
    if(self != nil){
        gameObjectType = kThorn;
        characterState = kStateIdle;
    }
    return self;
}

@end
