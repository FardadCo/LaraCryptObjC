
Pod::Spec.new do |s|
s.name             = 'LaraCryptObjC'
s.version          = '0.1.0'
s.summary          = 'Laravel encryption(LaraCryptObjC) method for Objective C.'



s.description      = <<-DESC
Laravel encryption method with using AES-256-CBC and base64 key for Objective C.
DESC

s.homepage         = 'https://github.com/FardadCo/LaraCryptObjC'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'FardadCo' => 'developers@fardad.co' }
s.source           = { :git => 'https://github.com/FardadCo/LaraCryptObjC.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.social_media_url = 'https://twitter.com/fardadco'
s.source_files  = 'LaraCryptObjC/Classes/**/*'

end
