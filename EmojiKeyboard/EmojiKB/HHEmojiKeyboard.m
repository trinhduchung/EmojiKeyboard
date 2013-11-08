//
//  HHEmojiKeyboard.m
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/7/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import "HHEmojiKeyboard.h"
#import "UIResponder+WriteableInputView.h"
#import "HHEmojiKeyboardCategoryToolView.h"
#import "HHEmojiKeyboardItemGroupView.h"

NSString * const WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification = @"WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification";

CGSize  const WUEmoticonsKeyboardDefaultSize            = (CGSize){320,216};
CGFloat const WUEmoticonsKeyboardToolsViewDefaultHeight = 45;

@interface HHEmojiKeyboard () <UIInputViewAudioFeedback>
@property (nonatomic,weak,readwrite) UIResponder<UITextInput>           *textInput;
@property (nonatomic,weak)           HHEmojiKeyboardCategoryToolView    *toolsView;
@property (nonatomic,weak)           UIImageView                        *backgroundImageView;
@property (nonatomic,strong)         NSArray                            *keyItemGroupViews;
@property (nonatomic,readonly)       CGRect                             keyItemGroupViewFrame;
@end
@implementation HHEmojiKeyboard


#pragma mark - TextInput

- (void)setInputViewToView:(UIView *)view {
    if (self.textInput.isFirstResponder) {
        [self.textInput resignFirstResponder];
        self.textInput.inputView = view;
        [self.textInput becomeFirstResponder];
    }else{
        self.textInput.inputView = view;
    }
}

- (void)attachToTextInput:(UIResponder<UITextInput> *)textInput {
    self.textInput = textInput;
    [self setInputViewToView:self];
}

- (void)switchToDefaultKeyboard {
    [self setInputViewToView:nil];
    self.textInput = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification object:self];
}

#pragma mark - Text Input

- (BOOL)textInputShouldReplaceTextInRange:(UITextRange *)range replacementText:(NSString *)replacementText {
    
    BOOL shouldChange = YES;
    
    NSInteger startOffset = [self.textInput offsetFromPosition:self.textInput.beginningOfDocument toPosition:range.start];
    NSInteger endOffset = [self.textInput offsetFromPosition:self.textInput.beginningOfDocument toPosition:range.end];
    NSRange replacementRange = NSMakeRange(startOffset, endOffset - startOffset);
    
    if ([self.textInput isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView *)self.textInput;
        if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]){
            shouldChange = [textView.delegate textView:textView shouldChangeTextInRange:replacementRange replacementText:replacementText];
        }
    }
    
    if ([self.textInput isKindOfClass:UITextField.class]) {
        UITextField *textField = (UITextField *)self.textInput;
        if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            shouldChange = [textField.delegate textField:textField shouldChangeCharactersInRange:replacementRange replacementString:replacementText];
        }
    }
    
    return shouldChange;
}

- (void)replaceTextInRange:(UITextRange *)range withText:(NSString *)text {
    if (range && [self textInputShouldReplaceTextInRange:range replacementText:text]) {
        [self.textInput replaceRange:range withText:text];
    }
}

- (void)inputText:(NSString *)text {
    [self replaceTextInRange:self.textInput.selectedTextRange withText:text];
}

- (void)backspace {
    if (self.textInput.selectedTextRange.empty) {
        //Find the last thing we may input and delete it. And RETURN
        NSString *text = [self.textInput textInRange:[self.textInput textRangeFromPosition:self.textInput.beginningOfDocument toPosition:self.textInput.selectedTextRange.start]];
        for (HHEmojiKeyboardItemGroup *group in self.keyItemGroups) {
            for (HHEmojiKeyboardItem *item in group.keyItems) {
                if ([text hasSuffix:item.textToInput]) {
                    __block NSUInteger composedCharacterLength = 0;
                    [item.textToInput enumerateSubstringsInRange:NSMakeRange(0, item.textToInput.length)
                                                         options:NSStringEnumerationByComposedCharacterSequences
                                                      usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                                          composedCharacterLength++;
                                                      }];
                    UITextRange *rangeToDelete = [self.textInput textRangeFromPosition:[self.textInput positionFromPosition:self.textInput.selectedTextRange.start offset:-composedCharacterLength] toPosition:self.textInput.selectedTextRange.start];
                    if (rangeToDelete) {
                        [self replaceTextInRange:rangeToDelete withText:@""];
                        return;
                    }
                }
            }
        }
        
        //If we cannot find the text. Do a delete backward.
        UITextRange *rangeToDelete = [self.textInput textRangeFromPosition:self.textInput.selectedTextRange.start toPosition:[self.textInput positionFromPosition:self.textInput.selectedTextRange.start offset:-1]];
        [self replaceTextInRange:rangeToDelete withText:@""];
    } else {
        [self replaceTextInRange:self.textInput.selectedTextRange withText:@""];
    }
}

#pragma mark - create & init

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    if (CGRectIsEmpty(self.bounds)) {
        self.bounds = (CGRect){CGPointZero, WUEmoticonsKeyboardDefaultSize};
    }
    
    self.backgroundColor = [UIColor blackColor];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    HHEmojiKeyboard *__weak weakSelf = self;
    
    self.toolsViewHeight = WUEmoticonsKeyboardToolsViewDefaultHeight;
    
    HHEmojiKeyboardCategoryToolView *toolsView = [[HHEmojiKeyboardCategoryToolView alloc] initWithFrame:self.toolsViewFrame];
    toolsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    [toolsView setKeyItemGroupSelectedBlock:^(HHEmojiKeyboardItemGroup *keyItemGroup) {
        [weakSelf switchToKeyItemGroup:keyItemGroup];
    }];
    
    [self addSubview:toolsView];
    self.toolsView = toolsView;
}

