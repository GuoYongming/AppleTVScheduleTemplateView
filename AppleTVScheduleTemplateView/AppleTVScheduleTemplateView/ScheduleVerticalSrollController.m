//
//  ScheduleVerticalSrollController.m
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/14/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import "ScheduleVerticalSrollController.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "NLTVScheduleTemplateViewHeader.h"

@interface ScheduleVerticalSrollController ()<NLTVScheduleTemplateProtocol>
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (nonatomic, strong) NLTVScheduleTemplateViewController *scheduleView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ScheduleVerticalSrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.scheduleView = [[NLTVScheduleTemplateViewController alloc] initVerticalTemplateViewWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, self.view.bounds.size.height - 250) delegate:self];
    self.scheduleView.innerItemMinimumLineSpacing = 48;
    self.scheduleView.outterItemVerticalSpacing = 60;
    [self.view addSubview:self.scheduleView.view];
    [self addChildViewController:self.scheduleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timerAction2) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

- (void)timerAction2
{
    [self.scheduleView reloadData];
}

- (void)initData
{
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        int number = (arc4random() % 31) + 20;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int j = 0; j < number; j++) {
            [tempArray addObject:[NSString stringWithFormat:@"This is number %d",j]];
        }
        [self.dataArray addObject:tempArray];
    }
}

#pragma mark - NLTVScheduleTemplateProtocol
- (NSString *)scheduleCollectionViewRegistCellName
{
    return @"CollectionViewCell";
}

- (NSInteger)numbersOfSectionInScheduleTemplateCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (NSInteger)scheduleTemplateCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (__kindof UICollectionViewCell *)scheduleTemplateCollectionView:(UICollectionView *)collectionView cellForItemAtOutterIndex:(NSInteger)outterIndex innerIndexPath:(NSIndexPath *)innerIndexPath identifier:(NSString *)identifier
{
    NSArray *array = self.dataArray[outterIndex];
    NSString *titleString = array[innerIndexPath.item];
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:innerIndexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"Section %ld\n\n%@",outterIndex, titleString];
    return cell;
}

- (CGSize)scheduleTemplateCollectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 250);
}

- (void)scheduleTemplateCollectionView:(UICollectionView *)collectionView didSelectItemAtOutterIndex:(NSInteger)outterIndex innerIndexPath:(NSIndexPath *)innerIndexPath
{
    self.displayLabel.text = [NSString stringWithFormat:@"Section %ld, number %ld",outterIndex, innerIndexPath.item];
}

- (NSString *)scheduleCollectionViewRegistHeaderName
{
    return @"CollectionReusableView";
}

- (UICollectionReusableView *)scheduleTemplateCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier
{
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        header.titleLabel.text = [NSString stringWithFormat:@"Section header %ld",indexPath.section];
        return header;
    }
    return nil;
}

-(CGSize)scheduleTemplateCollectionView:(UICollectionView *)collectionView referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 44);
}


@end
