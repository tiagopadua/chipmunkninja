//
//  Chipmunk.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 12/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "cocos2d.h"
#import "BaseObject.h"


@interface Chipmunk : BaseObject{
    CCAnimation *idleAnimation;    
    CCAnimation *jumpAnimation;    
    CCAnimation *firstJumpAnimation;    
    CCAnimation *flyAnimation;    
    CCAnimation *holdAnimation;
    CCAnimation *breathAnimation;
    double velY;
    BOOL side;
    BOOL touching;
    double score;
    id <ChipmunkDelegate> delegate;
    //    CCAnimation *damageAnimation;    
    //    CCAnimation *deadAnimation;    
}
@property (nonatomic, retain) CCAnimation *idleAnimation;
@property (nonatomic, retain) CCAnimation *jumpAnimation;
@property (nonatomic, retain) CCAnimation *firstJumpAnimation;
@property (nonatomic, retain) CCAnimation *flyAnimation;
@property (nonatomic, retain) CCAnimation *holdAnimation;
@property (nonatomic, retain) CCAnimation *breathAnimation;
@property (nonatomic, retain) id<ChipmunkDelegate> delegate;
@property (nonatomic) BOOL                 touching;
@property (nonatomic) double               velY;
@property (nonatomic) double               score;
//@property (nonatomic, retain) CCAnimation *damageAnimation;
//@property (nonatomic, retain) CCAnimation *deadAnimation;
@end
