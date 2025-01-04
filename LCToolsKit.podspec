Pod::Spec.new do |spec|

  spec.name         = "LCToolsKit"
  spec.version      = "1.0.7"
  spec.summary      = "LCToolsKit is a commonly used tool framework in macOS development"
  spec.description  = <<-DESC
  LCToolsKit is a commonly used tool framework in macOS development！
                   DESC

  spec.homepage     = "https://github.com/DevLiuSir/LCToolsKit"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Marvin" => "93428739@qq.com" }

  spec.swift_versions = ['5.0']
  
  spec.platform = :osx
  
  spec.osx.deployment_target = "10.15"

  spec.source       = { :git => "https://github.com/DevLiuSir/LCToolsKit.git", :tag => "#{spec.version}" }

  spec.subspec 'LCProgressHUD' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCProgressHUD/*.swift'
  end

  spec.subspec 'LCVolumeManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCVolumeManager/*.swift'
  end

  spec.subspec 'LCDistributedNotificationManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCDistributedNotificationManager/*.swift'
  end

  spec.subspec 'LCCFNotificationManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCCFNotificationManager/*.swift'
  end

  spec.subspec 'LCTemperatureUtils' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCTemperatureUtils/*.swift'
  end
  
  spec.subspec 'LCAppReviewManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppReviewManager/*.swift'
  end

  spec.subspec 'LCFileAdministrator' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCFileAdministrator/*.swift'
  end

  spec.subspec 'LCSpeechManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSpeechManager/*.swift'
  end

  spec.subspec 'Extension' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Extension/*.swift'
  end

  spec.subspec 'Other' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Other/*.swift'
  end


end


