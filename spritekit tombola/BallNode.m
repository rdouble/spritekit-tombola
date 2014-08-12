//
//  BallNode.m
//  spritekit tombola
//
//  Created by Rolf Hanson on 8/12/14.
//  Copyright (c) 2014 GITDOWN LLC. All rights reserved.
//

#import "BallNode.h"

@interface BallNode()

@property (strong, nonatomic) SKAction *marimbaAction;

@end

@implementation BallNode

- (instancetype)initWithPosition:(CGPoint)position {
    if (self = [super init]) {

        _marimbaAction = [SKAction playSoundFileNamed:@"marimba.wav" waitForCompletion:NO];
     
        
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddArc(circlePath, NULL, 0.0f, 0.0f, 10.0f, 0.0f, 2*M_PI, YES);
        self.path = circlePath;
        CGPathRelease(circlePath);
        
        self.position = position;

        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10.0f];
        self.physicsBody.dynamic = YES;
        self.physicsBody.restitution = 1.0f;
        self.physicsBody.linearDamping = 0.0f;
        self.physicsBody.categoryBitMask    = ballCategory;
        self.physicsBody.collisionBitMask   = ballCategory | hexCategory;
        self.physicsBody.contactTestBitMask = ballCategory | hexCategory;
        self.physicsBody.usesPreciseCollisionDetection = YES;

        self.strokeColor = [SKColor whiteColor];
        self.glowWidth = 1;
        
    }
    return self;
}

- (void)playMarimba {
    [self runAction:_marimbaAction];
}
@end
