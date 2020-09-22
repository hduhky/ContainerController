//
//  KYDesignButton.m
//  ContainerController
//
//  Created by smb-lsp on 2020/9/22.
//

#import "KYDesignButton.h"

@implementation KYDesignButton

- (instancetype)init {
    self = [super init];
    if (self) {
        _hideAnimation = YES;
        
        _fillColor = UIColor.clearColor;
        
        _gradientOffset = CGPointMake(0, 1);
        
        _cornerRadius = 0.0;
        
        _shadowColor = UIColor.clearColor;
        _shadowOffset = CGSizeZero;
        _shadowRadius = 0.0;
        _shadowOpacity = 0.0;
        
        _borderColor = UIColor.clearColor;
        _borderWidth = 0.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (_gradientColor) {
        CAGradientLayer *glayer = [CAGradientLayer layer];
        glayer.frame = self.bounds;
        glayer.colors = @[(id)_fillColor.CGColor, (id)_gradientColor.CGColor];
        glayer.startPoint = CGPointZero;
        glayer.endPoint = self.gradientOffset;
        glayer.cornerRadius = [self radius];
        [self.layer insertSublayer:glayer atIndex:0];
    } else {
        self.layer.backgroundColor = self.fillColor.CGColor;
    }
    
    self.layer.cornerRadius = [self radius];
    
    self.layer.shadowOffset = self.shadowOffset;
    self.layer.shadowOpacity = (float)self.shadowOpacity / 10.0;
    self.layer.shadowRadius = self.shadowRadius;
    self.layer.shadowColor = self.shadowColor.CGColor;
    
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self selectedLayerShow:YES];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:self];
    CGRect someFrame = self.bounds;
    BOOL highlighted = CGRectContainsPoint(someFrame, point);
    [self selectedLayerShow:highlighted];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self selectedLayerShow:NO];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self selectedLayerShow:NO];
    [super cancelTrackingWithEvent:event];
}

- (CGFloat)radius {
    CGFloat minSize = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat radius = (self.cornerRadius < 0) ? (minSize / 2) : self.cornerRadius;
    return radius;
}

- (void)selectedLayerShow:(BOOL)show {
    if (self.hideAnimation) {
        [self selectAnimationHide:show];
    } else {
        [self selectAnimationShadow:show];
    }
}

- (void)selectAnimationHide:(BOOL)show {
    if (show) {
        self.alpha = 0.5;
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)selectAnimationShadow:(BOOL)show {
    NSInteger tag = 1;
    UIView *view = [self viewWithTag:tag];
    if (show) {
        if (!view) {
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.2];
            view.tag = tag;
            view.layer.cornerRadius = [self radius];
            [self addSubview:view];
        }
    } else {
        if (view) {
            [UIView animateWithDuration:0.35 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

@end
