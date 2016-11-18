//
//  NLTVScheduleTemplateViewController.h
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/10/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLTVScheduleTemplateProtocol.h"

typedef void(^ScrollCompletionBlock)(BOOL isCanPreviousScroll, BOOL isCanNextScroll);

@interface NLTVScheduleTemplateViewController : UIViewController

/**
 Inner collectionvew cell minimumLineSpacing
 Used for both horizontal and vertical template view
 */
@property (nonatomic, assign) CGFloat innerItemMinimumLineSpacing;

/**
 Inner collectionvew cell minimumInteritemSpacing
 Only used for horizontal template view
 */
@property (nonatomic, assign) CGFloat innerItemMinimumInteritemSpacing;

/**
 Outter collection view's outter cell vertical spacing
 Only used for vertical template view
 */
@property (nonatomic, assign) CGFloat outterItemVerticalSpacing;

- (instancetype)initHorizontalTemplateViewWithFrame:(CGRect)frame delegate:(id<NLTVScheduleTemplateProtocol>)delegate;

- (instancetype)initVerticalTemplateViewWithFrame:(CGRect)frame delegate:(id<NLTVScheduleTemplateProtocol>)delegate;

//Only used for horizontal template view
- (void)scrollCollectionViewAtIndex:(NSInteger)index animated:(BOOL)animated completion:(ScrollCompletionBlock)completion;

//Only used for horizontal template view
- (void)scrollCollectionNextItemWithAnimated:(BOOL)animated completion:(ScrollCompletionBlock)completion;

//Only used for horizontal template view
- (void)scrollCollectionPreviousItemWithAnimated:(BOOL)animated completion:(ScrollCompletionBlock)completion;

/**
 Reload data
 Used for both horizontal and vertical template view
 */
- (void)reloadData;

@end
