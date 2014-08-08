//
//  MyScene.m
//  spritekit tombola
//
//  Created by Rolf Hanson on 2/22/14.
//  Copyright (c) 2014 GITDOWN LLC. All rights reserved.
//

#import "TombolaScene.h"

static const uint32_t hexCategory  = 0x1 << 0;
static const uint32_t ballCategory = 0x1 << 1;

@interface TombolaScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKShapeNode *hexNode;
@property (nonatomic, strong) SKLabelNode *speedLabelNode;
@property (nonatomic, strong) SKLabelNode *speedLabelNumericNode;
@property (nonatomic, strong) SKLabelNode *heavinessLabelNode;
@property (nonatomic, strong) SKLabelNode *heavinessLabelNumericNode;
@property (nonatomic, strong) SKLabelNode *bouncinessLabelNode;
@property (nonatomic, strong) SKLabelNode *bouncinessLabelNumericNode;

@property (nonatomic, strong) SKAction *playMarimba;

@end

@implementation TombolaScene

- (id)initWithSize:(CGSize)size {
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

        SKAction *action = [SKAction rotateByAngle:M_PI duration:2];
        [_hexNode runAction:[SKAction repeatActionForever:action] withKey:@"spinner"];
        _playMarimba = [SKAction playSoundFileNamed:@"marimba.wav" waitForCompletion:NO];


        _hexNode.speed = 0;
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

    //    CGPoint center = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),
//                                 (self.frame.origin.y + (self.frame.size.height / 2)));
//    [self addBallToScene:center];

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

    [self runAction:_playMarimba];
//    if ((contact.bodyA.categoryBitMask == ballCategory) || (contact.bodyB.categoryBitMask == hexCategory)) {
//    }

    
}

- (void)addBallToScene:(CGPoint)location {

    [self addChild:[self createBallNodeWithPosition:location]];
    
}

- (SKShapeNode *)createBallNodeWithPosition:(CGPoint)position {
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddArc(circlePath, NULL, 0.0f, 0.0f, 10.0f, 0.0f, 2*M_PI, YES);
    SKShapeNode *circleNode = [[SKShapeNode alloc] init];
    circleNode.path = circlePath;
    circleNode.position = position;
    circleNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10.0f];
    circleNode.physicsBody.dynamic = YES;
    circleNode.physicsBody.restitution = 1.0f;
    circleNode.physicsBody.linearDamping = 0.0f;
    circleNode.physicsBody.categoryBitMask    = ballCategory;
    circleNode.physicsBody.collisionBitMask   = ballCategory | hexCategory;
    circleNode.physicsBody.contactTestBitMask = ballCategory | hexCategory;
    circleNode.physicsBody.usesPreciseCollisionDetection = YES;
    circleNode.strokeColor = [SKColor whiteColor];
    circleNode.glowWidth = 1;
    CGPathRelease(circlePath);
    return circleNode;
}

- (void)mouseUp:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
