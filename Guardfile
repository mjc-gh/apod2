# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  watch(%r|^test/(.*)\/?(.*)_test\.rb|)
  watch(%r|^test/test_helper\.rb|)    { "test" }

  watch(%r|^app/(.*)\.rb|)      { |m| "test/#{m[1]}_test.rb" }
  watch(%r|^lib/(.*)\.rb|)      { |m| "test/unit/#{m[1]}_test.rb" }
end

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end
