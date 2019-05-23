module Helper
  def self.included(klass)
    klass.instance_variable_set(:@all, [])
    klass.singleton_class.class_eval{attr_reader(:all)}
  end

  def initialize(vars, args, hash)
    if !hash.empty?
      vars = hash.keys
      args = hash.values
      vars << "id" if vars.include?("id")
    end

    vars.each_with_index do |var, i|
      args[i] ||= nil
      instance_variable_set("@#{var}", args[i])
      self.class.class_eval {attr_reader(var)}
    end

    self.class.all << self
  end
end