+ (instancetype)keyboard {
    HHEmojiKeyboard *keyboard = [[HHEmojiKeyboard alloc] init];
    return keyboard;
}

#pragma mark - Layout

- (void)setToolsViewHeight:(CGFloat)toolsViewHeight {
    _toolsViewHeight = toolsViewHeight;
    [self setNeedsLayout];
}

- (CGRect)toolsViewFrame {
//    return CGRectMake(0, CGRectGetHeight(self.bounds) - self.toolsViewHeight, CGRectGetWidth(self.bounds), self.toolsViewHeight);
    return CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.toolsViewHeight);
}

- (CGRect)keyItemGroupViewFrame {
//    return CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMinY(self.toolsView.frame));
    return CGRectMake(0, self.toolsViewHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.toolsViewHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolsView.frame = self.toolsViewFrame;
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = self.keyItemGroupViewFrame;
    }];
}

#pragma mark - KeyItems

- (void)setKeyItemGroups:(NSArray *)keyItemGroups {
    _keyItemGroups = [keyItemGroups copy];
    [self reloadKeyItemGroupViews];
    self.toolsView.keyItemGroups = keyItemGroups;
}

- (void)reloadKeyItemGroupViews {
    [self.keyItemGroupViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __weak __typeof(&*self)weakSelf = self;
    self.keyItemGroupViews = nil;
    NSMutableArray *keyItemGroupViews = [NSMutableArray array];
    [self.keyItemGroups enumerateObjectsUsingBlock:^(HHEmojiKeyboardItemGroup *obj, NSUInteger idx, BOOL *stop) {
        HHEmojiKeyboardItemGroupView *keyItemGroupView = [[HHEmojiKeyboardItemGroupView alloc] initWithFrame:weakSelf.keyItemGroupViewFrame];
        keyItemGroupView.keyItemGroup = obj;
        [keyItemGroupView setKeyItemTappedBlock:^(HHEmojiKeyboardItem *keyItem) {
            [weakSelf keyItemTapped:keyItem];
        }];
        [keyItemGroupView setPressedKeyItemCellChangedBlock:^(HHEmojiKeyboardCell *fromCell, HHEmojiKeyboardCell *toCell) {
            if (weakSelf.keyItemGroupPressedKeyCellChangedBlock) {
                weakSelf.keyItemGroupPressedKeyCellChangedBlock(obj,fromCell,toCell);
            }
        }];
        [keyItemGroupViews addObject:keyItemGroupView];
    }];
    self.keyItemGroupViews = [keyItemGroupViews copy];
}

- (void)switchToKeyItemGroup:(HHEmojiKeyboardItemGroup *)keyItemGroup {
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(HHEmojiKeyboardItemGroupView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.keyItemGroup isEqual:keyItemGroup]) {
            obj.frame = self.keyItemGroupViewFrame;
            obj.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview:obj];
            *stop = YES;
        }
    }];
}

- (void)keyItemTapped:(HHEmojiKeyboardItem *)keyItem {
    [self inputText:keyItem.textToInput];
    [UIDevice.currentDevice playInputClick];
}

#pragma mark -
#pragma mark Public methods
- (void)switchToCategoryAtIndex:(NSInteger)index {
    self.toolsView.segmentsBar.selectedSegmentIndex = index;
    [self switchToKeyItemGroup:[self.keyItemGroups objectAtIndex:index]];
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL) enableInputClicksWhenVisible {
    return self.enableStandardSystemKeyboardClickSound;
}

#pragma mark - Apperance

- (void)setBackgroundImage:(UIImage *)image {
    [self.backgroundImageView setImage:image];
}

- (void)setBackgroundImage:(UIImage *)image forKeyItemGroup:(HHEmojiKeyboardItemGroup *)keyItemGroup {
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(HHEmojiKeyboardItemGroupView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.keyItemGroup isEqual:keyItemGroup]) {
            obj.backgroundImageView.image = image;
        }
    }];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forKeyItemGroup:(HHEmojiKeyboardItemGroup *)keyItemGroup {
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(HHEmojiKeyboardItemGroupView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.keyItemGroup isEqual:keyItemGroup]) {
            obj.backgroundImageView.backgroundColor = backgroundColor;
        }
    }];
}

@end

@implementation UIResponder (HHEmojiKeyboard)

- (HHEmojiKeyboard *)emoticonsKeyboard {
    if ([self.inputView isKindOfClass:[HHEmojiKeyboard class]]) {
        return (HHEmojiKeyboard *)self.inputView;
    }
    return nil;
}

- (void)switchToDefaultKeyboard {
    [self.emoticonsKeyboard switchToDefaultKeyboard];
}

- (void)switchToEmoticonsKeyboard:(HHEmojiKeyboard *)keyboard {
    if ([self conformsToProtocol:@protocol(UITextInput)] && [self respondsToSelector:@selector(setInputView:)]) {
        [keyboard attachToTextInput:(UIResponder<UITextInput> *)self];
    }
}

@end
