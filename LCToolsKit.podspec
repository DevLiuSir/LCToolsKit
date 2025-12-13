Pod::Spec.new do |spec|

  spec.name         = "LCToolsKit"
  spec.version      = "1.2.0"
  spec.summary      = "LCToolsKit is a commonly used tool framework in macOS development"
  spec.description  = <<-DESC
  LCToolsKit is a commonly used tool framework in macOS development！
                   DESC

  spec.homepage     = "https://github.com/DevLiuSir/LCToolsKit"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author                 = { "Marvin" => "93428739@qq.com" }

  spec.swift_versions         = ['5.0']
  
  spec.platform               = :osx
  
  spec.osx.deployment_target  = "10.15"

  spec.source                 = { :git => "https://github.com/DevLiuSir/LCToolsKit.git", :tag => "#{spec.version}" }

  
  spec.subspec 'LCActivityIndicatorManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCActivityIndicatorManager/*.swift'
  end

  spec.subspec 'LCAESEncryptManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAESEncryptManager/*.swift'
  end

  spec.subspec 'LCAppearanceManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppearanceManager/*.swift'
  end

  spec.subspec 'LCAppEnvironmentDetector' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppEnvironmentDetector/*.swift'
  end

  spec.subspec 'LCAppKit' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppKit/*.swift'
  end

  spec.subspec 'LCAppRatingManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppRatingManager/*.swift'
  end

  spec.subspec 'LCAppReviewManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAppReviewManager/*.swift'
  end
  
  spec.subspec 'LCAsyncHelper' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCAsyncHelper/*.swift'
  end

  spec.subspec 'LCBaseBox' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCBaseBox/*.swift'
  end

  spec.subspec 'LCControl' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCControl/*.swift'
  end

  spec.subspec 'LCCoordinatesAdministrator' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCCoordinatesAdministrator/*.swift'
  end

  spec.subspec 'LCCursorManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCCursorManager/*.swift'
  end

  spec.subspec 'LCCustomTableRowView' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCCustomTableRowView/*.swift'
  end

  spec.subspec 'LCDateManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCDateManager/*.swift'
  end

  spec.subspec 'LCDiskVolumeManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCDiskVolumeManager/*.swift'
  end

  spec.subspec 'LCFileAdministrator' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCFileAdministrator/*.swift'
  end

  spec.subspec 'LCFileSizeTool' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCFileSizeTool/*.swift'
  end

  spec.subspec 'LCGradientView' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCGradientView/*.swift'
  end

  spec.subspec 'LCKeyboardEvents' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCKeyboardEvents/*.swift'
  end

  spec.subspec 'LCLogFileManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCLogFileManager/*.swift'
  end

  spec.subspec 'LCLoginItemManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCLoginItemManager/*.swift'
  end

  spec.subspec 'LCOpenPanelManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCOpenPanelManager/*.swift'
  end

  spec.subspec 'LCPopoverManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCPopoverManager/*.swift'
  end
  
  spec.subspec 'LCProgressHUD' do |ss|
  ss.source_files  = 'Sources/LCToolsKit/LCProgressHUD/*.swift'
  ss.resource      = 'Sources/LCToolsKit/LCProgressHUD/Resources/*'
  end

  spec.subspec 'LCSavePanelManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSavePanelManager/*.swift'
  end

  spec.subspec 'LCScrollBarPreferenceManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCScrollBarPreferenceManager/*.swift'
  end
  
  spec.subspec 'LCShellManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCShellManager/*.swift'
  end

  spec.subspec 'LCSoundsManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSoundsManager/*.swift'
  end
  
  spec.subspec 'LCSpeechManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSpeechManager/*.swift'
  end

  spec.subspec 'LCStatusItemPositionManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCStatusItemPositionManager/*.swift'
  end

  spec.subspec 'LCSystemPreferencesManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSystemPreferencesManager/*.swift'
  end

  spec.subspec 'LCSystemVersionUtil' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCSystemVersionUtil/*.swift'
  end
  
  spec.subspec 'LCTableViewHelper' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCTableViewHelper/*.swift'
  end

  spec.subspec 'LCTemperatureUtils' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCTemperatureUtils/*.swift'
  end

  spec.subspec 'LCTextField' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCTextField/*.swift'
  end

  spec.subspec 'LCTextHighlighter' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCTextHighlighter/*.swift'
  end

  spec.subspec 'LCURLManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCURLManager/*.swift'
  end

  spec.subspec 'LCUserDefaults' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCUserDefaults/*.swift'
  end

  spec.subspec 'LCWallpaperManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCWallpaperManager/*.swift'
  end
  
  spec.subspec 'LCWindowManager' do |ss|
  ss.source_files = 'Sources/LCToolsKit/LCWindowManager/*.swift'
  end

  spec.subspec 'Extension' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Extension/*.swift'
  end

  spec.subspec 'Other' do |ss|
  ss.source_files = 'Sources/LCToolsKit/Other/*.swift'
  end


end


