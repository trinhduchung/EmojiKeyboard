//
//  HHEmojiKeyboardCategoryToolView.h
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/7/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHEmojiKeyboardItemGroup.h"

@interface HHEmojiKeyboardCategoryToolView : UIView
@property (nonatomic,strong) NSArray *keyItemGroups;
@property (nonatomic,copy)   void    (^keyItemGroupSelectedBlock)(HHEmojiKeyboardItemGroup *keyItemGroup);
@property (nonatomic, retain) UISegmentedControl *segmentsBar;
@end
