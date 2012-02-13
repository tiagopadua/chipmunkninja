//
//  Background.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 11/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "cocos2d.h"

@interface Background : CCSprite

-(Background*) init:(NSString*)imageFile withWindowSize:(CGSize)windowSize andHeightMultiplier:(double)heightTimes;
-(void)dealloc;

@end
