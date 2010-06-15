require 'attribute_normalizer/normalizers/blank_normalizer'
require 'attribute_normalizer/normalizers/strip_normalizer'

module AttributeNormalizer

  class MissingNormalizer < ArgumentError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end


  class Configuration
    attr_accessor :normalizers
    def initialize
      @normalizers = {}
      @normalizers[:blank] = AttributeNormalizer::Normalizers::BlankNormalizer
      @normalizers[:strip] = AttributeNormalizer::Normalizers::StripNormalizer
    end
  end

end


require 'attribute_normalizer/model_inclusions'
require 'attribute_normalizer/rspec_matcher'

def include_attribute_normalizer(class_or_module)
  return if class_or_module.include?(AttributeNormalizer)
  class_or_module.class_eval do
    extend AttributeNormalizer::ClassMethods
  end
end

include_attribute_normalizer(ActiveModel::Base)     if defined?(ActiveModel::Base)
include_attribute_normalizer(ActiveRecord::Base)    if defined?(ActiveRecord::Base)
include_attribute_normalizer(CassandraObject::Base) if defined?(CassandraObject::Base)
