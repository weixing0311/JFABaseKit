Pod::Spec.new do |s|
  s.name         = "JFABaseKit"
  s.version      = "0.0.1"
  s.summary      = "A short description of JFABaseKit."
  s.description  = <<-DESC
                      this project provide all kinds of categories for iOS developer 
                   DESC

  s.homepage     = "https://github.com/weixing0311/JFABaseKit.git"
  s.license      = "MIT"
  s.author             = { "魏星" => "weixing0311@126.com" }
  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.source       = { :git => "https://github.com/weixing0311/JFABaseKit.git" }
  s.source_files  = "JFABaseKitPodFiles", "JFABaseKitPodFiles/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.dependency "AFNetworking"
  s.dependency "MJRefresh"
  s.requires_arc = true
  s.prefix_header_file='JFABaseKitPodFiles/JFABaseKitHeader.h'
end
