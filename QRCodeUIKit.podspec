Pod::Spec.new do |s|
    s.name             = "QRCodeUIKit"
    s.version          = "1.2.5"
    s.summary          = "一款让扫码变得简单的视图控制器"
    s.description      = <<-DESC
    一款让扫码变得简单的视图控制器,支持 二维码/条码 扫描，可无需一行代码快速集成。
    DESC
    s.homepage         = "https://github.com/pcjbird/QRCodeUIKit"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/QRCodeUIKit.git", :tag => s.version.to_s}
    s.social_media_url = 'http://www.lessney.com'
    s.requires_arc     = true
#s.documentation_url = ''
#s.screenshot       = ''

    s.platform         = :ios, '10.0'
    s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'AVFoundation', 'CoreImage', 'Photos'
#s.preserve_paths   = ''
    s.source_files     = 'QRCodeUIKit/*.{h,m}', 'QRCodeUIKit/Categories/*.{h,m}'
    s.public_header_files = 'QRCodeUIKit/*.{h}'

    s.resource_bundles = {
        'QRCodeUIKit' => ['QRCodeUIKitBundle/*.{png,lproj}'],
    }

    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

    s.subspec 'QuickTextQRResultController' do |ss|
        ss.source_files = 'QRCodeUIKit/QuickTextQRResultController/*.{h,m}', 'QRCodeUIKit/Categories/*.{h,m}'
        ss.public_header_files = 'QRCodeUIKit/QuickTextQRResultController/QuickTextQRResultController.h'
        ss.dependency 'TTTAttributedLabel'
    end

    s.subspec 'QuickQRCodeScanController' do |ss|
        ss.source_files = 'QRCodeUIKit/QuickQRCodeScanController/*.{h,m}', 'QRCodeUIKit/QuickQRCodeScanController/UI', 'QRCodeUIKit/Categories/*.{h,m}'
        ss.public_header_files = 'QRCodeUIKit/QuickQRCodeScanController/QuickQRCodeScanController.h', 'QRCodeUIKit/QuickQRCodeScanController/QuickQRCodeScanResultHandler.h', 'QRCodeUIKit/QuickQRCodeScanController/UI/QuickQRCodeScanViewStyle.h'
        ss.dependency 'Toast'
        ss.dependency 'QRCodeUIKit/QuickTextQRResultController'
        ss.dependency 'ZXingObjC'
        ss.dependency 'QMUIKit/QMUIComponents/QMUIFillButton'
    end

    s.subspec 'QuickBarCodeScanController' do |ss|
        ss.source_files = 'QRCodeUIKit/QuickBarCodeScanController/*.{h,m}'
        ss.public_header_files = 'QRCodeUIKit/QuickBarCodeScanController/QuickBarCodeScanController.h'
        ss.dependency 'QRCodeUIKit/QuickQRCodeScanController'
    end

    s.subspec 'QuickQRCodeGenerator' do |ss|
        ss.source_files = 'QRCodeUIKit/QuickQRCodeGenerator/*.{h,m}'
        ss.public_header_files = 'QRCodeUIKit/QuickQRCodeGenerator/QuickQRCodeGenerator.h'
    end

    s.subspec 'QuickBarCodeGenerator' do |ss|
        ss.source_files = 'QRCodeUIKit/QuickBarCodeGenerator/*.{h,m}'
        ss.public_header_files = 'QRCodeUIKit/QuickBarCodeGenerator/QuickBarCodeGenerator.h'
    end

    s.subspec 'QuickQRCodeDetector' do |ss|
        ss.source_files = 'QRCodeUIKit/QuickQRCodeDetector/*.{h,m}'
        ss.public_header_files = 'QRCodeUIKit/QuickQRCodeDetector/QuickQRCodeDetector.h'
        ss.dependency 'ZXingObjC'
    end

end
