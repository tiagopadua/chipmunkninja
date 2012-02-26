//
//  Background.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 11/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Background.h"


@implementation Background 

-(void)createSpriteByName:(NSString*)name
flipX:(BOOL)flipX
ratio:(CGPoint)ratio
position:(CGPoint)position
zIndex:(int)zIndex
{
    CCSprite* sprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:name]];
    sprite.anchorPoint = ccp(0.0f, 0.0f);
    sprite.flipX = flipX;
    [self addChild:sprite z:zIndex parallaxRatio:ratio positionOffset:position];
}
-(Background*) init:(CGSize)winSize {
    self = [super init];

    if (self) {
        screenSize = winSize;
        self.anchorPoint = ccp(0,0);
        self.position = ccp(0, 0);

        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:CGPointZero zIndex:10];
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,screenSize.height-1) zIndex:10];
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,(screenSize.height*2)-2) zIndex:10];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:CGPointZero zIndex:10];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,(screenSize.height-1)) zIndex:10];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,(screenSize.height*2)-2) zIndex:10];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(screenSize.width-33,0) zIndex:10];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(screenSize.width-33,(screenSize.height-1)) zIndex:10];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(screenSize.width-33,(screenSize.height*2)-2) zIndex:10];

        
    }
    return self;
}
-(void)dealloc {
    [super dealloc];
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime {
    double deltaY = self.position.y+screenSize.height*2;
    self.position = ccp(self.position.x, self.position.y - deltaTime);
    if (deltaY < 0) {
        self.position = ccp(self.position.x, deltaY);
    }

}

@end
