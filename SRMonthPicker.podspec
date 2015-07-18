Pod::Spec.new do |s|
  s.name             = "SRMonthPicker"
  s.version          = "0.2.10"
  s.summary          = "Like UIDatePicker, but without the days"
  s.homepage         = "https://github.com/simonrice/SRMonthPicker"
  s.screenshots      =  "https://raw.githubusercontent.com/simonrice/SRMonthPicker/master/Doc/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "Simon Rice" => "im@simonrice.com" }
  s.source           = { :git => "https://github.com/simonrice/SRMonthPicker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_simonrice'

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
