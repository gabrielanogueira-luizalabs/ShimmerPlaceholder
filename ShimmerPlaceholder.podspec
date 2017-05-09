Pod::Spec.new do |s|

  s.name         = "ShimmerPlaceholder"
  s.version      = "0.0.2"
  s.summary      = "Custom Shimmer Placeholder"

  s.description  = <<-DESC
  A View for Shimmer Placeholder
                   DESC

  s.homepage     = "https://github.com/gabrielanogueira-luizalabs/ShimmerPlaceholder.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Gabriela Nogueira" => "gabriela.nogueira@luizalabs.com" }
  s.source       = { :git => "https://github.com/gabrielanogueira-luizalabs/ShimmerPlaceholder.git", :tag => "#{s.version}" }
  s.source_files = "Source/**/*.{swift}"
  s.platform     = :ios, "8.0"
  s.framework    = "UIKit"
  s.dependency 'Shimmer', '~> 1.0'

end