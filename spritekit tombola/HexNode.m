//
//  HexNode.m
//  spritekit tombola
//
//  Created by Rolf Hanson on 8/12/14.
//  Copyright (c) 2014 GITDOWN LLC. All rights reserved.
//

#import "HexNode.h"

@interface HexNode()

@property (strong, nonatomic) SKAction *spinAction;

@end

@implementation HexNode

- (instancetype)initWithPosition:(CGPoint)position {

    if (self = [super init]) {
        
        self.position = position;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:2];

        _spinAction = [SKAction repeatActionForever:action];

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

        //        _playMarimba = [SKAction playSoundFileNamed:@"marimba.wav" waitForCompletion:NO];
    }

    return self;

}

- (void)startRotating {
    [self runAction:_spinAction withKey:@"spinner"];
}

- (void)stopRotating {
    
}
@end
