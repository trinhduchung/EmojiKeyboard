//
//  HHEmojiKeyboardCategoryToolView.m
//  EmojiKeyboard
//
//  Created by Hung Trinh on 11/7/13.
//  Copyright (c) 2013 Hung Trinh. All rights reserved.
//

#import "HHEmojiKeyboardCategoryToolView.h"

#define DEFAULT_SELECTED_SEGMENT 0

@interface HHEmojiKeyboardCategoryToolView()
//@property (nonatomic, retain) UISegmentedControl *segmentsBar;
@end
@implementation HHEmojiKeyboardCategoryToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.segmentsBar = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        self.segmentsBar.segmentedControlStyle = UISegmentedControlStyleBar;
        
        self.segmentsBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self.segmentsBar setDividerImage:[UIImage imageNamed:@"icons_bg_separator.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.segmentsBar setDividerImage:[UIImage imageNamed:@"corner_left.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self.segmentsBar setDividerImage:[UIImage imageNamed:@"corner_right.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.segmentsBar setBackgroundImage:[UIImage imageNamed:@"unselected_center_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.segmentsBar setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        [self.segmentsBar addTarget:self action:@selector(categoryChangedViaSegmentsBar:) forControlEvents:UIControlEventValueChanged];
//        [self setSelectedCategoryImageInSegmentControl:self.segmentsBar AtIndex:DEFAULT_SELECTED_SEGMENT];
        self.segmentsBar.selectedSegmentIndex = DEFAULT_SELECTED_SEGMENT;
        [self addSubview:self.segmentsBar];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.segmentsBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)categoryChangedViaSegmentsBar:(UISegmentedControl *)sender {
    [self.keyItemGroups enumerateObjectsUsingBlock:^(HHEmojiKeyboardItemGroup *obj, NSUInteger idx, BOOL *stop) {
        if (obj.image) {
            if (obj.selectedImage && (NSInteger)idx == self.segmentsBar.selectedSegmentIndex) {
                [self.segmentsBar setImage:obj.selectedImage forSegmentAtIndex:idx];
            } else {
                [self.segmentsBar setImage:obj.image forSegmentAtIndex:idx];
            }
        } else {
            [self.segmentsBar setTitle:obj.title forSegmentAtIndex:idx];
        }
    }];
    if (self.keyItemGroupSelectedBlock) {
        HHEmojiKeyboardItemGroup *selectedKeyItemGroup = [self.keyItemGroups objectAtIndex:self.segmentsBar.selectedSegmentIndex];
        self.keyItemGroupSelectedBlock(selectedKeyItemGroup);
    }
}

- (void)setKeyItemGroups:(NSArray *)keyItemGroups {
    _keyItemGroups = keyItemGroups;
    [self.segmentsBar removeAllSegments];
    [self.keyItemGroups enumerateObjectsUsingBlock:^(HHEmojiKeyboardItemGroup *obj, NSUInteger idx, BOOL *stop) {
        if (obj.image) {
            [self.segmentsBar insertSegmentWithImage:obj.image atIndex:self.segmentsBar.numberOfSegments animated:NO];
        }else{
            [self.segmentsBar insertSegmentWithTitle:obj.title atIndex:self.segmentsBar.numberOfSegments animated:NO];
        }
    }];
    if (self.segmentsBar.numberOfSegments) {
        self.segmentsBar.selectedSegmentIndex = 0;
        [self categoryChangedViaSegmentsBar:self.segmentsBar];
    }
}


@end
