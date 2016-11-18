//
//  NLTVScheduleTemplateViewController.m
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/10/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import "NLTVScheduleTemplateViewController.h"
#import "NLTVScheduleTemplateHorizontalCell.h"
#import "NLTVScheduleTemplateVerticalCell.h"
#import "UIView+NLTVScheduleTemplateCellHelper.h"

typedef enum {
    NLTVScheduleTemplateHorizontal = 0,
    NLTVScheduleTemplateVertical
}NLTVScheduleTemplateDirection;


@interface NLTVScheduleTemplateViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) id<NLTVScheduleTemplateProtocol> delegate;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, assign) CGRect templateViewFrame;
@property (nonatomic, assign) NLTVScheduleTemplateDirection templateDirection;
@property (nonatomic, assign) NSInteger currentScrollIndex;
@property (nonatomic, copy) NSString *registHeaderViewClass;
@property (nonatomic, strong) NSNumber *outterIndex;
@property (nonatomic, strong) NSNumber *innerIndex;
@end

@implementation NLTVScheduleTemplateViewController

- (instancetype)initHorizontalTemplateViewWithFrame:(CGRect)frame delegate:(id<NLTVScheduleTemplateProtocol>)delegate
{
    self = [super init];
    if (self) {
        self.templateViewFrame = frame;
        self.templateDirection = NLTVScheduleTemplateHorizontal;
        self.delegate = delegate;
        self.currentScrollIndex = 0;
    }
    return self;
}

- (instancetype)initVerticalTemplateViewWithFrame:(CGRect)frame delegate:(id<NLTVScheduleTemplateProtocol>)delegate
{
    self = [super init];
    if (self) {
        self.templateViewFrame = frame;
        self.templateDirection = NLTVScheduleTemplateVertical;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = self.templateViewFrame;
    self.view.backgroundColor = [UIColor clearColor];
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else{
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    self.mainCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainCollectionView];
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        self.mainCollectionView.scrollEnabled = NO;
        [self.mainCollectionView registerClass:[NLTVScheduleTemplateHorizontalCell class] forCellWithReuseIdentifier:@"TemplateHorizontalCell"];
    }else{
        self.mainCollectionView.scrollEnabled = YES;
        [self.mainCollectionView registerClass:[NLTVScheduleTemplateVerticalCell class] forCellWithReuseIdentifier:@"TemplateVerticalCell"];
        if ([self.delegate respondsToSelector:@selector(scheduleCollectionViewRegistHeaderName)]) {
            self.registHeaderViewClass = [self.delegate scheduleCollectionViewRegistHeaderName];
            [self.mainCollectionView registerClass:NSClassFromString(self.registHeaderViewClass) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.registHeaderViewClass];
            [self.mainCollectionView registerNib:[UINib nibWithNibName:self.registHeaderViewClass bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.registHeaderViewClass];
        }
        [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableVie"];
    }
    
}

- (void)reloadData
{
    NLTVScheduleTemplateHorizontalCell *cell = (NLTVScheduleTemplateHorizontalCell *)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.currentScrollIndex]];
    [cell reloadData];
}

- (void)scrollCollectionViewAtIndex:(NSInteger)index animated:(BOOL)animated completion:(ScrollCompletionBlock)completion
{
    if (self.templateDirection == NLTVScheduleTemplateVertical) {
        return;
    }
    self.currentScrollIndex = index;
    NSInteger startIndex = 0;
    NSInteger endIndex = 0;
    if ([self.delegate respondsToSelector:@selector(numbersOfSectionInScheduleTemplateCollectionView:)]) {
        endIndex = [self.delegate numbersOfSectionInScheduleTemplateCollectionView:self.mainCollectionView] - 1;
    }
    BOOL isCanPreviousScroll = YES;
    BOOL isCanNextScroll = YES;
    if (index <= startIndex) {
        if (index < startIndex) {
            return;
        }
        isCanPreviousScroll = NO;
    }else if (index >= endIndex) {
        if (index > endIndex) {
            return;
        }
        isCanNextScroll = NO;
    }
    
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
    [self.mainCollectionView scrollToItemAtIndexPath:itemIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    if ([self.delegate respondsToSelector:@selector(scheduleTemplateView:currentDisplayIndex:)]) {
        [self.delegate scheduleTemplateView:self currentDisplayIndex:self.currentScrollIndex];
    }
    completion(isCanPreviousScroll, isCanNextScroll);
}

- (void)scrollCollectionNextItemWithAnimated:(BOOL)animated completion:(ScrollCompletionBlock)completion
{
    if (self.templateDirection == NLTVScheduleTemplateVertical) {
        return;
    }
    NSInteger index = ++self.currentScrollIndex;
    NSInteger endIndex = 0;
    if ([self.delegate respondsToSelector:@selector(numbersOfSectionInScheduleTemplateCollectionView:)]) {
        endIndex = [self.delegate numbersOfSectionInScheduleTemplateCollectionView:self.mainCollectionView] - 1;
    }
    if (index <= endIndex) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.mainCollectionView scrollToItemAtIndexPath:itemIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        completion(YES, index == endIndex ? NO : YES);
    }else{
        self.currentScrollIndex = endIndex;
        completion(YES, NO);
    }
}

