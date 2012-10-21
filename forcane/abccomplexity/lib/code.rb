# This class has a comment
class ComplexClass

  # I was surprised how much I had to do to get complexity ;)
  def bad_method(stuff, options={})
    stuff.each do |s|
      foo = s.respond_to?(:foo) && s.foo.present? ? s.foo.join(':') : 'NoFoo'
      puts s.class.method.chain.too.long.really +
        'Something' +
        foo.transform(:too)
      return unless s.done?(options)
    end
  end

end
