Pod::Spec.new do |s|
   s.name = 'JSQNotificationObserverKit'
   s.version = '1.0.0'
   s.license = 'MIT'
   
   s.summary = 'Generic notifications and observers for iOS'
   s.homepage = 'https://github.com/jessesquires/JSQNotificationObserverKit'
   s.social_media_url = 'https://twitter.com/jesse_squires'
   s.authors = { 'Jesse Squires' => 'jesse.squires.developer@gmail.com' }

   s.source = { :git => 'https://github.com/jessesquires/JSQNotificationObserverKit.git', :tag => s.version }

   s.platform = :ios, '8.0'

   s.source_files = 'JSQNotificationObserverKit/JSQNotificationObserverKit/*.swift'
   
   s.frameworks = 'Foundation'

   s.requires_arc = true
end