- (void)scrollCollectionPreviousItemWithAnimated:(BOOL)animated completion:(ScrollCompletionBlock)completion
{
    if (self.templateDirection == NLTVScheduleTemplateVertical) {
        return;
    }
    NSInteger index = --self.currentScrollIndex;
    NSInteger startIndex = 0;
    if (index >= startIndex) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.mainCollectionView scrollToItemAtIndexPath:itemIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        completion(index == startIndex ? NO : YES, YES);
    }else{
        self.currentScrollIndex = startIndex;
        completion(NO, YES);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.delegate respondsToSelector:@selector(numbersOfSectionInScheduleTemplateCollectionView:)]) {
        return [self.delegate numbersOfSectionInScheduleTemplateCollectionView:collectionView];
    }
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        NLTVScheduleTemplateHorizontalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TemplateHorizontalCell" forIndexPath:indexPath];
        cell.currentCellIndex = @(indexPath.section);
        cell.innerItemMinimumLineSpacing = self.innerItemMinimumLineSpacing;
        cell.innerItemMinimumInteritemSpacing = self.innerItemMinimumInteritemSpacing;
        cell.delegate = self.delegate;
        [cell reloadAllData];
        return cell;
    }else{
        NLTVScheduleTemplateVerticalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TemplateVerticalCell" forIndexPath:indexPath];
        cell.currentCellIndex = @(indexPath.section);
        cell.innerItemMinimumLineSpacing = self.innerItemMinimumLineSpacing;
        cell.innerItemMinimumInteritemSpacing = self.innerItemMinimumInteritemSpacing;
        cell.delegate = self.delegate;
        [cell reloadAllData];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        return nil;
    }else{
        if (kind == UICollectionElementKindSectionHeader) {
            if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:viewForSupplementaryElementOfKind:atIndexPath:identifier:)]) {
                return [self.delegate scheduleTemplateCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath identifier:self.registHeaderViewClass];
            }else{
                return nil;
            }
        }else{
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableVie" forIndexPath:indexPath];
            return footer;
        }
    }
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    }else{
        CGSize size = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:sizeForItemAtIndexPath:)]) {
            size = [self.delegate scheduleTemplateCollectionView:collectionView sizeForItemAtIndexPath:indexPath];
        }else{
            size = CGSizeMake(300, 250);
        }
        return CGSizeMake(collectionView.bounds.size.width, size.height + 40);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        return CGSizeZero;
    }else{
        if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:referenceSizeForHeaderInSection:)]) {
            return [self.delegate scheduleTemplateCollectionView:collectionView referenceSizeForHeaderInSection:section];
        }else{
            return CGSizeZero;
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        return CGSizeZero;
    }else{
        NSInteger number = 0;
        if ([self.delegate respondsToSelector:@selector(numbersOfSectionInScheduleTemplateCollectionView:)]) {
            number = [self.delegate numbersOfSectionInScheduleTemplateCollectionView:collectionView];
        }
        if (section == number - 1) {
            return CGSizeMake(collectionView.bounds.size.width, 60);
        }else{
            return CGSizeMake(collectionView.bounds.size.width, self.outterItemVerticalSpacing);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.templateDirection == NLTVScheduleTemplateHorizontal) {
        if ([self.delegate respondsToSelector:@selector(scheduleTemplateView:currentDisplayIndex:)]) {
            [self.delegate scheduleTemplateView:self currentDisplayIndex:self.currentScrollIndex];
        }
    }
}


@end
