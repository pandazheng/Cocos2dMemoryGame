#import "CCLayer.h"

@interface MTPlayfieldLayer : CCLayer
{
    CGSize size; // The window size from CCDirector (we only support LandscapeLeft and LandscapeRight orientations)

    CCSpriteBatchNode *memorySheet;

    CGSize tileSize; // Size (in points) of the tiles

    NSMutableArray *tilesAvailable;
    NSMutableArray *tilesInPlay;
    NSMutableArray *tilesSelected;

    CCSprite *backButton;

    NSInteger maxTiles;

    float boardHeight; // Max width of the game board
    float boardWidth; // Max height of the game board

    NSInteger boardRows; // Total rows in the grid
    NSInteger boardColumns; // total columns in the grid

    NSInteger boardOffsetX; // Offset from the left
    NSInteger boardOffsetY; // Offset from the bottom

    NSInteger padWidth;
    NSInteger padHeight;

    NSInteger playerScore; // Current score value
    CCLabelTTF *playerScoreDisplay; // Score label

    NSInteger livesRemaining; // Lives value
    CCLabelTTF *livesRemainingDisplay; // Lives label;

    BOOL isGameOver;
}

+(id) layerWithRows:(NSInteger)numRows andColumns:(NSInteger)numCols;

- (id)initWithRows:(NSInteger)i andColumns:(NSInteger)columns;

@end
