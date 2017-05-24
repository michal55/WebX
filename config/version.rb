module WebX
  module VERSION
    MAJOR = 1
    MINOR = 4
    PATCH = 2

    PRE = '--no-push'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact * '.'
  end
end
