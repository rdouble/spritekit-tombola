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
        
        SKLabelNode *gravityLabel = [[SKLabelNode alloc] initWithFontNamed:@"Bebas"];
        [gravityLabel setText:@"GRAVITY"];
        [gravityLabel setFontSize:42];

        [gravityLabel setFontColor:[NSColor greenColor]];
        gravityLabel.position = CGPointMake(900, 700);
        gravityLabel.alpha = 0.55;
        [self addChild:gravityLabel];

        _hexNode = [SKShapeNode node];

        _hexNode.strokeColor = [SKColor greenColor];
        _hexNode.glowWidth = 0.25;


        _hexNode.path = hexPath;
        _hexNode.position = center;
        _hexNode.name = @"hex";
        _hexNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:hexPath];

        _hexNode.physicsBody.categoryBitMask = hexCategory;

        
        [self addChild:_hexNode];
        CGPathRelease(hexPath);
        SKAction *action = [SKAction rotateByAngle:M_PI duration:20];
        
        [_hexNode runAction:[SKAction repeatActionForever:action] withKey:@"spinner"];
        
    }
    return self;
}

- (void)keyDown:(NSEvent *)theEvent {
    CGPoint center = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),
                                 (self.frame.origin.y + (self.frame.size.height / 2)));
    [self addBallToScene:center];
   
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    CGPoint location = [theEvent locationInNode:self];
    [self addBallToScene:location];



    
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKAction *playMarimba = [SKAction playSoundFileNamed:@"marimba.wav" waitForCompletion:NO];
    [self runAction:playMarimba];
    if ((contact.bodyA.categoryBitMask == ballCategory) || (contact.bodyB.categoryBitMask == hexCategory)) {
}

    
}
- (void)addBallToScene:(CGPoint)location {
    
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
    CGPathRelease(circlePath);
    
    [self addChild:circleNode];
    
}
-(void)mouseUp:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
