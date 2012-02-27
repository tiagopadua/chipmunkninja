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

        
        double posXTreeRigth = screenSize.width-33;
        double posY1Element = screenSize.height-1;
        double posY2Element = (screenSize.height*2)-2;
        double posY3Element = (screenSize.height*3)-3;
        [self createSpriteByName:@"base_sprite.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:CGPointZero zIndex:9];        
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,posY1Element) zIndex:10];
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,posY2Element) zIndex:11];
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,posY3Element) zIndex:12];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,posY1Element) zIndex:13];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,posY2Element) zIndex:14];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,posY3Element) zIndex:15];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(posXTreeRigth,posY1Element) zIndex:16];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(posXTreeRigth,posY2Element) zIndex:17];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(posXTreeRigth,posY3Element) zIndex:18];


    }
    return self;
}
-(void)dealloc {
    [super dealloc];
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime {
    double deltaY = self.position.y+screenSize.height*3;
    self.position = ccp(self.position.x, self.position.y - deltaTime);
    if (deltaY < 0) {
        CCLOG(@"%f - %f", self.position.y, deltaY);
        self.position = ccp(self.position.x, deltaY-screenSize.height);
    }

}

@end
