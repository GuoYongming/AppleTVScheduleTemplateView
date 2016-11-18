//
//  NLTVScheduleTemplateHorizontalCell.m
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/10/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import "NLTVScheduleTemplateHorizontalCell.h"
#import "UIView+NLTVScheduleTemplateCellHelper.h"

@interface NLTVScheduleTemplateHorizontalCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *registCalss;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

@implementation NLTVScheduleTemplateHorizontalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    self.mainCollectionView.showsHorizontalScrollIndicator = NO;
    self.mainCollectionView.clipsToBounds = NO;
    [self addSubview:self.mainCollectionView];
}

- (void)setDelegate:(id<NLTVScheduleTemplateProtocol>)delegate
{
    if (!_delegate) {
        _delegate = delegate;
    }
    if ([self.delegate respondsToSelector:@selector(scheduleCollectionViewRegistCellName)]) {
        self.registCalss = [self.delegate scheduleCollectionViewRegistCellName];
        self.identifier = self.registCalss;
        [self.mainCollectionView registerClass:NSClassFromString(self.registCalss) forCellWithReuseIdentifier:self.identifier];
        [self.mainCollectionView registerNib:[UINib nibWithNibName:self.registCalss bundle:nil] forCellWithReuseIdentifier:self.identifier];
        ((UICollectionViewFlowLayout *)self.mainCollectionView.collectionViewLayout).minimumLineSpacing = self.innerItemMinimumLineSpacing;
        ((UICollectionViewFlowLayout *)self.mainCollectionView.collectionViewLayout).minimumInteritemSpacing = self.innerItemMinimumInteritemSpacing;
    }
}

- (void)reloadData
{
    [self.mainCollectionView reloadItemsAtIndexPaths:[self.mainCollectionView indexPathsForVisibleItems]];
}

- (void)reloadAllData
{
    [self.mainCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:numberOfItemsInSection:)]) {
        return [self.delegate scheduleTemplateCollectionView:collectionView numberOfItemsInSection:self.currentCellIndex.intValue];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:cellForItemAtOutterIndex:innerIndexPath:identifier:)]) {
        UICollectionViewCell *cell = [self.delegate scheduleTemplateCollectionView:collectionView cellForItemAtOutterIndex:self.currentCellIndex.intValue innerIndexPath:indexPath identifier:self.identifier];
        cell.outterIndex = self.currentCellIndex;
        cell.innerIndex = @(indexPath.item);
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)shouldUpdateFocusInContext:(UIFocusUpdateContext *)context
{
    if ([context.nextFocusedView isKindOfClass:NSClassFromString(self.registCalss)] && [context.previouslyFocusedView isKindOfClass:NSClassFromString(self.registCalss)]) {
        UICollectionViewCell *previousCell = (UICollectionViewCell *)context.previouslyFocusedView;
        UICollectionViewCell *nextCell = (UICollectionViewCell *)context.nextFocusedView;
        if (![previousCell.outterIndex isEqualToNumber:nextCell.outterIndex]) {
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:sizeForItemAtIndexPath:)]) {
        return [self.delegate scheduleTemplateCollectionView:collectionView sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeMake(300, 250);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:insetForSectionAtIndex:)]) {
        return [self.delegate scheduleTemplateCollectionView:collectionView insetForSectionAtIndex:section];
    }
    return UIEdgeInsetsMake(30, 90, 60, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(scheduleTemplateCollectionView:didSelectItemAtOutterIndex:innerIndexPath:)]) {
        [self.delegate scheduleTemplateCollectionView:collectionView didSelectItemAtOutterIndex:self.currentCellIndex.intValue innerIndexPath:indexPath];
    }
}

@end
