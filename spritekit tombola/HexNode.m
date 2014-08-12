//
//  HexNode.m
//  spritekit tombola
//
//  Created by Rolf Hanson on 8/12/14.
//  Copyright (c) 2014 GITDOWN LLC. All rights reserved.
//

#import "HexNode.h"

static const uint32_t hexCategory  = 0x1 << 0;

@implementation HexNode


- (instancetype)init {
    if (self = [super init]) {

        
        
        self.strokeColor = [SKColor greenColor];
        self.glowWidth = 0.25;

        CGMutablePathRef hexPath = CGPathCreateMutable();
        
        int numberOfSides = 6;
        float radius = 200.0f;
        
        CGFloat startingAngle = 2 * M_PI / numberOfSides / 2.0f;
        for (int n = 0; n < numberOfSides; n++) {
            CGFloat rotationFactor = ((2 * M_PI) / numberOfSides) * (n+1) + startingAngle;
            CGFloat x = sin(rotationFactor) * radius;
            CGFloat y = cos(rotationFactor) * radius;
            
            if (n == 0) {
                CGPathMoveToPoint(hexPath, NULL, x, y);
            } else {
                CGPathAddLineToPoint(hexPath, NULL, x, y);
            }
        }
        CGPathCloseSubpath(hexPath);

        
        self.path = hexPath;

        self.name = @"hex";
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:hexPath];
        
        self.physicsBody.categoryBitMask = hexCategory;

        CGPathRelease(hexPath);
        

        
        
        self.speed = 0;

        
        
    }
    return self;
}

- (void)startRotating {
    
}

- (void)stopRotating {
    
}
@end
