#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface MTMemoryTile : CCSprite {
    NSInteger _tileRow;
    NSInteger _tileColumn;
    NSString *_faceSprintName;
    BOOL isFaceup;
}

@property(nonatomic, assign) NSInteger tileRow;
@property(nonatomic, assign) NSInteger tileColumn;
@property(nonatomic, assign) BOOL isFaceUp;
@property(nonatomic, retain) NSString *faceSprintName;

- (void)showFace;

- (void)showBack;

- (void)flipTile;

- (BOOL)containsTouchLocation:(CGPoint)pos;

@end