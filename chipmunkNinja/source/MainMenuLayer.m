//
//  MainMenuLayer.m
//  The Great Scape
//
//  Created by Maxwell Dayvson da Silva on 2/11/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import "MainMenuLayer.h"


@implementation MainMenuLayer
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
    sprite.opacity = 80;
    [sprite.texture setAntiAliasTexParameters]; 
    [background addChild:sprite z:zIndex parallaxRatio:ratio positionOffset:position];

}

-(void) initBackground {
    background = [CCParallaxNode node];
    background.anchorPoint = ccp(0.0f, 0.0f);
    
    double posY1Element = screenSize.height;
    double posY2Element = (screenSize.height*2);

    [self createSpriteByName:@"bg-menu.png" flipX:FALSE ratio:ccp(1.0f,1.0f) 
                                    position:CGPointZero zIndex:10];
    [self createSpriteByName:@"bg-menu.png" flipX:FALSE ratio:ccp(1.0f,1.0f) 
                                    position:ccp(0,posY1Element) zIndex:11];
    [self createSpriteByName:@"bg-menu.png" flipX:FALSE ratio:ccp(1.0f,1.0f) 
                                    position:ccp(0,posY2Element) zIndex:12];
    [self addChild:background];

}
-(void)dealloc {
    [self removeAllChildrenWithCleanup:TRUE];
    [super dealloc];

}

-(void) updateBackgrounPosition:(ccTime)deltaTime {
    double deltaY = background.position.y+screenSize.height*2;
    background.position = ccp(background.position.x, background.position.y - (40 * deltaTime));
    if (deltaY < 0) {
        background.position = ccp(background.position.x, deltaY-screenSize.height);
    }
    
}

-(void) update:(ccTime)deltaTime {
    if(background){
        [self updateBackgrounPosition:deltaTime];
    }
}

-(void) onClickPlay {
    [[GameManager sharedGameManager] runSceneWithID:kGameLevel1];
}

-(void) onClickOptions {
    
}

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"menu.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    
}

-(void) initMenu {
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    CCSprite *playSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"btn-start.png"]];
    [playSprite.texture setAliasTexParameters];
    CCMenuItemSprite *playButton = [CCMenuItemSprite itemFromNormalSprite:playSprite
                selectedSprite:nil target:self selector:@selector(onClickPlay)];

    
    CCSprite *optionSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"btn-options.png"]];
    [optionSprite.texture setAliasTexParameters];
    CCMenuItemSprite *optionButton = [CCMenuItemSprite itemFromNormalSprite:optionSprite selectedSprite:nil
                                                                   target:self selector:@selector(onClickOptions)];

    mainMenu = [CCMenu menuWithItems:playButton,optionButton,nil];
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition: ccp(screenSize.width * 2.0f, screenSize.height / 2.0f)];
    id moveAction = [CCMoveTo actionWithDuration:0.5f 
                                        position:ccp(screenSize.width /2 ,
                                                     screenSize.height/2.0f)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id sequenceAction = [CCSequence actions:moveEffect,nil];
    [mainMenu runAction:sequenceAction];
    mainMenu.anchorPoint = ccp(0,0);
    [self addChild:mainMenu z:0 tag:100];

}

-(id)init{
    self = [super init];
    if(self != nil){
        screenSize = [CCDirector sharedDirector].winSize;
        self.anchorPoint = ccp(0,0);
        self.position = ccp(0, 0);
        [self loadPlistLevel];
        [self initBackground];
        [self initMenu];
        [self scheduleUpdate];
        
    }
    return self;
}
@end
