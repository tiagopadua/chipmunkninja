//
//  Chipmunk.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 12/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Chipmunk.h"

@implementation Chipmunk

- (Chipmunk*) init:(NSString *)imageFile {
    self = [CCSprite spriteWithFile:imageFile];
    if (self) {
        self.position = ccp(23, self.contentSize.height/2);
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

-(void)slideDown:(ccTime)dt withGravity:(double)gravity andSlideSpeed:(double)slideSpeed andHoldFactor:(double)holdFactor {
//    double newPosY = self.position.y + slideSpeed * dt ;
//    if(isTouching) {
//        newPosY = self.position.y + MAX(slideSpeed * dt, jumpPower * dt);
//        jumpPower -= gravity * holdFactor * dt;
//    }
//
//    // Evita deslizar mais no inicio do jogo
//    double chipmunkZero = self.contentSize.height / 2;
//    if ((score <= 0) && (newPosY < chipmunkZero)) {
//        newPosY = chipmunkZero;
//    }
//
//    self.position = ccp(self.position.x, newPosY);
}

@end
