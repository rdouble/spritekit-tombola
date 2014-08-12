//
//  BallNode.h
//  spritekit tombola
//
//  Created by Rolf Hanson on 8/12/14.
//  Copyright (c) 2014 GITDOWN LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>




@interface BallNode : SKShapeNode

- (instancetype)initWithPosition:(CGPoint)position;
- (void)playMarimba;
@end
