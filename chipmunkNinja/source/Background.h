//
//  Background.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 11/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "cocos2d.h"
#import "GameConstants.h"
@interface Background : CCParallaxNode{
    CGSize screenSize;
}

-(Background*) init:(CGSize)screenSize;
-(void)dealloc;

-(void) updateStateWithDeltaTime:(ccTime)deltaTime;

@end
