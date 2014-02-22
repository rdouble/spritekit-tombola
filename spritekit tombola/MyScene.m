//
//  MyScene.m
//  spritekit tombola
//
//  Created by Rolf Hanson on 2/22/14.
//  Copyright (c) 2014 GITDOWN LLC. All rights reserved.
//

#import "MyScene.h"

static const uint32_t hexCategory  = 0x1 << 0;
static const uint32_t ballCategory = 0x1 << 1;

@interface MyScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKShapeNode *hexNode;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.contactDelegate = self;

        
        CGPoint center = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),
                                     (self.frame.origin.y + (self.frame.size.height / 2)));

        
        CGMutablePathRef hexPath = CGPathCreateMutable();

        int numberOfSides = 6;
        float radius = 200.0f;
        
        //float height = self.frame.size.height;
        //float width  = self.frame.size.width;
        
        float height = 0.0f;
        float width  = 0.0f;

        CGFloat startingAngle = 2 * M_PI / numberOfSides / 2.0f;
        for (int n = 0; n < numberOfSides; n++) {
            CGFloat rotationFactor = ((2 * M_PI) / numberOfSides) * (n+1) + startingAngle;
            CGFloat x = ( width / 2.0f) + sin(rotationFactor) * radius;
            CGFloat y = ( height / 2.0f) + cos(rotationFactor) * radius;
            NSLog(@"x = %f, y = %f", x, y);
            if (n == 0) {
                CGPathMoveToPoint(hexPath, NULL, x, y);
            } else {
                CGPathAddLineToPoint(hexPath, NULL, x, y);
            }
        }
        CGPathCloseSubpath(hexPath);

        _hexNode = [SKShapeNode node];

        _hexNode.strokeColor = [SKColor greenColor];
        _hexNode.glowWidth = 0.25;


        _hexNode.path = hexPath;
        _hexNode.position = center;
        _hexNode.name = @"hex";
        _hexNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:hexPath];
        _hexNode.physicsBody.categoryBitMask = hexCategory;

        
        [self addChild:_hexNode];
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [_hexNode runAction:[SKAction repeatActionForever:action] withKey:@"spinner"];
        
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    CGPoint location = [theEvent locationInNode:self];
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddArc(circlePath, NULL, 0.0f, 0.0f, 10.0f, 0.0f, 2*M_PI, YES);
    SKShapeNode *circleNode = [[SKShapeNode alloc] init];
    
    circleNode.path = circlePath;
    circleNode.position = location;
    circleNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:[circleNode calculateAccumulatedFrame].size.width/2];
    circleNode.physicsBody.dynamic = YES;
    circleNode.physicsBody.restitution = 1.0f;
    circleNode.physicsBody.categoryBitMask    = ballCategory;
    circleNode.physicsBody.collisionBitMask   = ballCategory | hexCategory;
    circleNode.physicsBody.contactTestBitMask = ballCategory | hexCategory;
    circleNode.strokeColor = [SKColor whiteColor];
    circleNode.glowWidth = 1;
    
    [self addChild:circleNode];



    
}

-(void)mouseUp:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
