//
//  MemberGradeCenterGrowUpProgressView.h
//  Business
//
//  Created by 梅琰培 on 7/29/19.
//  Copyright © 2019 prince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 会员成长进度条view 进度条加图标
 */
@interface SSCustomProgressView : UIView


typedef void(^SelectedBlock)(NSInteger index,CGFloat width);
//属性
@property(nonatomic,copy) SelectedBlock selectedBlock;

- (void)drawProcessValue;



/**
 当前成长值
 */
@property(nonatomic,assign) NSInteger currentGrowUpValue;

/**
 分段成长值数组
 */
@property(nonatomic,copy) NSArray *growUpValueArray;

/**
 分段成长值文本数组
 */
@property(nonatomic,copy) NSArray *growUpTitleArray;




@end

NS_ASSUME_NONNULL_END
