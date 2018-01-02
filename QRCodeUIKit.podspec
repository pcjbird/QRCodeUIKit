Pod::Spec.new do |s|
    s.name             = "QRCodeUIKit"
    s.version          = "1.0.0"
    s.summary          = "一款让扫码变得简单的视图控制器"
    s.description      = <<-DESC
    一款让扫码变得简单的视图控制器
    DESC
    s.homepage         = "https://github.com/pcjbird/QRCodeUIKit"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/QRCodeUIKit.git", :tag => s.version.to_s}
    s.social_media_url = 'http://www.lessney.com'
    s.requires_arc     = true
#s.documentation_url = ''
#s.screenshot       = ''

    s.platform         = :ios, '8.0'
    s.frameworks       = 'Foundation', 'UIKit'
#s.preserve_paths   = ''
    s.source_files     = 'QRCodeUIKit/*.{h,m}'
    s.public_header_files = 'QRCodeUIKit/*.{h}'


    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end
