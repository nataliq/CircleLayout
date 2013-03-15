
#import "CircleLayout.h"
#import <QuartzCore/QuartzCore.h>

#define EPS 0.2

@interface CircleLayout()

@property (nonatomic) float itemSize;

@end

@implementation CircleLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.angle = M_PI_2;
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.2;
    
    float angle = ( 2 * M_PI / _cellCount);
    _itemSize = fabsf( 2 * _radius * tanf( angle / 2 ));
    
}

-(CGSize)collectionViewContentSize
{
    return [self collectionView].frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    
    attributes.size = CGSizeMake(self.itemSize, self.itemSize);
    float alpha = fabsf(self.angle) + 2 * path.item * M_PI / _cellCount;
    //attributes.zIndex = self.cellCount - path.item;
    

    float distance = fabsf((2 * M_PI * self.radius - self.cellCount * self.itemSize) /  self.cellCount / 2);
    float d = (self.cellCount - path.item) * sinf(M_PI * (self.cellCount - 2) / self.cellCount) * distance ;
    
    
    CATransform3D transform = CATransform3DIdentity;
    
    transform = CATransform3DTranslate(transform, 0, self.center.x, 0);
    transform = CATransform3DRotate(transform, M_PI_2 - EPS, 1.0f, 0.0f, 0.0f);
    transform = CATransform3DTranslate(transform, _center.x + (_radius + d) * cosf(alpha), _center.y / 1.5 + (_radius + d) * sinf(alpha), 0);
    transform = CATransform3DRotate(transform, - M_PI_2 + alpha, 0.0f, 0.0f, 1.0f);
    transform = CATransform3DRotate(transform, -M_PI_2 , 1.0f, 0.0f, 0.0f);
    
    attributes.transform3D = transform;
    
    if (fmod(alpha, 2 * M_PI) > M_PI ) {
        attributes.alpha = 0.5;
    }
    
    else
    {
        attributes.alpha = 1;
    }

    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (void)setAngle:(CGFloat)angle
{
    _angle = fmod(angle, 2 * M_PI);
}

@end
