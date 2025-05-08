Pod::Spec.new do |spec|

  spec.name         = "LCToolsKit"
  spec.version      = "1.1.0"
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

  
  spec.subspec 'LCActivityIndicatorManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCActivityIndicatorManager/*.swift'
  end

  spec.subspec 'LCAESEncryptManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAESEncryptManager/*.swift'
  end

  spec.subspec 'LCAppearanceManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppearanceManager/*.swift'
  end

  spec.subspec 'LCCursorManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCCursorManager/*.swift'
  end

  spec.subspec 'LCAppRatingManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppRatingManager/*.swift'
  end

  spec.subspec 'LCAppReviewManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppReviewManager/*.swift'
  end
  
  spec.subspec 'LCDateManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCDateManager/*.swift'
  end

  spec.subspec 'LCOpenPanelManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCOpenPanelManager/*.swift'
  end

  spec.subspec 'LCFileAdministrator' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCFileAdministrator/*.swift'
  end

  spec.subspec 'LCLogFileManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCLogFileManager/*.swift'
  end

  spec.subspec 'LCProgressHUD' do |ss|
  ss.source_files  = 'Sources/LCToolsKit/LCProgressHUD/*.swift'
  ss.resource      = 'Sources/LCToolsKit/LCProgressHUD/Resources/*'
  end
  
  spec.subspec 'LCSpeechManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSpeechManager/*.swift'
  end

  spec.subspec 'LCTemperatureUtils' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCTemperatureUtils/*.swift'
  end

  spec.subspec 'LCURLManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCURLManager/*.swift'
  end

  spec.subspec 'LCVolumeManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCVolumeManager/*.swift'
  end
  
  spec.subspec 'Extension' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Extension/*.swift'
  end

  spec.subspec 'Other' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Other/*.swift'
  end


end


