//
//  HHDemoKeyboardBuilder.m
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/7/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import "HHDemoKeyboardBuilder.h"
#import "HHKeyboardPressedCellPopupView.h"
#import "HHEmojiKeyboardCell.h"
#import "HHEmojiKeyboardTextKeyCell.h"
#import "HHEmojiKeyboardItem.h"

@implementation HHDemoKeyboardBuilder
+ (HHEmojiKeyboard *)sharedEmoticonsKeyboard {
    static HHEmojiKeyboard *_sharedEmoticonsKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //create a keyboard of default size
        HHEmojiKeyboard *keyboard = [HHEmojiKeyboard keyboard];
        
        //Icon keys
        NSDictionary *customIcons = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CustomEmojisList" ofType:@"plist"]];
        NSMutableArray *cuscomFaceKeyItems = [NSMutableArray array];
        for (NSArray *arrObj in customIcons.allValues) {
            HHEmojiKeyboardItem *keyItem = [[HHEmojiKeyboardItem alloc] init];
            NSString *text = [arrObj objectAtIndex:0];
            NSString *image = [arrObj objectAtIndex:1];
            
            keyItem.title = text;
            keyItem.textToInput = text;
            keyItem.image = [UIImage imageNamed:image];
            
            [cuscomFaceKeyItems addObject:keyItem];
        }
        //Icon key group
        HHEmojiKeyboardKeyPageFlowLayout *iconsLayout = [[HHEmojiKeyboardKeyPageFlowLayout alloc] init];
        iconsLayout.itemSize = CGSizeMake(40, 40);
        iconsLayout.itemSpacing = 0;
        iconsLayout.lineSpacing = 0;
        iconsLayout.pageContentInsets = UIEdgeInsetsMake(0,0,0,0);
        
        HHEmojiKeyboardItemGroup *imageIconsGroup = [[HHEmojiKeyboardItemGroup alloc] init];
        imageIconsGroup.keyItems = cuscomFaceKeyItems;
        imageIconsGroup.keyItemsLayout = iconsLayout;
        imageIconsGroup.image = [UIImage imageNamed:@"face_n"];
        imageIconsGroup.selectedImage = [UIImage imageNamed:@"face_s"];
        
        //Default icon key group
            //Text keys
        NSDictionary *emojis = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"]];
        NSArray * faceIcons = [emojis objectForKey:@"Nature"];
        NSMutableArray *faceKeyItems = [NSMutableArray array];
        for (NSString *text in faceIcons) {
            HHEmojiKeyboardItem *keyItem = [[HHEmojiKeyboardItem alloc] init];
            keyItem.title = text;
            keyItem.textToInput = text;
            [faceKeyItems addObject:keyItem];
        }
            //icon key group
        HHEmojiKeyboardKeyPageFlowLayout *faceIconsLayout = [[HHEmojiKeyboardKeyPageFlowLayout alloc] init];
        faceIconsLayout.itemSize = CGSizeMake(40, 40);
        faceIconsLayout.itemSpacing = 0;
        faceIconsLayout.lineSpacing = 0;
        faceIconsLayout.pageContentInsets = UIEdgeInsetsMake(0,0,0,0);
        
        HHEmojiKeyboardItemGroup *faceIconsGroup = [[HHEmojiKeyboardItemGroup alloc] init];
        faceIconsGroup.keyItems = faceKeyItems;
        faceIconsGroup.keyItemsLayout = faceIconsLayout;
        faceIconsGroup.keyItemCellClass = [HHEmojiKeyboardTextKeyCell class];
        faceIconsGroup.image = [UIImage imageNamed:@"face_n"];
        faceIconsGroup.selectedImage = [UIImage imageNamed:@"face_s"];
        
        //Text keys
        NSArray *textKeys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmotionTextKeys" ofType:@"plist"]];
        
        NSMutableArray *textKeyItems = [NSMutableArray array];
        for (NSString *text in textKeys) {
            HHEmojiKeyboardItem *keyItem = [[HHEmojiKeyboardItem alloc] init];
            keyItem.title = text;
            keyItem.textToInput = text;
            [textKeyItems addObject:keyItem];
        }
        //Text key group
        HHEmojiKeyboardKeyPageFlowLayout *textIconsLayout = [[HHEmojiKeyboardKeyPageFlowLayout alloc] init];
        textIconsLayout.itemSize = CGSizeMake(80, 142 / 3.0);
        textIconsLayout.itemSpacing = 0;
        textIconsLayout.lineSpacing = 0;
        textIconsLayout.pageContentInsets = UIEdgeInsetsMake(0,0,0,0);
        
        HHEmojiKeyboardItemGroup *textIconsGroup = [[HHEmojiKeyboardItemGroup alloc] init];
        textIconsGroup.keyItems = textKeyItems;
        textIconsGroup.keyItemsLayout = textIconsLayout;
        textIconsGroup.keyItemCellClass = [HHEmojiKeyboardTextKeyCell class];
        textIconsGroup.image = [UIImage imageNamed:@"characters_n"];
        textIconsGroup.selectedImage = [UIImage imageNamed:@"characters_s"];
        
        //Set keyItemGroups
        keyboard.keyItemGroups = @[imageIconsGroup, faceIconsGroup, textIconsGroup];
        
        //Setup cell popup view
        [keyboard setKeyItemGroupPressedKeyCellChangedBlock:^(HHEmojiKeyboardItemGroup *keyItemGroup, HHEmojiKeyboardCell *fromCell, HHEmojiKeyboardCell *toCell) {
            [HHDemoKeyboardBuilder sharedEmotionsKeyboardKeyItemGroup:keyItemGroup pressedKeyCellChangedFromCell:fromCell toCell:toCell];
        }];
        
        //Keyboard appearance - should do later
        /*
        //Custom text icons scroll background
        UIView *textGridBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [textIconsLayout collectionViewContentSize].width, [textIconsLayout collectionViewContentSize].height)];
        textGridBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textGridBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyboard_grid_bg"]];
        [textIconsLayout.collectionView addSubview:textGridBackgroundView];
         */
        
        //Keyboard background
        [keyboard setBackgroundImage:[[UIImage imageNamed:@"keyboard_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
        
        _sharedEmoticonsKeyboard = keyboard;
    });
    return _sharedEmoticonsKeyboard;
}

+ (void)sharedEmotionsKeyboardKeyItemGroup:(HHEmojiKeyboardItemGroup *)keyItemGroup
             pressedKeyCellChangedFromCell:(HHEmojiKeyboardCell *)fromCell
                                    toCell:(HHEmojiKeyboardCell *)toCell
{
    //Should do later
    /*
    static HHKeyboardPressedCellPopupView *pressedKeyCellPopupView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pressedKeyCellPopupView = [[HHKeyboardPressedCellPopupView alloc] initWithFrame:CGRectMake(0, 0, 83, 110)];
        pressedKeyCellPopupView.hidden = YES;
        [[self sharedEmoticonsKeyboard] addSubview:pressedKeyCellPopupView];
    });
    
    if ([[self sharedEmoticonsKeyboard].keyItemGroups indexOfObject:keyItemGroup] == 0) {
        [[self sharedEmoticonsKeyboard] bringSubviewToFront:pressedKeyCellPopupView];
        if (toCell) {
            pressedKeyCellPopupView.keyItem = toCell.keyItem;
            pressedKeyCellPopupView.hidden = NO;
            CGRect frame = [[self sharedEmoticonsKeyboard] convertRect:toCell.bounds fromView:toCell];
            pressedKeyCellPopupView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)-CGRectGetHeight(pressedKeyCellPopupView.frame)/2);
        }else{
            pressedKeyCellPopupView.hidden = YES;
        }
    }
     */
    
    NSLog(@"text = %@", toCell.keyItem.textToInput);
}
@end
