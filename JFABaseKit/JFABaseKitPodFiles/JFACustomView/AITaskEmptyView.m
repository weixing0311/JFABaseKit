//
//  AITaskEmptyView.m
//  AppInstallerGreen
//
//  Created by ji gang on 14-1-20.
//
//

#import "AITaskEmptyView.h"
#import "UIImage+Extension.h"
#import "UIImage+LocalImage.h"

@interface AITaskEmptyView ()

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * label;
@end

@implementation AITaskEmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage * image = [UIImage storeImageNamed:@"bg_empty_task.png"];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.label setTextColor:AI_STORE_TEXT_MAINCOLOR];
        [self.label setFont:[UIFont systemFontOfSize:15.0]];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.label];
        
//        [self setBackgroundColor:[UIColor colorForHex:APP_COLOR_3]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.imageView.frame;
    rect.origin.x = self.bounds.size.width/2 - rect.size.width/2;
//    rect.origin.y = 85;
         if (IS_IPHONE5) {
            rect.origin.y = 140;
        }
        else{
            rect.origin.y = 75;
        }
    

    self.imageView.frame = rect;
    
    [self.label sizeToFit];
    CGRect frame = self.label.frame;
    frame.origin.x = (self.bounds.size.width - frame.size.width) / 2;
    frame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 5;
    self.label.frame = frame;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = _text;
    [self layoutSubviews];
}

@end
