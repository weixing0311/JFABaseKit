//
//  AICustomizedMBProgressHud.m
//  AppInstallerGreen
//
//  Created by chengb on 13-10-16.
//
//

#import "AICustomizedMBProgressHud.h"
#import "UIImage+Extension.h"
#import "UIImage+LocalImage.h"

//
//  CustomizedHUD.m
//  AIAntiTheftModel
//
//  Created by chengb on 13-6-21.
//  Copyright (c) 2013年 chenlei. All rights reserved.
//

#import "AICustomizedMBProgressHud.h"

#define WIDTH_HUD      150
#define HEIGHT_HUD     100

@implementation AICustomizedMBProgressHud


+ (AICustomizedMBProgressHud *)showHUDAddedTo:(UIView *)view type:(int)type animated:(BOOL)animated{
    AICustomizedMBProgressHud *hud = [[AICustomizedMBProgressHud alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
    [hud setLabelFont:[UIFont systemFontOfSize:13]];
    switch (type) {
        case AI_HudType_Warning:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage storeImageNamed:@"warningIcon.png"]];
            imageView.frame = CGRectMake(0, 0, 40, 40);
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
        }
            
            break;
            
        case AI_HudType_Info:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage storeImageNamed:@"InfoIcon.png"]];
            imageView.frame = CGRectMake(0, 0, 40, 40);
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
        }
            
            break;
            
        case AI_HudType_Loading:  //the default style
            break;
            
        default:
            break;
    }
    
	return hud;
}




+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
	UIView *viewToRemove = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[AICustomizedMBProgressHud class]]) {
			viewToRemove = v;
		}
	}
	if (viewToRemove != nil) {
		AICustomizedMBProgressHud *HUD = (AICustomizedMBProgressHud *)viewToRemove;
		HUD.removeFromSuperViewOnHide = YES;
		[HUD hide:animated];
		return YES;
	} else {
		return NO;
	}
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define PADDING 5.0f

#define LABELFONTSIZE 16.0f
#define LABELDETAILSFONTSIZE 12.0f

//- (void)layoutSubviews {
//    CGRect frame = self.bounds;
//	
//    // Compute HUD dimensions based on indicator size (add margin to HUD border)
//    CGRect indFrame = indicator.bounds;
//    width = indFrame.size.width + 2 * self.margin;
//    height = indFrame.size.height + 2 * self.margin;
//	
//    // Position the indicator
//    indFrame.origin.x = floorf((frame.size.width - indFrame.size.width) / 2) + self.xOffset;
//    indFrame.origin.y = floorf((frame.size.height - indFrame.size.height) / 2) + self.yOffset;
//    indicator.frame = indFrame;
//	
//    // Add label if label text was set
//    if (nil != self.labelText) {
//        // Get size of label text
//        //       CGSize dims = [self.labelText sizeWithFont:self.labelFont];
//        label.numberOfLines = 2;
//		CGSize dims = self.labelText ? [self.labelText sizeWithFont:self.labelFont constrainedToSize:CGSizeMake(WIDTH_HUD - margin, ceilf(HEIGHT_HUD/2)) lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap]: CGSizeMake(0, 0);
//        
//        // Compute label dimensions based on font metrics if size is larger than max then clip the label width
//        float lHeight = dims.height;
//        float lWidth;
//        if (dims.width <= (frame.size.width - 4 * margin)) {
//            lWidth = dims.width;
//        }
//        else {
//            lWidth = frame.size.width - 4 * margin;
//        }
//		
//        // Set label properties
//        label.font = self.labelFont;
//        label.adjustsFontSizeToFitWidth = NO;
//        label.textAlignment = UITextAlignmentCenter;
//        label.opaque = NO;
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor whiteColor];
//        label.text = self.labelText;
//		
//        // Move indicator to make room for the label
//        indFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2));
//        indicator.frame = indFrame;
//		
//        // Set the label position and dimensions
//        CGRect lFrame = CGRectMake(floorf((frame.size.width - lWidth) / 2) + xOffset,
//                                   floorf(indFrame.origin.y + indFrame.size.height + PADDING),
//                                   lWidth, lHeight);
//        label.frame = lFrame;
//		
//        [self addSubview:label];
//		
//        // Add details label delatils text was set
//        if (nil != self.detailsLabelText) {
//			
//            // Set label properties
//            detailsLabel.font = self.detailsLabelFont;
//            detailsLabel.adjustsFontSizeToFitWidth = NO;
//            detailsLabel.textAlignment = UITextAlignmentCenter;
//            detailsLabel.opaque = NO;
//            detailsLabel.backgroundColor = [UIColor clearColor];
//            detailsLabel.textColor = [UIColor whiteColor];
//            detailsLabel.text = self.detailsLabelText;
//            detailsLabel.numberOfLines = 0;
//            
//			CGFloat maxHeight = frame.size.height - height - 2*margin;
//			CGSize labelSize = detailsLabel.text ? [detailsLabel.text sizeWithFont:detailsLabel.font constrainedToSize:CGSizeMake(frame.size.width - 4*margin, maxHeight) lineBreakMode:detailsLabel.lineBreakMode] : CGSizeMake(0, 0);
//            lHeight = labelSize.height;
//            lWidth = labelSize.width;
//			
//            // Update HUD size
//            if (width < lWidth) {
//                width = lWidth + 2 * margin;
//            }
//            height = height + lHeight + PADDING;
//			
//            // Move indicator to make room for the new label
//            indFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2));
//            indicator.frame = indFrame;
//			
//            // Move first label to make room for the new label
//            lFrame.origin.y -= (floorf(lHeight / 2 + PADDING / 2));
//            label.frame = lFrame;
//			
//            // Set label position and dimensions
//            CGRect lFrameD = CGRectMake(floorf((frame.size.width - lWidth) / 2) + xOffset,
//                                        lFrame.origin.y + lFrame.size.height + PADDING, lWidth, lHeight);
//            detailsLabel.frame = lFrameD;
//			
//            [self addSubview:detailsLabel];
//        }
//    }
//	
//    //	if (square) {
//    //		CGFloat max = MAX(width, height);
//    //		if (max <= frame.size.width - 2*margin) {
//    //			width = max;
//    //		}
//    //		if (max <= frame.size.height - 2*margin) {
//    //			height = max;
//    //		}
//    //	}
//    //
//    //
//    //	if (width < minSize.width) {
//    //		width = minSize.width;
//    //	}
//    //	if (height < minSize.height) {
//    //		height = minSize.height;
//    //	}
//    
//    // Update HUD size
//    width = WIDTH_HUD;
//    height = HEIGHT_HUD;
//}


@end

