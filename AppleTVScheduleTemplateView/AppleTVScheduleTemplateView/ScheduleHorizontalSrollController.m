//
//  ScheduleHorizontalSrollController.m
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/14/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import "ScheduleHorizontalSrollController.h"
#import "CollectionViewCell.h"
#import "NLTVScheduleTemplateViewHeader.h"

@interface ScheduleHorizontalSrollController ()<NLTVScheduleTemplateProtocol>
@property (nonatomic, strong) NLTVScheduleTemplateViewController *scheduleView;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ScheduleHorizontalSrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.scheduleView = [[NLTVScheduleTemplateViewController alloc] initHorizontalTemplateViewWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, self.view.bounds.size.height - 250) delegate:self];
    self.scheduleView.innerItemMinimumInteritemSpacing = 48;
    self.scheduleView.innerItemMinimumLineSpacing = 48;
    
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
    [self.scheduleView scrollCollectionViewAtIndex:5 animated:NO completion:^(BOOL isCanPreviousScroll, BOOL isCanNextScroll) {
        
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timerAction1) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

- (void)timerAction1
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

- (IBAction)scrollToPrevious:(UIButton *)sender {
    typeof(self) weakSelf = self;
    [self.scheduleView scrollCollectionPreviousItemWithAnimated:YES completion:^(BOOL isCanPreviousScroll, BOOL isCanNextScroll) {
        weakSelf.previousButton.enabled = isCanPreviousScroll;
        weakSelf.nextButton.enabled = isCanNextScroll;
    }];
}
- (IBAction)scrollToNext:(UIButton *)sender {
    typeof(self) weakSelf = self;
    [self.scheduleView scrollCollectionNextItemWithAnimated:YES completion:^(BOOL isCanPreviousScroll, BOOL isCanNextScroll) {
        weakSelf.previousButton.enabled = isCanPreviousScroll;
        weakSelf.nextButton.enabled = isCanNextScroll;
    }];
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
    cell.titleLabel.text = [NSString stringWithFormat:@"Page%ld\n\n%@",outterIndex, titleString];
    return cell;
}

- (CGSize)scheduleTemplateCollectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 250);
}

- (UIEdgeInsets)scheduleTemplateCollectionView:(UICollectionView *)collectionView insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 90, 60, 90);
}

- (void)scheduleTemplateView:(NLTVScheduleTemplateViewController *)scheduleTemplateView currentDisplayIndex:(NSInteger)currentDisplayIndex
{
    self.displayLabel.text = [NSString stringWithFormat:@"Page %ld",currentDisplayIndex];
}

- (void)scheduleTemplateCollectionView:(UICollectionView *)collectionView didSelectItemAtOutterIndex:(NSInteger)outterIndex innerIndexPath:(NSIndexPath *)innerIndexPath
{
    self.displayLabel.text = [NSString stringWithFormat:@"Page %ld, number %ld",outterIndex, innerIndexPath.item];
}

@end
