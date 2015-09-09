//
//  AIDetailBrief.m
//  AppInstallerGreen
//
//  Created by feng.lipeng on 14-6-26.
//
//

#import "AIDetailBrief.h"

@interface AIDetailBrief () {
    BOOL _clicked;
}
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@end

@implementation AIDetailBrief

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeTapGesture:)];
        self.tapGesture = tapGesture;
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}

-(void)setTitle:(NSString *)title {
    if (!self.line) {
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, .5f)];
        self.line.backgroundColor = [UIColor colorWithRed:0xc9 / 255.0f green:0xc9 / 255.0f blue:0xc9 / 255.0f alpha:.8];
        self.line.autoresizingMask = self.line.autoresizingMask | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.line];
    }
    self.titleLab.textColor = [UIColor colorForHex:@"#333333"];
    self.titleLab.text = title;
}

-(void)setDesStr:(NSString *)des show:(BOOL)show{
    self.desLab.numberOfLines = 0;
    if (show) {
        self.desLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    else {
        self.desLab.lineBreakMode = 0;
    }
    self.desLab.font = [UIFont systemFontOfSize:12.0];
    self.desLab.textColor = [UIColor colorForHex:@"#666666"];
    [self.desLab setBackgroundColor:[UIColor clearColor]];
    self.desLab.text = des;
    if (!show) {
        [self.desLab sizeToFit];
    }
}

- (void)setDateStr:(NSString*)dateStr {
    if (dateStr) {
        self.upgradeLab.text = [NSString stringWithFormat:@"(%@)",dateStr];
        self.upgradeLab.textColor = [UIColor colorForHex:@"#999999"];
    }
    else {
        self.upgradeLab.text = @"";
    }
}

-(void)setButtonUI:(BOOL)show more:(BOOL)more {
    if (show) {
        self.moreBtn.hidden = NO;
        UIImage* image = nil;
        if (more) {
            self.moreBtn.frame = CGRectMake(JFA_SCREEN_WIDTH - 50, 0, 50, 40);
            image = [UIImage storeImageNamed:@"detail_more"];
            
        }
        else {
            self.moreBtn.frame = CGRectMake(JFA_SCREEN_WIDTH - 50, [self getHeight] - 20, 50, 40);
            image = [UIImage storeImageNamed:@"detail_less"];
        }
        [self.moreBtn setImage:image forState:UIControlStateNormal];
    }
    else {
        [self removeGestureRecognizer:self.tapGesture];
        self.tapGesture = nil;
        self.moreBtn.hidden = YES;
    }
}

-(CGFloat)getHeight {
    UILabel* tmplab = [[UILabel alloc] initWithFrame:self.desLab.frame];
    tmplab.numberOfLines = 0;
    tmplab.lineBreakMode = 0;
    tmplab.font = [UIFont systemFontOfSize:12.0];
    
    tmplab.text = self.desLab.text;
    [tmplab sizeToFit];
    DLog(@"%@",NSStringFromCGRect(tmplab.frame));
//    CGSize size = [tmplab sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
//    DLog(@"str : %@ ,height : %f",self.desLab.attributedText,tmplab.frame.size.height);
    return tmplab.frame.size.height + 32 + 10;
}

-(CGFloat)getShortHeight {
    UILabel* tmplab = [[UILabel alloc] initWithFrame:self.desLab.frame];
    tmplab.numberOfLines = 7;
    tmplab.lineBreakMode = 0;
    tmplab.font = [UIFont systemFontOfSize:12.0];
    
    tmplab.text = self.desLab.text;
    [tmplab sizeToFit];
    DLog(@"%@",NSStringFromCGRect(tmplab.frame));
    //    CGSize size = [tmplab sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    //    DLog(@"str : %@ ,height : %f",self.desLab.attributedText,tmplab.frame.size.height);
    return tmplab.frame.size.height;
}

-(void)setHeight:(CGFloat)height {
    self.desLab.frame = CGRectMake(self.desLab.frame.origin.x, 32, self.frame.size.width - 2*self.desLab.frame.origin.x, height - 32 - 10);
}

-(void)recognizeTapGesture:(UIGestureRecognizer*)g {
    [self btnPressed:self.moreBtn];
}

-(IBAction)btnPressed:(UIButton*)button {
    if (_clicked) {
        return;
    }
    _clicked = YES;
    if (self.delegate) {
        [self.delegate onDetailBriefSelectedAt:self.tag more:(BOOL)button.tag];
    }
    button.tag = 1 - button.tag;
    [self setButtonUI:YES more:(BOOL)button.tag];
    [self performSelector:@selector(clickDone) withObject:nil afterDelay:.5];
}

-(void)clickDone {
    _clicked = NO;
}

//- (NSAttributedString *)attributedString:(NSString*)tmpStr
//{
//    if (tmpStr.length == 0) {
//        return nil;
//    }
//    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:tmpStr];
//    if (!IOS6_EARLY) {
//        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 6.0;
//        paragraphStyle.firstLineHeadIndent = 24.0;
//        [attriStr setAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attriStr.string.length)];
//        UIFont * font = [UIFont systemFontOfSize:12.0];
//        [attriStr setAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, attriStr.string.length)];
//    } else {
//        
//        int sf = sizeof(CGFloat);
//        CGFloat lineSpacing = 6.0;
//        CGFloat firstLineIndent = 24.0;
//        CTParagraphStyleSetting settings[2] =
//        {
//            { kCTParagraphStyleSpecifierLineSpacing, sf, &lineSpacing},
//            { kCTParagraphStyleSpecifierFirstLineHeadIndent, sf, &firstLineIndent},
//        };
//        
//        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
//        [attriStr addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:NSMakeRange(0, attriStr.string.length)];
//        CFRelease(paragraphStyle);
//        
//    }
//    return attriStr;
//}

-(void)dealloc {
    if (self.tapGesture) {
        [self removeGestureRecognizer:self.tapGesture];
    }
    
}


@end
