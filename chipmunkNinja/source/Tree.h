//
//  Tree.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 12/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "cocos2d.h"

@interface Tree : CCSprite

-(Tree*) init:(NSString*)imageFile withWindowSize:(CGSize)windowSize andHeightMultiplier:(double)heightTimes;
-(Tree*) init:(NSString*)imageFile withWindowSize:(CGSize)windowSize andHeightMultiplier:(double)heightTimes andPositionRight:(BOOL)flipRight;
-(void)dealloc;

-(void) nextFrame:(double)dy;

@end
