Pod::Spec.new do |s|
  s.name         = 'Ethanol'
  s.version      = '0.0.7'
  s.summary      = 'An internal library for Fueled.'
  s.homepage     = 'https://github.com/Fueled/ethanol-ios'
  s.license      = { :type => 'Custom', :text => 'Copyright (C) 2013 Fuleld. All Rights Reserved.' }
  s.author       = { 'cmm-fueled' => 'cameron@fueled.com' }
  s.source       = { :git => 'https://github.com/Fueled/ethanol-ios.git', :branch => 'refactor' }
  s.platform     = :ios, '6.0'
  s.source_files = 'Ethanol/*.{h,m}'
  s.requires_arc = true
end
