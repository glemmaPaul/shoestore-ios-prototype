Pod::Spec.new do |s|
  s.name            = 'Ethanol'
  s.version         = '1.1.0-beta'
  s.summary         = 'An internal library for Fueled.'
  s.homepage        = 'https://github.com/Fueled/ethanol-ios'
  s.license         = { :type => 'Custom', :text => 'Copyright (C) 2013-2014 Fueled. All Rights Reserved.' }
  s.author          = { 'sec-fueled' => 'stephane@fueled.com' }
  s.source          = { :git => 'https://github.com/Fueled/ethanol-ios.git', :branch => 'develop' }
  s.platform        = :ios, '7.0'
  s.requires_arc    = true
  s.default_subspec = 'Core'

  s.subspec 'Common' do |ss|
    ss.source_files    = 'Ethanol/Ethanol.h', 'Ethanol/ETH{Constants,Framework,Injector,PreprocessorUtils}.{h,m}'
    ss.exclude_files   = 'Ethanol/Ethanol[A-Z]+.h'
    ss.resource_bundle = { 'Ethanol' => ['Ethanol/Resources/*.strings', 'Ethanol/Resources/*.png', 'Ethanol/**/*.xib'] }
  end

  s.subspec 'Core' do |ss|
    ss.source_files  = 'Ethanol/**/*.{h,m}'
    ss.exclude_files = 'Ethanol/EthanolTextField.h', 'Ethanol/EthanolPhone.h', 'Ethanol/EthanolFacebook.h', 'Ethanol/EthanolFormatter.h', 'Ethanol/EthanolFormatterPhone.h', 'Ethanol/EthanolValidation.h', 'Ethanol/EthanolValidationPhone.h', 'Ethanol/EthanolContact.h', 'Ethanol/EthanolContactPhone.h', 'Ethanol/EthanolContactFacebook.h', 'Ethanol/EthanolSocialManager.h', 'Ethanol/EthanolSocialManagerFacebook.h', 'Ethanol/EthanolSocialManagerTwitter.h', 'Ethanol/EthanolLMAlertView.h', 'Ethanol/EthanolMRProgress.h', 'Ethanol/EthanolSDWebImage.h', 'Ethanol/EthanolCoreData.h', 'Ethanol/NSManagedObjectContext+AsyncFetchRequest.{h,m}', 'Ethanol/ETH{Constants,Framework,Injector,PreprocessorUtils}.{h,m}', 'Ethanol/ETH*Validator.{h,m}', 'Ethanol/ETHValidationHelper.{h,m}', 'Ethanol/ETHTextField.{h,m}', 'Ethanol/ETHTextFieldProxyDelegate.{h,m}', 'Ethanol/ETH*Formatter.{h,m}', 'Ethanol/ETH*Contact*.{h,m}', 'Ethanol/ETHSocialManager.{h,m}', 'Ethanol/ETHSocial*Service.{h,m}', 'Ethanol/NSString+EthanolValidation*.{h,m}', 'Ethanol/ETHTwitterAccountPickerController.{h,m}', 'Ethanol/LMAlertView+Blocks.{h,m}', 'Ethanol/ETHMRRefreshControl.{h,m}', 'Ethanol/{NSObject,UIButton,UIImageView}+DownloadImage.{h,m}'
    ss.dependency 'Ethanol/Common'
  end

  s.subspec 'Phone' do |ss|
    ss.source_files = 'Ethanol/EthanolPhone.h'
    ss.dependency 'Ethanol/Common'
    ss.dependency 'Ethanol/Formatter'
    ss.dependency 'Ethanol/FormatterPhone'
    ss.dependency 'Ethanol/Validation'
    ss.dependency 'Ethanol/ValidationPhone'
    ss.dependency 'Ethanol/Contact'
    ss.dependency 'Ethanol/ContactPhone'
  end

  s.subspec 'Facebook' do |ss|
    ss.source_files = 'Ethanol/EthanolFacebook.h'
    ss.dependency 'Ethanol/Common'
    ss.dependency 'Ethanol/SocialManager'
    ss.dependency 'Ethanol/SocialManagerFacebook'
    ss.dependency 'Ethanol/Contact'
    ss.dependency 'Ethanol/ContactFacebook'
  end

  s.subspec 'LMAlertView' do |ss|
    ss.source_files = 'Ethanol/EthanolLMAlertView.h', 'Ethanol/LMAlertView+Blocks.{h,m}'
    ss.dependency 'Ethanol/Common'
    ss.dependency 'LMAlertView'
  end

  s.subspec 'LMAlertViewBlocks' do |ss|
    ss.dependency 'Ethanol/LMAlertView'
  end

  s.subspec 'MRProgress' do |ss|
    ss.source_files = 'Ethanol/EthanolMRProgress.h', 'Ethanol/ETH{,MR}RefreshControl.{h,m}'
    ss.dependency 'Ethanol/Common'
    ss.dependency 'MRProgress/Overlay', '~> 0.4'
  end

  s.subspec 'SDWebImage' do |ss|
    ss.source_files = 'Ethanol/EthanolSDWebImage.h', 'Ethanol/{NSObject,UIButton,UIImageView}+DownloadImage.{h,m}'
    ss.dependency 'Ethanol/Core'
    ss.dependency 'SDWebImage', '~> 3.6'
  end

  s.subspec 'TextField' do |ss|
    ss.source_files = 'Ethanol/EthanolTextField.h', 'Ethanol/ETHTextField.{h,m}', 'Ethanol/ETHTextFieldProxyDelegate.{h,m}'
    ss.private_header_files = 'Ethanol/ETHTextFieldProxyDelegate.h'
    ss.dependency 'Ethanol/Common'
    ss.dependency 'Ethanol/Formatter'
    ss.dependency 'Ethanol/Validation'
  end

  s.subspec 'Formatter' do |ss|
    ss.source_files = 'Ethanol/EthanolFormatter.h', 'Ethanol/ETHFormatter.{h,m}', 'Ethanol/ETH*Formatter.{h,m}'
    ss.exclude_files = 'Ethanol/ETHPhoneNumberFormatter.{h,m}'
    ss.dependency 'Ethanol/Common'
  end

  s.subspec 'FormatterPhone' do |ss|
    ss.source_files = 'Ethanol/EthanolFormatterPhone.h', 'Ethanol/ETHPhoneNumberFormatter.{h,m}'
    ss.dependency 'Ethanol/Formatter'
    ss.dependency 'libPhoneNumber-iOS', '~> 0.7'
  end

  s.subspec 'Validation' do |ss|
    ss.source_files = 'Ethanol/EthanolValidation.h', 'Ethanol/ETHValidationHelper.{h,m}', 'Ethanol/NSString+EthanolValidation.{h,m}', 'Ethanol/ETH*Validator.{h,m}'
    ss.exclude_files = 'Ethanol/ETHPhoneNumberValidator.{h,m}'
    ss.dependency 'Ethanol/Common'
  end

  s.subspec 'ValidationPhone' do |ss|
    ss.source_files = 'Ethanol/EthanolValidationPhone.h', 'Ethanol/ETHPhoneNumberValidator.{h,m}', 'Ethanol/NSString+EthanolValidationPhone.{h,m}'
    ss.dependency 'libPhoneNumber-iOS', '~> 0.7'
    ss.dependency 'Ethanol/Validation'
    # PhoneNumberValidator depends on NonemptyValidator
    ss.dependency 'Ethanol/Validation'
  end

  s.subspec 'Contact' do |ss|
    ss.source_files = 'Ethanol/ETHContact{,Fetcher}.{h,m}'
    ss.dependency 'Ethanol/Common'
  end

  s.subspec 'ContactPhone' do |ss|
    ss.source_files = 'Ethanol/EthanolContactPhone.h', 'Ethanol/ETHPhoneContactFetcher.{h,m}'
    ss.frameworks   = 'AddressBook'
    ss.dependency 'Ethanol/Contact'
  end

  s.subspec 'ContactFacebook' do |ss|
    ss.source_files = 'Ethanol/EthanolContactFacebook.h', 'Ethanol/ETHFacebookContactFetcher.{h,m}'
    ss.dependency 'Facebook-iOS-SDK'
    ss.dependency 'Ethanol/Contact'
    ss.dependency 'Ethanol/SocialManagerFacebook'
  end

  s.subspec 'ContactTwitter' do |ss|
    ss.source_files = 'Ethanol/EthanolContactTwitter.h', 'Ethanol/ETHTwitterContactFetcher.{h,m}'
    ss.dependency 'Facebook-iOS-SDK', '~> 3.13'
    ss.dependency 'Ethanol/Contact'
    ss.dependency 'Ethanol/SocialManagerTwitter'
  end

  s.subspec 'SocialManager' do |ss|
    ss.source_files = 'Ethanol/EthanolSocialManager.h', 'Ethanol/ETHSocial{Manager,Service}.{h,m}'
    ss.dependency 'Ethanol/Common'
  end

  s.subspec 'SocialManagerFacebook' do |ss|
    ss.source_files = 'Ethanol/EthanolSocialManagerFacebook.h', 'Ethanol/ETHSocialFacebookService.{h,m}'
    ss.dependency 'Ethanol/SocialManager'
    ss.dependency 'Facebook-iOS-SDK', '~> 3.13'
  end

  s.subspec 'SocialManagerTwitter' do |ss|
    ss.source_files = 'Ethanol/EthanolSocialManagerTwitter.h', 'Ethanol/ETHSocialTwitterService.{h,m}', 'Ethanol/ETHTwitterAccountPickerController.{h,m}'
    ss.frameworks   = 'Social', 'Accounts'
    ss.dependency 'Ethanol/Core'
    ss.dependency 'Ethanol/SocialManager'
  end

  s.subspec 'CoreData' do |ss|
    ss.source_files = 'Ethanol/EthanolCoreData.h', 'Ethanol/NSManagedObjectContext+AsyncFetchRequest.{h,m}'
    ss.frameworks   = 'CoreData'
    ss.dependency 'Ethanol/Common'
  end
end
