//
//  Level1.m
//  GameArchitecture
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "Level1.h"
#import "WinPopup.h"
#import "CCActionFollow+CurrentOffset.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Level1 {
  CCSprite *_character;
  CCSprite *_flag;
  CCPhysicsNode *_physicsNode;
  BOOL _jumped;
}

- (void)didLoadFromCCB {
  _flag.physicsBody.sensor = TRUE;
  _physicsNode.collisionDelegate = self;
}

- (void)onEnter {
  [super onEnter];

  _character.physicsBody.body.body->velocity_func = playerUpdateVelocity;
  CCActionFollow *follow = [CCActionFollow actionWithTarget:_character worldBoundary:_physicsNode.boundingBox];
  _physicsNode.position = [follow currentOffset];
  [_physicsNode runAction:follow];
}

- (void)onEnterTransitionDidFinish {
  [super onEnterTransitionDidFinish];
  
  self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [_character.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
    if (!_jumped) {
      [_character.physicsBody applyImpulse:ccp(0, 2000)];
      _jumped = TRUE;
      [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
    }
  }];
}

- (void)resetJump {
  _jumped = FALSE;
}

static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
  cpAssertSoft(body->m > 0.0f && body->i > 0.0f, "Body's mass and moment must be positive to simulate. (Mass: %f Moment: %f)", body->m, body->i);
  
	body->v = cpvadd(cpvmult(body->v, damping), cpvmult(cpvadd(gravity, cpvmult(body->f, body->m_inv)), dt));
	body->w = body->w*damping + body->t*body->i_inv*dt;
  
	// Reset forces.
	body->f = cpvzero;
	body->t = 0.0f;
  
	body->v.x = 40.f;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero flag:(CCNode *)flag {
  self.paused = YES;
  
  WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup"];
  popup.positionType = CCPositionTypeNormalized;
  popup.position = ccp(0.5, 0.5);
  popup.nextLevelName = @"Level2";
  [self addChild:popup];
  
  return TRUE;
}

@end
