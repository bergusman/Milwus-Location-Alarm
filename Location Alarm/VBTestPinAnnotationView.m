//
//  VBTestPinAnnotationView.m
//  Location Alarm
//
//  Created by Vitaliy Berg on 2/27/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "VBTestPinAnnotationView.h"
#import <QuartzCore/QuartzCore.h>

#import <objc/runtime.h>
#import <objc/objc.h>


@implementation CALayer (Bingo)

- (void)vbDrawInContext:(CGContextRef)ctx
{
    
}

@end

@implementation VBTestPinAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    self.frame = CGRectMake(0, 0, 30, 40);
    
    self.image = [UIImage imageNamed:@"alarm.marker.on.cover.png"];
    
    UIImageView *cover = [[UIImageView alloc] init];
    cover.image = [UIImage imageNamed:@"alarm.marker.on.cover.png"];
    cover.frame = CGRectMake(0, 0, 30, 40);
    [self addSubview:cover];
    
    
    /*
    SEL nc = @selector(navigationController);
    SEL wcnc = @selector(wc_navigationController);
    method_exchangeImplementations(class_getInstanceMethod(self, nc), class_getInstanceMethod(self, wcnc));
    
    SEL ni = @selector(navigationItem);
    SEL wcni = @selector(wc_navigationItem);
    method_exchangeImplementations(class_getInstanceMethod(self, ni), class_getInstanceMethod(self, wcni));
    */
    
    /*
    object_
    
    method_get
    
    method_getImplementation(<#Method m#>)
    
    method_setImplementation(<#Method m#>, <#IMP imp#>)
    
    self.layer m
    
    self.backgroundColor = [UIColor redColor];
    */
     
    return self;
}


- (void)sizeToFit
{
    
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"%@", self.subviews);
    NSLog(@"%@", self.layer);
    NSLog(@"%@", [self.layer sublayers]);
    NSLog(@"%@", [[self.layer sublayers][0] sublayers]);
    
    //CALayer *l = [self.layer sublayers][0];
    
    //[l removeFromSuperlayer];
    
    //ALayer *[self.layer sublayers][0];
    
    UIView *v = [self valueForKey:@"_pinInternal"];
    
    NSLog(@"%@", v);
    NSLog(@"%@", [v superclass]);
    NSLog(@"%@", [[v superclass] superclass]);
    //NSLog(@"%@", [v subviews]);
    
    NSLog(@"%@", self.layer.contents);
    
    
    
    //[self.layer renderInContext:nil];
    
    //NSLog(@"%@")
   //NSLog(@"%@", self.)
}

/*
+ (Class)layerClass
{
    return [CALayer class];
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
