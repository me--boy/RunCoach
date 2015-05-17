//
//  NoteCell.m
//  BillsMonitor
//
//  Created by  YQ006 on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteCell.h"
#import "NoteViewController.h"

const float label_left = 10.0;
const float label_up = 5.0;
const float max_height = 70.0;
const float min_height = 44.0;
const float accessoryRight = 310;

@implementation NoteCell
@synthesize editedKey;
@synthesize editedObject;

+ (CGFloat) height {
    return max_height;
}

+ (NSString *) identifier {
    return @"NoteCell";
}

- (CGFloat) noteCellHeight {
    return label_up * 2 + noteLabel.frame.size.height;
}

- (NSString *) string {
    return noteLabel.text;
}

- (void) setString:(NSString *)string {
    noteLabel.text = string;
    float height = [noteLabel.text sizeWithFont:noteLabel.font constrainedToSize:CGSizeMake(noteLabel.frame.size.width, max_height - 2 * label_up)].height;
    float mix_height = min_height - 2 * label_up;
    CGRect frame = noteLabel.frame;
    frame.size.height = height < mix_height ? mix_height : height;
    noteLabel.frame = frame;
}

- (NoteViewController *) noteViewController {
    if (noteViewController == nil ) {
        noteViewController = [[NoteViewController alloc] initWithDefaultString:self.string];
        noteViewController.delegate = self;
        
    }
    return noteViewController;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier 
    tableViewStyle:(UITableViewStyle)tbStyle {
    self = [super initWithStyle:UITableViewCellStyleValue1 
        reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        noteLabel = [[UILabel alloc] initWithFrame:
            CGRectMake(label_left, label_up, accessoryRight - label_left, 0)];
        float font_s = 14.0;
        noteLabel.font = [UIFont systemFontOfSize:font_s];
        noteLabel.minimumFontSize = font_s - 2;
        noteLabel.textColor = [UIColor whiteColor];
        noteLabel.adjustsFontSizeToFitWidth = YES;
        noteLabel.numberOfLines = 0;
        noteLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:noteLabel];
        [self setBackgroundColor:kTableCellBackgroundColor];
        
        self.string = @"";
    }
    return self;
}

- (void) noteChanged:(NSString *)note {
    self.string = note;
    if ([self.editedObject respondsToSelector:@selector(noteChanged:)]) {
        [self.editedObject noteChanged:note];
    }
}

@end
