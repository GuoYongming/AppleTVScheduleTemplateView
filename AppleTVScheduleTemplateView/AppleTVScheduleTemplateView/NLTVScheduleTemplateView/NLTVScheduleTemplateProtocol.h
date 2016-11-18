//
//  NLTVScheduleTemplateProtocol.h
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/15/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NLTVScheduleTemplateViewController;

@protocol NLTVScheduleTemplateProtocol <NSObject>

@required

/**
 Registe a custom UICollectionViewCell.

 @return : a custom UICollectionViewCell.
 */
- (NSString *)scheduleCollectionViewRegistCellName;

/**
 How many outter cell in outter colleciton view.

 @param collectionView : outter colleciton view.

 @return : outter cell number.
 */
- (NSInteger)numbersOfSectionInScheduleTemplateCollectionView:(UICollectionView *)collectionView;

/**
 How many inner cell in outter cell's collectionView.

 @param collectionView : inner collection view.
 @param section        : the outter cell index.

 @return : inner cell number.
 */
- (NSInteger)scheduleTemplateCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

/**
 Must return a custom UICollectionViewCell

 @param collectionView : inner collection view.
 @param outterIndex    : outter cell index.
 @param innerIndexPath : the inner collectionView's cell indexPath.
 @param identifier     : user passed with "-scheduleCollectionViewRegistCellName" method.

 @return : a custom UICollectionViewCell.
 */
- (__kindof UICollectionViewCell *)scheduleTemplateCollectionView:(UICollectionView *)collectionView cellForItemAtOutterIndex:(NSInteger)outterIndex innerIndexPath:(NSIndexPath *)innerIndexPath identifier:(NSString *)identifier;

@optional

/**
 The size of inner collection view cell, the size of outter cell based on the inner cell's size, user do not need to set.

 @param collectionView : inner collection view.
 @param indexPath      : the inner collectionView's cell indexPath.

 @return : the size of inner collection view cell.
 */
- (CGSize)scheduleTemplateCollectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Set edgeInsets of outter collection view.
 Only used for horizontal schedule template view.

 @param collectionView : outter collection view.
 @param section        : outter collection view cell index.

 @return : edgeInsets of outter collection view.
 */
- (UIEdgeInsets)scheduleTemplateCollectionView:(UICollectionView *)collectionView insetForSectionAtIndex:(NSInteger)section;

/**
 When scroll the outter colleciton view, after the animation, this method will be called.
 Only used for horizontal schedule template view.
 
 @param scheduleTemplateView : NLTVScheduleTemplateViewController.
 @param currentDisplayIndex  : the outter collection view cell's index.
 */
- (void)scheduleTemplateView:(NLTVScheduleTemplateViewController *)scheduleTemplateView currentDisplayIndex:(NSInteger)currentDisplayIndex;

/**
 This method will be called when user selecte item.

 @param collectionView : inner collection view.
 @param outterIndex    : outter cell index.
 @param innerIndexPath : inner cell indexPath, just indexPath.item is useful.
 */
- (void)scheduleTemplateCollectionView:(UICollectionView *)collectionView didSelectItemAtOutterIndex:(NSInteger)outterIndex innerIndexPath:(NSIndexPath *)innerIndexPath;

/**
 Must registe a header view for colleciton view.
 Only used for vertical template view.

 @return : registe header name.
 */
- (NSString *)scheduleCollectionViewRegistHeaderName;

/**
 This method only used for vertical template view.

 @param collectionView : outter collection view
 @param indexPath      : indexPath
 @param identifier     : registe header identifier

 @return : UICollectionReusableView for each section
 */
- (UICollectionReusableView *)scheduleTemplateCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier;

/**
 Collection view header size.

 @param collectionView : outter collection view
 @param section        : outter section

 @return : Collection view header size.
 */
-(CGSize)scheduleTemplateCollectionView:(UICollectionView *)collectionView referenceSizeForHeaderInSection:(NSInteger)section;

@end
