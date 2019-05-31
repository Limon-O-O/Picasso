Pod::Spec.new do |s|

  s.name        = "Picasso"
  s.version     = "0.4.4"
  s.summary     = "A view for rendering CIImage with Metal/OpenGL"

  s.description = <<-DESC
                  A view for rendering CIImage with Metal/OpenGL.
                  DESC

  s.homepage    = "https://github.com/Limon-O-O/Picasso"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.authors           = { "Limon" => "fengninglong@gmail.com" }
  s.social_media_url  = "https://twitter.com/Limon______"

  s.ios.deployment_target   = "9.0"
  # s.osx.deployment_target = "10.7"

  s.source          = { :git => "https://github.com/Limon-O-O/Picasso.git", :tag => s.version }
  s.source_files    = ['Picasso/**/*.h', 'Picasso/**/*.m', 'Picasso/**/*.swift']
  s.requires_arc    = true
  s.swift_version= '4.2'

end
