//
//  HHEmojiKeyboardItemGroupView.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHEmojiKeyboardItem.h"
#import "HHEmojiKeyboardCell.h"
#import "HHEmojiKeyboardItemGroup.h"

@interface HHEmojiKeyboardItemGroupView : UIView
@property (nonatomic,strong) HHEmojiKeyboardItemGroup *keyItemGroup;
@property (nonatomic,copy)   void(^keyItemTappedBlock)(HHEmojiKeyboardItem *keyItem);
@property (nonatomic,copy)   void(^pressedKeyItemCellChangedBlock)(HHEmojiKeyboardCell *fromKeyCell, HHEmojiKeyboardCell *toKeyCell);
@property (nonatomic,weak,readonly) UIImageView *backgroundImageView;
@end
