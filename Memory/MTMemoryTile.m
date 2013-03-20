#import "MTMemoryTile.h"

#define SND_TILE_FLIP @"button.caf"

@implementation MTMemoryTile

@synthesize tileRow = _tileRow;
@synthesize tileColumn = _tileColumn;
@synthesize faceSprintName = _faceSprintName;
@synthesize isFaceUp;

- (void)dealloc
{
    self.faceSprintName = nil;
    [super dealloc];
}

- (void)showFace
{
    // Instantly wap the texture used for this tile to the faceSpriteName
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:self.faceSprintName]];
    self.isFaceUp = YES;
}

- (void)showBack
{
    // Instantly swap the texture to the back image
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tileback.png"]];
    self.isFaceUp = NO;
}

- (void)changeTile
{
    // this is called in the middle of the flipTile method to change the tile image while the tile is "on edge", so the player doesn't see the switch
    if (isFaceUp) {
        [self showBack];
    } else {
        [self showFace];
    }
}

- (void)flipTile
{
    // this method uses the CCOrbitCamera to spin the view of this sprite so we simulate a tile flip

    // Duration is how long the total flip will last
    float duration = 0.25f;

    CCOrbitCamera *rotateToEdge = [CCOrbitCamera actionWithDuration:duration / 2 radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:90 angleX:0 deltaAngleX:0];
    CCOrbitCamera *rotateFlat = [CCOrbitCamera actionWithDuration:duration / 2 radius:1 deltaRadius:0 angleZ:270 deltaAngleZ:90 angleX:0 deltaAngleX:0];

    [self runAction:[CCSequence actions:rotateToEdge,
                                        [CCCallFunc actionWithTarget:self selector:@selector(changeTile)],
                                        rotateFlat,
                                        nil]];

    // Play the sound effect for flipping
    [[SimpleAudioEngine sharedEngine] playEffect:SND_TILE_FLIP];

}

- (BOOL)containsTouchLocation:(CGPoint)pos
{
    // This is called from the CCLayer to let the object answer if it was touched or not
    return CGRectContainsPoint(self.boundingBox, pos);
}

@end