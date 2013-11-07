//
//  HHEmojiKeyboardItemGroup.m
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/6/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import "HHEmojiKeyboardItemGroup.h"
#import "HHEmojiKeyboardCell.h"
#import "HHEmojiKeyboardKeyPageFlowLayout.h"

@implementation HHEmojiKeyboardItemGroup
@synthesize keyItemCellClass = _keyItemCellClass;

- (Class)keyItemCellClass {
    if (!_keyItemCellClass) {
        _keyItemCellClass = [HHEmojiKeyboardCell class];
    }
    return _keyItemCellClass;
}

- (UICollectionViewLayout *)keyItemsLayout {
    if (!_keyItemsLayout) {
        HHEmojiKeyboardKeyPageFlowLayout *layout = [[HHEmojiKeyboardKeyPageFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.pageContentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.itemSpacing = 0;
        layout.lineSpacing = 0;
        _keyItemsLayout = layout;
    }
    return _keyItemsLayout;
}

- (void)setKeyItemCellClass:(Class)keyItemCellClass {
    if ([keyItemCellClass isSubclassOfClass:[HHEmojiKeyboardCell class]]) {
        _keyItemCellClass = keyItemCellClass;
    }else{
        NSAssert(NO, @"HHEmojiKeyboardItemGroup: Setting keyItemCellClass - keyItemCellClass must be a subclass of HHEmojiKeyboardCell.class");
    }
}
@end
