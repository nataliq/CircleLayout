

#import "ViewController.h"
#import "CircleLayout.h"
#import "Cell.h"
#import "UIColor+Random.h"

#import <QuartzCore/QuartzCore.h>


int const CellCount = 15;
static NSString* const CellID = @"MY_CELL";

@interface ViewController ()
 
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) float initialAngle;
@property (strong, nonatomic) CircleLayout *customLayout;

@end


@implementation ViewController

- (void)viewDidLoad
{
    self.cellCount = CellCount;
    self.customLayout = (CircleLayout *) self.collectionView.collectionViewLayout;
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.collectionView addGestureRecognizer:panRecognizer];
    
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:CellID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    cell.label.text = [NSString stringWithFormat:@"Cell %d", indexPath.item];
    cell.label.center = cell.contentView.center;
    cell.contentView.backgroundColor = [UIColor randomColor];
    
    return cell;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.currentPoint = [sender locationInView:self.collectionView];
        self.initialAngle = self.customLayout.angle;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint activePoint = [sender locationInView: self.collectionView];
        
        float prevAngle = atan2(self.currentPoint.y, self.currentPoint.x);
        float curAngle= atan2(activePoint.y, activePoint.x);
        
        self.customLayout.angle = self.initialAngle + curAngle - prevAngle;
        
        [self.collectionView performBatchUpdates:nil completion:nil];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.customLayout.angle += 0.5 * -( [sender velocityInView:self.collectionView].x / ( 2 * M_PI * self.customLayout.radius) );
        self.customLayout.angle = lroundf(self.customLayout.angle);
        
        [self.collectionView performBatchUpdates:nil completion:nil];
        
        self.customLayout.velocity = 0;
        
    }
}

@end
