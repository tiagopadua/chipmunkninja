//
//  Thorns.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 16/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "cocos2d.h"
#import "BaseObject.h"
@interface Thorn : BaseObject {
    id <ThornDelegate> delegate;
@private
    BOOL _positionedRight;
}
-(void)updatePosition:(double)deltaY;
-(void)setSide:(BOOL)flipRight;

@property(nonatomic, retain) id<ThornDelegate>delegate;
@end
