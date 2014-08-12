//
//  MyScene.m
//  spritekit tombola
//
//  Created by Rolf Hanson on 2/22/14.
//  Copyright (c) 2014 GITDOWN LLC. All rights reserved.
//

#import "TombolaScene.h"
#import "HexNode.h"
#import "BallNode.h"

@interface TombolaScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong) HexNode *hexNode;
@property (nonatomic, strong) SKLabelNode *speedLabelNode;
@property (nonatomic, strong) SKLabelNode *speedLabelNumericNode;
@property (nonatomic, strong) SKLabelNode *heavinessLabelNode;
@property (nonatomic, strong) SKLabelNode *heavinessLabelNumericNode;
@property (nonatomic, strong) SKLabelNode *bouncinessLabelNode;
@property (nonatomic, strong) SKLabelNode *bouncinessLabelNumericNode;

@end

@implementation TombolaScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.contactDelegate = self;

        
        CGPoint center = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),
                                     (self.frame.origin.y + (self.frame.size.height / 2)));

        _hexNode = [[HexNode alloc] initWithPosition:center];
        [_hexNode startRotating];
        [self addChild:_hexNode];
        [self addLabels];

        
    }
    return self;
}

- (void)addLabels {
    _speedLabelNode = [[SKLabelNode alloc] initWithFontNamed:@"Bebas"];
    _speedLabelNumericNode = [[SKLabelNode alloc] initWithFontNamed:@"Bebas"];


    [_speedLabelNode  setText:@"SPEED:"];
    [_speedLabelNode setFontSize:42];
    [_speedLabelNode setFontColor:[NSColor greenColor]];
    [_speedLabelNumericNode setFontColor:[NSColor greenColor]];

    _speedLabelNode.position = CGPointMake(875, 700);
    _speedLabelNode.alpha = 0.55;
    _speedLabelNumericNode.alpha = 0.55;


    NSString *speedLabelNumericText = [NSString stringWithFormat:@"%.2f", _hexNode.speed];
    NSLog(@"speed: %@", speedLabelNumericText);
    _speedLabelNumericNode.fontSize = 42;
    _speedLabelNumericNode.position = CGPointMake(970, 700);
    _speedLabelNumericNode.text = speedLabelNumericText;
    
    [self addChild:_speedLabelNode];
    [self addChild:_speedLabelNumericNode];

}
- (void)keyDown:(NSEvent *)theEvent {

    switch (theEvent.keyCode) {
        case 1: // depressed 's'
            _hexNode.speed = _hexNode.speed + 0.25;
            break;
        case 0:  // depressed 'a'
            _hexNode.speed = _hexNode.speed - 0.25;
            break;
        case 2: // depressed 'd'
            _hexNode.physicsBody.categoryBitMask = 0;
            _hexNode.strokeColor = [SKColor blackColor];
        case 3: // depressed 'f'
            // reverse rotation direction
        default:
            break;
    }

    NSString *speedLabelNumericText = [NSString stringWithFormat:@"%.2f", _hexNode.speed];
    [_speedLabelNumericNode setText:speedLabelNumericText];
   
}

- (void)keyUp:(NSEvent *)theEvent {
    switch (theEvent.keyCode) {
        case 2:
            _hexNode.physicsBody.categoryBitMask = hexCategory;
            _hexNode.strokeColor = [SKColor greenColor];
            break;
        default:
            break;

            
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    CGPoint location = [theEvent locationInNode:self];
    [self addBallToScene:location];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {

    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;

    if ([firstNode isKindOfClass:[BallNode class]]) {
        [(BallNode *)firstNode playMarimba];
    } else {
        [(BallNode *)secondNode playMarimba];
    }
   
}

- (void)addBallToScene:(CGPoint)location {

    [self addChild:[self createBallNodeWithPosition:location]];
    
}

- (SKShapeNode *)createBallNodeWithPosition:(CGPoint)position {
    
    BallNode *ballNode = [[BallNode alloc] initWithPosition:position];
    return ballNode;
}

- (void)mouseUp:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
